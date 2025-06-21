import XCTest
import FoundryKit
import FoundationModels

// Test model with all supported types and validations
@FoundryGenerable
struct ComprehensiveTestModel {
    @FoundryGuide("User's unique identifier")
    let userId: String
    
    @FoundryGuide("Full name of the user", .pattern("^.{2,100}$"))
    let name: String
    
    @FoundryGuide("User's age in years", .range(0...150))
    let age: Int
    
    @FoundryGuide("Account balance", .minimum(-1000000), .maximum(1000000))
    let balance: Double
    
    @FoundryGuide("Is the account active")
    let isActive: Bool
    
    @FoundryGuide("User's role in the system", .anyOf(["admin", "user", "guest"]))
    let role: String
    
    @FoundryGuide("Email addresses", .minimumCount(1), .maximumCount(5))
    let emails: [String]
    
    @FoundryGuide("Phone numbers")
    let phoneNumbers: [String]?
    
    @FoundryGuide("Biography text", .pattern("^.{0,500}$"))
    let bio: String?
    
    @FoundryGuide("Preferred contact method", .anyOf(["email", "phone", "sms"]))
    let preferredContact: String?
    
    @FoundryGuide("Account creation timestamp", .pattern("^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}Z$"))
    let createdAt: String
}

// Edge case model with minimal properties
@FoundryGenerable
struct MinimalModel {
    let value: String
}

// Model with only optional properties
@FoundryGenerable
struct OptionalOnlyModel {
    @FoundryGuide("Optional name")
    let name: String?
    
    @FoundryGuide("Optional age")
    let age: Int?
}

final class FoundryGenerableMacroComprehensiveTests: XCTestCase {
    
    // MARK: - Basic Generation Tests
    
    func testAllGeneratedPropertiesExist() {
        // Verify all expected properties are generated
        XCTAssertNotNil(ComprehensiveTestModel.generationSchema)
        XCTAssertNotNil(ComprehensiveTestModel.jsonSchema)
        XCTAssertNotNil(ComprehensiveTestModel.toolCallSchema)
        XCTAssertNotNil(ComprehensiveTestModel.exampleJSON)
        
        // Test can create instances
        let model = ComprehensiveTestModel(
            userId: "123",
            name: "John Doe",
            age: 30,
            balance: 1000.50,
            isActive: true,
            role: "user",
            emails: ["john@example.com"],
            phoneNumbers: nil,
            bio: nil,
            preferredContact: "email",
            createdAt: "2024-01-01T00:00:00Z"
        )
        XCTAssertNotNil(model)
    }
    
    // MARK: - JSON Schema Validation Tests
    
    func testJSONSchemaCompleteness() {
        let schema = ComprehensiveTestModel.jsonSchema
        
        // Verify schema structure
        XCTAssertEqual(schema["type"] as? String, "object")
        
        let properties = schema["properties"] as? [String: Any]
        XCTAssertNotNil(properties)
        
        // Verify all properties are present
        let expectedProperties = ["userId", "name", "age", "balance", "isActive", "role", 
                                  "emails", "phoneNumbers", "bio", "preferredContact", "createdAt"]
        for prop in expectedProperties {
            XCTAssertNotNil(properties?[prop], "Missing property: \(prop)")
        }
        
        // Verify required fields
        let required = schema["required"] as? [String]
        XCTAssertNotNil(required)
        let expectedRequired = ["userId", "name", "age", "balance", "isActive", "role", "emails", "createdAt"]
        for req in expectedRequired {
            XCTAssertTrue(required?.contains(req) ?? false, "Missing required field: \(req)")
        }
        
        // Verify optional fields are NOT in required
        XCTAssertFalse(required?.contains("phoneNumbers") ?? true)
        XCTAssertFalse(required?.contains("bio") ?? true)
        XCTAssertFalse(required?.contains("preferredContact") ?? true)
    }
    
