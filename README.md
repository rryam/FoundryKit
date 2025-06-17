# FoundryKit

A unified Swift API for language model inference that seamlessly integrates MLX models and Apple's Foundation Models framework.

## Overview

FoundryKit provides a single, Foundation Models-style API that works with both:
- **MLX Models**: Open-source models from Hugging Face (Mistral, Llama, Qwen, etc.)
- **Foundation Models**: Apple's on-device language models (Apple Intelligence)

## Features

✅ **Unified API**: Same interface for both MLX and Foundation Models  
✅ **Foundation Models Style**: Uses familiar `@Generable`, `GenerationOptions`, `Instructions`  
✅ **Namespaced Types**: All types prefixed with `Foundry` to avoid conflicts (e.g., `FoundryGenerable`)  
✅ **Structured Generation**: Type-safe output with `@Generable` structs  
✅ **Streaming Support**: Real-time response streaming with AsyncSequence  
✅ **Full Swift 6 Support**: Complete concurrency safety with Sendable conformance  
✅ **Zero Learning Curve**: If you know Foundation Models, you know FoundryKit

## Installation

### Swift Package Manager

Add FoundryKit to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/FoundryKit", branch: "main")
]
```

## Usage

### Basic Text Generation

```swift
import FoundryKit

// Use MLX model
let mlxSession = FoundryModelSession(model: .mlx("mlx-community/Qwen3-4B"))
let response = try await mlxSession.respond(to: "Hello, world!")

// Use Foundation Models (Apple Intelligence)
let fmSession = FoundryModelSession(model: .foundation)
let response = try await fmSession.respond(to: "Hello, world!")
```

### Structured Generation

```swift
// Use either @Generable (compatibility) or @FoundryGenerable
@Generable
struct Recipe: Sendable {
    @Guide(description: "Recipe name")
    var name: String
    
    @Guide(description: "Cooking time in minutes", .range(10...120))
    var cookingTime: Int
    
    @Guide(description: "List of ingredients", .count(3...10))
    var ingredients: [String]
}

let session = FoundryModelSession(model: .mlx("mistralai/Mistral-7B"))
let recipe = try await session.respond(
    to: "Create a chocolate cake recipe",
    generating: Recipe.self
)

print("Recipe: \(recipe.content.name)")
print("Time: \(recipe.content.cookingTime) minutes")
print("Ingredients: \(recipe.content.ingredients)")
```

### Streaming Responses

```swift
let session = FoundryModelSession(model: .foundation)

for try await partial in session.streamResponse(
    to: "Tell me a story",
    generating: Story.self
) {
    // Handle partial generation as it arrives
    if let title = partial.title {
        print("Title: \(title)")
    }
}
```

### Custom Generation Options

```swift
let options = FoundryGenerationOptions(
    sampling: .random(top: 50, seed: 42),
    temperature: 0.8,
    maxTokens: 500
)

let response = try await session.respond(
    to: "Write a poem",
    options: options
)
```

## Model Selection

### MLX Models
Use any model from Hugging Face's MLX community:
```swift
.mlx("mlx-community/Mistral-7B-v0.1")
.mlx("mlx-community/Llama-3.2-3B-4bit")
.mlx("mlx-community/Phi-3.5-mini-instruct")
```

### Foundation Models
Use Apple's on-device models:
```swift
.foundation  // Uses the default system model
```

## Platform Requirements

- iOS 26.0+
- macOS 26.0+
- visionOS 26.0+
- Swift 6.0+

## Architecture

FoundryKit uses a clean backend architecture:
- **FoundryModelSession**: Main API class with Foundation Models-style interface
- **FoundryModel**: Enum for selecting between MLX and Foundation Models
- **Backend Protocol**: Clean separation between implementations
- **Type Re-exports**: All Foundation Models types available through FoundryKit

## Type Naming

All types are prefixed with `Foundry` to avoid conflicts with Foundation Models:
- `FoundryGenerable` instead of `Generable`
- `FoundryPrompt` instead of `Prompt`
- `FoundryTranscript` instead of `Transcript`
- etc.

For convenience, compatibility type aliases are provided without the prefix, so existing code using `@Generable`, `Prompt`, etc. continues to work.

## License

[Your License Here]

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.