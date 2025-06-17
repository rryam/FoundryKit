import Foundation
import FoundryKit

/// Examples demonstrating structured generation with MLX models
/// These examples show how to use StructuredOutput protocol for custom types
/// when you can't use the @Generable macro

// MARK: - Weather Example

/// Weather information without using @Generable macro
struct WeatherInfo: StructuredOutput, Codable {
    let location: String
    let temperature: Double
    let unit: TemperatureUnit
    let conditions: String
    let humidity: Int?
    let windSpeed: Double?
    
    enum TemperatureUnit: String, Codable {
        case celsius = "celsius"
        case fahrenheit = "fahrenheit"
    }
    
    // StructuredOutput requirements
    static var jsonSchema: [String: Any] {
        [
            "type": "object",
            "properties": [
                "location": ["type": "string", "description": "City or location name"],
                "temperature": ["type": "number", "description": "Current temperature"],
                "unit": ["type": "string", "enum": ["celsius", "fahrenheit"], "description": "Temperature unit"],
                "conditions": ["type": "string", "description": "Weather conditions (e.g., sunny, cloudy, rainy)"],
                "humidity": ["type": "integer", "description": "Humidity percentage (0-100)"],
                "windSpeed": ["type": "number", "description": "Wind speed in km/h"]
            ],
            "required": ["location", "temperature", "unit", "conditions"]
        ]
    }
    
    static var exampleJSON: String? {
        """
        {
            "location": "San Francisco",
            "temperature": 18.5,
            "unit": "celsius",
            "conditions": "partly cloudy",
            "humidity": 65,
            "windSpeed": 12.0
        }
        """
    }
}

// MARK: - Contact Information Example

/// Contact extraction without @Generable
struct ContactInfo: StructuredOutput, Codable {
    let name: String
    let email: String?
    let phone: String?
    let company: String?
    let title: String?
    
    static var jsonSchema: [String: Any] {
        [
            "type": "object",
            "properties": [
                "name": ["type": "string", "description": "Full name of the person"],
                "email": ["type": "string", "format": "email", "description": "Email address"],
                "phone": ["type": "string", "description": "Phone number"],
                "company": ["type": "string", "description": "Company or organization name"],
                "title": ["type": "string", "description": "Job title or position"]
            ],
            "required": ["name"]
        ]
    }
    
    static var exampleJSON: String? {
        """
        {
            "name": "John Smith",
            "email": "john.smith@example.com",
            "phone": "555-1234",
            "company": "Acme Corp",
            "title": "Software Engineer"
        }
        """
    }
}

// MARK: - Recipe Example with Nested Types

/// Recipe with ingredients - demonstrates nested structures
struct Recipe: StructuredOutput, Codable {
    let name: String
    let servings: Int
    let prepTime: Int
    let cookTime: Int
    let ingredients: [Ingredient]
    let instructions: [String]
    let difficulty: Difficulty
    
    struct Ingredient: Codable {
        let item: String
        let quantity: String
        let unit: String?
    }
    
    enum Difficulty: String, Codable {
        case easy = "easy"
        case medium = "medium"
        case hard = "hard"
    }
    
    static var jsonSchema: [String: Any] {
        [
            "type": "object",
            "properties": [
                "name": ["type": "string", "description": "Recipe name"],
                "servings": ["type": "integer", "description": "Number of servings"],
                "prepTime": ["type": "integer", "description": "Preparation time in minutes"],
                "cookTime": ["type": "integer", "description": "Cooking time in minutes"],
                "ingredients": [
                    "type": "array",
                    "items": [
                        "type": "object",
                        "properties": [
                            "item": ["type": "string", "description": "Ingredient name"],
                            "quantity": ["type": "string", "description": "Amount needed"],
                            "unit": ["type": "string", "description": "Measurement unit"]
                        ],
                        "required": ["item", "quantity"]
                    ]
                ],
                "instructions": [
                    "type": "array",
                    "items": ["type": "string"],
                    "description": "Step-by-step cooking instructions"
                ],
                "difficulty": [
                    "type": "string",
                    "enum": ["easy", "medium", "hard"],
                    "description": "Recipe difficulty level"
                ]
            ],
            "required": ["name", "ingredients", "instructions", "difficulty"]
        ]
    }
    