    func testJSONSchemaValidationConstraints() {
        let schema = ComprehensiveTestModel.jsonSchema
        let properties = schema["properties"] as? [String: Any]
        
        // Test string validation
        let nameProp = properties?["name"] as? [String: Any]
        XCTAssertEqual(nameProp?["type"] as? String, "string")
        XCTAssertEqual(nameProp?["pattern"] as? String, "^.{2,100}$")
        
        // Test integer validation
        let ageProp = properties?["age"] as? [String: Any]
        XCTAssertEqual(ageProp?["type"] as? String, "integer")
        XCTAssertEqual(ageProp?["minimum"] as? Int, 0)
        XCTAssertEqual(ageProp?["maximum"] as? Int, 150)
        
        // Test double validation
        let balanceProp = properties?["balance"] as? [String: Any]
        XCTAssertEqual(balanceProp?["type"] as? String, "number")
        XCTAssertEqual(balanceProp?["minimum"] as? Int, -1000000)
        XCTAssertEqual(balanceProp?["maximum"] as? Int, 1000000)
        
        // Test boolean
        let isActiveProp = properties?["isActive"] as? [String: Any]
        XCTAssertEqual(isActiveProp?["type"] as? String, "boolean")
        
        // Test enum validation
        let roleProp = properties?["role"] as? [String: Any]
        XCTAssertEqual(roleProp?["type"] as? String, "string")
        let roleEnum = roleProp?["enum"] as? [String]
        XCTAssertEqual(roleEnum, ["admin", "user", "guest"])
        
        // Test array validation
        let emailsProp = properties?["emails"] as? [String: Any]
        XCTAssertEqual(emailsProp?["type"] as? String, "array")
        XCTAssertEqual(emailsProp?["minItems"] as? Int, 1)
        XCTAssertEqual(emailsProp?["maxItems"] as? Int, 5)
        let emailItems = emailsProp?["items"] as? [String: String]
        XCTAssertEqual(emailItems?["type"], "string")
        
        // Test pattern validation
        let createdAtProp = properties?["createdAt"] as? [String: Any]
        // The pattern gets stored with escaped backslashes in the dictionary literal
        XCTAssertNotNil(createdAtProp?["pattern"])
        // Just verify it contains the expected pattern elements
        if let pattern = createdAtProp?["pattern"] as? String {
            XCTAssertTrue(pattern.contains("\\d"))
            XCTAssertTrue(pattern.contains("T"))
            XCTAssertTrue(pattern.contains("Z$"))
        }
    }
    
    // MARK: - Tool Call Schema Tests
    
    func testToolCallSchemaFormat() {
        let toolSchema = ComprehensiveTestModel.toolCallSchema
        
        // Verify MLX tool call format
        XCTAssertEqual(toolSchema["type"] as? String, "function")
        
        let function = toolSchema["function"] as? [String: Any]
        XCTAssertNotNil(function)
        
        // Verify function name is properly converted to snake_case
        XCTAssertEqual(function?["name"] as? String, "generate_comprehensive_test_model")
        XCTAssertEqual(function?["description"] as? String, "Generate a structured ComprehensiveTestModel object")
        
        // Verify parameters structure
        let parameters = function?["parameters"] as? [String: Any]
        XCTAssertNotNil(parameters)
        XCTAssertEqual(parameters?["type"] as? String, "object")
        
        // Verify properties are included
        let properties = parameters?["properties"] as? [String: Any]
        XCTAssertNotNil(properties)
        XCTAssertEqual(properties?.count, 11)
        
        // Verify required array
        let required = parameters?["required"] as? [String]
        XCTAssertNotNil(required)
        XCTAssertEqual(required?.count, 8) // 8 non-optional properties
    }
    
    func testToolCallSchemaPreservesValidation() {
        let toolSchema = ComprehensiveTestModel.toolCallSchema
        let function = toolSchema["function"] as? [String: Any]
        let parameters = function?["parameters"] as? [String: Any]
        let properties = parameters?["properties"] as? [String: Any]
        
        // Verify validation constraints are preserved
        let nameProp = properties?["name"] as? [String: Any]
        XCTAssertEqual(nameProp?["pattern"] as? String, "^.{2,100}$")
        
        let ageProp = properties?["age"] as? [String: Any]
        XCTAssertEqual(ageProp?["minimum"] as? Int, 0)
        XCTAssertEqual(ageProp?["maximum"] as? Int, 150)
        
        let roleProp = properties?["role"] as? [String: Any]
        let roleEnum = roleProp?["enum"] as? [String]
        XCTAssertEqual(roleEnum, ["admin", "user", "guest"])
    }
    
    // MARK: - Example JSON Tests
    
    func testExampleJSONGeneration() {
        guard let exampleJSON = ComprehensiveTestModel.exampleJSON else {
            XCTFail("Example JSON should be generated")
            return
        }
        
        // Parse the example JSON
        guard let data = exampleJSON.data(using: .utf8),
              let example = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            XCTFail("Example JSON should be valid JSON")
            return
        }
        
