# FoundryKit Structured Generation

## Overview

FoundryKit provides powerful structured generation capabilities for MLX models, bringing type-safe, schema-driven generation to local language models on Apple Silicon. While Apple's Foundation Models have native support for structured generation through the `@Generable` macro, FoundryKit extends this capability to MLX models through intelligent prompt engineering and JSON parsing.

## Key Features

- **Type-Safe Generation**: Use Swift types with `@Generable` macro for compile-time safety
- **JSON Schema Support**: Automatic schema extraction and validation
- **Nested Structures**: Support for complex, nested data types
- **Optional Fields**: Proper handling of optional properties
- **Streaming Support**: Progressive generation of structured data
- **Tool/Function Calling**: Built-in support for function calling patterns
- **Model-Specific Optimization**: Tailored prompts for different MLX models

## Basic Usage

### Using @Generable Types

The simplest way to use structured generation is with the `@Generable` macro from FoundationModels:

```swift
import FoundryKit
import FoundationModels

@Generable
struct WeatherInfo {
    @Guide(description: "City name")
    let location: String
    
    @Guide(description: "Temperature in Celsius")
    let temperature: Double
    
    @Guide(description: "Weather conditions")
    let conditions: String
    
    @Guide(description: "Humidity percentage (0-100)")
    let humidity: Int?
}

// Usage
let session = FoundryModelSession(model: .mlx(.qwen2_0_5B_4bit))
let weather = try await session.respond(
    to: "What's the weather in Tokyo?",
    generating: WeatherInfo.self
)

print("Weather in \(weather.content.location):")
print("Temperature: \(weather.content.temperature)°C")
print("Conditions: \(weather.content.conditions)")
```

### Using StructuredOutput Protocol

For cases where you can't use the `@Generable` macro, implement the `StructuredOutput` protocol:

```swift
struct ContactInfo: StructuredOutput, Codable {
    let name: String
    let email: String?
    let phone: String?
    
    static var jsonSchema: [String: Any] {
        [
            "type": "object",
            "properties": [
                "name": ["type": "string", "description": "Full name"],
                "email": ["type": "string", "format": "email"],
                "phone": ["type": "string"]
            ],
            "required": ["name"]
        ]
    }
    
    static var exampleJSON: String? {
        """
        {
            "name": "John Doe",
            "email": "john@example.com",
            "phone": "555-1234"
        }
        """
    }
}
```

## Advanced Features

### Nested Structures

FoundryKit supports complex nested structures:

```swift
@Generable
struct Recipe {
    @Guide(description: "Recipe name")
    let name: String
    
    @Guide(description: "List of ingredients")
    let ingredients: [Ingredient]
    
    @Guide(description: "Cooking instructions")
    let instructions: [String]
    
    @Generable
    struct Ingredient {
        @Guide(description: "Ingredient name")
        let name: String
        
        @Guide(description: "Amount needed")
        let amount: String
    }
}
```

### Tool/Function Calling

Implement tool calling patterns for enhanced LLM capabilities:

```swift
struct CalculatorTool: Tool {
    static let signature = ToolSignature(
        name: "calculator",
        description: "Performs arithmetic calculations",
        parameters: [
            .number(name: "x", description: "First number"),
            .number(name: "y", description: "Second number"),
            .enum(name: "operation", description: "Math operation", 
                  values: ["add", "subtract", "multiply", "divide"])
        ]
    )
    
    func execute(with arguments: [String: Any]) async throws -> String {
        // Implementation
    }
}

let session = FoundryModelSession(
    model: .mlx(.qwen2_0_5B_4bit),
    tools: [CalculatorTool()]
)
```

### Streaming Structured Generation

Stream structured data as it's generated:

```swift
@Generable
struct ArticleSummary {
    @Guide(description: "Article title")
    let title: String
    
    @Guide(description: "Key points")
    let mainPoints: [String]
    
    @Guide(description: "Conclusion")
    let conclusion: String
}

let stream = session.streamResponse(
    to: "Summarize this article: ...",
    generating: ArticleSummary.self
)

for try await partial in stream {
    // Access fields as they become available
    if let title = partial.title {
        print("Title: \(title)")
    }
}
```

## Model-Specific Considerations

Different MLX models have varying capabilities for structured generation:

