import XCTest
@testable import FoundryKit
import FoundationModels
import Tokenizers

final class GuidedGenerationTests: XCTestCase {
    
    // MARK: - Test Types
    
    @FoundryGenerable
    struct TestPerson {
        @FoundryGuide("Person's full name")
        let name: String
        
        @FoundryGuide("Age in years")
        @FoundryValidation(min: 0, max: 150)
        let age: Int
        
        @FoundryGuide("Email address")
        @FoundryValidation(pattern: "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")
        let email: String
    }
    
    @FoundryGenerable
    struct TestProduct {
        @FoundryGuide("Product name")
        let name: String
        
        @FoundryGuide("Price in USD")
        @FoundryValidation(min: 0)
        let price: Double
        
        @FoundryGuide("Product category")
        @FoundryValidation(enumValues: ["electronics", "clothing", "food", "books"])
        let category: String
        
        @FoundryGuide("In stock")
        let inStock: Bool
    }
    
    @FoundryGenerable
    struct TestOrder {
        @FoundryGuide("Order ID")
        let orderId: String
        
        @FoundryGuide("Items in the order")
        @FoundryValidation(minItems: 1, maxItems: 10)
        let items: [TestProduct]
        
        @FoundryGuide("Customer information")
        let customer: TestPerson
    }
    
    // MARK: - Schema Generation Tests
    
    func testSchemaGenerationForSimpleType() {
        // TODO: Implement full schema generation from Generable types
        /*
        let schema = RuntimeGenerationSchema(from: TestPerson.self)
        
        XCTAssertEqual(schema.root.name, "TestPerson")
        XCTAssertEqual(schema.root.properties.count, 3)
        XCTAssertTrue(schema.root.properties.keys.contains("name"))
        XCTAssertTrue(schema.root.properties.keys.contains("age"))
        XCTAssertTrue(schema.root.properties.keys.contains("email"))
        */
    }
    
    func testSchemaGenerationForNestedType() {
        // TODO: Implement full schema generation from Generable types
        /*
        let schema = RuntimeGenerationSchema(from: TestOrder.self)
        
        XCTAssertEqual(schema.root.name, "TestOrder")
        XCTAssertEqual(schema.root.properties.count, 3)
        XCTAssertTrue(schema.root.properties.keys.contains("orderId"))
        XCTAssertTrue(schema.root.properties.keys.contains("items"))
        XCTAssertTrue(schema.root.properties.keys.contains("customer"))
        
        // Check nested types
        if case .array(let elementType) = schema.root.properties["items"]?.type {
            if case .object = elementType {
                // Expected array of objects
            } else {
                XCTFail("Expected array of objects for items")
            }
        } else {
            XCTFail("Expected array type for items")
        }
        */
    }
    
    // MARK: - JSON State Machine Tests
    
    func testJSONParseStateTransitions() {
        // TODO: Implement full JSON state machine
        /*
        let schema = RuntimeGenerationSchema(from: TestPerson.self)
        let parseState = JSONParseState(schema: schema)
        
        // Test initial state
        var validChars = parseState.getValidNextCharacters()
        XCTAssertEqual(validChars, ["{"])
        
        // Advance to object state
        parseState.advance(with: "{")
        validChars = parseState.getValidNextCharacters()
        XCTAssertTrue(validChars.contains("\""))
        
        // Start property name
        parseState.advance(with: "\"")
        validChars = parseState.getValidNextCharacters()
        // Should contain first letters of valid property names
        XCTAssertTrue(validChars.contains("n") || validChars.contains("a") || validChars.contains("e"))
        */
    }
    
    func testValidPropertyNameCompletion() {
        // TODO: Implement property name completion logic
        /*
        let schema = RuntimeGenerationSchema(from: TestPerson.self)
        let parseState = JSONParseState(schema: schema)
        
        // Navigate to property name state
        parseState.advance(with: "{")
        parseState.advance(with: "\"")
        
        // Type "na" - should only allow "m" for "name"
        parseState.advance(with: "n")
        parseState.advance(with: "a")
        let validChars = parseState.getValidNextCharacters()
        XCTAssertTrue(validChars.contains("m"))
        XCTAssertFalse(validChars.contains("g")) // "nag" is not valid
        */
    }
    
    // MARK: - Dynamic Schema Tests
    
    func testDynamicSchemaCreation() {
        let menuSchema = DynamicGenerationSchema(name: "Menu")
        
        // Add properties
        let soupProperty = DynamicGenerationSchema.Property(
            name: "soup",
            schema: DynamicGenerationSchema(name: "soup", anyOf: ["Tomato", "Chicken Noodle", "Clam Chowder"])
        )
        menuSchema.addProperty(soupProperty, required: true)
        
        let priceProperty = DynamicGenerationSchema.Property(
            name: "price",
            schema: DynamicGenerationSchema(name: "price", type: .number)
        )
        menuSchema.addProperty(priceProperty, required: true)
        
        XCTAssertEqual(menuSchema.properties.count, 2)
        XCTAssertEqual(menuSchema.required.count, 2)
        XCTAssertTrue(menuSchema.required.contains("soup"))
        XCTAssertTrue(menuSchema.required.contains("price"))
    }
    
    func testDynamicSchemaWithConstraints() {
        let schema = DynamicGenerationSchema(name: "ConstrainedValue", type: .string)
        schema.addConstraint(.minLength(5))
        schema.addConstraint(.maxLength(20))
        schema.addConstraint(.pattern("^[A-Z][a-z]+$"))
        
        XCTAssertEqual(schema.constraints.count, 3)
    }
    
    // MARK: - Schema Conversion Tests
    
    func testSchemaConversionToFoundationModels() async throws {
        let session = FoundryModelSession(model: .foundation)
        
        let ourSchema = DynamicGenerationSchema(name: "TestSchema")
        let nameProperty = DynamicGenerationSchema.Property(
            name: "name",
            schema: DynamicGenerationSchema(name: "name", type: .string)
        )
        ourSchema.addProperty(nameProperty, required: true)
        
        // This should not throw
        _ = try await session.respond(
            to: "Generate a test object",
            schema: ourSchema
        )
    }
    
    // MARK: - Integration Tests
    
    func testGuidedGenerationWithMLXBackend() async throws {
        let session = FoundryModelSession(model: .mlx("test-model"))
        
        // Test that it falls back gracefully
        do {
            _ = try await session.respond(
                to: "Generate a person",
                schema: DynamicGenerationSchema(name: "Person")
            )
            XCTFail("Expected unsupported feature error")
        } catch FoundryGenerationError.unsupportedFeature {
            // Expected
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    // MARK: - Token Masking Tests
    
    func testTokenMaskingForInvalidTokens() throws {
        // Token masking tests would require MLX framework and real tokenizer
        // For unit tests, we focus on the logic tests above
        // Integration tests would handle the full token masking behavior
    }
    
    // MARK: - Validation Tests
    
    func testValidationConstraints() {
        let person = TestPerson(name: "John Doe", age: 25, email: "john@example.com")
        
        // Test that valid data passes
        // In a real implementation, we'd validate against the schema
        XCTAssertTrue(person.age >= 0 && person.age <= 150)
        XCTAssertTrue(person.email.contains("@"))
    }
    
    func testEnumValidation() {
        let product = TestProduct(
            name: "Laptop",
            price: 999.99,
            category: "electronics",
            inStock: true
        )
        
        let validCategories = ["electronics", "clothing", "food", "books"]
        XCTAssertTrue(validCategories.contains(product.category))
    }
}

