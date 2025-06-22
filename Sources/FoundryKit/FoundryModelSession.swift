import Foundation
import Observation
import FoundationModels
import MLXLMCommon

/// A session for generating responses using language models.
///
/// FoundryModelSession provides a unified API that works with both MLX models
/// and Apple's Foundation Models, using the same interface style as Apple's
/// LanguageModelSession.
@Observable
public final class FoundryModelSession {
    
    /// The model used by this session.
    public let model: FoundryModel
    
    /// The guardrails setting for this session.
    public let guardrails: Guardrails
    
    /// Tools available to the model during generation.
    public let tools: [any Tool]
    
    /// Instructions that control the model's behavior.
    public let instructions: Instructions?
    
    /// The current conversation transcript.
    ///
    /// This property provides read-only access to the conversation history,
    /// including all prompts and responses. The transcript is automatically
    /// updated after each interaction.
    ///
    /// Example usage:
    /// ```swift
    /// let session = FoundryModelSession()
    /// let response = try await session.respond(to: "Hello")
    /// 
    /// // Access the transcript
    /// for entry in session.transcript.entries {
    ///     print("Role: \(entry.role), Content: \(entry.content)")
    /// }
    /// ```
    public private(set) var transcript: Transcript
    
    // Internal backend implementations
    private let backend: any FoundryBackend
    
    /// Creates a new session with the specified configuration.
    public init(
        model: FoundryModel = .foundation,
        guardrails: Guardrails = .default,
        tools: [any Tool] = [],
        instructions: Instructions? = nil
    ) {
        self.model = model
        self.guardrails = guardrails
        self.tools = tools
        self.instructions = instructions
        self.transcript = Transcript()
        
        // Select appropriate backend based on model type
        switch model {
        case .foundation:
            self.backend = FoundationBackend(
                guardrails: guardrails,
                tools: tools,
                instructions: instructions
            )
        case .mlx:
            self.backend = MLXBackend(
                model: model,
                guardrails: guardrails,
                tools: tools,
                instructions: instructions
            )
        }
    }
    
    /// Creates a session by rehydrating from a transcript.
    public convenience init(
        model: FoundryModel = .foundation,
        guardrails: Guardrails = .default,
        tools: [any Tool] = [],
        transcript: Transcript
    ) {
        self.init(model: model, guardrails: guardrails, tools: tools)
        self.transcript = transcript
    }
    
    /// Requests that the system eagerly load the resources required for this session.
    public func prewarm() {
        backend.prewarm()
    }
}

// MARK: - Response Types

extension FoundryModelSession {
    
    /// A structure that stores the output of a response call.
    public struct Response<Content: Sendable>: Sendable {
        
        /// The response content.
        public let content: Content
        
        /// The list of transcript entries.
        public let transcriptEntries: ArraySlice<Transcript.Entry>
        
        internal init(content: Content, transcriptEntries: ArraySlice<Transcript.Entry>) {
            self.content = content
            self.transcriptEntries = transcriptEntries
        }
    }
    
    // Commented out for 0.0.1 release - focusing on simple text generation only
    /*
    /// A structure that stores the output of a response stream.
    public struct ResponseStream<Content> where Content: Generable & Sendable {
        private let asyncSequence: any AsyncSequence<Content.PartiallyGenerated, any Error>
        
        internal init<S: AsyncSequence>(_ sequence: S) where S.Element == Content.PartiallyGenerated, S.Failure == any Error {
            self.asyncSequence = sequence
        }
    }
    */
}

// MARK: - Text Generation

extension FoundryModelSession {
    
    /// Produces a response to a string prompt.
    @discardableResult
    public func respond(
        to prompt: String,
        options: FoundryGenerationOptions = FoundryGenerationOptions(),
        isolation: isolated (any Actor)? = #isolation
    ) async throws -> sending Response<String> {
        let result = try await backend.respond(to: prompt, options: options)
        updateTranscript(with: result.transcriptEntries)
        return Response(content: result.content, transcriptEntries: result.transcriptEntries)
    }
    
    /// Produces a response to a Prompt.
    @discardableResult
    public func respond(
        to prompt: Prompt,
        options: FoundryGenerationOptions = FoundryGenerationOptions(),
        isolation: isolated (any Actor)? = #isolation
    ) async throws -> sending Response<String> {
        let result = try await backend.respond(to: prompt, options: options)
        updateTranscript(with: result.transcriptEntries)
        return Response(content: result.content, transcriptEntries: result.transcriptEntries)
    }
    
