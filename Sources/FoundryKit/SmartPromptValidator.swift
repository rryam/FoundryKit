import Foundation

/// Smart prompt engineering for better JSON generation
public struct SmartPromptValidator {

  /// Generate improved prompts that lead to more valid JSON
  public static func createValidationPrompt<T: Codable>(
    for type: T.Type,
    schema: [String: Any],
    userPrompt: String,
    includeExamples: Bool = true
  ) -> String {

    var prompt = """
      You are a JSON generator. You MUST respond with valid JSON only, no additional text.

      User Request: \(userPrompt)

      JSON Schema:
      \(formatSchema(schema))

      Requirements:
      - Output ONLY valid JSON that matches the schema exactly
      - No explanations, no markdown, no extra text
      - All required fields must be present
      - Respect all validation constraints (min/max, patterns, etc.)

      """

    if includeExamples {
      prompt += "\nExample valid output:\n"
      if let example = generateExample(from: schema) {
        prompt += example
      }
    }

    prompt += "\n\nJSON:"

    return prompt
  }

  /// Create a self-correcting prompt that validates its own output
  public static func createSelfCorrectingPrompt<T: Codable>(
    for type: T.Type,
    schema: [String: Any],
    userPrompt: String,
    invalidJSON: String? = nil
  ) -> String {

    var prompt = """
      You are a JSON generator with self-correction capabilities.

      User Request: \(userPrompt)

      JSON Schema:
      \(formatSchema(schema))

      """

    if let invalidJSON = invalidJSON {
      prompt += """

        PREVIOUS ATTEMPT WAS INVALID:
        \(invalidJSON)

        Common Issues to Fix:
        - Missing required fields
        - Incorrect data types  
        - Values outside allowed ranges
        - Invalid array lengths
        - Pattern mismatches

        """
    }

    prompt += """

      Generate valid JSON that:
      1. Includes ALL required fields
      2. Matches data types exactly
      3. Respects all constraints
      4. Contains no extra fields

      Output ONLY the JSON, nothing else:
      """

    return prompt
  }

  /// Create validation-aware chat messages
  public static func createValidationMessages<T: Codable>(
    for type: T.Type,
    schema: [String: Any],
    userRequest: String
  ) -> [[String: String]] {

    let systemMessage = """
      You are a precise JSON generator. Your responses must be valid JSON that exactly matches the provided schema.

      Schema: \(formatSchema(schema))

      Rules:
      - Respond with JSON only
      - Include all required fields
      - Respect all constraints
      - Use correct data types
      """

    let userMessage = """
      Generate JSON for: \(userRequest)

      Respond with valid JSON only:
      """

    return [
      ["role": "system", "content": systemMessage],
      ["role": "user", "content": userMessage],
    ]
  }

  // MARK: - Private Helpers

  private static func formatSchema(_ schema: [String: Any]) -> String {
    do {
      let data = try JSONSerialization.data(withJSONObject: schema, options: .prettyPrinted)
      return String(data: data, encoding: .utf8) ?? "Invalid schema"
    } catch {
      return "Schema formatting error: \(error)"
    }
  }

  private static func generateExample(from schema: [String: Any]) -> String? {
    // Generate a simple example based on schema
    guard let properties = schema["properties"] as? [String: Any] else {
      return nil
    }

    var example: [String: Any] = [:]

    for (key, propSchema) in properties {
      if let propDict = propSchema as? [String: Any],
        let type = propDict["type"] as? String
      {

        example[key] = generateExampleValue(for: type, schema: propDict)
      }
    }

    do {
      let data = try JSONSerialization.data(withJSONObject: example, options: .prettyPrinted)
      return String(data: data, encoding: .utf8)
    } catch {
      return nil
    }
  }

  private static func generateExampleValue(for type: String, schema: [String: Any]) -> Any {
    switch type {
    case "string":
      if let enumValues = schema["enum"] as? [String], let first = enumValues.first {
        return first
      }
      if let pattern = schema["pattern"] as? String {
        return generateExampleForPattern(pattern)
      }
      return "example"

    case "integer":
      let min = schema["minimum"] as? Int ?? 0
      let max = schema["maximum"] as? Int ?? 100
      return min + (max - min) / 2

    case "number":
      let min = schema["minimum"] as? Double ?? 0.0
      let max = schema["maximum"] as? Double ?? 100.0
      return min + (max - min) / 2

    case "boolean":
      return true

    case "array":
      if let items = schema["items"] as? [String: Any],
        let itemType = items["type"] as? String
      {
        let minItems = schema["minItems"] as? Int ?? 1
        return Array(0..<minItems).map { _ in
          generateExampleValue(for: itemType, schema: items)
        }
      }
      return ["example"]

    default:
      return "example"
    }
  }

  private static func generateExampleForPattern(_ pattern: String) -> String {
    // Simple pattern matching for common cases
    switch pattern {
    case let p where p.contains("email") || p.contains("@"):
      return "user@example.com"
    case let p where p.contains("username"):
      return "user123"
    case let p where p.contains("phone"):
      return "+1234567890"
    case let p where p.contains("url") || p.contains("http"):
      return "https://example.com"
    default:
      return "example"
    }
  }
}
