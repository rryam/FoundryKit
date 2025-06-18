import XCTest
@testable import FoundryKit

final class StructuredGenerationEnhancementsTests: XCTestCase {
    
    // MARK: - Model-Specific Prompting Tests
    
    func testLlamaStylePrompt() {
        let schema: [String: Any] = ["type": "object", "properties": ["name": ["type": "string"]]]
        let config = StructuredGenerationConfig(modelType: "llama-3.1-8b")
        
        let prompt = StructuredPromptBuilder.buildPrompt(
            userPrompt: "Generate a person",
            schema: schema,
            config: config
        )
        
        XCTAssertTrue(prompt.contains("You must respond with a JSON object"))
        XCTAssertTrue(prompt.contains("Provide only the JSON object with no additional text"))
        XCTAssertFalse(prompt.contains("请按照以下JSON模式响应")) // Should not contain Qwen-specific text
    }
    
    func testQwenStylePrompt() {
        let schema: [String: Any] = ["type": "object", "properties": ["name": ["type": "string"]]]
        let config = StructuredGenerationConfig(modelType: "qwen2.5-7b-instruct")
        
        let prompt = StructuredPromptBuilder.buildPrompt(
            userPrompt: "Generate a person",
            schema: schema,
            config: config
        )
        
        XCTAssertTrue(prompt.contains("请按照以下JSON模式响应"))
        XCTAssertTrue(prompt.contains("Respond according to this JSON schema"))
        XCTAssertTrue(prompt.contains("仅返回JSON对象"))
    }
    
    func testMistralStylePrompt() {
        let schema: [String: Any] = ["type": "object", "properties": ["name": ["type": "string"]]]
        let config = StructuredGenerationConfig(modelType: "mistral-7b-instruct")
        
        let prompt = StructuredPromptBuilder.buildPrompt(
            userPrompt: "Generate a person",
            schema: schema,
            config: config
        )
        
        XCTAssertTrue(prompt.contains("[INST]"))
        XCTAssertTrue(prompt.contains("[/INST]"))
        XCTAssertTrue(prompt.contains("Generate a JSON response following this exact schema"))
    }
    
    func testPhiStylePrompt() {
        let schema: [String: Any] = ["type": "object", "properties": ["name": ["type": "string"]]]
        let config = StructuredGenerationConfig(modelType: "phi-3-mini")
        
        let prompt = StructuredPromptBuilder.buildPrompt(
            userPrompt: "Generate a person",
            schema: schema,
            config: config
        )
        
        XCTAssertTrue(prompt.contains("Instruction:"))
        XCTAssertTrue(prompt.contains("Output format (JSON schema):"))
        XCTAssertTrue(prompt.contains("Output:"))
    }
    
    func testDefaultPromptForUnknownModel() {
        let schema: [String: Any] = ["type": "object", "properties": ["name": ["type": "string"]]]
        let config = StructuredGenerationConfig(modelType: "unknown-model-xyz")
        
        let prompt = StructuredPromptBuilder.buildPrompt(
            userPrompt: "Generate a person",
            schema: schema,
            config: config
        )
        
        XCTAssertTrue(prompt.contains("Please respond with valid JSON"))
        XCTAssertTrue(prompt.contains("IMPORTANT: Respond ONLY with valid JSON"))
    }
    
    // MARK: - Model Type Detection Tests
    
    func testModelTypeDetection() {
        let testCases = [
            ("meta-llama/Llama-3.2-1B", "llama"),
            ("Qwen/Qwen2.5-7B-Instruct", "qwen"),
            ("mistralai/Mistral-7B-Instruct-v0.3", "mistral"),
            ("microsoft/phi-3-mini-4k-instruct", "phi"),
            ("mlx-community/Meta-Llama-3.1-8B-Instruct-4bit", "llama")
        ]
        
        for (modelId, expectedStyle) in testCases {
            let config = StructuredGenerationConfig(modelType: modelId)
            let prompt = StructuredPromptBuilder.buildPrompt(
                userPrompt: "Test",
                schema: [:],
                config: config
            )
            
            // Verify it uses the right style based on content
            switch expectedStyle {
            case "llama":
                XCTAssertTrue(prompt.contains("You must respond with a JSON object") || 
                            prompt.contains("Provide only the JSON object"))
            case "qwen":
                XCTAssertTrue(prompt.contains("请按照以下JSON模式响应"))
            case "mistral":
                XCTAssertTrue(prompt.contains("[INST]"))
            case "phi":
                XCTAssertTrue(prompt.contains("Instruction:"))
            default:
                XCTAssertTrue(prompt.contains("Please respond with valid JSON"))
            }
        }
    }
    
    // MARK: - Retry Logic Tests
    
    func testRetryConfiguration() {
        let config = StructuredGenerationConfig(maxRetries: 5)
        XCTAssertEqual(config.maxRetries, 5)
    }
    
    func testDefaultRetryCount() {
        let config = StructuredGenerationConfig()
        XCTAssertEqual(config.maxRetries, 3)
    }
    
    // MARK: - Integration Tests
    
    func testPromptWithExample() {
        let schema: [String: Any] = [
            "type": "object",
            "properties": [
                "name": ["type": "string"],
                "age": ["type": "integer"]
            ]
        ]
        let config = StructuredGenerationConfig(
            includeExample: true,
            modelType: "llama-3.1-8b"
        )
        
        let prompt = StructuredPromptBuilder.buildPrompt(
            userPrompt: "Generate a person",
            schema: schema,
            example: "{\"name\": \"John Doe\", \"age\": 30}",
            config: config
        )
        
        XCTAssertTrue(prompt.contains("Example output format:"))
        XCTAssertTrue(prompt.contains("John Doe"))
    }
    
    func testPromptWithoutSchema() {
        let config = StructuredGenerationConfig(
            includeSchemaInPrompt: false,
            modelType: "qwen2.5"
        )
        
        let prompt = StructuredPromptBuilder.buildPrompt(
            userPrompt: "Generate a person",
            schema: ["type": "object" as Any],
            config: config
        )
        
        // Should still have the user prompt
        XCTAssertTrue(prompt.contains("Generate a person"))
        // But no schema-related content
        XCTAssertFalse(prompt.contains("JSON schema"))
        XCTAssertFalse(prompt.contains("```json"))
    }
    
    // MARK: - System Prompt Tests
    
    func testModelSpecificSystemPrompts() {
        XCTAssertTrue(StructuredPromptBuilder.structuredSystemPrompt(modelType: "qwen")
            .contains("native support for structured outputs"))
        
        XCTAssertTrue(StructuredPromptBuilder.structuredSystemPrompt(modelType: "mistral")
            .contains("Follow the JSON schema precisely"))
        
        XCTAssertTrue(StructuredPromptBuilder.structuredSystemPrompt(modelType: "llama")
            .contains("strictly follow its structure"))
    }
}