    /// Produces a response to a prompt built with PromptBuilder.
    @discardableResult
    public func respond(
        options: FoundryGenerationOptions = FoundryGenerationOptions(),
        isolation: isolated (any Actor)? = #isolation,
        @PromptBuilder prompt: () throws -> Prompt
    ) async throws -> sending Response<String> {
        let builtPrompt = try prompt()
        return try await respond(to: builtPrompt, options: options, isolation: isolation)
    }
}

// MARK: - Structured Generation

// Commented out for 0.0.1 release - focusing on simple text generation only
/*
extension FoundryModelSession {
    
    /// Produces a generable object as a response to a string prompt.
    @discardableResult
    public func respond<Content>(
        to prompt: String,
        generating type: Content.Type = Content.self,
        includeSchemaInPrompt: Bool = true,
        options: FoundryGenerationOptions = FoundryGenerationOptions(),
        isolation: isolated (any Actor)? = #isolation
    ) async throws -> sending Response<Content> where Content: Generable & Sendable {
        let result = try await backend.respond(
            to: prompt,
            generating: type,
            includeSchemaInPrompt: includeSchemaInPrompt,
            options: options
        )
        updateTranscript(with: result.transcriptEntries)
        return Response(content: result.content, transcriptEntries: result.transcriptEntries)
    }
    
    /// Produces a generable object as a response to a Prompt.
    @discardableResult
    public func respond<Content>(
        to prompt: Prompt,
        generating type: Content.Type = Content.self,
        includeSchemaInPrompt: Bool = true,
        options: FoundryGenerationOptions = FoundryGenerationOptions(),
        isolation: isolated (any Actor)? = #isolation
    ) async throws -> sending Response<Content> where Content: Generable & Sendable {
        let result = try await backend.respond(
            to: prompt,
            generating: type,
            includeSchemaInPrompt: includeSchemaInPrompt,
            options: options
        )
        updateTranscript(with: result.transcriptEntries)
        return Response(content: result.content, transcriptEntries: result.transcriptEntries)
    }
    
    /// Produces a generable object as a response to a prompt built with PromptBuilder.
    @discardableResult
    public func respond<Content>(
        generating type: Content.Type = Content.self,
        options: FoundryGenerationOptions = FoundryGenerationOptions(),
        includeSchemaInPrompt: Bool = true,
        isolation: isolated (any Actor)? = #isolation,
        @PromptBuilder prompt: () throws -> Prompt
    ) async throws -> sending Response<Content> where Content: Generable & Sendable {
        let builtPrompt = try prompt()
        return try await respond(
            to: builtPrompt,
            generating: type,
            includeSchemaInPrompt: includeSchemaInPrompt,
            options: options,
            isolation: isolation
        )
    }
}
*/

// MARK: - Dynamic Schema Generation

// Commented out for 0.0.1 release - focusing on simple text generation only
/*
extension FoundryModelSession {
    
    /// Produces a response using a dynamic generation schema.
    @discardableResult
    public func respond(
        to prompt: String,
        schema: DynamicGenerationSchema,
        options: FoundryGenerationOptions = FoundryGenerationOptions(),
        isolation: isolated (any Actor)? = #isolation
    ) async throws -> sending Response<GeneratedContent> {
        // For now, MLX backend will use structured prompting
        // Foundation backend can use native schema support
        switch model {
        case .foundation:
            // Use Foundation Models' native dynamic schema support
            // Convert our DynamicGenerationSchema to Foundation Models' version
            let fmSchema = convertToFoundationModelSchema(schema)
            let generationSchema = try FoundationModels.GenerationSchema(root: fmSchema, dependencies: [])
            let session = LanguageModelSession(model: .default, guardrails: guardrails, tools: tools)
            let response = try await session.respond(to: prompt, schema: generationSchema)
            
            // Convert to our response type
            let transcriptEntries = session.transcript.entries.suffix(2)
            updateTranscript(with: transcriptEntries)
            return Response(content: response.content, transcriptEntries: transcriptEntries)
            
        case .mlx:
            // For MLX, convert dynamic schema to structured prompt
            throw FoundryGenerationError.unsupportedFeature(
                FoundryGenerationError.Context(
                    debugDescription: "Dynamic schema generation not yet supported for MLX models"
                )
            )
        }
    }
    
    /// Produces a response using a dynamic generation schema with a Prompt.
    @discardableResult
    public func respond(
        to prompt: Prompt,
        schema: DynamicGenerationSchema,
        options: FoundryGenerationOptions = FoundryGenerationOptions(),
        isolation: isolated (any Actor)? = #isolation
    ) async throws -> sending Response<GeneratedContent> {
        // For Foundation Models, we can leverage the native prompt support
        switch model {
        case .foundation:
            let fmSchema = convertToFoundationModelSchema(schema)
            let generationSchema = try FoundationModels.GenerationSchema(root: fmSchema, dependencies: [])
            let session = LanguageModelSession(model: .default, guardrails: guardrails, tools: tools)
            let response = try await session.respond(to: prompt, schema: generationSchema)
            
            let transcriptEntries = session.transcript.entries.suffix(2)
            updateTranscript(with: transcriptEntries)
            return Response(content: response.content, transcriptEntries: transcriptEntries)
            
        case .mlx:
            throw FoundryGenerationError.unsupportedFeature(
                FoundryGenerationError.Context(
                    debugDescription: "Dynamic schema generation not yet supported for MLX models with Prompt"
                )
            )
        }
    }
}
*/

