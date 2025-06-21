import Foundation
import FoundryKit

// MARK: - Example: Weather Report with @FoundryGenerable

@FoundryGenerable
struct WeatherReport {
    @FoundryGuide("City or location name")
    let location: String
    
    @FoundryGuide("Current temperature value", .rangeDouble(-50...60))
    let temperature: Double
    
    @FoundryGuide("Temperature unit (celsius or fahrenheit)", .anyOf(["celsius", "fahrenheit"]))
    let unit: String
    
    @FoundryGuide("Weather conditions description", .pattern("^.{3,50}$"))
    let conditions: String
    
    @FoundryGuide("Humidity percentage", .range(0...100))
    let humidity: Int?
    
    @FoundryGuide("Wind speed in km/h", .rangeDouble(0...200))
    let windSpeed: Double?
}

// MARK: - Example: User Profile with Validation

@FoundryGenerable
struct UserProfile {
    @FoundryGuide("User's full name", .pattern("^.{2,100}$"))
    let name: String
    
    @FoundryGuide("User's email address", .pattern("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"))
    let email: String
    
    @FoundryGuide("User's age in years", .range(13...120))
    let age: Int
    
    @FoundryGuide("User's role in the system", .anyOf(["admin", "user", "guest", "moderator"]))
    let role: String
    
    @FoundryGuide("User's bio or description")
    @FoundryValidation(maxLength: 500)
    let bio: String?
    
    @FoundryGuide("Tags associated with the user")
    @FoundryValidation(minItems: 0, maxItems: 10)
    let tags: [String]
}

// MARK: - Example: Product Catalog

@FoundryGenerable
struct Product {
    @FoundryGuide("Unique product identifier")
    let id: String
    
    @FoundryGuide("Product name")
    @FoundryValidation(minLength: 1, maxLength: 200)
    let name: String
    
    @FoundryGuide("Product description")
    @FoundryValidation(minLength: 10, maxLength: 1000)
    let description: String
    
    @FoundryGuide("Product price in USD")
    @FoundryValidation(min: 0, max: 1000000)
    let price: Double
    
    @FoundryGuide("Product category")
    @FoundryValidation(enumValues: ["electronics", "clothing", "food", "books", "toys", "other"])
    let category: String
    
    @FoundryGuide("Whether the product is currently in stock")
    let inStock: Bool
    
    @FoundryGuide("Number of items in stock")
    @FoundryValidation(min: 0)
    let stockQuantity: Int?
    
    @FoundryGuide("Product tags for search")
    @FoundryValidation(minItems: 1, maxItems: 20)
    let tags: [String]
}

// MARK: - Example: Task Management

@FoundryGenerable
struct Task {
    @FoundryGuide("Task title")
    @FoundryValidation(minLength: 3, maxLength: 100)
    let title: String
    
    @FoundryGuide("Detailed task description")
    @FoundryValidation(maxLength: 500)
    let description: String?
    
    @FoundryGuide("Task priority level")
    @FoundryValidation(enumValues: ["low", "medium", "high", "critical"])
    let priority: String
    
    @FoundryGuide("Task status")
    @FoundryValidation(enumValues: ["todo", "in_progress", "review", "done", "cancelled"])
    let status: String
    
    @FoundryGuide("Assigned user email")
    @FoundryValidation(pattern: "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")
    let assignee: String?
    
    @FoundryGuide("Due date in ISO 8601 format")
    let dueDate: String?
    
    @FoundryGuide("Task labels")
    @FoundryValidation(maxItems: 5)
    let labels: [String]
}

// MARK: - Example: API Response

@FoundryGenerable
struct APIResponse {
    @FoundryGuide("HTTP status code")
    @FoundryValidation(min: 100, max: 599)
    let statusCode: Int
    
    @FoundryGuide("Response message")
    let message: String
    
    @FoundryGuide("Response data payload")
    let data: [String: String]?
    
    @FoundryGuide("Error details if any")
    let error: ErrorDetail?
    
    @FoundryGuide("Response timestamp in ISO 8601 format")
    let timestamp: String
}

@FoundryGenerable
struct ErrorDetail {
    @FoundryGuide("Error code")
    let code: String
    
    @FoundryGuide("Human-readable error message")
    @FoundryValidation(minLength: 10, maxLength: 200)
    let message: String
    
    @FoundryGuide("Additional error context")
    let context: [String: String]?
}

// MARK: - Usage Example

func demonstrateUsage() async throws {
    // Example 1: Generate weather report
    let session = FoundryModelSession(model: .mlx("mlx-community/Qwen2.5-3B-Instruct-4bit"))
    
    let weatherPrompt = "What's the weather like in San Francisco today?"
    let weather = try await session.generate(
        WeatherReport.self,
        prompt: weatherPrompt
    )
    
    print("Weather Report:")
    print("Location: \(weather.location)")
    print("Temperature: \(weather.temperature)°\(weather.unit)")
    print("Conditions: \(weather.conditions)")
    if let humidity = weather.humidity {
        print("Humidity: \(humidity)%")
    }
    
    // Example 2: Extract user profile from text
    let profileText = """
    John Doe is a 28-year-old software engineer who loves coding.
    You can reach him at john.doe@example.com. He's an admin on our platform
    and enjoys working on open source projects, machine learning, and web development.
    """
    
    let profile = try await session.generate(
        UserProfile.self,
        prompt: "Extract user profile information from: \(profileText)"
    )
    
    print("\nUser Profile:")
    print("Name: \(profile.name)")
    print("Email: \(profile.email)")
    print("Age: \(profile.age)")
    print("Role: \(profile.role)")
    print("Tags: \(profile.tags.joined(separator: ", "))")
    
    // Example 3: Generate product listing
    let productPrompt = "Create a product listing for a high-end gaming laptop"
    let product = try await session.generate(
        Product.self,
        prompt: productPrompt
    )
    
    print("\nProduct:")
    print("Name: \(product.name)")
    print("Price: $\(product.price)")
    print("Category: \(product.category)")
    print("In Stock: \(product.inStock)")
    
    // The macro automatically generates:
    // - generationSchema property
    // - generatedContent property  
    // - PartiallyGenerated nested type
    // - jsonSchema static property
    // - exampleJSON (when validation rules are present)
    // - Generable protocol conformance
}

// MARK: - Accessing Generated Properties

func showGeneratedProperties() {
    // Access the JSON schema
    let schema = WeatherReport.jsonSchema
    print("Weather Report Schema:")
    print(schema)
    
    // Access example JSON (generated because WeatherReport has validation rules)
    if let example = WeatherReport.exampleJSON {
        print("\nExample JSON:")
        print(example)
    }
    
    // The generation schema is also available
    let genSchema = WeatherReport.generationSchema
    print("\nGeneration Schema Type: \(genSchema.type)")
    print("Properties: \(genSchema.properties.map { $0.name })")
}