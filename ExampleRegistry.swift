import Foundation
import FoundryKit
import MLXLMCommon

// Example showing how to use MLX models from the registry

@main
struct FoundryKitRegistryExample {
    static func main() async throws {
        print("FoundryKit - Using MLX Registry Models\n")
        
        // Example 1: Using pre-configured models from MLXLMRegistry
        print("1. Using pre-configured Llama model from registry:")
        let llamaSession = FoundryModelSession(
            model: .mlxRegistry(.llama3_2_1B_4bit)
        )
        
        do {
            let response = try await llamaSession.respond(
                to: "What is machine learning in one sentence?"
            )
            print("Llama Response: \(response.content)\n")
        } catch {
            print("Error: \(error)\n")
        }
        
        // Example 2: Using Mistral from registry
        print("2. Using Mistral from registry:")
        let mistralSession = FoundryModelSession(
            model: .mlxRegistry(.mistral7B4bit)
        )
        
        do {
            let response = try await mistralSession.respond(
                to: "Write a haiku about Swift programming"
            )
            print("Mistral Response: \(response.content)\n")
        } catch {
            print("Error: \(error)\n")
        }
        
        // Example 3: Using Phi model for code generation
        print("3. Using Phi model for code generation:")
        let phiSession = FoundryModelSession(
            model: .mlxRegistry(.phi4bit)
        )
        
        do {
            let response = try await phiSession.respond(
                to: "Write a Swift function to calculate fibonacci numbers"
            )
            print("Phi Response: \(response.content)\n")
        } catch {
            print("Error: \(error)\n")
        }
        
        // Example 4: Using Qwen model with structured generation
        print("4. Using Qwen model with structured generation:")
        
        @Generable
        struct CodeExample: Sendable {
            @Guide(description: "The programming language")
            var language: String
            
            @Guide(description: "Brief description of what the code does")
            var description: String
            
            @Guide(description: "The actual code")
            var code: String
        }
        
        let qwenSession = FoundryModelSession(
            model: .mlxRegistry(.qwen2_0_5B_4bit)
        )
        
        do {
            let example = try await qwenSession.respond(
                to: "Create a simple hello world example",
                generating: CodeExample.self
            )
            print("Language: \(example.content.language)")
            print("Description: \(example.content.description)")
            print("Code:\n\(example.content.code)\n")
        } catch {
            print("Error: \(error)\n")
        }
        
        // Example 5: Comparing registry model vs direct ID
        print("5. Registry model vs direct ID (both work!):")
        
        // Using registry
        let registrySession = FoundryModelSession(
            model: .mlxRegistry(.gemma2_2B_4bit)
        )
        
        // Using direct ID
        let directSession = FoundryModelSession(
            model: .mlx("mlx-community/gemma-2-2b-it-4bit")
        )
        
        let prompt = "What is 2 + 2?"
        
        do {
            let registryResponse = try await registrySession.respond(to: prompt)
            let directResponse = try await directSession.respond(to: prompt)
            
            print("Registry model: \(registryResponse.content)")
            print("Direct ID model: \(directResponse.content)\n")
        } catch {
            print("Error: \(error)\n")
        }
        
        // Show available models in registry
        print("Available models in MLXLMRegistry:")
        print("- .llama3_2_1B_4bit")
        print("- .llama3_2_3B_4bit") 
        print("- .mistral7B4bit")
        print("- .mistralNeMo4bit")
        print("- .phi4bit")
        print("- .phi3_5_4bit")
        print("- .qwen2_0_5B_4bit")
        print("- .gemma2_2B_4bit")
        print("- .codeLlama13b4bit")
        print("- And many more...")
        
        print("\n✅ FoundryKit Registry examples completed!")
    }
}