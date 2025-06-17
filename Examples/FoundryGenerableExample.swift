import Foundation
import FoundryKit
import FoundationModels

// MARK: - Example 1: Product Review with Validation

@FoundryGenerable
struct ProductReview {
    @FoundryGuide("Product name")
    let productName: String
    
    @FoundryGuide("Rating from 1 to 5")
    @FoundryValidation(min: 1, max: 5)
    let rating: Int
    
    @FoundryGuide("Review text between 50-200 words")
    @FoundryValidation(minLength: 50, maxLength: 200)
    let reviewText: String
    
    @FoundryGuide("Would recommend this product")
    let recommendation: Bool
    
    @FoundryGuide("Key pros of the product")
    @FoundryValidation(minItems: 1, maxItems: 5)
    let pros: [String]
    
    @FoundryGuide("Key cons of the product")
    let cons: [String]
}

// MARK: - Example 2: User Registration with Complex Validation

@FoundryGenerable
struct UserRegistration {
    @FoundryGuide("Username (alphanumeric, 3-20 characters)")
    @FoundryValidation(pattern: "^[a-zA-Z0-9]{3,20}$")
    let username: String
    
    @FoundryGuide("Email address")
    @FoundryValidation(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$")
    let email: String
    
    @FoundryGuide("Age (must be 18 or older)")
    @FoundryValidation(min: 18, max: 120)
    let age: Int
    
    @FoundryGuide("Country code")
    @FoundryValidation(enumValues: ["US", "CA", "UK", "DE", "FR", "JP", "AU"])
    let country: String
    
    @FoundryGuide("Preferred language")
    @FoundryValidation(enumValues: ["en", "es", "fr", "de", "ja", "zh"])
    let language: String
    
    @FoundryGuide("Accept terms and conditions")
    let acceptedTerms: Bool
    
    @FoundryGuide("Optional referral code")
    let referralCode: String?
}

// MARK: - Example 3: API Configuration

@FoundryGenerable
struct APIConfiguration {
    @FoundryGuide("API endpoint URL")
    @FoundryValidation(pattern: "^https?://.*")
    let endpoint: String
    
    @FoundryGuide("API key")
    @FoundryValidation(minLength: 32, maxLength: 64)
    let apiKey: String
    
    @FoundryGuide("Request timeout in seconds")
    @FoundryValidation(min: 1, max: 300)
    let timeout: Int
    
    @FoundryGuide("Maximum retry attempts")
    @FoundryValidation(min: 0, max: 10)
    let maxRetries: Int
    
    @FoundryGuide("Enable debug logging")
    let debugMode: Bool
    
    @FoundryGuide("Custom headers")
    let headers: [String: String]?
}

// MARK: - Example 4: Nested Structures

@FoundryGenerable
struct Order {
    @FoundryGuide("Order ID")
    let orderId: String
    
    @FoundryGuide("Customer information")
    let customer: Customer
    
    @FoundryGuide("Order items")
    @FoundryValidation(minItems: 1)
    let items: [OrderItem]
    
    @FoundryGuide("Shipping address")
    let shippingAddress: Address
    
    @FoundryGuide("Order total in cents")
    @FoundryValidation(min: 0)
    let totalAmount: Int
    
    @FoundryGenerable
    struct Customer {
        @FoundryGuide("Customer name")
        let name: String
        
        @FoundryGuide("Customer email")
        let email: String
        
        @FoundryGuide("Customer phone")
        let phone: String?
    }
    
    @FoundryGenerable
    struct OrderItem {
        @FoundryGuide("Product SKU")
        let sku: String
        
        @FoundryGuide("Product name")
        let name: String
        
        @FoundryGuide("Quantity")
        @FoundryValidation(min: 1)
        let quantity: Int
        
        @FoundryGuide("Price per unit in cents")
        @FoundryValidation(min: 0)
        let unitPrice: Int
    }
    
    @FoundryGenerable
    struct Address {
        @FoundryGuide("Street address")
        let street: String
        
