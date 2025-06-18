import Foundation
import MLX
import MLXLLM
import MLXLMCommon
@preconcurrency import Tokenizers

/// Schema representation specific to guided generation (to avoid conflicts)
// Using RuntimeGenerationSchema from GenerationSchema.swift
public typealias GuidedGenerationSchema = RuntimeGenerationSchema

// MARK: - MLX LogitProcessor Integration

/// State container for thread-safe access
private actor ProcessorState {
    var parseState: JSONParseState
    var validTokenCache: [String: Set<Int>] = [:]
    
    init(schema: GuidedGenerationSchema) {
        self.parseState = JSONParseState(schema: schema)
    }
    
    func reset(schema: GuidedGenerationSchema) {
        self.parseState = JSONParseState(schema: schema)
        self.validTokenCache.removeAll()
    }
    
    func updateWithToken(_ tokenId: Int, tokenizer: Tokenizer) {
        validTokenCache.removeAll()
        let text = tokenizer.decode(tokens: [tokenId])
        parseState.advance(with: text)
    }
    
    func getValidTokenIds(tokenizer: Tokenizer) -> Set<Int> {
        let stateKey = parseState.currentStateKey
        
        if let cached = validTokenCache[stateKey] {
            return cached
        }
        
        let validChars = parseState.getValidNextCharacters()
        var validTokenIds = Set<Int>()
        
        for char in validChars {
            let charString = String(char)
            let tokens = tokenizer.encode(text: charString)
            validTokenIds.formUnion(tokens)
        }
        
        if parseState.isComplete {
            if let eosId = tokenizer.eosTokenId {
                validTokenIds.insert(eosId)
            }
        }
        
        validTokenCache[stateKey] = validTokenIds
        return validTokenIds
    }
    
    var isComplete: Bool {
        return parseState.isComplete
    }
}

/// A constraint processor for guided JSON generation
/// Now conforms to MLX's LogitProcessor protocol for token-level constraints!
public final class GuidedJSONProcessor: LogitProcessor, @unchecked Sendable {
    private let schema: GuidedGenerationSchema
    private let tokenizer: Tokenizer
    private let state: ProcessorState
    
    // We need to maintain a reference to track state synchronously
    // This is a limitation of the LogitProcessor protocol which is synchronous
    private var cachedValidTokens: Set<Int> = []
    private var cachedIsComplete: Bool = false
    
    public init(schema: GuidedGenerationSchema, tokenizer: Tokenizer) {
        self.schema = schema
        self.tokenizer = tokenizer
        self.state = ProcessorState(schema: schema)
        
        // Initialize cached values
        Task {
            self.cachedValidTokens = await state.getValidTokenIds(tokenizer: tokenizer)
            self.cachedIsComplete = await state.isComplete
        }
    }
    
    // MARK: - LogitProcessor Protocol
    
    public func prompt(_ prompt: MLXArray) {
        // Reset state when a new prompt starts
        Task {
            await state.reset(schema: schema)
            self.cachedValidTokens = await state.getValidTokenIds(tokenizer: tokenizer)
            self.cachedIsComplete = await state.isComplete
        }
    }
    
    public func didSample(token: MLXArray) {
        // Update parse state with the sampled token
        let tokenId = token.item(Int.self)
        Task {
            await state.updateWithToken(tokenId, tokenizer: tokenizer)
            self.cachedValidTokens = await state.getValidTokenIds(tokenizer: tokenizer)
            self.cachedIsComplete = await state.isComplete
        }
    }
    
    public func process(logits: MLXArray) -> MLXArray {
        // Use cached values for synchronous processing
        let validTokenIds = cachedValidTokens
        
        // If we're complete or have no constraints, return original logits
        if cachedIsComplete || validTokenIds.isEmpty {
            return logits
        }
        
        // Get vocabulary size from logits shape
        let vocabSize = logits.shape.last ?? 0
        
        // Create mask: 1 for valid tokens, 0 for invalid
        var maskValues = [Float](repeating: 0, count: vocabSize)
        for tokenId in validTokenIds {
            if tokenId < vocabSize {
                maskValues[tokenId] = 1
            }
        }
        
        let mask = MLXArray(maskValues).reshaped(1, vocabSize)
        
        // Apply mask: set invalid tokens to -inf
        // Use broadcasting to apply mask
        let maskedLogits = MLX.where(
            mask .== 0,
            MLXArray(-Float.infinity),
            logits
        )
        
        return maskedLogits
    }
}

// MARK: - Alternative: Fully Synchronous Processor

