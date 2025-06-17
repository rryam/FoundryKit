import Foundation
import MLXLLM
import MLXLMCommon
import FoundationModels

/// Backend implementation that uses MLX for language model inference.
internal final class MLXBackend: FoundryBackend, @unchecked Sendable {
    
    private let model: FoundryModel
    private let guardrails: Guardrails
    private let tools: [any Tool]
    private let instructions: Instructions?
    
    private var mlxModel: ModelContext?
    private var chatSession: ChatSession?
    
    init(
        model: FoundryModel,
        guardrails: Guardrails,
        tools: [any Tool],
        instructions: Instructions?
    ) {
        self.model = model
        self.guardrails = guardrails
        self.tools = tools
        self.instructions = instructions
    }
    
    func prewarm() {
        Task {
            await loadModelIfNeeded()
        }
    }
    
    func respond(
        to prompt: String,
        options: FoundryGenerationOptions
    ) async throws -> BackendResponse<String> {
        await loadModelIfNeeded()
        
        guard let chatSession = self.chatSession else {
            throw FoundryGenerationError.modelLoadingFailed(
                FoundryGenerationError.Context(
                    debugDescription: "Failed to load MLX model: \(model.identifier)"
                )
            )
        }
        
        do {
            let response = try await chatSession.respond(to: prompt)
            
            // Create transcript entries - simplified for now
            let promptEntry = createTranscriptEntry(role: "user", content: prompt)
            let responseEntry = createTranscriptEntry(role: "assistant", content: response)
            
            return BackendResponse(
                content: response,
                transcriptEntries: [promptEntry, responseEntry][...]
            )
        } catch {
            throw FoundryGenerationError.unknown(
                FoundryGenerationError.Context(
                    debugDescription: "MLX generation failed: \(error)",
                    underlyingErrors: [error]
                )
            )
        }
    }
    
    func respond(
        to prompt: Prompt,
        options: FoundryGenerationOptions
    ) async throws -> BackendResponse<String> {
        // Convert Prompt to string for MLX
        let promptString = convertPromptToString(prompt)
        return try await respond(to: promptString, options: options)
    }
    
    func respond<Content>(
        to prompt: String,
        generating type: Content.Type,
        includeSchemaInPrompt: Bool,
        options: FoundryGenerationOptions
    ) async throws -> BackendResponse<Content> where Content: Generable & Sendable {
        await loadModelIfNeeded()
        
        guard let chatSession = self.chatSession else {
            throw FoundryGenerationError.modelLoadingFailed(
                FoundryGenerationError.Context(
                    debugDescription: "Failed to load MLX model: \(model.identifier)"
                )
            )
        }
        
        // Track the type for schema access
        currentGenerationType = type
        
        // Extract schema from the Generable type
        let schema = try extractSchema(from: type)
        
        // Create structured prompt
        let structuredPrompt = includeSchemaInPrompt ? 
            createStructuredPrompt(prompt: prompt, schema: schema) : prompt
        
        do {
            let response = try await chatSession.respond(to: structuredPrompt)
            
            // Parse JSON response into the target type
            let parsedContent = try parseStructuredResponse(response, into: type)
            
            // Create transcript entries - simplified for now
            let promptEntry = createTranscriptEntry(role: "user", content: structuredPrompt)
            let responseEntry = createTranscriptEntry(role: "assistant", content: response)
            
            return BackendResponse(
                content: parsedContent,
                transcriptEntries: [promptEntry, responseEntry][...]
            )
        } catch {
            throw FoundryGenerationError.decodingFailure(
                FoundryGenerationError.Context(
                    debugDescription: "Failed to parse MLX response into \(type): \(error)",
                    underlyingErrors: [error]
                )
            )
        }
    }
    
