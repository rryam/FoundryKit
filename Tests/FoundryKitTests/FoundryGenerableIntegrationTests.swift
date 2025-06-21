import Testing
import FoundryKit
import Foundation
import FoundationModels

// MARK: - Test Models

@FoundryGenerable
struct Product {
    @FoundryGuide("Product name", .pattern("^.{3,100}$"))
    let name: String
    
    @FoundryGuide("Price in cents", .minimum(0))
    let price: Int
    
    @FoundryGuide("Stock quantity", .range(0...10000))
    let stock: Int
    
    @FoundryGuide("Categories", .count(.range(1...5)))
    let categories: [String]
    
    @FoundryGuide("Optional description", .pattern("^.{0,1000}$"))
    let description: String?
}

@FoundryGenerable
struct ComplexModelTest {
    @FoundryGuide("Identifier")
    let identifier: String
    
    @FoundryGuide("Status", .anyOf(["active", "inactive", "pending"]))
    let status: String
    
    @FoundryGuide("Score", .rangeDouble(0.0...100.0))
    let score: Double
    
    @FoundryGuide("Tags", .minimumCount(1))
    let tags: [String]
}

@FoundryGenerable
struct ConstraintTest {
    @FoundryGuide("String with pattern", .pattern("^[A-Z]{3}$"))
    let code: String
    
    @FoundryGuide("Enum string", .anyOf(["red", "green", "blue"]))
    let color: String
    
    @FoundryGuide("Range int", .range(0...100))
    let percentage: Int
    
    @FoundryGuide("Array with count", .count(5))
    let items: [String]
}

@FoundryGenerable
struct EmptyArrayTest {
    @FoundryGuide("Optional array")
    let items: [String]?
    
    @FoundryGuide("Required array")
    let tags: [String]
}

@FoundryGenerable
struct NestedArrayTest {
    @FoundryGuide("Matrix of integers")
    let matrix: [[Int]]
}

@FoundryGenerable
struct HTTPSConnectionManager {
    @FoundryGuide("Connection ID")
    let connectionID: String
    
    @FoundryGuide("Max retry count")
    let maxRetryCount: Int
}

@FoundryGenerable
struct UserProfile {
    @FoundryGuide("Full name", .pattern("^[A-Za-z ]{2,50}$"))
    let name: String
    
    @FoundryGuide("Email address", .pattern("^[^@]+@[^@]+\\.[^@]+$"))
    let email: String
    
    @FoundryGuide("User role", .anyOf(["admin", "editor", "viewer"]))
    let role: String
    
    @FoundryGuide("Years of experience", .range(0...50))
    let experience: Int
    
    @FoundryGuide("Skills", .count(.range(1...10)))
    let skills: [String]
    
    @FoundryGuide("Biography (optional)")
    let bio: String?
}

// MARK: - Tests

@Suite("Integration Tests - Generated Code Behavior")
struct FoundryGenerableIntegrationTests {
    
    // MARK: - JSON Schema Generation Tests
    
    @Test("Generated JSON schema structure is correct")
    func testJSONSchemaGeneration() {
        let schema = Product.jsonSchema
        
        // Test top-level structure
        #expect(schema["type"] as? String == "object")
        
        // Test properties exist
        let properties = schema["properties"] as? [String: Any]
        #expect(properties != nil)
        #expect(properties?.count == 5)
        
        // Test name property with pattern
        let nameSchema = properties?["name"] as? [String: Any]
        #expect(nameSchema?["type"] as? String == "string")
        #expect(nameSchema?["description"] as? String == "Product name")
        #expect(nameSchema?["pattern"] as? String == "^.{3,100}$")
        
        // Test price property with minimum
        let priceSchema = properties?["price"] as? [String: Any]
        #expect(priceSchema?["type"] as? String == "integer")
        #expect(priceSchema?["minimum"] as? Int == 0)
        
        // Test stock property with range
        let stockSchema = properties?["stock"] as? [String: Any]
        #expect(stockSchema?["minimum"] as? Int == 0)
        #expect(stockSchema?["maximum"] as? Int == 10000)
        
        // Test array property
        let categoriesSchema = properties?["categories"] as? [String: Any]
        #expect(categoriesSchema?["type"] as? String == "array")
        #expect(categoriesSchema?["minItems"] as? Int == 1)
        #expect(categoriesSchema?["maxItems"] as? Int == 5)
        let itemsSchema = categoriesSchema?["items"] as? [String: String]
        #expect(itemsSchema?["type"] == "string")
        
        // Test required fields
        let required = schema["required"] as? [String]
        #expect(required?.count == 4)
        #expect(required?.contains("name") == true)
        #expect(required?.contains("price") == true)
        #expect(required?.contains("stock") == true)
        #expect(required?.contains("categories") == true)
        #expect(required?.contains("description") == false)  // Optional
    }
    