### Qwen Models
- **Best for**: Tool calling and complex structured outputs
- **Strengths**: Native understanding of function calling patterns
- **Recommended**: `qwen2_0_5B_4bit`, `qwen2_5_3B_4bit`

### Mistral/Mixtral Models
- **Best for**: General structured generation
- **Strengths**: Good JSON compliance, reliable parsing
- **Recommended**: `mistral7B4bit`, `mixtral8x7B4bit`

### Llama Models
- **Best for**: Simple to medium complexity structures
- **Strengths**: Fast inference, good for basic schemas
- **Recommended**: `llama3_2_3B_4bit`, `llama3_2_1B_4bit`

### Phi Models
- **Best for**: Lightweight structured generation
- **Strengths**: Efficient for edge devices
- **Recommended**: `phi3_5_4bit`, `phi4bit`

## Configuration Options

Customize structured generation behavior:

```swift
let config = StructuredGenerationConfig(
    includeSchemaInPrompt: true,  // Include JSON schema in prompt
    includeExample: true,          // Include example JSON
    maxRetries: 3,                 // Retry parsing failures
    temperature: 0.7               // Lower for more deterministic output
)

let response = try await session.respond(
    to: prompt,
    generating: MyType.self,
    options: FoundryGenerationOptions(
        temperature: config.temperature
    )
)
```

## Best Practices

1. **Use @Guide Attributes**: Provide clear descriptions for each field
   ```swift
   @Guide(description: "User's age, must be 18 or older")
   let age: Int
   ```

2. **Validate Generated Data**: Always validate critical fields
   ```swift
   struct Form {
       let email: String
       
       var isValid: Bool {
           email.contains("@") && email.contains(".")
       }
   }
   ```

3. **Handle Optionals Properly**: Use optional fields for non-required data
   ```swift
   @Guide(description: "Optional middle name")
   let middleName: String?
   ```

4. **Provide Examples**: Include example JSON for complex structures
   ```swift
   static var exampleJSON: String? {
       // Provide a complete, valid example
   }
   ```

5. **Choose the Right Model**: Match model capabilities to your needs
   - Complex structures: Qwen or Mistral models
   - Simple schemas: Llama or Phi models
   - Tool calling: Qwen models preferred

## Error Handling

Handle common structured generation errors:

```swift
do {
    let result = try await session.respond(
        to: prompt,
        generating: MyType.self
    )
} catch let error as FoundryGenerationError {
    switch error {
    case .decodingFailure(let context):
        print("Failed to parse response: \(context.debugDescription)")
        // Retry with adjusted prompt or different model
    case .exceededContextWindowSize:
        // Reduce prompt size or schema complexity
    default:
        // Handle other errors
    }
}
```

## Common Patterns

### Form Generation
```swift
@Generable
struct RegistrationForm {
    @Guide(description: "Username (3-20 characters)")
    let username: String
    
    @Guide(description: "Valid email address")
    let email: String
    
    @Guide(description: "Password (min 8 characters)")
    let password: String
}
```

### Data Extraction
```swift
@Generable
struct ExtractedData {
    @Guide(description: "Extracted entities")
    let entities: [Entity]
    
    @Guide(description: "Sentiment (positive/negative/neutral)")
    let sentiment: String
    
    @Guide(description: "Key phrases")
    let keyPhrases: [String]
}
```

### API Response Modeling
```swift
@Generable
struct APIResponse {
    @Guide(description: "Success status")
    let success: Bool
    
    @Guide(description: "Response data")
    let data: ResponseData?
    
    @Guide(description: "Error message if failed")
    let error: String?
}
```

## Performance Tips

1. **Cache Schemas**: Reuse schema definitions across requests
2. **Batch Requests**: Generate multiple structures in one call when possible
3. **Use Appropriate Models**: Smaller models for simple schemas
4. **Optimize Prompts**: Keep prompts concise but descriptive
5. **Stream When Possible**: Use streaming for large structures

## Future Enhancements

The FoundryKit team is working on:
- Native `@FoundryGenerable` macro for automatic schema generation
- Improved JSON parsing with ML-based error correction
- Schema validation and migration tools
- Enhanced streaming with field-level updates
- Direct integration with SwiftData models

## Conclusion

FoundryKit's structured generation brings the power of type-safe, schema-driven AI generation to MLX models. Whether you're building forms, extracting data, or implementing complex tool-calling patterns, FoundryKit provides the tools you need for reliable, production-ready structured generation on Apple Silicon.