/// Alternative implementation that avoids actors entirely
/// This is more suitable for the synchronous LogitProcessor protocol
public final class SyncGuidedJSONProcessor: LogitProcessor, @unchecked Sendable {
    private let schema: GuidedGenerationSchema
    private let tokenizer: Tokenizer
    private var parseState: JSONParseState
    private var validTokenCache: [String: Set<Int>] = [:]
    
    public init(schema: GuidedGenerationSchema, tokenizer: Tokenizer) {
        self.schema = schema
        self.tokenizer = tokenizer
        self.parseState = JSONParseState(schema: schema)
    }
    
    // MARK: - LogitProcessor Protocol
    
    public func prompt(_ prompt: MLXArray) {
        // Reset state when a new prompt starts
        self.parseState = JSONParseState(schema: schema)
        self.validTokenCache.removeAll()
    }
    
    public func didSample(token: MLXArray) {
        // Update parse state with the sampled token
        let tokenId = token.item(Int.self)
        updateStateWithToken(tokenId)
    }
    
    public func process(logits: MLXArray) -> MLXArray {
        let validTokenIds = getValidTokenIds()
        
        // If we're complete or have no constraints, return original logits
        if parseState.isComplete || validTokenIds.isEmpty {
            return logits
        }
        
        // Get vocabulary size from logits shape
        let vocabSize = logits.shape.last ?? 0
        
        // Create mask: 1 for valid tokens, 0 for invalid
        var maskValues = [Float](repeating: 0, count: vocabSize)
        for tokenId in validTokenIds {
            if tokenId < vocabSize {
                maskValues[tokenId] = 1
            }
        }
        
        let mask = MLXArray(maskValues).reshaped(1, vocabSize)
        
        // Apply mask: set invalid tokens to -inf
        let maskedLogits = MLX.where(
            mask .== 0,
            MLXArray(-Float.infinity),
            logits
        )
        
        return maskedLogits
    }
    
    // MARK: - Private Methods
    
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
            let charString = String(char)
            
            // Get all tokens that could produce this character
            let tokens = tokenizer.encode(text: charString)
            validTokenIds.formUnion(tokens)
        }
        
        // Always allow EOS token if JSON is complete
        if parseState.isComplete {
            if let eosId = tokenizer.eosTokenId {
                validTokenIds.insert(eosId)
            }
        }
        
        // Cache the result
        validTokenCache[stateKey] = validTokenIds
        
        return validTokenIds
    }
    
    private func updateStateWithToken(_ tokenId: Int) {
        // Clear cache as state will change
        validTokenCache.removeAll()
        
        // Update parse state if we can decode the token
        let text = tokenizer.decode(tokens: [tokenId])
        parseState.advance(with: text)
    }
}

// MARK: - Custom LogitSampler for Guided Generation

/// A sampler that works with guided generation constraints
public struct GuidedSampler: LogitSampler {
    private let temperature: Float
    private let topP: Float
    
    public init(temperature: Float = 0.7, topP: Float = 1.0) {
        self.temperature = temperature
        self.topP = topP
    }
    
    public func sample(logits: MLXArray) -> MLXArray {
        // The logits have already been processed by GuidedJSONProcessor
        // Use appropriate sampling based on temperature
        if temperature == 0 {
            return argMax(logits, axis: -1)
        } else {
            // Use categorical sampling with temperature
            let scaledLogits = logits / MLXArray(temperature)
            let probs = softmax(scaledLogits, axis: -1)
            return MLXRandom.categorical(probs)
        }
    }
}