    static var exampleJSON: String? {
        """
        {
            "name": "Simple Pasta Carbonara",
            "servings": 4,
            "prepTime": 10,
            "cookTime": 20,
            "ingredients": [
                {"item": "spaghetti", "quantity": "400", "unit": "grams"},
                {"item": "eggs", "quantity": "4", "unit": null},
                {"item": "parmesan cheese", "quantity": "100", "unit": "grams"},
                {"item": "pancetta", "quantity": "150", "unit": "grams"}
            ],
            "instructions": [
                "Bring water to boil and cook pasta",
                "Fry pancetta until crispy",
                "Mix eggs with grated parmesan",
                "Drain pasta and mix with egg mixture off heat",
                "Add pancetta and serve immediately"
            ],
            "difficulty": "easy"
        }
        """
    }
}

// MARK: - Job Application Form

/// Complex form with validation
struct JobApplication: StructuredOutput, Codable {
    let applicantInfo: ApplicantInfo
    let education: [Education]
    let experience: [Experience]
    let skills: [String]
    let references: [Reference]
    
    struct ApplicantInfo: Codable {
        let firstName: String
        let lastName: String
        let email: String
        let phone: String
        let linkedIn: String?
    }
    
    struct Education: Codable {
        let institution: String
        let degree: String
        let field: String
        let graduationYear: Int
    }
    
    struct Experience: Codable {
        let company: String
        let position: String
        let startDate: String
        let endDate: String?
        let description: String
    }
    
    struct Reference: Codable {
        let name: String
        let relationship: String
        let contact: String
    }
    
    static var jsonSchema: [String: Any] {
        [
            "type": "object",
            "properties": [
                "applicantInfo": [
                    "type": "object",
                    "properties": [
                        "firstName": ["type": "string"],
                        "lastName": ["type": "string"],
                        "email": ["type": "string", "format": "email"],
                        "phone": ["type": "string"],
                        "linkedIn": ["type": "string", "format": "uri"]
                    ],
                    "required": ["firstName", "lastName", "email", "phone"]
                ],
                "education": [
                    "type": "array",
                    "items": [
                        "type": "object",
                        "properties": [
                            "institution": ["type": "string"],
                            "degree": ["type": "string"],
                            "field": ["type": "string"],
                            "graduationYear": ["type": "integer"]
                        ]
                    ]
                ],
                "experience": [
                    "type": "array",
                    "items": [
                        "type": "object",
                        "properties": [
                            "company": ["type": "string"],
                            "position": ["type": "string"],
                            "startDate": ["type": "string", "format": "date"],
                            "endDate": ["type": "string", "format": "date"],
                            "description": ["type": "string"]
                        ]
                    ]
                ],
                "skills": [
                    "type": "array",
                    "items": ["type": "string"]
                ],
                "references": [
                    "type": "array",
                    "items": [
                        "type": "object",
                        "properties": [
                            "name": ["type": "string"],
                            "relationship": ["type": "string"],
                            "contact": ["type": "string"]
                        ]
                    ]
                ]
            ],
            "required": ["applicantInfo", "education", "experience", "skills"]
        ]
    }
}

// MARK: - Streaming Example

/// Article summary for streaming generation
struct ArticleSummary: StructuredOutput, Codable {
    let title: String
    let mainPoints: [String]
    let conclusion: String
    let tags: [String]
    
    static var jsonSchema: [String: Any] {
        [
            "type": "object",
            "properties": [
                "title": ["type": "string", "description": "Article title or headline"],
                "mainPoints": [
                    "type": "array",
                    "items": ["type": "string"],
                    "description": "Key points from the article"
                ],
                "conclusion": ["type": "string", "description": "Summary conclusion"],
                "tags": [
                    "type": "array",
                    "items": ["type": "string"],
                    "description": "Relevant tags or categories"
                ]
            ],
            "required": ["title", "mainPoints", "conclusion", "tags"]
        ]
    }
}

// MARK: - Tool/Function Calling Examples

/// Example function specs for tool calling
enum ToolExamples {
    static let calculatorFunction = FunctionSpec(
        name: "calculate",
        description: "Performs mathematical calculations",
        parameters: [
            "operation": SchemaExtractor.parameterSchema(
                type: "string",
                description: "The operation to perform",
                enum: ["add", "subtract", "multiply", "divide", "power", "sqrt"]
            ),
            "a": SchemaExtractor.parameterSchema(
                type: "number",
                description: "First operand"
            ),
            "b": SchemaExtractor.parameterSchema(
                type: "number",
                description: "Second operand (not needed for sqrt)"
            )
        ],
        required: ["operation", "a"]
    )
    
