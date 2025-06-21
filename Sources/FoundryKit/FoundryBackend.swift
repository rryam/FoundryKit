import Foundation
import FoundationModels

/// Protocol for backend implementations that provide language model capabilities.
///
/// Conforming types implement the underlying functionality for generating responses
/// using different model backends (e.g., MLX or Foundation Models).
///
/// To create a custom backend:
/// ```swift
/// public class MyCustomBackend: FoundryBackend {
///     public func prewarm() {
///         // Preload model resources
///     }
///     
///     public func respond(
///         to prompt: String,
///         options: FoundryGenerationOptions
///     ) async throws -> BackendResponse<String> {
///         // Generate response
///     }
///     // ... implement other required methods
/// }
/// ```
public protocol FoundryBackend: Sendable {
    
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

/// Response type returned by backend implementations.
///
/// Contains the generated content along with transcript entries that record
/// the conversation history.
public struct BackendResponse<Content: Sendable>: Sendable {
    /// The generated content.
    public let content: Content
    
    /// The transcript entries recording the conversation.
    public let transcriptEntries: ArraySlice<Transcript.Entry>
    
    /// Creates a backend response.
    ///
    /// - Parameters:
    ///   - content: The generated content
    ///   - transcriptEntries: The transcript entries for this interaction
    public init(content: Content, transcriptEntries: ArraySlice<Transcript.Entry>) {
        self.content = content
        self.transcriptEntries = transcriptEntries
    }
}