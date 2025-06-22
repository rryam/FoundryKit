import Foundation

// MARK: - Structured Output Protocol

/// Protocol for types that can be generated as structured output by language models.
/// This extends the Generable protocol with additional metadata for MLX models.
internal protocol StructuredOutput: Generable {
    /// Returns a JSON schema representation of this type
    static var jsonSchema: [String: Any] { get }
    
    /// Returns example JSON for this type to help guide generation
    static var exampleJSON: String? { get }
}

// Default implementation
extension StructuredOutput {
    internal static var exampleJSON: String? { nil }
}

// MARK: - Structured Generation Configuration

/// Configuration options for structured generation with MLX models
internal struct StructuredGenerationConfig: Sendable {
    /// Whether to include the schema in the prompt
    internal let includeSchemaInPrompt: Bool
    
    /// Whether to include an example in the prompt
    internal let includeExample: Bool
    
    /// Maximum number of retries for parsing
    internal let maxRetries: Int
    
    /// Custom system prompt for structured generation
    internal let systemPrompt: String?
    
    /// Temperature override for structured generation (lower is more deterministic)
    internal let temperature: Double?
    
    /// Model type identifier for model-specific prompting
    internal let modelType: String?
    
    internal init(
        includeSchemaInPrompt: Bool = true,
        includeExample: Bool = true,
        maxRetries: Int = 3,
        systemPrompt: String? = nil,
        temperature: Double? = 0.7,
        modelType: String? = nil
    ) {
        self.includeSchemaInPrompt = includeSchemaInPrompt
        self.includeExample = includeExample
        self.maxRetries = maxRetries
        self.systemPrompt = systemPrompt
        self.temperature = temperature
        self.modelType = modelType
    }
    
    internal static let `default` = StructuredGenerationConfig()
}

// MARK: - Tool/Function Calling Support

/// Represents a function that can be called by the model
internal struct FunctionSpec {
    internal let name: String
    internal let description: String
    internal let parameters: [String: Any]
    internal let required: [String]
    
    internal init(
        name: String,
        description: String,
        parameters: [String: Any],
        required: [String] = []
    ) {
        self.name = name
        self.description = description
        self.parameters = parameters
        self.required = required
    }
    
    /// Converts to JSON representation for the prompt
    internal var jsonRepresentation: [String: Any] {
        [
            "name": name,
            "description": description,
            "parameters": [
                "type": "object",
                "properties": parameters,
                "required": required
            ]
        ]
    }
}

/// Represents a function call made by the model
internal struct FunctionCall: Codable {
    internal let name: String
    internal let arguments: [String: Any]
    
    internal init(name: String, arguments: [String: Any]) {
        self.name = name
        self.arguments = arguments
    }
    
    // Custom Codable implementation to handle Any types
    private enum CodingKeys: String, CodingKey {
        case name
        case arguments
    }
    
    internal init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        
        // Decode arguments as a dictionary
        if let argumentsData = try? container.decode(Data.self, forKey: .arguments),
           let argumentsJSON = try? JSONSerialization.jsonObject(with: argumentsData) as? [String: Any] {
            arguments = argumentsJSON
        } else {
            arguments = [:]
        }
    }
    
    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        
        // Encode arguments as JSON data
        if let argumentsData = try? JSONSerialization.data(withJSONObject: arguments) {
            try container.encode(argumentsData, forKey: .arguments)
        }
    }
}

// MARK: - JSON Parsing Utilities

/// Utilities for extracting and parsing JSON from LLM responses
internal enum JSONExtractor {
    /// Extracts JSON from a response that may contain additional text
    internal static func extractJSON(from response: String) -> String? {
        // Try to find JSON between code blocks first
        if let match = response.range(of: "```json\\n[\\s\\S]+?\\n```", options: .regularExpression) {
            let jsonContent = String(response[match])
                .replacingOccurrences(of: "```json\n", with: "")
                .replacingOccurrences(of: "\n```", with: "")
            return jsonContent
        }
        
        // Try to find JSON between triple backticks without language specifier
        if let match = response.range(of: "```\\n[\\s\\S]+?\\n```", options: .regularExpression) {
            let content = String(response[match])
                .replacingOccurrences(of: "```\n", with: "")
                .replacingOccurrences(of: "\n```", with: "")
            if isLikelyJSON(content) {
                return content
            }
        }
        
        // Try to find raw JSON object or array
        if let firstBrace = response.firstIndex(of: "{"),
           let lastBrace = response.lastIndex(of: "}") {
            let jsonString = String(response[firstBrace...lastBrace])
            if isValidJSON(jsonString) {
                return jsonString
            }
        }
        
        if let firstBracket = response.firstIndex(of: "["),
           let lastBracket = response.lastIndex(of: "]") {
            let jsonString = String(response[firstBracket...lastBracket])
            if isValidJSON(jsonString) {
                return jsonString
            }
        }
        
        // If the entire response might be JSON
        if isValidJSON(response) {
            return response
        }
        
        return nil
    }
    
