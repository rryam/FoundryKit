# FoundryKit Macro Example

This example demonstrates the `@FoundryGenerable` macro from FoundryKit, which automatically generates JSON schemas and MLX tool call schemas for Swift structs.

## Features Demonstrated

### 1. Automatic Schema Generation
The example shows two models with the `@FoundryGenerable` macro:
- **Product Model**: E-commerce product with various validation constraints
- **User Profile Model**: User account with pattern validation and optional fields

### 2. Validation Attributes
- `@FoundryGuide`: Adds descriptions to properties
- `@FoundryValidation`: Adds constraints like min/max values, string lengths, patterns, and enums

### 3. Generated Outputs
Each model automatically generates:
- **JSON Schema**: Standard JSON Schema format for validation
- **MLX Tool Call Schema**: Function calling format for MLX Swift
- **Example JSON**: Realistic example data respecting validation rules

## Running the Example

1. Generate the Xcode project:
   ```bash
   cd Examples/FoundryMacroExample
   xcodegen generate
   ```

2. Open the generated project:
   ```bash
   open FoundryMacroExample.xcodeproj
   ```

3. Build and run for either iOS or macOS

## Key Features

### JSON Schema Generation
```swift
@FoundryGenerable
struct Product {
    @FoundryGuide("Product name")
    @FoundryValidation(minLength: 3, maxLength: 200)
    let name: String
    
    @FoundryGuide("Price in USD")
    @FoundryValidation(min: 0, max: 999999)
    let price: Double
}
```

Generates:
```json
{
  "type": "object",
  "properties": {
    "name": {
      "type": "string",
      "description": "Product name",
      "minLength": 3,
      "maxLength": 200
    },
    "price": {
      "type": "number",
      "description": "Price in USD",
      "minimum": 0,
      "maximum": 999999
    }
  },
  "required": ["name", "price"]
}
```

### MLX Tool Call Schema
The same model also generates an MLX-compatible schema:
```json
{
  "type": "function",
  "function": {
    "name": "generate_product",
    "description": "Generate a structured Product object",
    "parameters": {
      "type": "object",
      "properties": { ... },
      "required": [ ... ]
    }
  }
}
```

## Supported Validations

- **Numeric**: `min`, `max`
- **String**: `minLength`, `maxLength`, `pattern`
- **Array**: `minItems`, `maxItems`
- **Enum**: `enumValues`

## UI Features

- Toggle between JSON Schema and MLX Tool Call Schema views
- Copy schemas to clipboard
- Properties summary with constraints
- Example JSON generation
- Cross-platform support (iOS and macOS)