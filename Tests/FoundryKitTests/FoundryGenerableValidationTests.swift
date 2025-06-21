import Testing
import FoundryKit
import Foundation
import FoundationModels

// MARK: - Test Models

@FoundryGenerable
struct EmailModel {
    @FoundryGuide("Email address", .pattern("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"))
    let email: String
}

@FoundryGenerable
struct StatusModel {
    @FoundryGuide("Status", .constant("active"))
    let status: String
}

@FoundryGenerable
struct UserModel {
    @FoundryGuide("User role", .anyOf(["admin", "user", "guest"]))
    let role: String
}

@FoundryGenerable
struct PersonModel {
    @FoundryGuide("Age", .range(18...120))
    let age: Int
}

@FoundryGenerable
struct ScoreModel {
    @FoundryGuide("Score", .minimum(1), .maximum(100))
    let score: Int
}

@FoundryGenerable
struct MeasurementModel {
    @FoundryGuide("Temperature", .rangeFloat(-50.0...50.0))
    let temperature: Float
    
    @FoundryGuide("Humidity", .minimumFloat(0.0), .maximumFloat(100.0))
    let humidity: Float
}

@FoundryGenerable
struct PriceModel {
    @FoundryGuide("Price", .minimumDouble(0.01), .maximumDouble(999999.99))
    let price: Double
    
    @FoundryGuide("Discount", .rangeDouble(0.0...1.0))
    let discountRate: Double
}

@FoundryGenerable
struct TagModel {
    @FoundryGuide("Tags", .count(.exact(3)))
    let tags: [String]
    
    @FoundryGuide("Categories", .count(.range(1...5)))
    let categories: [String]
    
    @FoundryGuide("Keywords", .minimumCount(2), .maximumCount(10))
    let keywords: [String]
}

@FoundryGenerable
struct ComplexModel {
    @FoundryGuide("Score must be between 0-100", .minimum(0), .maximum(100))
    let score: Int
}

@FoundryGenerable
struct ProfileModel {
    @FoundryGuide("Required username", .pattern("^[a-zA-Z0-9_]{3,20}$"))
    let username: String
    
    @FoundryGuide("Optional bio", .pattern("^.{0,500}$"))
    let bio: String?
    
    @FoundryGuide("Optional age", .range(13...120))
    let age: Int?
}

@FoundryGenerable
struct RegistrationForm {
    @FoundryGuide("Email", .pattern("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"))
    let email: String
    
    @FoundryGuide("Password must be 8-128 chars", .pattern("^.{8,128}$"))
    let password: String
    
    @FoundryGuide("Age", .range(18...120))
    let age: Int
    
    @FoundryGuide("Country", .anyOf(["US", "CA", "UK", "AU", "NZ"]))
    let country: String
    
    @FoundryGuide("Interests", .count(.range(1...10)))
    let interests: [String]
    
    @FoundryGuide("Accept terms", .constant("true"))
    let acceptTerms: String
}

// MARK: - Tests

@Suite("Schema Generation Tests - Validation Constraints")
struct FoundryGenerableValidationTests {
    
    // MARK: - String Pattern Schema Tests
    
    @Test("Pattern constraints are included in JSON schema")
    func testPatternInJSONSchema() {
        let schema = EmailModel.jsonSchema
        let properties = schema["properties"] as? [String: Any]
        let emailSchema = properties?["email"] as? [String: Any]
        
        #expect(emailSchema?["type"] as? String == "string")
        #expect(emailSchema?["pattern"] as? String == "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")
        #expect(emailSchema?["description"] as? String == "Email address")
    }
    
    @Test("Constant constraints are converted to enum in JSON schema")
    func testConstantInJSONSchema() {
        let schema = StatusModel.jsonSchema
        let properties = schema["properties"] as? [String: Any]
        let statusSchema = properties?["status"] as? [String: Any]
        
        #expect(statusSchema?["type"] as? String == "string")
        #expect(statusSchema?["enum"] as? [String] == ["active"])
        #expect(statusSchema?["description"] as? String == "Status")
    }
    
    @Test("AnyOf constraints are converted to enum in JSON schema")
    func testAnyOfInJSONSchema() {
        let schema = UserModel.jsonSchema
        let properties = schema["properties"] as? [String: Any]
        let roleSchema = properties?["role"] as? [String: Any]
        
        #expect(roleSchema?["type"] as? String == "string")
        #expect(roleSchema?["enum"] as? [String] == ["admin", "user", "guest"])
        #expect(roleSchema?["description"] as? String == "User role")
    }
    
    // MARK: - Numeric Constraint Schema Tests
    
    @Test("Integer range constraints in JSON schema")
    func testIntegerRangeInJSONSchema() {
        let schema = PersonModel.jsonSchema
        let properties = schema["properties"] as? [String: Any]
        let ageSchema = properties?["age"] as? [String: Any]
        
        #expect(ageSchema?["type"] as? String == "integer")
        #expect(ageSchema?["minimum"] as? Int == 18)
        #expect(ageSchema?["maximum"] as? Int == 120)
        #expect(ageSchema?["description"] as? String == "Age")
    }
    
    @Test("Separate minimum and maximum constraints in JSON schema")
    func testMinMaxInJSONSchema() {
        let schema = ScoreModel.jsonSchema
        let properties = schema["properties"] as? [String: Any]
        let scoreSchema = properties?["score"] as? [String: Any]
        
        #expect(scoreSchema?["type"] as? String == "integer")
        #expect(scoreSchema?["minimum"] as? Int == 1)
        #expect(scoreSchema?["maximum"] as? Int == 100)
    }
    
