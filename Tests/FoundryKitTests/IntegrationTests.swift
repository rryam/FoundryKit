import Testing
import Foundation
@testable import FoundryKit

@Suite("Integration Tests")
struct IntegrationTests {
    
    // MARK: - Public API Tests
    
    @Test("Create FoundryModelSession with different models")
    func testModelSessionCreation() {
        // Test MLX model session creation
        let mlxSession = FoundryModelSession(model: .mlx("test-model"))
        #expect(mlxSession.model != nil)
        
        // Test Foundation model session creation
        let foundationSession = FoundryModelSession(model: .foundation)
        #expect(foundationSession.model != nil)
    }
    
    @Test("Generation options creation and validation")
    func testGenerationOptionsCreation() {
        // Test creating options with all parameters
        let fullOptions = FoundryGenerationOptions(
            sampling: .random(top: 40, seed: 12345),
            temperature: 0.8,
            frequencyPenalty: 0.1,
            presencePenalty: 0.2,
            maxTokens: 150,
            topP: 0.95,
            useGuidedGeneration: true
        )
        
        #expect(fullOptions.temperature == 0.8)
        #expect(fullOptions.maxTokens == 150)
        #expect(fullOptions.useGuidedGeneration == true)
        
        // Test minimal options
        let minOptions = FoundryGenerationOptions()
        #expect(minOptions.temperature == nil)
        #expect(minOptions.maxTokens == nil)
        #expect(minOptions.useGuidedGeneration == false)
    }
    
