import Foundation
import MLX
import MLXLLM
import MLXLMCommon
import Tokenizers

/// Schema representation specific to guided generation (to avoid conflicts)
// Using RuntimeGenerationSchema from GenerationSchema.swift
public typealias GuidedGenerationSchema = RuntimeGenerationSchema

/// A constraint processor for guided JSON generation
public final class GuidedJSONProcessor {
    private var parseState: JSONParseState
    private let schema: GuidedGenerationSchema
    private let tokenizer: Tokenizer
    private var validTokenCache: [String: Set<Int>] = [:]
    
    public init(schema: GuidedGenerationSchema, tokenizer: Tokenizer) {
        self.schema = schema
        self.tokenizer = tokenizer
        self.parseState = JSONParseState(schema: schema)
    }
    
    /// Process logits to constrain next token generation
    public func processLogits(_ logits: MLXArray, vocabularySize: Int) -> MLXArray {
        let validTokenIds = getValidTokenIds()
        
        // Create mask with -inf for invalid tokens
        var mask = [Float](repeating: -Float.infinity, count: vocabularySize)
        for tokenId in validTokenIds {
            mask[tokenId] = 0
        }
        
        // Apply mask to logits
        let maskArray = MLXArray(mask)
        return logits + maskArray
    }
    
    private func getValidTokenIds() -> Set<Int> {
        let stateKey = parseState.currentStateKey
        
        // Check cache first
        if let cached = validTokenCache[stateKey] {
            return cached
        }
        
        // Get valid characters for current state
        let validChars = parseState.getValidNextCharacters()
        var validTokenIds = Set<Int>()
        
        // Map characters to token IDs
        for char in validChars {
            let tokens = tokenizer.encode(text: String(char))
            validTokenIds.formUnion(tokens)
        }
        
        // Always allow special tokens
        // Add common end tokens
        let eosTokens = tokenizer.encode(text: "</s>")
        validTokenIds.formUnion(eosTokens)
        
        // Cache the result
        validTokenCache[stateKey] = validTokenIds
        
        return validTokenIds
    }
    
    public func update(with token: Int) {
        let text = tokenizer.decode(tokens: [token])
        parseState.advance(with: text)
    }
}

/// Tracks the current state of JSON parsing and determines valid next characters
class JSONParseState {
    indirect enum State {
        case start
        case inObject(path: [String])
        case expectingPropertyName(path: [String])
        case inPropertyName(path: [String], partial: String)
        case afterPropertyName(path: [String], property: String)
        case expectingColon(path: [String], property: String)
        case expectingValue(path: [String], property: String, type: SchemaType)
        case inStringValue(path: [String], property: String, partial: String)
        case inNumberValue(path: [String], property: String, partial: String)
        case inBooleanValue(path: [String], property: String, partial: String)
        case inArray(path: [String], property: String, elementType: SchemaType, count: Int)
        case afterValue(path: [String])
        case complete
    }
    
    private var state: State = .start
    private let schema: GuidedGenerationSchema
    private var buffer: String = ""
    
    init(schema: GuidedGenerationSchema) {
        self.schema = schema
    }
    
    var currentStateKey: String {
        switch state {
        case .start: return "start"
        case .inObject(let path): return "obj:\(path.joined(separator: "."))"
        case .expectingPropertyName(let path): return "prop:\(path.joined(separator: "."))"
        case .inPropertyName(let path, let partial): return "pname:\(path.joined(separator: ".")):\(partial)"
        case .afterPropertyName(let path, let prop): return "aprop:\(path.joined(separator: ".")):\(prop)"
        case .expectingColon(let path, let prop): return "colon:\(path.joined(separator: ".")):\(prop)"
        case .expectingValue(let path, let prop, let type): return "val:\(path.joined(separator: ".")):\(prop):\(type)"
        case .inStringValue(let path, let prop, _): return "str:\(path.joined(separator: ".")):\(prop)"
        case .inNumberValue(let path, let prop, let partial): return "num:\(path.joined(separator: ".")):\(prop):\(partial)"
        case .inBooleanValue(let path, let prop, let partial): return "bool:\(path.joined(separator: ".")):\(prop):\(partial)"
        case .inArray(let path, let prop, let elemType, let count): return "arr:\(path.joined(separator: ".")):\(prop):\(elemType):\(count)"
        case .afterValue(let path): return "after:\(path.joined(separator: "."))"
        case .complete: return "complete"
        }
    }
    