    @Test("Float constraints in JSON schema")
    func testFloatConstraintsInJSONSchema() {
        let schema = MeasurementModel.jsonSchema
        let properties = schema["properties"] as? [String: Any]
        
        // Check temperature schema
        let tempSchema = properties?["temperature"] as? [String: Any]
        #expect(tempSchema?["type"] as? String == "number")
        #expect(tempSchema?["minimum"] as? Int == -50)
        #expect(tempSchema?["maximum"] as? Int == 50)
        
        // Check humidity schema
        let humiditySchema = properties?["humidity"] as? [String: Any]
        #expect(humiditySchema?["type"] as? String == "number")
        #expect(humiditySchema?["minimum"] as? Int == 0)
        #expect(humiditySchema?["maximum"] as? Int == 100)
    }
    
    @Test("Double constraints in JSON schema")
    func testDoubleConstraintsInJSONSchema() {
        let schema = PriceModel.jsonSchema
        let properties = schema["properties"] as? [String: Any]
        
        // Check price schema
        let priceSchema = properties?["price"] as? [String: Any]
        #expect(priceSchema?["type"] as? String == "number")
        #expect(priceSchema?["minimum"] as? Int == 0)
        #expect(priceSchema?["maximum"] as? Int == 999999)
        
        // Check discount schema  
        let discountSchema = properties?["discountRate"] as? [String: Any]
        #expect(discountSchema?["type"] as? String == "number")
        #expect(discountSchema?["minimum"] as? Int == 0)
        #expect(discountSchema?["maximum"] as? Int == 1)
    }
    
    // MARK: - Array Constraint Schema Tests
    
    @Test("Array count constraints in JSON schema")
    func testArrayCountInJSONSchema() {
        let schema = TagModel.jsonSchema
        let properties = schema["properties"] as? [String: Any]
        
        // Check tags schema (exact count)
        let tagsSchema = properties?["tags"] as? [String: Any]
        #expect(tagsSchema?["type"] as? String == "array")
        #expect(tagsSchema?["minItems"] as? Int == 3)
        #expect(tagsSchema?["maxItems"] as? Int == 3)
        let tagsItems = tagsSchema?["items"] as? [String: String]
        #expect(tagsItems?["type"] == "string")
        
        // Check categories schema (range)
        let categoriesSchema = properties?["categories"] as? [String: Any]
        #expect(categoriesSchema?["type"] as? String == "array")
        #expect(categoriesSchema?["minItems"] as? Int == 1)
        #expect(categoriesSchema?["maxItems"] as? Int == 5)
        
        // Check keywords schema (min/max)
        let keywordsSchema = properties?["keywords"] as? [String: Any]
        #expect(keywordsSchema?["type"] as? String == "array")
        #expect(keywordsSchema?["minItems"] as? Int == 2)
        #expect(keywordsSchema?["maxItems"] as? Int == 10)
    }
    
    // MARK: - Complex Schema Generation Tests
    
    @Test("Multiple constraints on single property")
    func testMultipleConstraintsInSchema() {
        let schema = ComplexModel.jsonSchema
        let properties = schema["properties"] as? [String: Any]
        let scoreSchema = properties?["score"] as? [String: Any]
        
        // Both constraints should be present
        #expect(scoreSchema?["minimum"] as? Int == 0)
        #expect(scoreSchema?["maximum"] as? Int == 100)
        #expect(scoreSchema?["description"] as? String == "Score must be between 0-100")
    }
    
    @Test("Optional properties in schema")
    func testOptionalPropertiesInSchema() {
        let schema = ProfileModel.jsonSchema
        
        // Check required fields
        let required = schema["required"] as? [String]
        #expect(required?.contains("username") == true)
        #expect(required?.contains("bio") == false)
        #expect(required?.contains("age") == false)
        
        // Check properties still have constraints
        let properties = schema["properties"] as? [String: Any]
        
        let usernameSchema = properties?["username"] as? [String: Any]
        #expect(usernameSchema?["pattern"] as? String == "^[a-zA-Z0-9_]{3,20}$")
        
        let bioSchema = properties?["bio"] as? [String: Any]
        #expect(bioSchema?["pattern"] as? String == "^.{0,500}$")
        
        let ageSchema = properties?["age"] as? [String: Any]
        #expect(ageSchema?["minimum"] as? Int == 13)
        #expect(ageSchema?["maximum"] as? Int == 120)
    }
    
    @Test("Complex real-world schema generation")
    func testComplexSchemaGeneration() {
        let schema = RegistrationForm.jsonSchema
        
        // Test overall structure
        #expect(schema["type"] as? String == "object")
        
        let properties = schema["properties"] as? [String: Any]
        #expect(properties?.count == 6)
        
        // All fields should be required
        let required = schema["required"] as? [String]
        #expect(required?.count == 6)
        
        // Test tool call schema generation
        let toolSchema = RegistrationForm.toolCallSchema
        #expect(toolSchema["type"] as? String == "function")
        
        let function = toolSchema["function"] as? [String: Any]
        #expect(function?["name"] as? String == "generate_registration_form")
        #expect(function?["description"] as? String == "Generate a structured RegistrationForm object")
        
        // Test example JSON generation
        let exampleJSON = RegistrationForm.exampleJSON
        #expect(exampleJSON != nil)
        
        if let jsonString = exampleJSON,
           let data = jsonString.data(using: .utf8),
           let example = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            // Example should have all required fields
            #expect(example["email"] != nil)
            #expect(example["password"] != nil)
            #expect(example["age"] != nil)
            #expect(example["country"] != nil)
            #expect(example["interests"] != nil)
            #expect(example["acceptTerms"] != nil)
        }
    }
}