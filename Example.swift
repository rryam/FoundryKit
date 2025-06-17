import Foundation
import FoundryKit

// Example of using FoundryKit with Foundation Models-style API

// Define a FoundryGenerable struct for structured output
// Note: You can use either @FoundryGenerable or @Generable (compatibility alias)
@Generable
struct Recipe: Sendable {
    @Guide(description: "A catchy recipe name")
    var name: String
    
    @Guide(description: "Preparation time in minutes", .range(5...120))
    var prepTime: Int
    
    @Guide(description: "List of ingredients", .count(3...10))
    var ingredients: [String]
    
    @Guide(description: "Step by step instructions", .count(3...8))
    var instructions: [String]
}

@main
struct FoundryKitExample {
    static func main() async throws {
        print("FoundryKit Example - Unified MLX + Foundation Models API\n")
        
        // Example 1: Using MLX model for text generation
        print("1. Text generation with MLX model:")
        let mlxSession = FoundryModelSession(model: .mlx("mlx-community/Mistral-7B-v0.1"))
        
        do {
            let response = try await mlxSession.respond(to: "What is Swift programming language?")
            print("Response: \(response.content)")
        } catch {
            print("MLX Error: \(error)")
        }
        
        // Example 2: Using Foundation Models (Apple Intelligence)
        print("\n2. Text generation with Foundation Models:")
        let fmSession = FoundryModelSession(model: .foundation)
        
        do {
            let response = try await fmSession.respond(to: "Explain quantum computing in simple terms")
            print("Response: \(response.content)")
        } catch {
            print("Foundation Models Error: \(error)")
        }
        
        // Example 3: Structured generation with MLX
        print("\n3. Structured generation with MLX:")
        let structuredSession = FoundryModelSession(model: .mlx("mlx-community/Qwen3-4B-4bit"))
        
        do {
            let recipe = try await structuredSession.respond(
                to: "Create a simple pasta recipe",
                generating: Recipe.self
            )
            print("Recipe Name: \(recipe.content.name)")
            print("Prep Time: \(recipe.content.prepTime) minutes")
            print("Ingredients: \(recipe.content.ingredients.joined(separator: ", "))")
            print("Instructions:")
            for (i, instruction) in recipe.content.instructions.enumerated() {
                print("  \(i + 1). \(instruction)")
            }
        } catch {
            print("Structured Generation Error: \(error)")
        }
        
        // Example 4: Streaming generation
        print("\n4. Streaming generation:")
        let streamSession = FoundryModelSession(model: .foundation)
        
        do {
            print("Streaming response for 'Tell me a story':")
            for try await partial in streamSession.streamResponse(
                to: "Tell me a very short story about a robot",
                generating: Recipe.self
            ) {
                // Show partial generation as it streams
                if let name = partial.name {
                    print("  Partial name: \(name)")
                }
            }
        } catch {
            print("Streaming Error: \(error)")
        }
        
        // Example 5: Using generation options
        print("\n5. Custom generation options:")
        let options = FoundryGenerationOptions(
            sampling: .random(top: 10, seed: 42),
            temperature: 0.7,
            maxTokens: 100
        )
        
        let customSession = FoundryModelSession(model: .mlx("microsoft/Phi-3.5-mini-instruct"))
        
        do {
            let response = try await customSession.respond(
                to: "Write a haiku about Swift programming",
                options: options
            )
            print("Haiku: \(response.content)")
        } catch {
            print("Custom Options Error: \(error)")
        }
        
        print("\n✅ FoundryKit examples completed!")
    }
}