    func getValidNextCharacters() -> Set<Character> {
        switch state {
        case .start:
            return ["{"]
            
        case .inObject, .expectingPropertyName:
            return ["\"", "}"]
            
        case .inPropertyName(_, let partial):
            let validPropertyNames = getValidPropertyNames(at: getCurrentPath())
            var validChars = Set<Character>()
            
            for propertyName in validPropertyNames {
                if propertyName.hasPrefix(partial) && propertyName.count > partial.count {
                    let nextIndex = propertyName.index(propertyName.startIndex, offsetBy: partial.count)
                    validChars.insert(propertyName[nextIndex])
                }
            }
            
            if validPropertyNames.contains(partial) {
                validChars.insert("\"")
            }
            
            return validChars
            
        case .afterPropertyName:
            return [":"]
            
        case .expectingColon:
            return [":"]
            
        case .expectingValue(_, _, let type):
            switch type {
            case .string:
                return ["\""]
            case .number:
                return Set("0123456789-.")
            case .boolean:
                return Set("tf")
            case .array:
                return ["["]
            case .object:
                return ["{"]
            case .null:
                return ["n"]
            }
            
        case .inStringValue:
            // Allow any character except unescaped quotes
            return Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 !#$%&'()*+,-./:;<=>?@[\\]^_`{|}~\"")
            
        case .inNumberValue(_, _, let partial):
            var validChars = Set("0123456789")
            if !partial.contains(".") {
                validChars.insert(".")
            }
            if partial.isEmpty {
                validChars.insert("-")
            }
            // Allow ending the number
            validChars.formUnion([",", "}", "]"])
            return validChars
            
        case .inBooleanValue(_, _, let partial):
            if partial.isEmpty {
                return ["t", "f"]
            } else if partial == "t" {
                return ["r"]
            } else if partial == "tr" {
                return ["u"]
            } else if partial == "tru" {
                return ["e"]
            } else if partial == "f" {
                return ["a"]
            } else if partial == "fa" {
                return ["l"]
            } else if partial == "fal" {
                return ["s"]
            } else if partial == "fals" {
                return ["e"]
            }
            return [",", "}", "]"]
            
        case .inArray:
            // Simplified - would need more complex handling
            return ["]", "{", "\"", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "-", "t", "f", "n"]
            
        case .afterValue:
            return [",", "}"]
            
        case .complete:
            return []
        }
    }
    
    func advance(with text: String) {
        buffer += text
        
        // Update state based on the new text
        // This is a simplified version - a full implementation would need
        // more sophisticated state tracking
        updateState()
    }
    
    private func updateState() {
        // This would contain the full state machine logic
        // For brevity, showing simplified transitions
        switch state {
        case .start:
            if buffer.hasSuffix("{") {
                state = .expectingPropertyName(path: [])
            }
            
        case .expectingPropertyName:
            if buffer.hasSuffix("\"") {
                state = .inPropertyName(path: getCurrentPath(), partial: "")
            }
            
        case .inPropertyName(let path, var partial):
            if let lastChar = buffer.last, lastChar != "\"" {
                partial.append(lastChar)
                state = .inPropertyName(path: path, partial: partial)
            } else if buffer.hasSuffix("\"") {
                state = .afterPropertyName(path: path, property: partial)
            }
            
        // ... more state transitions ...
            
        default:
            break
        }
    }
    
    private func getCurrentPath() -> [String] {
        switch state {
        case .inObject(let path), .expectingPropertyName(let path),
             .inPropertyName(let path, _), .afterPropertyName(let path, _),
             .expectingColon(let path, _), .expectingValue(let path, _, _),
             .inStringValue(let path, _, _), .inNumberValue(let path, _, _),
             .inBooleanValue(let path, _, _), .inArray(let path, _, _, _),
             .afterValue(let path):
            return path
        default:
            return []
        }
    }
    
    private func getValidPropertyNames(at path: [String]) -> Set<String> {
        // Get valid properties from schema at the current path
        return schema.getValidProperties(at: path)
    }
}

/// Schema type enumeration for guided generation
public indirect enum SchemaType {
    case string
    case number
    case boolean
    case array(elementType: SchemaType)
    case object(properties: [String: SchemaType])
    case null
}

/// Extension to integrate guided generation with MLX
extension MLXBackend {
    /// Generate a structured response with guided generation
    func generateGuided<T: Generable & Sendable>(
        prompt: String,
        generating type: T.Type,
        options: FoundryGenerationOptions? = nil
    ) async throws -> T {
        // For now, use the existing structured generation approach
        // Full guided generation would require deeper MLX integration
        
        // Create generation schema from the Generable type
        _ = GuidedGenerationSchema(from: type)
        
        // For now, we'll use the existing structured generation approach
        // Full guided generation would require deeper MLX integration
        return try await respond(
            to: prompt,
            generating: type,
            includeSchemaInPrompt: true,
            options: options ?? FoundryGenerationOptions()
        ).content
    }
}