// Commented out for 0.0.1 release - focusing on simple text generation only
/*
import Foundation
import MLX
import MLXLLM
import MLXLMCommon
import Tokenizers

/// Simple JSON validation for generated content
public struct SimpleJSONValidator {

  /// Validate generated JSON against a schema with retry capability
  public static func validateAndRetry<T: Codable>(
    model: LanguageModel,
    tokenizer: Tokenizer,
    schema: [String: Any],
    maxRetries: Int = 3,
    prompt: String
  ) async throws -> T {

    for attempt in 1...maxRetries {
      print("🔄 Validation attempt \(attempt)/\(maxRetries)")

      // Generate JSON
      let generatedText = try await generateText(
        model: model,
        tokenizer: tokenizer,
        prompt: prompt
      )

      // Try to parse and validate
      if let validObject: T = try? parseAndValidate(
        jsonText: generatedText,
        schema: schema
      ) {
        print("✅ Valid JSON generated on attempt \(attempt)")
        return validObject
      }

      print("❌ Invalid JSON on attempt \(attempt), retrying...")
    }

    throw ValidationError.maxRetriesExceeded
  }

  /// Generate text using MLX model
  private static func generateText(
    model: LanguageModel,
    tokenizer: Tokenizer,
    prompt: String
  ) async throws -> String {

    let messages = [
      ["role": "user", "content": prompt]
    ]

    let input = try await tokenizer.apply(chat: messages)
    let parameters = GenerateParameters(maxTokens: 1000, temperature: 0.1)

    var generatedText = ""
    let generate = try await model.generate(
      input: input,
      parameters: parameters
    ) { token in
      generatedText += tokenizer.decode(tokens: [token])
      return .more
    }

    return generatedText
  }

  /// Parse JSON and validate against schema
  private static func parseAndValidate<T: Codable>(
    jsonText: String,
    schema: [String: Any]
  ) throws -> T {

    // Extract JSON from response (handle cases with extra text)
    guard let cleanJSON = extractJSON(from: jsonText) else {
      throw ValidationError.noJSONFound
    }

    // Basic JSON syntax validation
    guard let data = cleanJSON.data(using: .utf8),
      JSONSerialization.isValidJSONObject(try JSONSerialization.jsonObject(with: data))
    else {
      throw ValidationError.invalidJSONSyntax
    }

    // Decode to target type
    let decoder = JSONDecoder()
    do {
      return try decoder.decode(T.self, from: data)
    } catch {
      throw ValidationError.schemaValidationFailed(error)
    }
  }

  /// Extract JSON from potentially messy generated text
  private static func extractJSON(from text: String) -> String? {
    // Look for JSON blocks (between { and })
    let patterns = [
      "\\{[^{}]*(?:\\{[^{}]*\\}[^{}]*)*\\}",  // Simple nested objects
      "```json\\s*([\\s\\S]*?)```",  // Markdown JSON blocks
      "```\\s*([\\s\\S]*?)```",  // Generic code blocks
    ]

    for pattern in patterns {
      if let range = text.range(of: pattern, options: .regularExpression) {
        var jsonCandidate = String(text[range])

        // Clean up markdown markers
        jsonCandidate =
          jsonCandidate
          .replacingOccurrences(of: "```json", with: "")
          .replacingOccurrences(of: "```", with: "")
          .trimmingCharacters(in: .whitespacesAndNewlines)

        return jsonCandidate
      }
    }

    // Fallback: return the text as-is if it looks like JSON
    let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmed.hasPrefix("{") && trimmed.hasSuffix("}") {
      return trimmed
    }

    return nil
  }
}

/// Validation errors
public enum ValidationError: Error, LocalizedError {
  case maxRetriesExceeded
  case noJSONFound
  case invalidJSONSyntax
  case schemaValidationFailed(Error)

  public var errorDescription: String? {
    switch self {
    case .maxRetriesExceeded:
      return "Failed to generate valid JSON after maximum retries"
    case .noJSONFound:
      return "No JSON found in generated text"
    case .invalidJSONSyntax:
      return "Generated text is not valid JSON"
    case .schemaValidationFailed(let error):
      return "Schema validation failed: \(error.localizedDescription)"
    }
  }
}
*/