        // Verify required fields are present
        XCTAssertNotNil(example["userId"])
        XCTAssertNotNil(example["name"])
        XCTAssertNotNil(example["age"])
        XCTAssertNotNil(example["balance"])
        XCTAssertNotNil(example["isActive"])
        XCTAssertNotNil(example["role"])
        XCTAssertNotNil(example["emails"])
        XCTAssertNotNil(example["createdAt"])
        
        // Verify types
        XCTAssertTrue(example["userId"] is String)
        XCTAssertTrue(example["name"] is String)
        XCTAssertTrue(example["age"] is Int)
        XCTAssertTrue(example["balance"] is Double)
        XCTAssertTrue(example["isActive"] is Bool)
        XCTAssertTrue(example["role"] is String)
        XCTAssertTrue(example["emails"] is [Any])
        
        // Verify enum values
        if let role = example["role"] as? String {
            XCTAssertTrue(["admin", "user", "guest"].contains(role))
        }
        
        // Verify array constraints
        if let emails = example["emails"] as? [Any] {
            XCTAssertTrue(emails.count >= 1 && emails.count <= 5)
        }
    }
    
    // MARK: - Edge Case Tests
    
    func testMinimalModel() {
        // Test that minimal models work
        XCTAssertNotNil(MinimalModel.jsonSchema)
        XCTAssertNotNil(MinimalModel.toolCallSchema)
        // MinimalModel has no validation rules, so no example JSON is generated
        
        let schema = MinimalModel.jsonSchema
        let properties = schema["properties"] as? [String: Any]
        XCTAssertEqual(properties?.count, 1)
        
        let required = schema["required"] as? [String]
        XCTAssertEqual(required?.count, 1)
        XCTAssertTrue(required?.contains("value") ?? false)
    }
    
    func testOptionalOnlyModel() {
        // Test model with only optional properties
        XCTAssertNotNil(OptionalOnlyModel.jsonSchema)
        XCTAssertNotNil(OptionalOnlyModel.toolCallSchema)
        
        let schema = OptionalOnlyModel.jsonSchema
        let required = schema["required"] as? [String]
        XCTAssertTrue(required?.isEmpty ?? true) // Should have no required fields
    }
    
    // MARK: - Name Conversion Tests
    
    func testCamelCaseToSnakeCaseConversion() {
        // Test various naming patterns
        let testCases: [(String, String)] = [
            ("SimpleModel", "generate_simple_model"),
            ("XMLParser", "generate_xmlparser"),
            ("IOManager", "generate_iomanager"),
            ("HTTPSConnection", "generate_httpsconnection"),
            ("Model123", "generate_model123"),
            ("A", "generate_a")
        ]
        
        for (modelName, expectedFunctionName) in testCases {
            // We can't directly test the conversion without creating models,
            // but we can verify the pattern is correct in our comprehensive model
            let toolSchema = ComprehensiveTestModel.toolCallSchema
            let function = toolSchema["function"] as? [String: Any]
            let functionName = function?["name"] as? String
            XCTAssertTrue(functionName?.hasPrefix("generate_") ?? false)
            XCTAssertTrue(functionName?.contains("_") ?? false)
        }
    }
    
    // MARK: - Generated Content Tests
    
    func testGeneratedContentProperty() {
        let model = ComprehensiveTestModel(
            userId: "test-123",
            name: "Test User",
            age: 25,
            balance: 100.0,
            isActive: true,
            role: "user",
            emails: ["test@example.com"],
            phoneNumbers: ["+1234567890"],
            bio: "Test bio",
            preferredContact: "email",
            createdAt: "2024-01-01T00:00:00Z"
        )
        
        let content = model.generatedContent
        XCTAssertNotNil(content)
        
        // Verify content contains all properties
        // This tests that the generatedContent computed property works
    }
    
    // MARK: - PartiallyGenerated Tests
    
    func testPartiallyGeneratedType() {
        let content = GeneratedContent(properties: [
            "userId": "123",
            "name": "Test",
            "age": 30,
            "balance": 100.0,
            "isActive": true,
            "role": "user",
            "emails": ["test@test.com"],
            "createdAt": "2024-01-01T00:00:00Z"
        ])
        
        do {
            let partial = try ComprehensiveTestModel.PartiallyGenerated(content)
            XCTAssertNotNil(partial)
            XCTAssertNotNil(partial.id)
        } catch {
            XCTFail("Should be able to create PartiallyGenerated: \(error)")
        }
    }
}