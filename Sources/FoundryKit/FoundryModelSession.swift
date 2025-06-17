import Foundation
import Observation
import FoundationModels

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
    
    /// A structure that stores the output of a response stream.
    public struct ResponseStream<Content> where Content: Generable & Sendable {
        private let asyncSequence: any AsyncSequence<Content.PartiallyGenerated, any Error>
        
        internal init<S: AsyncSequence>(_ sequence: S) where S.Element == Content.PartiallyGenerated, S.Failure == any Error {
            self.asyncSequence = sequence
        }
    }
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

// MARK: - Streaming Generation

extension FoundryModelSession {
    
    /// Produces a response stream to a prompt for generable types.
    public func streamResponse<Content>(
        to prompt: String,
        generating type: Content.Type,
        includeSchemaInPrompt: Bool = true,
        options: FoundryGenerationOptions = FoundryGenerationOptions()
    ) -> ResponseStream<Content> where Content: Generable & Sendable {
        let stream = backend.streamResponse(
            to: prompt,
            generating: type,
            includeSchemaInPrompt: includeSchemaInPrompt,
            options: options
        )
        return ResponseStream(stream)
    }
    
    /// Produces a response stream to a Prompt for generable types.
    public func streamResponse<Content>(
        to prompt: Prompt,
        generating type: Content.Type,
        includeSchemaInPrompt: Bool = true,
        options: FoundryGenerationOptions = FoundryGenerationOptions()
    ) -> ResponseStream<Content> where Content: Generable & Sendable {
        let stream = backend.streamResponse(
            to: prompt,
            generating: type,
            includeSchemaInPrompt: includeSchemaInPrompt,
            options: options
        )
        return ResponseStream(stream)
    }
}

// MARK: - Private Helpers

extension FoundryModelSession {
    
    private func updateTranscript(with entries: ArraySlice<Transcript.Entry>) {
        // Update internal transcript with new entries
        for entry in entries {
            transcript.entries.append(entry)
        }
    }
}

// MARK: - AsyncSequence Conformance for ResponseStream

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