        @FoundryGuide("City")
        let city: String
        
        @FoundryGuide("State or province")
        let state: String
        
        @FoundryGuide("Postal code")
        let postalCode: String
        
        @FoundryGuide("Country code")
        @FoundryValidation(enumValues: ["US", "CA", "UK", "DE", "FR", "JP", "AU"])
        let country: String
    }
}

// MARK: - Usage Examples

@main
struct FoundryGenerableExamples {
    static func main() async throws {
        // Example 1: Generate a product review
        let session = FoundryModelSession(model: .mlx(.qwen2_5_3B_4bit))
        
        let review = try await session.respond(
            to: "Write a review for the new iPhone 15 Pro",
            generating: ProductReview.self
        )
        
        print("Generated Review:")
        print("Product: \(review.content.productName)")
        print("Rating: \(review.content.rating)/5")
        print("Review: \(review.content.reviewText)")
        print("Recommendation: \(review.content.recommendation)")
        print("Pros: \(review.content.pros.joined(separator: ", "))")
        print("Cons: \(review.content.cons.joined(separator: ", "))")
        
        // The generated content will automatically:
        // - Have a rating between 1-5
        // - Have review text between 50-200 characters
        // - Have 1-5 pros
        // - Follow the JSON schema generated by the macro
        
        // Example 2: User registration with validation
        let registrationSession = FoundryModelSession(
            model: .mlx(.mistral7B4bit),
            instructions: Instructions(
                text: "Generate valid user registration data for testing"
            )
        )
        
        let registration = try await registrationSession.respond(
            to: "Create a test user registration for a software developer from California",
            generating: UserRegistration.self
        )
        
        // The macro ensures:
        // - Username matches the regex pattern
        // - Email is valid
        // - Age is 18+
        // - Country is from the allowed list
        // - All validation rules are enforced
        
        // Example 3: Complex nested structure
        let orderSession = FoundryModelSession(model: .mlx(.llama3_2_3B_4bit))
        
        let order = try await orderSession.respond(
            to: "Generate an order for electronics items shipped to New York",
            generating: Order.self
        )
        
        // The nested structures are all properly generated with their own schemas
        print("\nGenerated Order:")
        print("Order ID: \(order.content.orderId)")
        print("Customer: \(order.content.customer.name)")
        print("Items: \(order.content.items.count)")
        print("Total: $\(Double(order.content.totalAmount) / 100)")
        
        // Example 4: Access generated JSON schema
        print("\nJSON Schema for ProductReview:")
        print(ProductReview.jsonSchema)
        
        // Example 5: Access example JSON
        if let exampleJSON = ProductReview.exampleJSON {
            print("\nExample JSON:")
            print(exampleJSON)
        }
        
        // Example 6: Streaming with structured generation
        let streamSession = FoundryModelSession(model: .mlx(.phi3_5_4bit))
        
        print("\nStreaming Order Generation:")
        let stream = streamSession.streamResponse(
            to: "Create an order for office supplies",
            generating: Order.self
        )
        
        for try await partial in stream {
            // Access fields as they're generated
            if let orderId = partial.orderId {
                print("Order ID: \(orderId)")
            }
            if let customer = partial.customer {
                print("Customer name: \(customer.name)")
            }
        }
    }
}

// MARK: - Benefits of @FoundryGenerable

/*
 The @FoundryGenerable macro provides:
 
 1. **Automatic Schema Generation**: No need to manually write JSON schemas
 2. **Type Safety**: Compile-time checking of structured outputs
 3. **Validation**: Built-in validation based on annotations
 4. **Documentation**: Self-documenting through @FoundryGuide
 5. **Example Generation**: Automatic example JSON based on validation rules
 6. **Partial Generation**: Support for streaming with PartiallyGenerated
 7. **Nested Support**: Works with nested structures
 8. **Compatibility**: Works with both MLX and Foundation Models
 
 This makes FoundryKit the most powerful framework for structured generation
 on Apple platforms!
 */