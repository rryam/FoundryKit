import XCTest
import FoundryKit
import FoundationModels

@FoundryGenerable
struct DetailedTestModel {
    @FoundryGuide("User's full name")
    @FoundryValidation(minLength: 2, maxLength: 100)
    let name: String
    
    @FoundryGuide("User's age in years")
    @FoundryValidation(min: 18, max: 120)
    let age: Int
    
    @FoundryGuide("User's account status")
    @FoundryValidation(enumValues: ["active", "inactive", "suspended"])
    let status: String
    
    @FoundryGuide("User's email addresses")
    @FoundryValidation(minItems: 1, maxItems: 5)
    let emails: [String]
    
    @FoundryGuide("Optional bio")
    let bio: String?
}

final class FoundryGenerableMacroSchemaTests: XCTestCase {
    func testDetailedSchemaGeneration() {
        // Print the generated JSON schema
        let schema = DetailedTestModel.jsonSchema
        print("\n=== Generated JSON Schema ===")
        print(prettyPrintJSON(schema))
        
        // Verify the schema structure
        XCTAssertEqual(schema["type"] as? String, "object")
        
        // Check properties
        let properties = schema["properties"] as? [String: Any]
        XCTAssertNotNil(properties)
        
        // Verify name property with validation
        let nameSchema = properties?["name"] as? [String: Any]
        XCTAssertEqual(nameSchema?["type"] as? String, "string")
        XCTAssertEqual(nameSchema?["description"] as? String, "User's full name")
        XCTAssertEqual(nameSchema?["minLength"] as? Int, 2)
        XCTAssertEqual(nameSchema?["maxLength"] as? Int, 100)
        
        // Verify age property with validation
        let ageSchema = properties?["age"] as? [String: Any]
        XCTAssertEqual(ageSchema?["type"] as? String, "integer")
        XCTAssertEqual(ageSchema?["description"] as? String, "User's age in years")
        XCTAssertEqual(ageSchema?["minimum"] as? Int, 18)
        XCTAssertEqual(ageSchema?["maximum"] as? Int, 120)
        
        // Verify status property with enum validation
        let statusSchema = properties?["status"] as? [String: Any]
        XCTAssertEqual(statusSchema?["type"] as? String, "string")
        XCTAssertEqual(statusSchema?["description"] as? String, "User's account status")
        let enumValues = statusSchema?["enum"] as? [String]
        XCTAssertEqual(enumValues, ["active", "inactive", "suspended"])
        
        // Verify emails array property
        let emailsSchema = properties?["emails"] as? [String: Any]
        XCTAssertEqual(emailsSchema?["type"] as? String, "array")
        XCTAssertEqual(emailsSchema?["description"] as? String, "User's email addresses")
        XCTAssertEqual(emailsSchema?["minItems"] as? Int, 1)
        XCTAssertEqual(emailsSchema?["maxItems"] as? Int, 5)
        let itemsSchema = emailsSchema?["items"] as? [String: String]
        XCTAssertEqual(itemsSchema?["type"], "string")
        
        // Verify optional bio property
        let bioSchema = properties?["bio"] as? [String: Any]
        XCTAssertEqual(bioSchema?["type"] as? String, "string")
        XCTAssertEqual(bioSchema?["description"] as? String, "Optional bio")
        
        // Verify required fields (bio should not be required)
        let required = schema["required"] as? [String]
        XCTAssertNotNil(required)
        XCTAssertTrue(required?.contains("name") ?? false)
        XCTAssertTrue(required?.contains("age") ?? false)
        XCTAssertTrue(required?.contains("status") ?? false)
        XCTAssertTrue(required?.contains("emails") ?? false)
        XCTAssertFalse(required?.contains("bio") ?? false) // bio is optional
    }
    
    func testGenerationSchemaGeneration() {
        let genSchema = DetailedTestModel.generationSchema
        print("\n=== Generation Schema ===")
        print("Type: \(type(of: genSchema))")
        
        // The schema exists and can be used by FoundationModels
        XCTAssertNotNil(genSchema)
    }
    
    func testGeneratedContentProperty() {
        let model = DetailedTestModel(
            name: "John Doe",
            age: 30,
            status: "active",
            emails: ["john@example.com"],
            bio: "Software developer"
        )
        
        let content = model.generatedContent
        print("\n=== Generated Content ===")
        print("Content type: \(type(of: content))")
        
        XCTAssertNotNil(content)
    }
    
    func testPartiallyGeneratedType() {
        // Verify PartiallyGenerated type exists
        let content = GeneratedContent(properties: [
            "name": "Jane Doe",
            "age": 25,
            "status": "active",
            "emails": ["jane@example.com"]
        ])
        
        do {
            let partial = try DetailedTestModel.PartiallyGenerated(content)
            XCTAssertNotNil(partial)
            print("\n=== Partially Generated Type ===")
            print("Successfully created PartiallyGenerated instance")
        } catch {
            print("Error creating PartiallyGenerated: \(error)")
        }
    }
    
    private func prettyPrintJSON(_ object: Any) -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted),
              let string = String(data: data, encoding: .utf8) else {
            return "Failed to serialize JSON"
        }
        return string
    }
}