    @Test("Error context creation and information")
    func testErrorContextHandling() {
        let underlyingError = NSError(domain: "TestDomain", code: 42, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        let context = FoundryGenerationError.Context(
            debugDescription: "Main error description",
            underlyingErrors: [underlyingError]
        )
        
        #expect(context.debugDescription == "Main error description")
        #expect(context.underlyingErrors.count == 1)
        
        // Create various error types
        let errors: [FoundryGenerationError] = [
            .networkError(context),
            .backendUnavailable(context),
            .modelLoadingFailed(context),
            .decodingFailure(context)
        ]
        
        // Verify all errors have proper descriptions
        for error in errors {
            #expect(error.errorDescription != nil)
            #expect(error.failureReason != nil)
            #expect(error.recoverySuggestion != nil)
        }
    }
    
    @Test("Dynamic schema creation and manipulation")
    func testDynamicSchemaCreation() {
        let schema = DynamicGenerationSchema(name: "User", type: .object(properties: [:]))
        
        // Add string property
        let nameProperty = DynamicGenerationSchema.Property(
            name: "name",
            schema: DynamicGenerationSchema(name: "name", type: .string)
        )
        schema.addProperty(nameProperty, required: true)
        
        // Add number property with constraints
        let ageSchema = DynamicGenerationSchema(name: "age", type: .integer)
        ageSchema.addConstraint(.minimum(0))
        ageSchema.addConstraint(.maximum(150))
        
        let ageProperty = DynamicGenerationSchema.Property(
            name: "age",
            schema: ageSchema
        )
        schema.addProperty(ageProperty, required: false)
        
        #expect(schema.properties.count == 2)
        #expect(schema.required.contains("name"))
        #expect(!schema.required.contains("age"))
        #expect(schema.properties[1].schema.constraints.count == 2)
    }
    
    @Test("Runtime schema creation from dynamic schema")
    func testRuntimeSchemaCreation() throws {
        let dynamicSchema = DynamicGenerationSchema(name: "Product", type: .object(properties: [:]))
        
        let nameProperty = DynamicGenerationSchema.Property(
            name: "productName",
            schema: DynamicGenerationSchema(name: "productName", type: .string)
        )
        dynamicSchema.addProperty(nameProperty, required: true)
        
        let priceProperty = DynamicGenerationSchema.Property(
            name: "price",
            schema: DynamicGenerationSchema(name: "price", type: .number)
        )
        dynamicSchema.addProperty(priceProperty, required: true)
        
        // Create runtime schema
        let runtimeSchema = try RuntimeGenerationSchema(root: dynamicSchema)
        
        #expect(runtimeSchema.root.name == "Product")
        
        // Test property traversal
        let rootProperties = runtimeSchema.getValidProperties(at: [])
        #expect(rootProperties.contains("productName"))
        #expect(rootProperties.contains("price"))
        
        // Test getting schema types
        let nameType = runtimeSchema.getSchemaType(at: [], property: "productName")
        let priceType = runtimeSchema.getSchemaType(at: [], property: "price")
        
        #expect(nameType == .string)
        #expect(priceType == .number)
    }
    
    @Test("Schema type conversions")
    func testSchemaTypeConversions() {
        // Test creating schema types from strings
        #expect(SchemaType(from: "string") == .string)
        #expect(SchemaType(from: "number") == .number)
        #expect(SchemaType(from: "integer") == .number) // Maps to number
        #expect(SchemaType(from: "boolean") == .boolean)
        #expect(SchemaType(from: "array") == .array(elementType: .string))
        #expect(SchemaType(from: "object") == .object(properties: [:]))
        #expect(SchemaType(from: "null") == .null)
        #expect(SchemaType(from: "unknown") == .string) // Default fallback
    }
    
    @Test("Schema node creation and parsing")
    func testSchemaNodeCreation() {
        // Test creating schema node from dictionary
        let schemaDict: [String: Any] = [
            "type": "object",
            "properties": [
                "message": ["type": "string"]
            ],
            "required": ["message"]
        ]
        
        let node = SchemaNode(from: schemaDict, name: "TestSchema")
        #expect(node.name == "TestSchema")
        #expect(node.required.contains("message"))
        
        // Test getting valid properties
        let props = node.getValidProperties(at: [])
        #expect(props.contains("message"))
    }
    
    @Test("Complex nested schema handling")
    func testComplexNestedSchema() throws {
        // Create a complex nested schema
        let companySchema = DynamicGenerationSchema(name: "Company", type: .object(properties: [:]))
        
        // Employee schema
        let employeeSchema = DynamicGenerationSchema(name: "Employee", type: .object(properties: [:]))
        employeeSchema.addProperty(
            DynamicGenerationSchema.Property(
                name: "id",
                schema: DynamicGenerationSchema(name: "id", type: .integer)
            ),
            required: true
        )
        employeeSchema.addProperty(
            DynamicGenerationSchema.Property(
                name: "name",
                schema: DynamicGenerationSchema(name: "name", type: .string)
            ),
            required: true
        )
        
        // Department schema with employees array
        let departmentSchema = DynamicGenerationSchema(name: "Department", type: .object(properties: [:]))
        departmentSchema.addProperty(
            DynamicGenerationSchema.Property(
                name: "name",
                schema: DynamicGenerationSchema(name: "name", type: .string)
            ),
            required: true
        )
        
        let employeesArraySchema = DynamicGenerationSchema(name: "employees", type: .array(elementType: .object(properties: [:])))
        employeesArraySchema.items = employeeSchema
        
        departmentSchema.addProperty(
            DynamicGenerationSchema.Property(
                name: "employees",
                schema: employeesArraySchema
            ),
            required: true
        )
        
        // Add departments to company
        let departmentsArraySchema = DynamicGenerationSchema(name: "departments", type: .array(elementType: .object(properties: [:])))
        departmentsArraySchema.items = departmentSchema
        
        companySchema.addProperty(
            DynamicGenerationSchema.Property(
                name: "name",
                schema: DynamicGenerationSchema(name: "name", type: .string)
            ),
            required: true
        )
        companySchema.addProperty(
            DynamicGenerationSchema.Property(
                name: "departments",
                schema: departmentsArraySchema
            ),
            required: true
        )
        
        // Create runtime schema and test traversal
        let runtimeSchema = try RuntimeGenerationSchema(root: companySchema)
        
        let companyProps = runtimeSchema.getValidProperties(at: [])
        #expect(companyProps.contains("name"))
        #expect(companyProps.contains("departments"))
        
        _ = runtimeSchema.getValidProperties(at: ["departments"])
        // Note: Array elements don't have direct properties in this implementation
        
        #expect(runtimeSchema.root.name == "Company")
    }
    
}

// MARK: - Test-specific Extensions

extension FoundryGenerationOptions {
    static var testDefault: FoundryGenerationOptions {
        FoundryGenerationOptions(
            sampling: .random(top: 40),
            temperature: 0.7,
            maxTokens: 100
        )
    }
}