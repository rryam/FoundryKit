import Foundation
#if canImport(FoundationModels)
import FoundationModels
#endif

// MARK: - Public API

/// FoundryKit provides a unified API for language model inference that works
/// with both MLX models and Apple's Foundation Models.
///
/// Use FoundryModelSession to interact with language models using the same
/// interface regardless of the backend.
///
/// Example usage:
/// ```swift
/// // Use MLX model
/// let mlxSession = FoundryModelSession(model: .mlx("mlx-community/Qwen3-4B"))
/// let response = try await mlxSession.respond(to: "Hello, world!")
///
/// // Use Foundation Models
/// let fmSession = FoundryModelSession(model: .foundation)
/// let structuredResponse = try await fmSession.respond(
///     to: "Create a recipe",
///     generating: Recipe.self
/// )
/// ```

// MARK: - Re-exported Foundation Models Types

#if canImport(FoundationModels)
/// Re-export Foundation Models types for convenience
public typealias Generable = FoundationModels.Generable
public typealias GeneratedContent = FoundationModels.GeneratedContent
public typealias GenerationGuide = FoundationModels.GenerationGuide
public typealias GenerationSchema = FoundationModels.GenerationSchema
public typealias Instructions = FoundationModels.Instructions
public typealias InstructionsBuilder = FoundationModels.InstructionsBuilder
public typealias InstructionsRepresentable = FoundationModels.InstructionsRepresentable
public typealias Prompt = FoundationModels.Prompt
public typealias PromptBuilder = FoundationModels.PromptBuilder
public typealias PromptRepresentable = FoundationModels.PromptRepresentable
public typealias Transcript = FoundationModels.Transcript
public typealias Tool = FoundationModels.Tool
public typealias Guardrails = FoundationModels.LanguageModelSession.Guardrails
public typealias ConvertibleFromGeneratedContent = FoundationModels.ConvertibleFromGeneratedContent
public typealias ConvertibleToGeneratedContent = FoundationModels.ConvertibleToGeneratedContent
public typealias GenerationID = FoundationModels.GenerationID

#else
// Provide stub types when Foundation Models is not available
public protocol Generable {
    associatedtype PartiallyGenerated = Self
    func asPartiallyGenerated() -> PartiallyGenerated
}

extension Generable {
    public func asPartiallyGenerated() -> Self {
        return self
    }
}

public struct Prompt: CustomDebugStringConvertible {
    public let debugDescription: String = "Prompt"
}

public struct Instructions {}

public struct Transcript {
    public var entries: [Entry] = []
    
    public init() {}
    
    public struct Entry {
        public enum Role {
            case user
            case assistant
            case system
        }
        
        public enum Content {
            case text(String)
        }
        
        public let role: Role
        public let content: [Content]
        
        public init(role: Role, content: [Content]) {
            self.role = role
            self.content = content
        }
    }
}

public protocol Tool {}

public struct Guardrails {
    public static let `default` = Guardrails()
}

// Placeholder builder for when Foundation Models is not available
@resultBuilder
public struct PromptBuilder {
    public static func buildBlock(_ components: String...) -> Prompt {
        return Prompt()
    }
}

#endif
