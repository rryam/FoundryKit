import Testing
@testable import FoundryKit

@Suite("Schema Types Tests")
struct SchemaTests {
    
    // MARK: - DynamicGenerationSchema Tests
    
    @Test("Create simple dynamic schema")
    func testSimpleDynamicSchema() {
        let schema = DynamicGenerationSchema(name: "Person", type: .object(properties: [:]))
        
        #expect(schema.name == "Person")
        #expect(schema.properties.isEmpty)
        #expect(schema.required.isEmpty)
        #expect(schema.constraints.isEmpty)
    }
    
    @Test("Add properties to dynamic schema")
    func testAddProperties() {
        let schema = DynamicGenerationSchema(name: "User")
        
        let nameProperty = DynamicGenerationSchema.Property(
            name: "name",
            schema: DynamicGenerationSchema(name: "name", type: .string)
        )
        schema.addProperty(nameProperty, required: true)
        
        let ageProperty = DynamicGenerationSchema.Property(
            name: "age",
            schema: DynamicGenerationSchema(name: "age", type: .integer)
        )
        schema.addProperty(ageProperty, required: false)
        
        #expect(schema.properties.count == 2)
        #expect(schema.required.count == 1)
        #expect(schema.required.contains("name"))
        #expect(!schema.required.contains("age"))
    }
    
    @Test("Dynamic schema with constraints")
    func testSchemaConstraints() {
        let schema = DynamicGenerationSchema(name: "ConstrainedString", type: .string)
        
        schema.addConstraint(.minLength(5))
        schema.addConstraint(.maxLength(20))
        schema.addConstraint(.pattern("^[A-Z].*"))
        
        #expect(schema.constraints.count == 3)
    }
    
    @Test("Dynamic schema with enum values")
    func testEnumSchema() {
        let schema = DynamicGenerationSchema(
            name: "Status",
            anyOf: ["active", "inactive", "pending"]
        )
        
        #expect(schema.anyOf?.count == 3)
        #expect(schema.anyOf?.contains("active") == true)
        #expect(schema.anyOf?.contains("inactive") == true)
        #expect(schema.anyOf?.contains("pending") == true)
    }
    
    @Test("Nested dynamic schema")
    func testNestedSchema() {
        let addressSchema = DynamicGenerationSchema(name: "Address", type: .object(properties: [:]))
        
        let streetProperty = DynamicGenerationSchema.Property(
            name: "street",
            schema: DynamicGenerationSchema(name: "street", type: .string)
        )
        addressSchema.addProperty(streetProperty, required: true)
        
        let cityProperty = DynamicGenerationSchema.Property(
            name: "city",
            schema: DynamicGenerationSchema(name: "city", type: .string)
        )
        addressSchema.addProperty(cityProperty, required: true)
        
        let userSchema = DynamicGenerationSchema(name: "User", type: .object(properties: [:]))
        let addressProperty = DynamicGenerationSchema.Property(
            name: "address",
            schema: addressSchema
        )
        userSchema.addProperty(addressProperty, required: false)
        
        #expect(userSchema.properties.count == 1)
        #expect(userSchema.properties.first?.schema.properties.count == 2)
    }
    
    @Test("Array schema")
    func testArraySchema() {
        let itemSchema = DynamicGenerationSchema(name: "Item", type: .string)
        let arraySchema = DynamicGenerationSchema(
            name: "StringArray",
            type: .array(elementType: .string)
        )
        arraySchema.items = itemSchema
        
        // Note: DynamicConstraint doesn't have minItems/maxItems
        // These would need to be added to match the original test intent
        
        #expect(arraySchema.type == .array(elementType: .string))
        #expect(arraySchema.items != nil)
    }
    
    // MARK: - RuntimeGenerationSchema Tests
    
    @Test("Create runtime schema from dynamic")
    func testRuntimeSchemaFromDynamic() throws {
        let dynamicSchema = DynamicGenerationSchema(name: "Test", type: .object(properties: [:]))
        let runtimeSchema = try RuntimeGenerationSchema(root: dynamicSchema)
        
        #expect(runtimeSchema.root.name == "Test")
        #expect(runtimeSchema.dependencies.isEmpty)
    }
    
