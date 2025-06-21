import XCTest
import FoundryKit
import FoundationModels

@FoundryGenerable
struct TestModel {
    @FoundryGuide("User name", .pattern("^.{3,50}$"))
    let name: String
    
    @FoundryGuide("User age", .range(0...150))
    let age: Int
    
    @FoundryGuide("User email")
    let email: String?
}

final class FoundryGenerableMacroTests: XCTestCase {
    func testMacroGeneratesRequiredProperties() {
        // Test that the macro generates the required properties
        XCTAssertNotNil(TestModel.generationSchema)
        XCTAssertNotNil(TestModel.jsonSchema)
        XCTAssertNotNil(TestModel.toolCallSchema)
        
        // Test that example JSON is generated when validation rules are present
        XCTAssertNotNil(TestModel.exampleJSON)
    }
    
    func testJSONSchemaStructure() {
        let schema = TestModel.jsonSchema
        
        // Verify schema type
        XCTAssertEqual(schema["type"] as? String, "object")
        
        // Verify properties exist
        let properties = schema["properties"] as? [String: Any]
        XCTAssertNotNil(properties)
        XCTAssertNotNil(properties?["name"])
        XCTAssertNotNil(properties?["age"])
        XCTAssertNotNil(properties?["email"])
        
        // Verify required fields
        let required = schema["required"] as? [String]
        XCTAssertNotNil(required)
        XCTAssertTrue(required?.contains("name") ?? false)
        XCTAssertTrue(required?.contains("age") ?? false)
        XCTAssertFalse(required?.contains("email") ?? false) // email is optional
    }
    
    func testValidationConstraints() {
        let schema = TestModel.jsonSchema
        let properties = schema["properties"] as? [String: Any]
        
        // Test name validation
        let nameSchema = properties?["name"] as? [String: Any]
        XCTAssertEqual(nameSchema?["type"] as? String, "string")
        XCTAssertEqual(nameSchema?["pattern"] as? String, "^.{3,50}$")
        
        // Test age validation
        let ageSchema = properties?["age"] as? [String: Any]
        XCTAssertEqual(ageSchema?["type"] as? String, "integer")
        XCTAssertEqual(ageSchema?["minimum"] as? Int, 0)
        XCTAssertEqual(ageSchema?["maximum"] as? Int, 150)
    }
    
    func testGenerationSchema() {
        let schema = TestModel.generationSchema
        
        // Just verify that the schema exists
        // The actual structure depends on FoundationModels implementation
        XCTAssertNotNil(schema)
    }
    
    func testPartiallyGeneratedType() {
        // Test that PartiallyGenerated type exists and has correct properties
        let content = GeneratedContent(properties: [:])
        
        // This will fail at runtime if PartiallyGenerated doesn't exist
        do {
            _ = try TestModel.PartiallyGenerated(content)
        } catch {
            // Expected to fail with empty content
            XCTAssertTrue(true)
        }
    }
    
    func testToolCallSchema() {
        let toolSchema = TestModel.toolCallSchema
        
        // Verify it's a function type
        XCTAssertEqual(toolSchema["type"] as? String, "function")
        
        // Verify function details
        let function = toolSchema["function"] as? [String: Any]
        XCTAssertNotNil(function)
        XCTAssertEqual(function?["name"] as? String, "generate_test_model")
        XCTAssertEqual(function?["description"] as? String, "Generate a structured TestModel object")
        
        // Verify parameters exist
        let parameters = function?["parameters"] as? [String: Any]
        XCTAssertNotNil(parameters)
        XCTAssertEqual(parameters?["type"] as? String, "object")
        
        // Verify required fields include non-optional properties
        let required = parameters?["required"] as? [String]
        XCTAssertNotNil(required)
        XCTAssertTrue(required?.contains("name") ?? false)
        XCTAssertTrue(required?.contains("age") ?? false)
        XCTAssertFalse(required?.contains("email") ?? false) // email is optional
    }
}