    /// Checks if a string is likely JSON based on its structure
    private static func isLikelyJSON(_ string: String) -> Bool {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        return (trimmed.hasPrefix("{") && trimmed.hasSuffix("}")) ||
               (trimmed.hasPrefix("[") && trimmed.hasSuffix("]"))
    }
    
    /// Validates if a string is valid JSON
    private static func isValidJSON(_ string: String) -> Bool {
        guard let data = string.data(using: .utf8) else { return false }
        do {
            _ = try JSONSerialization.jsonObject(with: data)
            return true
        } catch {
            return false
        }
    }
    
    /// Attempts to fix common JSON errors in LLM responses
    internal static func repairJSON(_ jsonString: String) -> String? {
        var repaired = jsonString
        
        // Fix trailing commas
        repaired = repaired.replacingOccurrences(
            of: ",\\s*}",
            with: "}",
            options: .regularExpression
        )
        repaired = repaired.replacingOccurrences(
            of: ",\\s*]",
            with: "]",
            options: .regularExpression
        )
        
        // Fix missing quotes around keys (simple cases)
        repaired = repaired.replacingOccurrences(
            of: "(\\w+):",
            with: "\"$1\":",
            options: .regularExpression
        )
        
        // Fix single quotes to double quotes
        repaired = repaired.replacingOccurrences(of: "'", with: "\"")
        
        // Validate the repaired JSON
        if isValidJSON(repaired) {
            return repaired
        }
        
        return nil
    }
}

// MARK: - Prompt Building

/// Utilities for building prompts for structured generation
internal enum StructuredPromptBuilder {
    /// Creates a prompt for structured data generation
    internal static func buildPrompt(
        userPrompt: String,
        schema: [String: Any],
        example: String? = nil,
        config: StructuredGenerationConfig = .default
    ) -> String {
        let schemaJSON: String
        if let schemaData = try? JSONSerialization.data(
            withJSONObject: schema,
            options: .prettyPrinted
        ), let str = String(data: schemaData, encoding: .utf8) {
            schemaJSON = str
        } else {
            schemaJSON = "{}"
        }
        
        // Use model-specific prompt format
        return buildModelSpecificPrompt(
            userPrompt: userPrompt,
            schemaJSON: schemaJSON,
            example: example,
            modelType: config.modelType ?? "default",
            config: config
        )
    }
    
    /// Creates model-specific prompts for better structured generation
    private static func buildModelSpecificPrompt(
        userPrompt: String,
        schemaJSON: String,
        example: String?,
        modelType: String,
        config: StructuredGenerationConfig
    ) -> String {
        let modelIdentifier = modelType.lowercased()
        
        switch modelIdentifier {
        case let id where id.contains("llama") || id.contains("meta-llama"):
            return buildLlamaStylePrompt(userPrompt: userPrompt, schemaJSON: schemaJSON, example: example, config: config)
            
        case let id where id.contains("qwen"):
            return buildQwenStylePrompt(userPrompt: userPrompt, schemaJSON: schemaJSON, example: example, config: config)
            
        case let id where id.contains("mistral"):
            return buildMistralStylePrompt(userPrompt: userPrompt, schemaJSON: schemaJSON, example: example, config: config)
            
        case let id where id.contains("phi"):
            return buildPhiStylePrompt(userPrompt: userPrompt, schemaJSON: schemaJSON, example: example, config: config)
            
        default:
            return buildDefaultPrompt(userPrompt: userPrompt, schemaJSON: schemaJSON, example: example, config: config)
        }
    }
    
    // MARK: - Model-Specific Prompt Builders
    
    private static func buildLlamaStylePrompt(
        userPrompt: String,
        schemaJSON: String,
        example: String?,
        config: StructuredGenerationConfig
    ) -> String {
        var prompt = userPrompt
        
        if config.includeSchemaInPrompt {
            prompt += "\n\nYou must respond with a JSON object that conforms to the following schema:\n```json\n\(schemaJSON)\n```"
        }
        
        if config.includeExample, let example = example {
            prompt += "\n\nExample output format:\n```json\n\(example)\n```"
        }
        
        prompt += "\n\nProvide only the JSON object with no additional text or markdown formatting."
        
        return prompt
    }
    
    private static func buildQwenStylePrompt(
        userPrompt: String,
        schemaJSON: String,
        example: String?,
        config: StructuredGenerationConfig
    ) -> String {
        var prompt = userPrompt
        
        if config.includeSchemaInPrompt {
            prompt += "\n\n请按照以下JSON模式响应 (Respond according to this JSON schema):\n```json\n\(schemaJSON)\n```"
        }
        
        if config.includeExample, let example = example {
            prompt += "\n\n示例 (Example):\n```json\n\(example)\n```"
        }
        
        prompt += "\n\n仅返回JSON对象，不要包含其他文本。(Return only the JSON object, no other text.)"
        
        return prompt
    }
    
