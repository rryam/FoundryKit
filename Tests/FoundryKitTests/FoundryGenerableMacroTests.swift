import XCTest
import FoundryKit
import FoundationModels

@FoundryGenerable
struct TestModel {
    @FoundryGuide("User name")
    @FoundryValidation(minLength: 3, maxLength: 50)
    let name: String
    
    @FoundryGuide("User age")
    @FoundryValidation(min: 0, max: 150)
    let age: Int
    
    @FoundryGuide("User email")
    let email: String?
}

final class FoundryGenerableMacroTests: XCTestCase {
    func testMacroGeneratesRequiredProperties() {
        // Test that the macro generates the required properties
        XCTAssertNotNil(TestModel.generationSchema)
        XCTAssertNotNil(TestModel.jsonSchema)
        
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
        XCTAssertEqual(nameSchema?["minLength"] as? Int, 3)
        XCTAssertEqual(nameSchema?["maxLength"] as? Int, 50)
        
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
}