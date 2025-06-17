#if canImport(FoundationModels)
import Foundation
import FoundationModels

/// Backend implementation that uses Apple's Foundation Models.
internal final class FoundationBackend: FoundryBackend {
    
    private let session: LanguageModelSession
    
    init(
        guardrails: Guardrails,
        tools: [any Tool],
        instructions: Instructions?
    ) {
        self.session = LanguageModelSession(
            model: .default,
            guardrails: guardrails,
            tools: tools,
            instructions: instructions
        )
    }
    
    func prewarm() {
        session.prewarm()
    }
    
    func respond(
        to prompt: String,
        options: FoundryGenerationOptions
    ) async throws -> BackendResponse<String> {
        do {
            let response = try await session.respond(
                to: prompt,
                options: options.toFoundationModels()
            )
            return BackendResponse(
                content: response.content,
                transcriptEntries: response.transcriptEntries
            )
        } catch let error as LanguageModelSession.GenerationError {
            throw mapFoundationError(error)
        } catch {
            throw FoundryGenerationError.unknown(
                FoundryGenerationError.Context(
                    debugDescription: "Unknown Foundation Models error: \(error)",
                    underlyingErrors: [error]
                )
            )
        }
    }
    
    func respond(
        to prompt: Prompt,
        options: FoundryGenerationOptions
    ) async throws -> BackendResponse<String> {
        do {
            let response = try await session.respond(
                to: prompt,
                options: options.toFoundationModels()
            )
            return BackendResponse(
                content: response.content,
                transcriptEntries: response.transcriptEntries
            )
        } catch let error as LanguageModelSession.GenerationError {
            throw mapFoundationError(error)
        } catch {
            throw FoundryGenerationError.unknown(
                FoundryGenerationError.Context(
                    debugDescription: "Unknown Foundation Models error: \(error)",
                    underlyingErrors: [error]
                )
            )
        }
    }
    
    func respond<Content>(
        to prompt: String,
        generating type: Content.Type,
        includeSchemaInPrompt: Bool,
        options: FoundryGenerationOptions
    ) async throws -> BackendResponse<Content> where Content: Generable {
        do {
            let response = try await session.respond(
                to: prompt,
                generating: type,
                includeSchemaInPrompt: includeSchemaInPrompt,
                options: options.toFoundationModels()
            )
            return BackendResponse(
                content: response.content,
                transcriptEntries: response.transcriptEntries
            )
        } catch let error as LanguageModelSession.GenerationError {
            throw mapFoundationError(error)
        } catch {
            throw FoundryGenerationError.unknown(
                FoundryGenerationError.Context(
                    debugDescription: "Unknown Foundation Models error: \(error)",
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
    ) async throws -> BackendResponse<Content> where Content: Generable {
        do {
            let response = try await session.respond(
                to: prompt,
                generating: type,
                includeSchemaInPrompt: includeSchemaInPrompt,
                options: options.toFoundationModels()
            )
            return BackendResponse(
                content: response.content,
                transcriptEntries: response.transcriptEntries
            )
        } catch let error as LanguageModelSession.GenerationError {
            throw mapFoundationError(error)
        } catch {
            throw FoundryGenerationError.unknown(
                FoundryGenerationError.Context(
                    debugDescription: "Unknown Foundation Models error: \(error)",
                    underlyingErrors: [error]
                )
            )
        }
    }
    
    func streamResponse<Content>(
        to prompt: String,
        generating type: Content.Type,
        includeSchemaInPrompt: Bool,
        options: FoundryGenerationOptions
    ) -> any AsyncSequence<Content.PartiallyGenerated, any Error> where Content: Generable {
        let stream = session.streamResponse(
            to: prompt,
            generating: type,
            includeSchemaInPrompt: includeSchemaInPrompt,
            options: options.toFoundationModels()
        )
        return FoundationStreamWrapper(stream: stream)
    }
    
    func streamResponse<Content>(
        to prompt: Prompt,
        generating type: Content.Type,
        includeSchemaInPrompt: Bool,
        options: FoundryGenerationOptions
    ) -> any AsyncSequence<Content.PartiallyGenerated, any Error> where Content: Generable {
        let stream = session.streamResponse(
            to: prompt,
            generating: type,
            includeSchemaInPrompt: includeSchemaInPrompt,
            options: options.toFoundationModels()
        )
        return FoundationStreamWrapper(stream: stream)
    }
    
    private func mapFoundationError(_ error: LanguageModelSession.GenerationError) -> FoundryGenerationError {
        switch error {
        case .exceededContextWindowSize(let context):
            return .exceededContextWindowSize(
                FoundryGenerationError.Context(
                    debugDescription: context.debugDescription,
                    underlyingErrors: context.underlyingErrors
                )
            )
        case .assetsUnavailable(let context):
            return .assetsUnavailable(
                FoundryGenerationError.Context(
                    debugDescription: context.debugDescription,
                    underlyingErrors: context.underlyingErrors
                )
            )
        case .guardrailViolation(let context):
            return .guardrailViolation(
                FoundryGenerationError.Context(
                    debugDescription: context.debugDescription,
                    underlyingErrors: context.underlyingErrors
                )
            )
        case .unsupportedGuide(let context):
            return .unsupportedGuide(
                FoundryGenerationError.Context(
                    debugDescription: context.debugDescription,
                    underlyingErrors: context.underlyingErrors
                )
            )
        case .unsupportedLanguageOrLocale(let context):
            return .unsupportedLanguageOrLocale(
                FoundryGenerationError.Context(
                    debugDescription: context.debugDescription,
                    underlyingErrors: context.underlyingErrors
                )
            )
        case .decodingFailure(let context):
            return .decodingFailure(
                FoundryGenerationError.Context(
                    debugDescription: context.debugDescription,
                    underlyingErrors: context.underlyingErrors
                )
            )
        @unknown default:
            return .unknown(
                FoundryGenerationError.Context(
                    debugDescription: "Unknown Foundation Models error: \(error)",
                    underlyingErrors: []
                )
            )
        }
    }
}

/// Wrapper to adapt Foundation Models stream to our AsyncSequence protocol.
private struct FoundationStreamWrapper<Content>: AsyncSequence where Content: Generable {
    typealias Element = Content.PartiallyGenerated
    
    private let stream: LanguageModelSession.ResponseStream<Content>
    
    init(stream: LanguageModelSession.ResponseStream<Content>) {
        self.stream = stream
    }
    
    func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(stream: stream)
    }
    
    struct AsyncIterator: AsyncIteratorProtocol {
        private var streamIterator: LanguageModelSession.ResponseStream<Content>.AsyncIterator
        
        init(stream: LanguageModelSession.ResponseStream<Content>) {
            self.streamIterator = stream.makeAsyncIterator()
        }
        
        mutating func next() async throws -> Content.PartiallyGenerated? {
            return try await streamIterator.next()
        }
    }
}

#endif