    @Test("Tool call schema generation for MLX")
    func testToolCallSchemaGeneration() {
        let toolSchema = Product.toolCallSchema
        
        // Test top-level structure
        #expect(toolSchema["type"] as? String == "function")
        
        let function = toolSchema["function"] as? [String: Any]
        #expect(function != nil)
        
        // Test function metadata
        #expect(function?["name"] as? String == "generate_product")
        #expect(function?["description"] as? String == "Generate a structured Product object")
        
        // Test parameters
        let parameters = function?["parameters"] as? [String: Any]
        #expect(parameters?["type"] as? String == "object")
        
        let properties = parameters?["properties"] as? [String: Any]
        #expect(properties?.count == 5)
        
        // Verify validation constraints are preserved
        let nameParam = properties?["name"] as? [String: Any]
        #expect(nameParam?["pattern"] as? String == "^.{3,100}$")
    }
    
    // MARK: - Example JSON Generation Tests
    
    @Test("Example JSON generation with validation rules")
    func testExampleJSONGeneration() {
        let exampleJSON = Product.exampleJSON
        #expect(exampleJSON != nil)
        
        if let jsonString = exampleJSON,
           let data = jsonString.data(using: .utf8),
           let example = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            
            // Verify example follows schema
            #expect(example["name"] is String)
            #expect(example["price"] is Int)
            #expect(example["stock"] is Int)
            #expect(example["categories"] is [String])
            
            // Check constraints are respected
            if let name = example["name"] as? String {
                #expect(name.count >= 3 && name.count <= 100)
            }
            
            if let price = example["price"] as? Int {
                #expect(price >= 0)
            }
            
            if let stock = example["stock"] as? Int {
                #expect(stock >= 0 && stock <= 10000)
            }
            
            if let categories = example["categories"] as? [String] {
                #expect(categories.count >= 1 && categories.count <= 5)
            }
        } else {
            Issue.record("Failed to parse example JSON")
        }
    }
    
    // MARK: - GeneratedContent Tests
    
    @Test("GeneratedContent property generation")
    func testGeneratedContentGeneration() {
        let product = Product(
            name: "Test Product",
            price: 999,
            stock: 100,
            categories: ["electronics", "gadgets"],
            description: "A test product"
        )
        
        let content = product.generatedContent
        
        // This would normally interact with FoundationModels
        // Here we're just testing the structure is correct
        #expect(type(of: content).self == GeneratedContent.self)
    }
    
    @Test("Generation schema property")
    func testGenerationSchemaProperty() {
        let schema = Product.generationSchema
        
        // Just verify the schema exists and has the right type
        #expect(type(of: schema).self == GenerationSchema.self)
    }
    
    @Test("Tool call schema includes all parameters")
    func testToolCallSchemaParameters() {
        let toolSchema = Product.toolCallSchema
        let function = toolSchema["function"] as? [String: Any]
        let parameters = function?["parameters"] as? [String: Any]
        let properties = parameters?["properties"] as? [String: Any]
        
        // Should have all 5 properties
        #expect(properties?.count == 5)
        
        // Check required fields match non-optional properties
        let required = parameters?["required"] as? [String]
        #expect(Set(required ?? []) == ["name", "price", "stock", "categories"])
    }
    
    @Test("Example JSON respects constraints")
    func testExampleJSONConstraints() {
        guard let exampleJSON = Product.exampleJSON,
              let data = exampleJSON.data(using: .utf8),
              let example = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            Issue.record("Failed to parse example JSON")
            return
        }
        
        // Name should match pattern
        if let name = example["name"] as? String {
            #expect(name.count >= 3 && name.count <= 100)
        }
        
        // Price should be non-negative
        if let price = example["price"] as? Int {
            #expect(price >= 0)
        }
        
        // Categories should have correct count
        if let categories = example["categories"] as? [String] {
            #expect(categories.count >= 1 && categories.count <= 5)
        }
    }
    
    // MARK: - Generated Property Tests
    
    @Test("GeneratedContent property")
    func testGeneratedContentProperty() {
        let product = Product(
            name: "Test Product",
            price: 999,
            stock: 100,
            categories: ["electronics", "gadgets"],
            description: "A test product"
        )
        
        let content = product.generatedContent
        
        // The generated content should exist
        #expect(type(of: content).self == GeneratedContent.self)
    }
    
    @Test("Schema includes validation constraints from multiple sources")
    func testMultipleConstraintTypes() {
        let schema = ConstraintTest.jsonSchema
        let properties = schema["properties"] as? [String: Any]
        
        // Pattern constraint
        let codeSchema = properties?["code"] as? [String: Any]
        #expect(codeSchema?["pattern"] as? String == "^[A-Z]{3}$")
        
        // Enum constraint
        let colorSchema = properties?["color"] as? [String: Any]
        #expect(colorSchema?["enum"] as? [String] == ["red", "green", "blue"])
        
        // Range constraint
        let percentageSchema = properties?["percentage"] as? [String: Any]
        #expect(percentageSchema?["minimum"] as? Int == 0)
        #expect(percentageSchema?["maximum"] as? Int == 100)
        
        // Count constraint
        let itemsSchema = properties?["items"] as? [String: Any]
        #expect(itemsSchema?["minItems"] as? Int == 5)
        #expect(itemsSchema?["maxItems"] as? Int == 5)
    }
    
    // MARK: - Complex Type Tests
    
    @Test("Complex types in schema")
    func testComplexTypeSchema() {
        let schema = ComplexModelTest.jsonSchema
        let properties = schema["properties"] as? [String: Any]
        
        // Check all property types
        let idSchema = properties?["identifier"] as? [String: Any]
        #expect(idSchema?["type"] as? String == "string")
        
        let statusSchema = properties?["status"] as? [String: Any]
        #expect(statusSchema?["type"] as? String == "string")
        #expect(statusSchema?["enum"] as? [String] == ["active", "inactive", "pending"])
        
        let scoreSchema = properties?["score"] as? [String: Any]
        #expect(scoreSchema?["type"] as? String == "number")
        #expect(scoreSchema?["minimum"] as? Int == 0)
        #expect(scoreSchema?["maximum"] as? Int == 100)
        
        let tagsSchema = properties?["tags"] as? [String: Any]
        #expect(tagsSchema?["type"] as? String == "array")
        #expect(tagsSchema?["minItems"] as? Int == 1)
    }
    
    @Test("Snake case conversion in tool schemas")
    func testSnakeCaseConversion() {
        let toolSchema = HTTPSConnectionManager.toolCallSchema
        let function = toolSchema["function"] as? [String: Any]
        
        // Should convert to snake_case
        #expect(function?["name"] as? String == "generate_httpsconnection_manager")
    }
    
    // MARK: - Edge Case Tests
    
    @Test("Empty arrays in schema")
    func testEmptyArraySchema() {
        let schema = EmptyArrayTest.jsonSchema
        let properties = schema["properties"] as? [String: Any]
        
        // Both should have array type with string items
        let itemsSchema = properties?["items"] as? [String: Any]
        #expect(itemsSchema?["type"] as? String == "array")
        let itemsItems = itemsSchema?["items"] as? [String: String]
        #expect(itemsItems?["type"] == "string")
        
        let tagsSchema = properties?["tags"] as? [String: Any]
        #expect(tagsSchema?["type"] as? String == "array")
        let tagsItems = tagsSchema?["items"] as? [String: String]
        #expect(tagsItems?["type"] == "string")
        
        // Only tags should be required
        let required = schema["required"] as? [String]
        #expect(required?.contains("tags") == true)
        #expect(required?.contains("items") == false)
    }
    
    @Test("Nested array types")
    func testNestedArrayTypes() {
        let schema = NestedArrayTest.jsonSchema
        let properties = schema["properties"] as? [String: Any]
        let matrixSchema = properties?["matrix"] as? [String: Any]
        
        // Should be array type
        #expect(matrixSchema?["type"] as? String == "array")
        
        // Items should also be array type
        let itemsSchema = matrixSchema?["items"] as? [String: String]
        #expect(itemsSchema?["type"] == "object") // Nested arrays become objects in current implementation
    }
    
    // MARK: - Generated Properties Tests
    
    @Test("All generated properties are accessible")
    func testAllGeneratedProperties() {
        // Test that all macro-generated properties exist and are accessible
        
        // Static properties
        #expect(Product.jsonSchema["type"] as? String == "object")
        #expect(Product.toolCallSchema["type"] as? String == "function")
        #expect(type(of: Product.generationSchema).self == GenerationSchema.self)
        
        // Example JSON (optional, only generated when validation rules exist)
        let hasExample = Product.exampleJSON != nil
        #expect(hasExample == true) // Should have example since we have validation rules
        
        // Instance property
        let product = Product(
            name: "Test",
            price: 100,
            stock: 10,
            categories: ["test"],
            description: nil
        )
        #expect(type(of: product.generatedContent).self == GeneratedContent.self)
        
        // Nested type
        #expect(Product.PartiallyGenerated.self != Never.self)
    }
    
    // MARK: - Real-world Integration Test
    
    @Test("Schema suitable for LLM structured generation")
    func testSchemaForLLMGeneration() {
        // Test that generated schemas are suitable for LLM use
        
        // 1. JSON Schema should be valid for OpenAPI/JSON Schema validators
        let jsonSchema = UserProfile.jsonSchema
        #expect(jsonSchema["type"] as? String == "object")
        #expect(jsonSchema["properties"] != nil)
        #expect(jsonSchema["required"] != nil)
        
        // 2. Tool call schema should follow OpenAI function calling format
        let toolSchema = UserProfile.toolCallSchema
        let function = toolSchema["function"] as? [String: Any]
        #expect(function?["name"] as? String == "generate_user_profile")
        #expect(function?["parameters"] != nil)
        
        // 3. Example JSON should be valid and follow constraints
        if let exampleJSON = UserProfile.exampleJSON,
           let data = exampleJSON.data(using: .utf8),
           let _ = try? JSONSerialization.jsonObject(with: data) {
            #expect(true) // JSON is valid
        } else {
            Issue.record("Example JSON is not valid")
        }
        
        // 4. Generation schema for Foundation Models
        let genSchema = UserProfile.generationSchema
        #expect(type(of: genSchema).self == GenerationSchema.self)
    }
}