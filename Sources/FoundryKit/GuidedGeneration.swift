import Foundation
import MLX
import MLXLLM
import MLXLMCommon
@preconcurrency import Tokenizers

/// Main interface for guided JSON generation
///
/// This module provides constrained decoding capabilities that ensure
/// generated text conforms to a specific JSON schema.
public struct GuidedGeneration {

  /// Create a LogitProcessor for MLX that constrains generation to valid JSON
  internal static func createJSONProcessor(
    schema: RuntimeGenerationSchema,
    tokenizer: Tokenizer
  ) -> LogitProcessor {
    return SyncGuidedJSONProcessor(schema: schema, tokenizer: tokenizer)
  }

  /// Test if a partial JSON string could be valid according to schema
  internal static func isValidPartialJSON(
    _ partialJSON: String,
    schema: RuntimeGenerationSchema
  ) -> Bool {
    let parseState = JSONParseState(schema: schema)
    parseState.advance(with: partialJSON)

    // If we can get valid next characters, the partial JSON is valid so far
    let validChars = parseState.getValidNextCharacters()
    return !validChars.isEmpty || parseState.isComplete
  }

  /// Get the set of valid next characters for a partial JSON string
  internal static func getValidNextCharacters(
    for partialJSON: String,
    schema: RuntimeGenerationSchema
  ) -> Set<Character> {
    let parseState = JSONParseState(schema: schema)
    parseState.advance(with: partialJSON)
    return parseState.getValidNextCharacters()
  }
}