    static let weatherFunction = FunctionSpec(
        name: "get_weather",
        description: "Gets current weather for a location",
        parameters: [
            "location": SchemaExtractor.parameterSchema(
                type: "string",
                description: "City name or coordinates"
            ),
            "unit": SchemaExtractor.parameterSchema(
                type: "string",
                description: "Temperature unit",
                enum: ["celsius", "fahrenheit", "kelvin"]
            ),
            "include_forecast": SchemaExtractor.parameterSchema(
                type: "boolean",
                description: "Whether to include 5-day forecast"
            )
        ],
        required: ["location"]
    )
    
    static let searchFunction = FunctionSpec(
        name: "web_search",
        description: "Searches the web for information",
        parameters: [
            "query": SchemaExtractor.parameterSchema(
                type: "string",
                description: "Search query"
            ),
            "num_results": SchemaExtractor.parameterSchema(
                type: "integer",
                description: "Number of results to return (1-10)"
            ),
            "search_type": SchemaExtractor.parameterSchema(
                type: "string",
                description: "Type of search",
                enum: ["web", "images", "news", "videos"]
            )
        ],
        required: ["query"]
    )
}

// MARK: - Usage Examples

/// Example usage patterns for structured generation
enum StructuredGenerationUsageExamples {
    
    /// Basic weather query
    static func weatherExample() async throws {
        let session = FoundryModelSession(model: .mlx("mlx-community/Qwen2.5-3B-Instruct-4bit"))
        
        // Note: Since WeatherInfo conforms to StructuredOutput but not Generable,
        // this would need custom handling in MLXBackend
        // The actual implementation would use the jsonSchema and exampleJSON
        
        // This is how it would be called if WeatherInfo was @Generable:
        // let weather = try await session.respond(
        //     to: "What's the weather in Paris?",
        //     generating: WeatherInfo.self
        // )
    }
    
    /// Contact extraction from unstructured text
    static func contactExtractionExample() async throws {
        let text = """
        Hi there! I'm Sarah Johnson, the CTO at TechCorp. 
        You can reach me at sarah.j@techcorp.com or call my office at (555) 123-4567.
        Looking forward to our meeting!
        """
        
        let session = FoundryModelSession(
            model: .mlx("mlx-community/Mistral-7B-Instruct-v0.3-4bit"),
            instructions: Instructions(
                text: "You are an expert at extracting contact information from text."
            )
        )
        
        // Extract contact info using the schema
        // Implementation would use ContactInfo.jsonSchema
    }
    
    /// Recipe generation with nested structures
    static func recipeExample() async throws {
        let session = FoundryModelSession(model: .mlx(.llama3_2_3B_4bit))
        
        let prompt = "Create a healthy vegetarian pasta recipe for 4 people"
        
        // Generate recipe using Recipe.jsonSchema and exampleJSON
    }
    
    /// Tool calling example
    static func toolCallingExample() async throws {
        let session = FoundryModelSession(model: .mlx("mlx-community/Qwen2.5-7B-Instruct-4bit"))
        
        let functions = [
            ToolExamples.calculatorFunction,
            ToolExamples.weatherFunction
        ]
        
        let prompt = "What's 25 times 18, and what's the weather in London?"
        
        // Build tool calling prompt
        let toolPrompt = StructuredPromptBuilder.buildToolCallingPrompt(
            userPrompt: prompt,
            functions: functions
        )
        
        // The response would be parsed as FunctionCall
    }
    
    /// Streaming structured generation
    static func streamingExample() async throws {
        let session = FoundryModelSession(model: .mlx(.phi3_5_4bit))
        
        let articleText = """
        Apple announced its new M4 chip today, featuring breakthrough performance 
        and efficiency improvements. The chip includes a 10-core CPU and 10-core GPU,
        with support for hardware ray tracing. It will debut in the new MacBook Pro
        lineup starting at $1599.
        """
        
        // Stream the summary generation
        // Each partial result would contain progressively more fields
    }
}