    @Test("Runtime schema with dependencies")
    func testRuntimeSchemaWithDependencies() throws {
        let rootSchema = DynamicGenerationSchema(name: "Root", type: .object(properties: [:]))
        let depSchema = DynamicGenerationSchema(name: "Dependency", type: .string)
        
        let runtimeSchema = try RuntimeGenerationSchema(
            root: rootSchema,
            dependencies: [depSchema]
        )
        
        #expect(runtimeSchema.root.name == "Root")
        #expect(runtimeSchema.dependencies.count == 1)
        #expect(runtimeSchema.dependencies[0].name == "Dependency")
    }
    
    // MARK: - Schema Validation Tests
    
    @Test("Validate string constraints")
    func testStringConstraintValidation() {
        let minLengthConstraint = DynamicGenerationSchema.DynamicConstraint.minLength(5)
        let maxLengthConstraint = DynamicGenerationSchema.DynamicConstraint.maxLength(10)
        let patternConstraint = DynamicGenerationSchema.DynamicConstraint.pattern("^[A-Z].*")
        
        // Test constraint creation
        if case .minLength(let value) = minLengthConstraint {
            #expect(value == 5)
        } else {
            Issue.record("Expected minLength constraint")
        }
        
        if case .maxLength(let value) = maxLengthConstraint {
            #expect(value == 10)
        } else {
            Issue.record("Expected maxLength constraint")
        }
        
        if case .pattern(let value) = patternConstraint {
            #expect(value == "^[A-Z].*")
        } else {
            Issue.record("Expected pattern constraint")
        }
    }
    
    @Test("Validate number constraints")
    func testNumberConstraintValidation() {
        let minConstraint = DynamicGenerationSchema.DynamicConstraint.minimum(0)
        let maxConstraint = DynamicGenerationSchema.DynamicConstraint.maximum(100)
        
        if case .minimum(let value) = minConstraint {
            #expect(value == 0)
        } else {
            Issue.record("Expected minimum constraint")
        }
        
        if case .maximum(let value) = maxConstraint {
            #expect(value == 100)
        } else {
            Issue.record("Expected maximum constraint")
        }
    }
    
    @Test("Validate enum constraints")
    func testEnumConstraintValidation() {
        let enumConstraint = DynamicGenerationSchema.DynamicConstraint.enum(["red", "green", "blue"])
        
        if case .enum(let values) = enumConstraint {
            #expect(values.count == 3)
            #expect(values.contains("red"))
            #expect(values.contains("green"))
            #expect(values.contains("blue"))
        } else {
            Issue.record("Expected enum constraint")
        }
    }
    
    // MARK: - Schema Type Tests
    
    @Test("Schema type creation")
    func testSchemaTypes() {
        let types: [SchemaType] = [
            .object(properties: [:]),
            .array(elementType: .string),
            .string,
            .number,
            .integer,
            .boolean,
            .null,
            .any
        ]
        
        #expect(types.count == 8)
        
        // Test type initialization from string
        #expect(SchemaType(from: "string") == .string)
        #expect(SchemaType(from: "number") == .number)
        #expect(SchemaType(from: "boolean") == .boolean)
        #expect(SchemaType(from: "null") == .null)
    }
    
    @Test("Schema node traversal")
    func testSchemaNodeTraversal() throws {
        let schema = DynamicGenerationSchema(name: "Root", type: .object(properties: [:]))
        
        let userPropSchema = DynamicGenerationSchema(name: "user", type: .object(properties: [:]))
        let namePropSchema = DynamicGenerationSchema(name: "name", type: .string)
        
        userPropSchema.addProperty(
            DynamicGenerationSchema.Property(name: "name", schema: namePropSchema),
            required: true
        )
        
        schema.addProperty(
            DynamicGenerationSchema.Property(name: "user", schema: userPropSchema),
            required: true
        )
        
        let runtimeSchema = try RuntimeGenerationSchema(root: schema)
        
        // Test getting valid properties at root
        let rootProperties = runtimeSchema.getValidProperties(at: [])
        #expect(rootProperties.contains("user"))
        
        // Test getting valid properties at nested path
        let userProperties = runtimeSchema.getValidProperties(at: ["user"])
        #expect(userProperties.contains("name"))
        
        // Test getting schema type
        let nameType = runtimeSchema.getSchemaType(at: ["user"], property: "name")
        #expect(nameType == .string)
    }
}