// MARK: - Streaming Generation

// Commented out for 0.0.1 release - focusing on simple text generation only
// extension FoundryModelSession {
//     
//     /// Produces a response stream to a prompt for generable types.
//     public func streamResponse<Content>(
//         to prompt: String,
//         generating type: Content.Type,
//         includeSchemaInPrompt: Bool = true,
//         options: FoundryGenerationOptions = FoundryGenerationOptions()
//     ) -> ResponseStream<Content> where Content: Generable & Sendable {
//         let stream = backend.streamResponse(
//             to: prompt,
//             generating: type,
//             includeSchemaInPrompt: includeSchemaInPrompt,
//             options: options
//         )
//         return ResponseStream(stream)
//     }
//     
//     /// Produces a response stream to a Prompt for generable types.
//     public func streamResponse<Content>(
//         to prompt: Prompt,
//         generating type: Content.Type,
//         includeSchemaInPrompt: Bool = true,
//         options: FoundryGenerationOptions = FoundryGenerationOptions()
//     ) -> ResponseStream<Content> where Content: Generable & Sendable {
//         let stream = backend.streamResponse(
//             to: prompt,
//             generating: type,
//             includeSchemaInPrompt: includeSchemaInPrompt,
//             options: options
//         )
//         return ResponseStream(stream)
//     }
// }

// MARK: - Utility Methods

// Commented out for 0.0.1 release - focusing on simple text generation only
/*
extension FoundryModelSession {
    
    /// Extracts JSON from a model response that may contain additional text.
    ///
    /// This utility method helps parse JSON from model responses that might include
    /// markdown formatting, explanatory text, or other non-JSON content.
    ///
    /// Example usage:
    /// ```swift
    /// let response = "Here's the JSON: ```json\n{\"name\": \"John\"}\n```"
    /// if let json = FoundryModelSession.extractJSON(from: response) {
    ///     // Use the extracted JSON string
    /// }
    /// ```
    ///
    /// - Parameter response: The model's response that may contain JSON
    /// - Returns: The extracted JSON string, or nil if no valid JSON is found
    public static func extractJSON(from response: String) -> String? {
        return JSONExtractor.extractJSON(from: response)
    }
    
    /// Attempts to repair common JSON errors in model responses.
    ///
    /// This method fixes common JSON issues like trailing commas, missing quotes,
    /// and single quotes instead of double quotes.
    ///
    /// Example usage:
    /// ```swift
    /// let malformedJSON = "{name: 'John', age: 30,}"
    /// if let repaired = FoundryModelSession.repairJSON(malformedJSON) {
    ///     // Use the repaired JSON: {"name": "John", "age": 30}
    /// }
    /// ```
    ///
    /// - Parameter jsonString: The potentially malformed JSON string
    /// - Returns: A repaired JSON string, or nil if repair failed
    public static func repairJSON(_ jsonString: String) -> String? {
        return JSONExtractor.repairJSON(jsonString)
    }
}
*/

// MARK: - Advanced MLX Access

extension FoundryModelSession {
    