    func respond<Content>(
        to prompt: Prompt,
        generating type: Content.Type,
        includeSchemaInPrompt: Bool,
        options: FoundryGenerationOptions
    ) async throws -> BackendResponse<Content> where Content: Generable & Sendable {
        let promptString = convertPromptToString(prompt)
        return try await respond(
            to: promptString,
            generating: type,
            includeSchemaInPrompt: includeSchemaInPrompt,
            options: options
        )
    }
    
    func streamResponse<Content>(
        to prompt: String,
        generating type: Content.Type,
        includeSchemaInPrompt: Bool,
        options: FoundryGenerationOptions
    ) -> any AsyncSequence<Content.PartiallyGenerated, any Error> where Content: Generable & Sendable {
        return MLXStreamSequence<Content>(
            backend: self,
            prompt: prompt,
            type: type,
            includeSchemaInPrompt: includeSchemaInPrompt,
            options: options
        )
    }
    
    func streamResponse<Content>(
        to prompt: Prompt,
        generating type: Content.Type,
        includeSchemaInPrompt: Bool,
        options: FoundryGenerationOptions
    ) -> any AsyncSequence<Content.PartiallyGenerated, any Error> where Content: Generable & Sendable {
        let promptString = convertPromptToString(prompt)
        return streamResponse(
            to: promptString,
            generating: type,
            includeSchemaInPrompt: includeSchemaInPrompt,
            options: options
        )
    }
    
    // MARK: - Private Helpers
    
    private func loadModelIfNeeded() async {
        guard mlxModel == nil else { return }
        
        do {
            switch model {
            case .mlx(let source):
                let loadedModel: ModelContext
                switch source {
                case .id(let modelId):
                    loadedModel = try await loadModel(id: modelId)
                case .registry(let config):
                    loadedModel = try await loadModel(configuration: config)
                }
                self.mlxModel = loadedModel
                self.chatSession = ChatSession(loadedModel)
            case .foundation:
                // This shouldn't happen as Foundation backend handles .foundation cases
                break
            }
        } catch {
            // Model loading failed - will be handled when methods are called
        }
    }
    
    private func convertPromptToString(_ prompt: Prompt) -> String {
        // For now, convert Prompt to a simple string representation
        // This is a simplified implementation - in practice, you'd want
        // to handle the full Prompt structure including images, etc.
        return String(describing: prompt)
    }
    
    private func extractSchema<T: Generable>(from type: T.Type) throws -> [String: Any] {
        // Check if the type conforms to StructuredOutput for custom schema
        if let structuredType = type as? StructuredOutput.Type {
            return structuredType.jsonSchema
        }
        
        // For standard Generable types, use basic schema extraction
        return SchemaExtractor.extractSchema(from: type)
    }
    
    private func createStructuredPrompt(prompt: String, schema: [String: Any]) -> String {
        // Use the structured prompt builder with model-specific optimizations
        let modelId = model.identifier.lowercased()
        let config = StructuredGenerationConfig(
            systemPrompt: StructuredPromptBuilder.structuredSystemPrompt(modelType: modelId)
        )
        
        // Check for example if available
        var example: String? = nil
        if let type = currentGenerationType as? StructuredOutput.Type {
            example = type.exampleJSON
        }
        
        return StructuredPromptBuilder.buildPrompt(
            userPrompt: prompt,
            schema: schema,
            example: example,
            config: config
        )
    }
    
    // Track current generation type for schema access
    private var currentGenerationType: Any.Type?
    
    private func parseStructuredResponse<T: Generable>(
        _ response: String,
        into type: T.Type
    ) throws -> T {
        // Try multiple extraction methods
        guard let jsonString = JSONExtractor.extractJSON(from: response) ??
                               JSONExtractor.repairJSON(response) else {
            throw FoundryGenerationError.decodingFailure(
                FoundryGenerationError.Context(
                    debugDescription: "Failed to extract valid JSON from response: \(response)"
                )
            )
        }
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            throw FoundryGenerationError.decodingFailure(
                FoundryGenerationError.Context(
                    debugDescription: "Failed to convert JSON string to data"
                )
            )
        }
        
