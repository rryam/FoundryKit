# @FoundryGenerable Macro

## Overview

The `@FoundryGenerable` macro is a powerful Swift macro that automatically generates all the boilerplate code needed for structured generation with language models. It creates `Generable` conformance, JSON schemas, validation rules, and example data - all from simple property annotations.

## Why @FoundryGenerable?

Traditional structured generation requires:
- Manual JSON schema creation
- Separate validation logic
- Example data maintenance

With `@FoundryGenerable`, you just write:
```swift
@FoundryGenerable
struct ProductReview {
    @FoundryGuide("Product name")
    let productName: String
    
    @FoundryGuide("Rating from 1 to 5")
    @FoundryValidation(min: 1, max: 5)
    let rating: Int
}
```

And the macro generates everything automatically!

## Features

### 1. Automatic Generable Conformance
The macro generates:
- `generationSchema` property
- `generatedContent` property
- `PartiallyGenerated` nested type
- Initializer from `GeneratedContent`

### 2. JSON Schema Generation
Automatically creates JSON schemas with:
- Type information
- Property descriptions
- Validation constraints
- Required/optional fields

### 3. Validation Rules
Built-in validation support:
- Numeric ranges (min/max)
- String length constraints
- Array size limits
- Regex patterns
- Enum values
- Custom validators

### 4. Example Generation
Generates realistic example JSON based on:
- Validation constraints
- Property descriptions
- Type information

## Usage

### Basic Example

```swift
@FoundryGenerable
struct WeatherInfo {
    @FoundryGuide("City name")
    let location: String
    
    @FoundryGuide("Temperature in Celsius")
    @FoundryValidation(min: -50, max: 50)
    let temperature: Double
    
    @FoundryGuide("Weather conditions")
    @FoundryValidation(enumValues: ["sunny", "cloudy", "rainy", "snowy"])
    let conditions: String
    
    @FoundryGuide("Humidity percentage")
    @FoundryValidation(min: 0, max: 100)
    let humidity: Int?
}

// Usage
let session = FoundryModelSession(model: .mlx(.qwen2_0_5B_4bit))
let weather = try await session.respond(
    to: "What's the weather in Tokyo?",
    generating: WeatherInfo.self
)
```

### Complex Validation

```swift
@FoundryGenerable
struct UserProfile {
    @FoundryGuide("Username (alphanumeric, 3-20 chars)")
    @FoundryValidation(
        pattern: "^[a-zA-Z0-9]{3,20}$",
        minLength: 3,
        maxLength: 20
    )
    let username: String
    
    @FoundryGuide("Email address")
    @FoundryValidation(
        pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
    )
    let email: String
    
    @FoundryGuide("Age")
    @FoundryValidation(min: 13, max: 120)
    let age: Int
    
    @FoundryGuide("Interests")
    @FoundryValidation(minItems: 1, maxItems: 10)
    let interests: [String]
}
```

### Nested Structures

```swift
@FoundryGenerable
struct Order {
    @FoundryGuide("Order ID")
    let id: String
    
    @FoundryGuide("Customer details")
    let customer: Customer
    
    @FoundryGuide("Order items")
    @FoundryValidation(minItems: 1)
    let items: [OrderItem]
    
    @FoundryGenerable
    struct Customer {
        @FoundryGuide("Full name")
        let name: String
        
        @FoundryGuide("Email")
        let email: String
    }
    
    @FoundryGenerable
    struct OrderItem {
        @FoundryGuide("Product name")
        let product: String
        
        @FoundryGuide("Quantity")
        @FoundryValidation(min: 1)
        let quantity: Int
        
        @FoundryGuide("Price in cents")
        @FoundryValidation(min: 0)
        let price: Int
    }
}
```

## Validation Attributes

### @FoundryGuide
Adds descriptions to properties for better LLM understanding:
```swift
@FoundryGuide("User's full name including middle name")
let fullName: String
```

### @FoundryValidation
Adds validation constraints:

#### Numeric Validation
```swift
@FoundryValidation(min: 0, max: 100)
let percentage: Int

@FoundryValidation(min: -273.15)  // Absolute zero
let temperature: Double
```

#### String Validation
```swift
@FoundryValidation(minLength: 8, maxLength: 128)
let password: String

@FoundryValidation(pattern: "^[A-Z]{2}[0-9]{4}$")
let productCode: String
```

#### Array Validation
```swift
@FoundryValidation(minItems: 1, maxItems: 5)
let tags: [String]
```

#### Enum Validation
```swift
@FoundryValidation(enumValues: ["small", "medium", "large", "xl"])
let size: String
```

## Generated Code

The macro generates several components:

