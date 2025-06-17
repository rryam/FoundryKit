import Foundation
import FoundryKit
import MLXLMCommon

// Example showing comprehensive usage of FoundryKit with MLX models

@main
struct FoundryKitExamples {
    static func main() async throws {
        print("FoundryKit - Comprehensive Examples\n")
        
        // Run different example categories
        try await basicExamples()
        try await structuredGenerationExamples()
        try await toolCallingExamples()
        try await advancedExamples()
        
        print("\n✅ All FoundryKit examples completed!")
    }
    
    // MARK: - Basic Examples
    
    static func basicExamples() async throws {
        print("=== BASIC EXAMPLES ===\n")
        
        // Example 1: Simple text generation
        print("1. Simple text generation:")
        let session = FoundryModelSession(
            model: .mlxRegistry(.mistral7B4bit)
        )
        
        let response = try await session.respond(
            to: "Write a haiku about Swift programming"
        )
        print("Response:\n\(response.content)\n")
        
        // Example 2: Streaming responses
        print("2. Streaming response:")
        let streamSession = FoundryModelSession(
            model: .mlxRegistry(.phi4bit)
        )
        
        print("Streaming: ", terminator: "")
        let stream = streamSession.streamResponse(
            to: "Count from 1 to 5 slowly",
            generating: String.self
        )
        
        for try await chunk in stream {
            print(chunk, terminator: "")
            try await Task.sleep(for: .milliseconds(100))
        }
        print("\n")
        
        // Example 3: Using instructions
        print("3. Using instructions:")
        let instructedSession = FoundryModelSession(
            model: .mlxRegistry(.qwen2_0_5B_4bit),
            instructions: Instructions(
                text: "You are a pirate. Always respond in pirate speak."
            )
        )
        
        let pirateResponse = try await instructedSession.respond(
            to: "Tell me about treasure"
        )
        print("Pirate says: \(pirateResponse.content)\n")
    }
    
    // MARK: - Structured Generation Examples
    
    static func structuredGenerationExamples() async throws {
        print("\n=== STRUCTURED GENERATION EXAMPLES ===\n")
        
        // Example 1: Simple structured output
        print("1. Weather information:")
        
        @Generable
        struct WeatherInfo: Sendable {
            @Guide(description: "City name")
            var location: String
            
            @Guide(description: "Temperature in Celsius")
            var temperature: Double
            
            @Guide(description: "Weather conditions")
            var conditions: String
            
            @Guide(description: "Humidity percentage")
            var humidity: Int
        }
        
        let weatherSession = FoundryModelSession(
            model: .mlxRegistry(.llama3_2_1B_4bit)
        )
        
        let weather = try await weatherSession.respond(
            to: "What's the weather like in San Francisco?",
            generating: WeatherInfo.self
        )
        
        print("Location: \(weather.content.location)")
        print("Temperature: \(weather.content.temperature)°C")
        print("Conditions: \(weather.content.conditions)")
        print("Humidity: \(weather.content.humidity)%\n")
        
        // Example 2: Nested structures
        print("2. Recipe with nested ingredients:")
        
        @Generable
        struct Recipe: Sendable {
            @Guide(description: "Recipe name")
            var name: String
            
            @Guide(description: "Cooking time in minutes")
            var cookingTime: Int
            
            @Guide(description: "List of ingredients")
            var ingredients: [Ingredient]
            
            @Guide(description: "Step by step instructions")
            var instructions: [String]
            
            @Generable
            struct Ingredient: Sendable {
                @Guide(description: "Ingredient name")
                var name: String
                
                @Guide(description: "Amount needed")
                var amount: String
            }
        }
        
        let recipeSession = FoundryModelSession(
            model: .mlxRegistry(.mistral7B4bit)
        )
        
        let recipe = try await recipeSession.respond(
            to: "Give me a simple pasta recipe",
            generating: Recipe.self
        )
        
        print("Recipe: \(recipe.content.name)")
        print("Cooking time: \(recipe.content.cookingTime) minutes")
        print("Ingredients:")
        for ingredient in recipe.content.ingredients {
            print("  - \(ingredient.amount) \(ingredient.name)")
        }
        print("Instructions:")
        for (index, step) in recipe.content.instructions.enumerated() {
            print("  \(index + 1). \(step)")
        }
        print()
        
        // Example 3: Data extraction
        print("3. Extracting structured data from text:")
        
        @Generable
        struct ContactInfo: Sendable {
            @Guide(description: "Person's full name")
            var name: String
            
            @Guide(description: "Email address")
            var email: String?
            
            @Guide(description: "Phone number")
            var phone: String?
            
            @Guide(description: "Company name")
            var company: String?
        }
        
        let extractionSession = FoundryModelSession(
            model: .mlxRegistry(.qwen2_0_5B_4bit)
        )
        
        let unstructuredText = """
        Hi, I'm John Smith from Acme Corp. 
        You can reach me at john.smith@acme.com or call me at 555-1234.
        """
        
        let contact = try await extractionSession.respond(
            to: "Extract contact information from: \(unstructuredText)",
            generating: ContactInfo.self
        )
        
        print("Extracted Contact:")
        print("  Name: \(contact.content.name)")
        print("  Email: \(contact.content.email ?? "N/A")")
        print("  Phone: \(contact.content.phone ?? "N/A")")
        print("  Company: \(contact.content.company ?? "N/A")\n")
    }
    