// MARK: - JSON Parse State

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
    
    var isComplete: Bool {
        if case .complete = state {
            return true
        }
        return false
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
            
        case let .expectingValue(_, _, type):
            return getValidValueStartCharacters(for: type)
            
        case .inStringValue(_, _, let partial):
            // Allow any character except unescaped quotes
            var validChars = Set<Character>()
            for c in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 .,!?-_@#$%^&*()[]{}+=/<>:;" {
                validChars.insert(c)
            }
            if !partial.hasSuffix("\\") {
                validChars.insert("\"")
            }
            return validChars
            
        case .inNumberValue(_, _, let partial):
            var validChars = Set<Character>("0123456789")
            if !partial.contains(".") {
                validChars.insert(".")
            }
            if partial.isEmpty || partial == "-" {
                validChars.insert("-")
            }
            // Can end number with comma or closing brace
            if !partial.isEmpty && partial != "-" {
                validChars.insert(",")
                validChars.insert("}")
            }
            return validChars
            
        case .inBooleanValue(_, _, let partial):
            if "true".hasPrefix(partial) {
                let nextIndex = "true".index("true".startIndex, offsetBy: partial.count)
                if nextIndex < "true".endIndex {
                    return ["true"[nextIndex]]
                }
            }
            if "false".hasPrefix(partial) {
                let nextIndex = "false".index("false".startIndex, offsetBy: partial.count)
                if nextIndex < "false".endIndex {
                    return ["false"[nextIndex]]
                }
            }
            return [",", "}"]
            
        case let .inArray(_, _, elementType, _):
            var validChars = getValidValueStartCharacters(for: elementType)
            validChars.insert("]")
            return validChars
            
        case .afterValue:
            return [",", "}"]
            
        case .complete:
            return []
        }
    }
    
    func advance(with text: String) {
        buffer += text
        
        // Process each character
        for char in text {
            processCharacter(char)
        }
    }
    
    private func processCharacter(_ char: Character) {
        // State machine transitions based on character
        // This is a simplified implementation
        switch (state, char) {
        case (.start, "{"):
            state = .expectingPropertyName(path: [])
            
        case (.expectingPropertyName, "\""):
            state = .inPropertyName(path: getCurrentPath(), partial: "")
            
        case (.inPropertyName(let path, let partial), "\""):
            state = .afterPropertyName(path: path, property: partial)
            
        case (.inPropertyName(let path, let partial), _):
            state = .inPropertyName(path: path, partial: partial + String(char))
            
        case (.afterPropertyName(let path, let prop), ":"):
            if let propSchema = getPropertySchema(name: prop, at: path) {
                state = .expectingValue(path: path, property: prop, type: propSchema.type)
            }
            
        // Add more state transitions as needed
        default:
            break
        }
    }
    
    private func getCurrentPath() -> [String] {
        switch state {
        case .inObject(let path), .expectingPropertyName(let path),
             .inPropertyName(let path, _), .afterPropertyName(let path, _),
             .expectingColon(let path, _), let .expectingValue(path, _, _),
             let .inStringValue(path, _, _), let .inNumberValue(path, _, _),
             let .inBooleanValue(path, _, _), let .inArray(path, _, _, _),
             .afterValue(let path):
            return path
        default:
            return []
        }
    }
    
    private func getValidPropertyNames(at path: [String]) -> Set<String> {
        // Get valid property names from schema based on current path
        var validNames = Set<String>()
        
        // For root level
        if path.isEmpty {
            for (propName, _) in schema.root.properties {
                validNames.insert(propName)
            }
        }
        
        return validNames
    }
    
    private func getPropertySchema(name: String, at path: [String]) -> SchemaNode? {
        // Find property schema based on name and path
        if path.isEmpty {
            return schema.root.properties[name]
        }
        return nil
    }
    
    private func getValidValueStartCharacters(for type: SchemaType) -> Set<Character> {
        switch type {
        case .string:
            return ["\""]
        case .number, .integer:
            return Set("0123456789-")
        case .boolean:
            return ["t", "f"] // for true/false
        case .array:
            return ["["]
        case .object:
            return ["{"]
        case .null:
            return ["n"] // for null
        case .any:
            var chars = Set<Character>()
            chars.formUnion(["\"", "{", "[", "t", "f", "n"])
            chars.formUnion("0123456789-")
            return chars
        }
    }
}

// MARK: - MLX Integration Extensions

extension MLXBackend {
    /// Create a guided generation session with token-level constraints
    internal func createGuidedSession(
        schema: RuntimeGenerationSchema,
        temperature: Float = 0.7,
        topP: Float = 1.0
    ) -> GuidedGenerationSession? {
        guard let mlxModel = getMLXModel() else { return nil }
        
        // Create the guided processor (using sync version for simplicity)
        let processor = SyncGuidedJSONProcessor(
            schema: schema,
            tokenizer: mlxModel.tokenizer
        )
        
        // Create the sampler
        let sampler = GuidedSampler(temperature: temperature, topP: topP)
        
        return GuidedGenerationSession(
            model: mlxModel,
            processor: processor,
            sampler: sampler
        )
    }
}

/// A generation session with guided constraints
public struct GuidedGenerationSession {
    let model: ModelContext
    let processor: SyncGuidedJSONProcessor
    let sampler: GuidedSampler
    
    public func generate(prompt: String, maxTokens: Int = 512) async throws -> String {
        // Use MLX's generate function with our custom processor and sampler
        let input = try await model.processor.prepare(
            input: UserInput(chat: [.user(prompt)], processing: .init())
        )
        
        let parameters = GenerateParameters(maxTokens: maxTokens)
        
        // Create token iterator with our guided processor and sampler
        let iterator = try TokenIterator(
            input: input,
            model: model.model,
            cache: model.model.newCache(parameters: parameters),
            processor: processor,
            sampler: sampler,
            maxTokens: maxTokens
        )
        
        // Generate tokens
        var result = ""
        for token in iterator {
            let decoded = model.tokenizer.decode(tokens: [token])
            result += decoded
        }
        
        return result
    }
}