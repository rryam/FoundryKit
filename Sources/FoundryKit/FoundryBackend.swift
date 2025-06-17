import Foundation
import FoundationModels

/// Internal protocol for backend implementations.
internal protocol FoundryBackend: Sendable {
    
    /// Preloads model resources if possible.
    func prewarm()
    
    /// Generates a text response to a string prompt.
    func respond(
        to prompt: String,
        options: FoundryGenerationOptions
    ) async throws -> BackendResponse<String>
    
    /// Generates a text response to a Prompt.
    func respond(
        to prompt: Prompt,
        options: FoundryGenerationOptions
    ) async throws -> BackendResponse<String>
    
    /// Generates a structured response to a string prompt.
    func respond<Content>(
        to prompt: String,
        generating type: Content.Type,
        includeSchemaInPrompt: Bool,
        options: FoundryGenerationOptions
    ) async throws -> BackendResponse<Content> where Content: Generable & Sendable
    
    /// Generates a structured response to a Prompt.
    func respond<Content>(
        to prompt: Prompt,
        generating type: Content.Type,
        includeSchemaInPrompt: Bool,
        options: FoundryGenerationOptions
    ) async throws -> BackendResponse<Content> where Content: Generable & Sendable
    
    /// Streams a structured response to a string prompt.
    func streamResponse<Content>(
        to prompt: String,
        generating type: Content.Type,
        includeSchemaInPrompt: Bool,
        options: FoundryGenerationOptions
    ) -> any AsyncSequence<Content.PartiallyGenerated, any Error> where Content: Generable & Sendable
    
    /// Streams a structured response to a Prompt.
    func streamResponse<Content>(
        to prompt: Prompt,
        generating type: Content.Type,
        includeSchemaInPrompt: Bool,
        options: FoundryGenerationOptions
    ) -> any AsyncSequence<Content.PartiallyGenerated, any Error> where Content: Generable & Sendable
}

/// Internal response type for backends.
internal struct BackendResponse<Content: Sendable>: Sendable {
    let content: Content
    let transcriptEntries: ArraySlice<Transcript.Entry>
    
    init(content: Content, transcriptEntries: ArraySlice<Transcript.Entry>) {
        self.content = content
        self.transcriptEntries = transcriptEntries
    }
}