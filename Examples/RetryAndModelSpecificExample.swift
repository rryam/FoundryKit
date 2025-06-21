import Foundation
import FoundryKit

// Example showing the enhanced structured generation features

@FoundryGenerable
struct Recipe {
    @FoundryGuide("Name of the dish")
    let name: String
    
    @FoundryGuide("List of ingredients with quantities")
    let ingredients: [String]
    
    @FoundryGuide("Step by step cooking instructions")
    let steps: [String]
    
    @FoundryGuide("Cooking time in minutes", .range(1...300))
    let cookingTime: Int
}

// Example usage
func demonstrateEnhancedGeneration() async throws {
    // Example 1: Model-specific prompting
    print("=== Model-Specific Prompting ===")
    
    // Llama model will get Llama-optimized prompts
    let llamaSession = FoundryModelSession(model: .mlx("meta-llama/Llama-3.2-1B-Instruct"))
    let llamaRecipe = try await llamaSession.respond(
        to: "Create a recipe for chocolate cake",
        generating: Recipe.self
    )
    print("Llama generated: \(llamaRecipe.content.name)")
    
    // Qwen model will get Qwen-optimized prompts (bilingual)
    let qwenSession = FoundryModelSession(model: .mlx("Qwen/Qwen2.5-1.5B-Instruct"))
    let qwenRecipe = try await qwenSession.respond(
        to: "Create a recipe for chocolate cake",
        generating: Recipe.self
    )
    print("Qwen generated: \(qwenRecipe.content.name)")
    
    // Example 2: Retry mechanism
    print("\n=== Retry Mechanism ===")
    
    // The MLXBackend now automatically retries up to 3 times if JSON parsing fails
    // This is especially useful for smaller models that might occasionally produce malformed JSON
    
    @FoundryGenerable
    struct ComplexData {
        let matrix: [[Double]]
        let metadata: [String: String]
        let flags: [Bool]
    }
    
    let session = FoundryModelSession(model: .mlx("some-small-model"))
    
    do {
        let result = try await session.respond(
            to: "Generate a 3x3 matrix with metadata",
            generating: ComplexData.self
        )
        print("Successfully generated after retries (if needed)")
        print("Matrix: \(result.content.matrix)")
    } catch {
        print("Failed even after retries: \(error)")
    }
}

// Example 3: Customizing retry behavior
func demonstrateCustomRetry() async throws {
    // You can also implement custom retry logic if needed
    let session = FoundryModelSession(model: .mlx("mlx-community/Qwen2.5-1.5B-Instruct-4bit"))
    
    var lastError: Error?
    for attempt in 1...5 {
        do {
            let response = try await session.respond(
                to: "Generate a list of 5 random numbers",
                generating: [Int].self
            )
            print("Success on attempt \(attempt): \(response.content)")
            break
        } catch {
            lastError = error
            print("Attempt \(attempt) failed, retrying...")
            
            // You could add exponential backoff here
            try await Task.sleep(nanoseconds: UInt64(attempt) * 1_000_000_000)
        }
    }
    
    if let error = lastError {
        print("All attempts failed: \(error)")
    }
}

// The system now provides:
// 1. Automatic model detection from the model ID
// 2. Model-specific prompt formatting for better results
// 3. Automatic retry with JSON repair for robustness
// 4. Support for Llama, Qwen, Mistral, Phi, and more models