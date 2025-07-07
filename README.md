# FoundryKit

A unified Swift API for language model inference that seamlessly integrates MLX models and Apple's Foundation Models framework.

## Overview

FoundryKit provides a single, Foundation Models-style API that works with both:
- **MLX Models**: Open-source models from Hugging Face (Mistral, Llama, Qwen, etc.)
- **Foundation Models**: Apple's on-device language models (Apple Intelligence)

## Support

Love this project? Check out my books to explore more of AI and iOS development:
- [Exploring AI for iOS Development](https://academy.rudrank.com/product/ai)
- [Exploring AI-Assisted Coding for iOS Development](https://academy.rudrank.com/product/ai-assisted-coding)

Your support helps to keep this project growing!

## Features (v0.0.1)

**Unified API**: Same interface for both MLX and Foundation Models  
**Simple Text Generation**: Clean, straightforward API for generating text responses  
**Foundation Models Style**: Uses familiar `Prompt`, `Instructions`, `Guardrails`  
**Model Selection**: Easy switching between MLX and Foundation Models  
**Generation Options**: Control temperature, sampling, token limits, and penalties  
**Full Swift 6 Support**: Complete concurrency safety with Sendable conformance  
**Zero Learning Curve**: If you know Foundation Models, you know FoundryKit

### Coming Soon
- Structured generation with `@FoundryGenerable` macro
- Response streaming
- Guided JSON generation
- Schema validation

## Installation

### Swift Package Manager

Add FoundryKit to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/rryam/FoundryKit", from: "0.0.2")
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

### Using Prompts

```swift
// Build complex prompts using PromptBuilder
let session = FoundryModelSession(model: .mlx("mlx-community/Llama-3.2-3B"))

let response = try await session.respond {
    "You are a helpful assistant."
    "User: What is the capital of France?"
}

// Or use explicit Prompt construction
let prompt = Prompt("Explain quantum computing in simple terms")
let response = try await session.respond(to: prompt)
```

### With Instructions

```swift
let session = FoundryModelSession(
    model: .foundation,
    instructions: Instructions("You are a creative writing assistant. Always respond with vivid descriptions.")
)

let response = try await session.respond(to: "Describe a sunset")
```

### Custom Generation Options

```swift
let options = FoundryGenerationOptions(
    sampling: .random(top: 50, seed: 42),
    temperature: 0.8,
    maxTokens: 500,
    repetitionPenalty: 1.1,
    frequencyPenalty: 0.1,
    presencePenalty: 0.1
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
- **Type Re-exports**: Foundation Models types available through FoundryKit

## API Reference

### Core Types
- `FoundryModelSession` - Main session class for text generation
- `FoundryModel` - Model selection (`.mlx(String)` or `.foundation`)
- `FoundryGenerationOptions` - Generation parameters
- `Response<String>` - Response container with content and transcript

### Foundation Models Types
- `Prompt`, `PromptBuilder` - For building prompts
- `Instructions` - Model behavior instructions
- `Guardrails` - Safety settings
- `Transcript` - Conversation history

## Error Handling

FoundryKit provides comprehensive error handling:

```swift
do {
    let response = try await session.respond(to: "Hello")
} catch let error as FoundryGenerationError {
    switch error {
    case .backendUnavailable:
        print("Model backend is not available")
    case .exceededContextWindowSize:
        print("Input too long for model")
    case .modelLoadingFailed(let context):
        print("Failed to load model: \(context.debugDescription)")
    default:
        print("Generation error: \(error.localizedDescription)")
    }
}
```

## License

MIT License

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Roadmap

- [x] v0.0.1 - Simple text generation
- [ ] v0.1.0 - Structured generation with `@FoundryGenerable`
- [ ] v0.2.0 - Response streaming
- [ ] v0.3.0 - Guided JSON generation
- [ ] v0.4.0 - Tool calling support
- [ ] v1.0.0 - Production ready with full feature parity