    /// Provides access to the underlying MLX model context for advanced operations.
    ///
    /// This method returns the MLX model context if the session is using an MLX backend.
    /// Use this for direct access to MLX features not exposed through the standard API.
    ///
    /// Example usage:
    /// ```swift
    /// let session = FoundryModelSession(model: .mlx(.qwen2_5_3B_4bit))
    /// if let mlxContext = await session.getMLXModelContext() {
    ///     // Use mlxContext for advanced operations
    ///     let tokenizer = mlxContext.tokenizer
    ///     let model = mlxContext.model
    /// }
    /// ```
    ///
    /// - Returns: The MLX ModelContext if using MLX backend, nil otherwise
    /// - Note: This is an advanced API. Most users should use the standard generation methods.
    @available(iOS 16.0, macOS 13.0, *)
    public func getMLXModelContext() async -> ModelContext? {
        guard model.isMLX else { return nil }
        
        if let mlxBackend = backend as? MLXBackend {
            return mlxBackend.getMLXModel()
        }
        
        return nil
    }
    
    // Commented out for 0.0.1 release - focusing on simple text generation only
    // Creates a guided generation session for structured JSON generation with MLX models.
    //
    // This method creates a session that enforces token-level constraints to ensure
    // the generated output conforms to a specific JSON schema.
    //
    // Example usage:
    // ```swift
    // let schema = RuntimeGenerationSchema(root: schemaNode, dependencies: [])
    // if let guidedSession = await session.createGuidedSession(schema: schema) {
    //     let result = try await guidedSession.generate(prompt: "Create a user")
    // }
    // ```
    //
    // - Parameters:
    //   - schema: The generation schema to enforce
    //   - temperature: Temperature for sampling (default: 0.7)
    //   - topP: Top-p sampling parameter (default: 1.0)
    // - Returns: A GuidedGenerationSession if using MLX backend, nil otherwise
    // @available(iOS 16.0, macOS 13.0, *)
    // public func createGuidedSession(
    //     schema: RuntimeGenerationSchema,
    //     temperature: Float = 0.7,
    //     topP: Float = 1.0
    // ) async -> GuidedGenerationSession? {
    //     guard model.isMLX else { return nil }
    //     
    //     if let mlxBackend = backend as? MLXBackend {
    //         return mlxBackend.createGuidedSession(
    //             schema: schema,
    //             temperature: temperature,
    //             topP: topP
    //         )
    //     }
    //     
    //     return nil
    // }
}

// MARK: - Private Helpers

extension FoundryModelSession {
    
    private func updateTranscript(with entries: ArraySlice<Transcript.Entry>) {
        // Update internal transcript with new entries
        for entry in entries {
            transcript.entries.append(entry)
        }
    }
    
    // Commented out for 0.0.1 release - focusing on simple text generation only
    // private func convertToFoundationModelSchema(_ schema: DynamicGenerationSchema) -> FoundationModels.DynamicGenerationSchema {
    //     // Handle anyOf case first
    //     if let anyOf = schema.anyOf {
    //         return FoundationModels.DynamicGenerationSchema(name: schema.name, anyOf: anyOf)
    //     }
    //     
    //     // Convert properties to Foundation Models format
    //     var convertedProperties: [FoundationModels.DynamicGenerationSchema.Property] = []
    //     
    //     for property in schema.properties {
    //         let convertedSchema = convertToFoundationModelSchema(property.schema)
    //         
    //         // Create property
    //         // Note: FoundationModels.DynamicGenerationSchema doesn't support required properties
    //         // in the same way as our internal schema, so this information is lost in conversion
    //         let fmProperty = FoundationModels.DynamicGenerationSchema.Property(
    //             name: property.name,
    //             schema: convertedSchema
    //         )
    //         convertedProperties.append(fmProperty)
    //     }
    //     
    //     // Create schema with all properties
    //     let fmSchema = FoundationModels.DynamicGenerationSchema(
    //         name: schema.name,
    //         properties: convertedProperties
    //     )
    //     
    //     return fmSchema
    // }
}

// MARK: - AsyncSequence Conformance for ResponseStream

// Commented out for 0.0.1 release - focusing on simple text generation only
/*
extension FoundryModelSession.ResponseStream: AsyncSequence {
    public typealias Element = Content.PartiallyGenerated
    
    public func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(asyncSequence.makeAsyncIterator())
    }
    
    public struct AsyncIterator: AsyncIteratorProtocol {
        private var iterator: any AsyncIteratorProtocol
        
        init<I: AsyncIteratorProtocol>(_ iterator: I) where I.Element == Content.PartiallyGenerated {
            self.iterator = iterator
        }
        
        public mutating func next() async throws -> Content.PartiallyGenerated? {
            return try await iterator.next() as? Content.PartiallyGenerated
        }
    }
}
*/