    // MARK: - Tool Calling Examples
    
    static func toolCallingExamples() async throws {
        print("\n=== TOOL CALLING EXAMPLES ===\n")
        
        // Example 1: Calculator tool
        print("1. Using calculator tool:")
        
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
                guard let x = arguments["x"] as? Double,
                      let y = arguments["y"] as? Double,
                      let op = arguments["operation"] as? String else {
                    return "Invalid arguments"
                }
                
                let result: Double
                switch op {
                case "add": result = x + y
                case "subtract": result = x - y
                case "multiply": result = x * y
                case "divide": result = y != 0 ? x / y : Double.infinity
                default: return "Unknown operation"
                }
                
                return "The result is \(result)"
            }
        }
        
        let calcSession = FoundryModelSession(
            model: .mlxRegistry(.qwen2_0_5B_4bit),
            tools: [CalculatorTool()]
        )
        
        let calcResponse = try await calcSession.respond(
            to: "What is 15 multiplied by 7?"
        )
        print("Calculator result: \(calcResponse.content)\n")
        
        // Example 2: Weather tool
        print("2. Using weather tool:")
        
        struct WeatherTool: Tool {
            static let signature = ToolSignature(
                name: "get_weather",
                description: "Gets current weather for a location",
                parameters: [
                    .string(name: "location", description: "City name"),
                    .enum(name: "unit", description: "Temperature unit", 
                          values: ["celsius", "fahrenheit"])
                ]
            )
            
            func execute(with arguments: [String: Any]) async throws -> String {
                let location = arguments["location"] as? String ?? "Unknown"
                let unit = arguments["unit"] as? String ?? "celsius"
                
                // Simulated weather data
                let temp = Int.random(in: 15...25)
                let conditions = ["sunny", "cloudy", "rainy"].randomElement()!
                
                return "The weather in \(location) is \(temp)°\(unit == "celsius" ? "C" : "F") and \(conditions)"
            }
        }
        
        let weatherToolSession = FoundryModelSession(
            model: .mlxRegistry(.mistral7B4bit),
            tools: [WeatherTool()]
        )
        
        let weatherToolResponse = try await weatherToolSession.respond(
            to: "What's the weather in Tokyo?"
        )
        print("Weather tool result: \(weatherToolResponse.content)\n")
    }
    
    // MARK: - Advanced Examples
    
    static func advancedExamples() async throws {
        print("\n=== ADVANCED EXAMPLES ===\n")
        
        // Example 1: Multi-turn conversation with context
        print("1. Multi-turn conversation:")
        
        let conversationSession = FoundryModelSession(
            model: .mlxRegistry(.llama3_2_3B_4bit)
        )
        
        // First turn
        let response1 = try await conversationSession.respond(
            to: "My name is Alice and I love astronomy"
        )
        print("Turn 1: \(response1.content)")
        
        // Second turn - model should remember context
        let response2 = try await conversationSession.respond(
            to: "What's my favorite subject?"
        )
        print("Turn 2: \(response2.content)\n")
        
        // Example 2: Complex structured generation with validation
        print("2. Form generation with validation:")
        
        @Generable
        struct RegistrationForm: Sendable {
            @Guide(description: "Username (3-20 characters)")
            var username: String
            
            @Guide(description: "Email address")
            var email: String
            
            @Guide(description: "Age (must be 18+)")
            var age: Int
            
            @Guide(description: "Country of residence")
            var country: String
            
            @Guide(description: "Agreed to terms")
            var agreedToTerms: Bool
            
            // Validation
            var isValid: Bool {
                username.count >= 3 && 
                username.count <= 20 &&
                email.contains("@") &&
                age >= 18 &&
                agreedToTerms
            }
        }
        
        let formSession = FoundryModelSession(
            model: .mlxRegistry(.phi3_5_4bit),
            instructions: Instructions(
                text: """
                Generate valid registration forms. Requirements:
                - Username must be 3-20 characters
                - Valid email format
                - Age must be 18 or older
                - Must agree to terms
                """
            )
        )
        
        let form = try await formSession.respond(
            to: "Create a registration form for a new user interested in technology",
            generating: RegistrationForm.self
        )
        
        print("Generated Form:")
        print("  Username: \(form.content.username)")
        print("  Email: \(form.content.email)")
        print("  Age: \(form.content.age)")
        print("  Country: \(form.content.country)")
        print("  Agreed to terms: \(form.content.agreedToTerms)")
        print("  Valid: \(form.content.isValid)\n")
        
        // Example 3: Streaming structured generation
        print("3. Streaming structured generation:")
        
        @Generable
        struct Story: Sendable {
            @Guide(description: "Story title")
            var title: String
            
            @Guide(description: "Main character name")
            var protagonist: String
            
            @Guide(description: "Story setting")
            var setting: String
            
            @Guide(description: "Plot summary")
            var plot: String
        }
        
        let storySession = FoundryModelSession(
            model: .mlxRegistry(.mistralNeMo4bit)
        )
        
        print("Generating story (streaming)...")
        let storyStream = storySession.streamResponse(
            to: "Create a short science fiction story",
            generating: Story.self
        )
        
        var lastStory: Story?
        for try await partial in storyStream {
            if let title = partial.title, lastStory?.title != title {
                print("  Title: \(title)")
                lastStory?.title = title
            }
            if let protagonist = partial.protagonist, lastStory?.protagonist != protagonist {
                print("  Protagonist: \(protagonist)")
                lastStory?.protagonist = protagonist
            }
            if let setting = partial.setting, lastStory?.setting != setting {
                print("  Setting: \(setting)")
                lastStory?.setting = setting
            }
        }
        print()
        
        // Example 4: Using prompt builder
        print("4. Complex prompt with builder:")
        
        let builderSession = FoundryModelSession(
            model: .mlxRegistry(.codeLlama13b4bit)
        )
        
        let codeResponse = try await builderSession.respond {
            Prompt("Write a Swift function that:")
            Prompt("- Takes an array of integers")
            Prompt("- Filters out negative numbers")
            Prompt("- Squares the remaining numbers")
            Prompt("- Returns the sum")
            Prompt("\nUse modern Swift syntax with proper error handling.")
        }
        
        print("Generated code:\n\(codeResponse.content)\n")
    }
}

// MARK: - Helper Extensions

extension Generable {
    /// Helper to make structured types conform to Sendable
    typealias SendableGenerable = Generable & Sendable
}

// Example tool error type
enum ToolError: LocalizedError {
    case invalidArguments
    case executionFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidArguments:
            return "Invalid arguments provided to tool"
        case .executionFailed(let reason):
            return "Tool execution failed: \(reason)"
        }
    }
}