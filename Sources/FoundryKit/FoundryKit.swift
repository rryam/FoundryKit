import Foundation
import FoundationModels

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

/// Re-export Foundation Models types for convenience with Foundry suffix
// Commented out for 0.0.1 release - focusing on simple text generation only
/*
public typealias FoundryGenerable = FoundationModels.Generable
public typealias FoundryGeneratedContent = FoundationModels.GeneratedContent
public typealias FoundryGenerationGuide = FoundationModels.GenerationGuide
public typealias FoundryGenerationSchema = FoundationModels.GenerationSchema
*/

// Internal type aliases for compatibility with internal code
internal typealias Generable = FoundationModels.Generable
internal typealias GeneratedContent = FoundationModels.GeneratedContent
public typealias FoundryInstructions = FoundationModels.Instructions
public typealias FoundryInstructionsBuilder = FoundationModels.InstructionsBuilder
public typealias FoundryInstructionsRepresentable = FoundationModels.InstructionsRepresentable
public typealias FoundryPrompt = FoundationModels.Prompt
public typealias FoundryPromptBuilder = FoundationModels.PromptBuilder
public typealias FoundryPromptRepresentable = FoundationModels.PromptRepresentable
public typealias FoundryTranscript = FoundationModels.Transcript
public typealias FoundryTool = FoundationModels.Tool
public typealias FoundryGuardrails = FoundationModels.LanguageModelSession.Guardrails
/*
public typealias FoundryConvertibleFromGeneratedContent = FoundationModels
  .ConvertibleFromGeneratedContent
public typealias FoundryConvertibleToGeneratedContent = FoundationModels
  .ConvertibleToGeneratedContent
public typealias FoundryGenerationID = FoundationModels.GenerationID
*/

// MARK: - Compatibility Type Aliases

// For backward compatibility and convenience, also expose without Foundry prefix
// Commented out for 0.0.1 release - focusing on simple text generation only
/*
public typealias Generable = FoundryGenerable
public typealias GeneratedContent = FoundryGeneratedContent
public typealias GenerationGuide = FoundryGenerationGuide
public typealias GenerationSchema = FoundryGenerationSchema
*/
public typealias Instructions = FoundryInstructions
public typealias InstructionsBuilder = FoundryInstructionsBuilder
public typealias InstructionsRepresentable = FoundryInstructionsRepresentable
public typealias Prompt = FoundryPrompt
public typealias PromptBuilder = FoundryPromptBuilder
public typealias PromptRepresentable = FoundryPromptRepresentable
public typealias Transcript = FoundryTranscript
public typealias Tool = FoundryTool
public typealias Guardrails = FoundryGuardrails
/*
public typealias ConvertibleFromGeneratedContent = FoundryConvertibleFromGeneratedContent
public typealias ConvertibleToGeneratedContent = FoundryConvertibleToGeneratedContent
public typealias GenerationID = FoundryGenerationID
*/
