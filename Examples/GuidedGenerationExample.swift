import Foundation
import FoundryKit

// Example showcasing true token-level guided generation with MLX

@FoundryGenerable
struct GuidedRecipe {
    @FoundryGuide("Name of the dish")
    let name: String
    
    @FoundryGuide("List of ingredients with quantities")
    let ingredients: [String]
    
    @FoundryGuide("Cooking time in minutes")
    @FoundryValidation(min: 10, max: 180)
    let cookingTime: Int
    
    @FoundryGuide("Difficulty level")
    let difficulty: String // "easy", "medium", "hard"
}

// Example usage of guided generation
func demonstrateGuidedGeneration() async throws {
    print("=== Token-Level Guided Generation with MLX ===")
    
    // Initialize MLX backend directly
    let model = FoundryModel.mlx("mlx-community/Qwen2.5-1.5B-Instruct-4bit")
    let backend = MLXBackend(
        model: model,
        guardrails: Guardrails(),
        tools: [],
        instructions: nil
    )
    
    // Wait for model to load
    backend.prewarm()
    try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
    
    // Create a runtime schema for guided generation
    let schema = RuntimeGenerationSchema(
        root: SchemaNode(
            name: "GuidedRecipe",
            type: .object,
            properties: [
                SchemaNode.Property(name: "name", type: .string),
                SchemaNode.Property(name: "ingredients", type: .array(elementType: .string)),
                SchemaNode.Property(name: "cookingTime", type: .integer),
                SchemaNode.Property(name: "difficulty", type: .string)
            ]
        ),
        dependencies: []
    )
    
    // Create guided generation session
    if let guidedSession = backend.createGuidedSession(
        schema: schema,
        temperature: 0.7,
        topP: 0.9
    ) {
        print("Successfully created guided generation session!")
        
        // Generate with token-level constraints
        let prompt = "Create a recipe for a delicious pasta dish"
        print("\nPrompt: \(prompt)")
        print("\nGenerating with token-level constraints...")
        
        do {
            let result = try await guidedSession.generate(
                prompt: prompt,
                maxTokens: 256
            )
            
            print("\nGuided Generation Result:")
            print(result)
            
            // Try to parse the result
            if let data = result.data(using: .utf8) {
                let decoder = JSONDecoder()
                if let recipe = try? decoder.decode(GuidedRecipe.self, from: data) {
                    print("\nSuccessfully parsed recipe:")
                    print("- Name: \(recipe.name)")
                    print("- Ingredients: \(recipe.ingredients.joined(separator: ", "))")
                    print("- Cooking Time: \(recipe.cookingTime) minutes")
                    print("- Difficulty: \(recipe.difficulty)")
                } else {
                    print("\nNote: JSON parsing failed, but the structure should be constrained")
                }
            }
        } catch {
            print("Generation failed: \(error)")
        }
    } else {
        print("Failed to create guided session - model may not be loaded yet")
    }
}

// Example comparing guided vs unguided generation
func compareGuidedVsUnguided() async throws {
    print("\n=== Comparing Guided vs Unguided Generation ===")
    
    let session = FoundryModelSession(model: .mlx("mlx-community/Qwen2.5-1.5B-Instruct-4bit"))
    let prompt = "Create a recipe for chocolate cake with the following fields: name, ingredients (array), cookingTime (number), difficulty"
    
    // 1. Standard structured generation (prompt-based)
    print("\n1. Standard Structured Generation (Prompt-based):")
    do {
        let result = try await session.respond(
            to: prompt,
            generating: GuidedRecipe.self
        )
        print("Success: \(result.content)")
    } catch {
        print("Failed: \(error)")
    }
    
    // 2. True guided generation (token-level constraints)
    print("\n2. Token-Level Guided Generation:")
    print("This ensures EVERY token generated follows the JSON schema constraints")
    print("Invalid tokens are masked out at the logit level before sampling")
    
    // The guided generation would be used through the MLXBackend directly
    // as shown in the previous example
}

// Example showing custom constraints
func demonstrateCustomConstraints() async throws {
    print("\n=== Custom Constraints Example ===")
    
    // Create a schema with specific constraints
    let schema = RuntimeGenerationSchema(
        root: SchemaNode(
            name: "ConstrainedData",
            type: .object,
            properties: [
                SchemaNode.Property(
                    name: "status",
                    type: .string,
                    validation: SchemaNode.Validation(enum: ["active", "inactive", "pending"])
                ),
                SchemaNode.Property(
                    name: "count",
                    type: .integer,
                    validation: SchemaNode.Validation(minimum: 0, maximum: 100)
                ),
                SchemaNode.Property(
                    name: "tags",
                    type: .array(elementType: .string),
                    validation: SchemaNode.Validation(maxItems: 5)
                )
            ]
        ),
        dependencies: []
    )
    
    print("Schema enforces:")
    print("- status must be one of: active, inactive, pending")
    print("- count must be between 0 and 100")
    print("- tags array can have at most 5 items")
    print("\nWith token-level constraints, the model CANNOT generate invalid values!")
}

// Run all examples
@main
struct GuidedGenerationExamples {
    static func main() async {
        do {
            try await demonstrateGuidedGeneration()
            try await compareGuidedVsUnguided()
            try await demonstrateCustomConstraints()
        } catch {
            print("Error: \(error)")
        }
    }
}