        // Try to decode the JSON into the target type
        do {
            if let decodableType = type as? Decodable.Type {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(decodableType, from: jsonData)
                if let result = decoded as? T {
                    return result
                }
            }
            
            // If direct decoding fails, try using GeneratedContent conversion
            if let convertibleType = type as? ConvertibleFromGeneratedContent.Type {
                // Create a GeneratedContent wrapper
                let json = try JSONSerialization.jsonObject(with: jsonData)
                // This would need proper GeneratedContent construction
                // For now, throw an error indicating partial implementation
                throw FoundryGenerationError.decodingFailure(
                    FoundryGenerationError.Context(
                        debugDescription: "GeneratedContent conversion not yet implemented"
                    )
                )
            }
            
            throw FoundryGenerationError.decodingFailure(
                FoundryGenerationError.Context(
                    debugDescription: "Type \(type) does not conform to required protocols for parsing"
                )
            )
        } catch let decodingError as DecodingError {
            throw FoundryGenerationError.decodingFailure(
                FoundryGenerationError.Context(
                    debugDescription: "Failed to decode JSON: \(decodingError.localizedDescription)",
                    underlyingErrors: [decodingError]
                )
            )
        } catch {
            throw error
        }
    }
    
    // Removed in favor of JSONExtractor.extractJSON
    
    private func createTranscriptEntry(role: String, content: String) -> Transcript.Entry {
        // Simplified transcript entry creation
        // In a full implementation, this would properly handle the Foundation Models types
        #if canImport(FoundationModels)
        // For now, create a minimal entry that works with Foundation Models
        // This is a placeholder - proper implementation would require deeper integration
        fatalError("Foundation Models transcript creation not yet implemented in MLX backend")
        #else
        return Transcript.Entry(role: role == "user" ? .user : .assistant, content: [.text(content)])
        #endif
    }
}

/// AsyncSequence implementation for MLX streaming.
private struct MLXStreamSequence<Content: Generable & Sendable>: AsyncSequence {
    typealias Element = Content.PartiallyGenerated
    
    private let backend: MLXBackend
    private let prompt: String
    private let type: Content.Type
    private let includeSchemaInPrompt: Bool
    private let options: FoundryGenerationOptions
    
    init(
        backend: MLXBackend,
        prompt: String,
        type: Content.Type,
        includeSchemaInPrompt: Bool,
        options: FoundryGenerationOptions
    ) {
        self.backend = backend
        self.prompt = prompt
        self.type = type
        self.includeSchemaInPrompt = includeSchemaInPrompt
        self.options = options
    }
    
    func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(
            backend: backend,
            prompt: prompt,
            type: type,
            includeSchemaInPrompt: includeSchemaInPrompt,
            options: options
        )
    }
    
    struct AsyncIterator: AsyncIteratorProtocol {
        private let backend: MLXBackend
        private let prompt: String
        private let type: Content.Type
        private let includeSchemaInPrompt: Bool
        private let options: FoundryGenerationOptions
        private var hasStarted = false
        private var hasCompleted = false
        
        init(
            backend: MLXBackend,
            prompt: String,
            type: Content.Type,
            includeSchemaInPrompt: Bool,
            options: FoundryGenerationOptions
        ) {
            self.backend = backend
            self.prompt = prompt
            self.type = type
            self.includeSchemaInPrompt = includeSchemaInPrompt
            self.options = options
        }
        
        mutating func next() async throws -> Content.PartiallyGenerated? {
            if hasCompleted {
                return nil
            }
            
            if !hasStarted {
                hasStarted = true
                // For now, return the completed result as a single item
                // Full streaming implementation would incrementally build the object
                let response = try await backend.respond(
                    to: prompt,
                    generating: type,
                    includeSchemaInPrompt: includeSchemaInPrompt,
                    options: options
                )
                hasCompleted = true
                
                // Convert to PartiallyGenerated - this is a simplified approach
                return response.content.asPartiallyGenerated()
            }
            
            return nil
        }
    }
}