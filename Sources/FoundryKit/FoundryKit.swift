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
  /// Re-export Foundation Models types for convenience with Foundry suffix
  public typealias FoundryGenerable = FoundationModels.Generable
  public typealias FoundryGeneratedContent = FoundationModels.GeneratedContent
  public typealias FoundryGenerationGuide = FoundationModels.GenerationGuide
  public typealias FoundryGenerationSchema = FoundationModels.GenerationSchema
  public typealias FoundryInstructions = FoundationModels.Instructions
  public typealias FoundryInstructionsBuilder = FoundationModels.InstructionsBuilder
  public typealias FoundryInstructionsRepresentable = FoundationModels.InstructionsRepresentable
  public typealias FoundryPrompt = FoundationModels.Prompt
  public typealias FoundryPromptBuilder = FoundationModels.PromptBuilder
  public typealias FoundryPromptRepresentable = FoundationModels.PromptRepresentable
  public typealias FoundryTranscript = FoundationModels.Transcript
  public typealias FoundryTool = FoundationModels.Tool
  public typealias FoundryGuardrails = FoundationModels.LanguageModelSession.Guardrails
  public typealias FoundryConvertibleFromGeneratedContent = FoundationModels
    .ConvertibleFromGeneratedContent
  public typealias FoundryConvertibleToGeneratedContent = FoundationModels
    .ConvertibleToGeneratedContent
  public typealias FoundryGenerationID = FoundationModels.GenerationID

#else
  // Provide stub types when Foundation Models is not available
  public protocol FoundryGenerable {
    associatedtype PartiallyGenerated = Self
    func asPartiallyGenerated() -> PartiallyGenerated
  }

  extension FoundryGenerable {
    public func asPartiallyGenerated() -> Self {
      return self
    }
  }

  public struct FoundryPrompt: CustomDebugStringConvertible {
    public let debugDescription: String = "FoundryPrompt"
  }

  public struct FoundryInstructions {}
  
  public struct FoundryGeneratedContent {}
  public struct FoundryGenerationGuide<T> {}
  public struct FoundryGenerationSchema {}
  public protocol FoundryInstructionsRepresentable {}
  public protocol FoundryPromptRepresentable {}
  public protocol FoundryConvertibleFromGeneratedContent {}
  public protocol FoundryConvertibleToGeneratedContent {}
  public struct FoundryGenerationID {}

  public struct FoundryTranscript {
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

  public protocol FoundryTool {}

  public struct FoundryGuardrails {
    public static let `default` = FoundryGuardrails()
  }

  // Placeholder builder for when Foundation Models is not available
  @resultBuilder
  public struct FoundryPromptBuilder {
    public static func buildBlock(_ components: String...) -> FoundryPrompt {
      return FoundryPrompt()
    }
  }

#endif

// MARK: - Compatibility Type Aliases

// For backward compatibility and convenience, also expose without Foundry prefix
public typealias Generable = FoundryGenerable
public typealias GeneratedContent = FoundryGeneratedContent
public typealias GenerationGuide = FoundryGenerationGuide
public typealias GenerationSchema = FoundryGenerationSchema
public typealias Instructions = FoundryInstructions
public typealias InstructionsBuilder = FoundryInstructionsBuilder
public typealias InstructionsRepresentable = FoundryInstructionsRepresentable
public typealias Prompt = FoundryPrompt
public typealias PromptBuilder = FoundryPromptBuilder
public typealias PromptRepresentable = FoundryPromptRepresentable
public typealias Transcript = FoundryTranscript
public typealias Tool = FoundryTool
public typealias Guardrails = FoundryGuardrails
public typealias ConvertibleFromGeneratedContent = FoundryConvertibleFromGeneratedContent
public typealias ConvertibleToGeneratedContent = FoundryConvertibleToGeneratedContent
public typealias GenerationID = FoundryGenerationID