    private static func buildMistralStylePrompt(
        userPrompt: String,
        schemaJSON: String,
        example: String?,
        config: StructuredGenerationConfig
    ) -> String {
        var prompt = "[INST] " + userPrompt
        
        if config.includeSchemaInPrompt {
            prompt += "\n\nGenerate a JSON response following this exact schema:\n```json\n\(schemaJSON)\n```"
        }
        
        if config.includeExample, let example = example {
            prompt += "\n\nHere is an example of the expected format:\n```json\n\(example)\n```"
        }
        
        prompt += "\n\nOutput only valid JSON. [/INST]"
        
        return prompt
    }
    
    private static func buildPhiStylePrompt(
        userPrompt: String,
        schemaJSON: String,
        example: String?,
        config: StructuredGenerationConfig
    ) -> String {
        var prompt = "Instruction: " + userPrompt
        
        if config.includeSchemaInPrompt {
            prompt += "\n\nOutput format (JSON schema):\n\(schemaJSON)"
        }
        
        if config.includeExample, let example = example {
            prompt += "\n\nExample:\n\(example)"
        }
        
        prompt += "\n\nOutput:"
        
        return prompt
    }
    
    private static func buildDefaultPrompt(
        userPrompt: String,
        schemaJSON: String,
        example: String?,
        config: StructuredGenerationConfig
    ) -> String {
        var prompt = userPrompt
        
        if config.includeSchemaInPrompt {
            prompt += "\n\nPlease respond with valid JSON that matches this schema:\n```json\n\(schemaJSON)\n```"
        }
        
        if config.includeExample, let example = example {
            prompt += "\n\nHere's an example of the expected format:\n```json\n\(example)\n```"
        }
        
        prompt += "\n\nIMPORTANT: Respond ONLY with valid JSON, no additional text or explanation."
        
        return prompt
    }
    
    /// Creates a prompt for function/tool calling
    internal static func buildToolCallingPrompt(
        userPrompt: String,
        functions: [FunctionSpec],
        config: StructuredGenerationConfig = .default
    ) -> String {
        let functionsJSON = functions.map { $0.jsonRepresentation }
        let functionsString: String
        if let functionsData = try? JSONSerialization.data(
            withJSONObject: functionsJSON,
            options: .prettyPrinted
        ), let str = String(data: functionsData, encoding: .utf8) {
            functionsString = str
        } else {
            functionsString = "[]"
        }
        
        return """
        You have access to the following functions:
        
        \(functionsString)
        
        To use a function, respond with a JSON object in this format:
        {
            "function_call": {
                "name": "function_name",
                "arguments": {
                    "param1": "value1",
                    "param2": "value2"
                }
            }
        }
        
        User request: \(userPrompt)
        
        Determine if you need to use a function to answer this request. If so, respond with the appropriate function call. If not, respond with:
        {
            "response": "your text response here"
        }
        """
    }
    
    /// Creates a system prompt optimized for structured generation
    internal static func structuredSystemPrompt(modelType: String? = nil) -> String {
        let basePrompt = "You are a helpful assistant that always responds with valid JSON when requested."
        
        // Add model-specific instructions if known
        if let model = modelType?.lowercased() {
            if model.contains("qwen") {
                return basePrompt + " You have native support for structured outputs and tool calling."
            } else if model.contains("mistral") || model.contains("mixtral") {
                return basePrompt + " Follow the JSON schema precisely and ensure all required fields are included."
            } else if model.contains("llama") {
                return basePrompt + " When given a JSON schema, strictly follow its structure without adding extra fields."
            }
        }
        
        return basePrompt
    }
}

// MARK: - Schema Extraction Helpers

/// Helper to extract schema information from Swift types
internal enum SchemaExtractor {
    /// Basic schema extraction for common types
    internal static func extractSchema(from type: Any.Type) -> [String: Any] {
        // This is a simplified implementation
        // In a real implementation, we would use Mirror or other reflection APIs
        var schema: [String: Any] = ["type": "object"]
        let properties: [String: Any] = [:]
        
        // For now, return a basic schema
        // Real implementation would inspect the type's properties
        schema["properties"] = properties
        
        return schema
    }
    
    /// Creates a schema for a function parameter
    internal static func parameterSchema(
        type: String,
        description: String? = nil,
        enum values: [Any]? = nil,
        format: String? = nil
    ) -> [String: Any] {
        var schema: [String: Any] = ["type": type]
        
        if let desc = description {
            schema["description"] = desc
        }
        
        if let values = values {
            schema["enum"] = values
        }
        
        if let format = format {
            schema["format"] = format
        }
        
        return schema
    }
}