### 1. Generation Schema
```swift
nonisolated static var generationSchema: GenerationSchema {
    GenerationSchema(
        type: Self.self,
        properties: [
            GenerationSchema.Property(
                name: "productName",
                description: "Product name",
                type: String.self
            ),
            // ... other properties
        ]
    )
}
```

### 2. JSON Schema
```swift
static var jsonSchema: [String: Any] {
    [
        "type": "object",
        "properties": [
            "productName": [
                "type": "string",
                "description": "Product name"
            ],
            "rating": [
                "type": "integer",
                "description": "Rating from 1 to 5",
                "minimum": 1,
                "maximum": 5
            ]
        ],
        "required": ["productName", "rating"]
    ]
}
```

### 3. Example JSON
```swift
static var exampleJSON: String? {
    """
    {
        "productName": "iPhone 15 Pro",
        "rating": 5,
        "reviewText": "Amazing phone with excellent camera..."
    }
    """
}
```

### 4. Partial Generation Support
```swift
struct PartiallyGenerated: Identifiable {
    var id: GenerationID
    var productName: String.PartiallyGenerated?
    var rating: Int.PartiallyGenerated?
    // ...
}
```

## Advanced Features

### Custom Validation
Combine with FoundryStructuredOutput for custom validation:

```swift
@FoundryGenerable
struct CustomForm: FoundryStructuredOutput {
    @FoundryGuide("Start date")
    let startDate: String
    
    @FoundryGuide("End date")
    let endDate: String
    
    static var validationRules: [String: ValidationRule] {
        [
            "endDate": ValidationRule(
                propertyName: "endDate",
                rules: [.custom { value in
                    // Custom validation logic
                    guard let endDate = value as? String else { return false }
                    // Validate end date is after start date
                    return true
                }]
            )
        ]
    }
}
```

### Runtime Validation
Validate generated content:

```swift
let form = try await session.respond(
    to: "Create a vacation request form",
    generating: CustomForm.self
)

do {
    try form.content.validate()
    print("Form is valid!")
} catch let error as ValidationError {
    print("Validation failed: \(error.localizedDescription)")
}
```

## Best Practices

1. **Clear Descriptions**: Use descriptive @FoundryGuide annotations
   ```swift
   @FoundryGuide("Customer's primary shipping address")
   let shippingAddress: Address
   ```

2. **Appropriate Constraints**: Set realistic validation ranges
   ```swift
   @FoundryValidation(min: 0, max: 150)  // Realistic age range
   let age: Int
   ```

3. **Optional Fields**: Use optionals for non-required data
   ```swift
   @FoundryGuide("Secondary phone number")
   let secondaryPhone: String?
   ```

4. **Enum Values**: Use validation for fixed sets
   ```swift
   @FoundryValidation(enumValues: ["active", "pending", "cancelled"])
   let status: String
   ```

5. **Nested Types**: Break down complex structures
   ```swift
   @FoundryGenerable
   struct Invoice {
       let billing: BillingInfo
       let shipping: ShippingInfo
       let items: [LineItem]
   }
   ```

## Performance Tips

1. **Schema Caching**: The generated schemas are static properties, so they're computed once
2. **Example Reuse**: Example JSON is generated at compile time
3. **Streaming**: Use PartiallyGenerated for progressive updates
4. **Model Selection**: Choose appropriate models for complexity

## Troubleshooting

### Common Issues

1. **Macro Not Found**
   - Ensure FoundryGenerableMacros is in dependencies
   - Clean build folder and rebuild

2. **Invalid JSON Schema**
   - Check property types are JSON-serializable
   - Verify validation constraints are appropriate

3. **Generation Failures**
   - Simplify schema for smaller models
   - Provide clearer descriptions
   - Use examples to guide generation

## Comparison with @Generable

| Feature | @Generable | @FoundryGenerable |
|---------|-----------|-------------------|
| Generable conformance | ✅ | ✅ |
| JSON schema | ❌ | ✅ |
| Validation rules | ❌ | ✅ |
| Example generation | ❌ | ✅ |
| Custom descriptions | ✅ (@Guide) | ✅ (@FoundryGuide) |
| Works with MLX | ⚠️ (via FoundryKit) | ✅ |
| Works with Foundation Models | ✅ | ✅ |

## Future Enhancements

- **Database Integration**: Auto-generate Core Data models
- **API Client Generation**: Create type-safe API clients
- **SwiftUI Forms**: Generate forms from schemas
- **Migration Support**: Handle schema versioning
- **Validation Composition**: Combine multiple validators

## Conclusion

The @FoundryGenerable macro revolutionizes structured generation in Swift by eliminating boilerplate and providing a declarative, type-safe approach to defining AI-generated data structures. It's the perfect tool for building robust, validated AI applications on Apple platforms.