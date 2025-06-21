import Foundation
import FoundryKit
import FoundationModels

@FoundryGenerable
struct Product {
    @FoundryGuide("Product name", .minLength(3), .maxLength(200))
    let name: String
    
    @FoundryGuide("Product description", .maxLength(1000))
    let description: String
    
    @FoundryGuide("Price in USD", .minimum(0), .maximum(999999))
    let price: Double
    
    @FoundryGuide("Product category", .anyOf(["electronics", "clothing", "food", "books", "home", "sports"]))
    let category: String
    
    @FoundryGuide("Available stock quantity", .range(0...10000))
    let stock: Int
    
    @FoundryGuide("Product tags for search", .minimumCount(1), .maximumCount(10))
    let tags: [String]
    
    @FoundryGuide("Product SKU code", .pattern("^[A-Z]{3}-\\d{4}-[A-Z]{2}$"))
    let sku: String
    
    @FoundryGuide("Is the product currently available")
    let isAvailable: Bool
    
    @FoundryGuide("Optional discount percentage", .range(0...100))
    let discountPercentage: Int?
    
    @FoundryGuide("Product images URLs", .minimumCount(1), .maximumCount(5))
    let imageUrls: [String]?
}

// MARK: - User Profile Model
@FoundryGenerable
struct UserProfile {
    @FoundryGuide("User's unique identifier")
    let userId: String
    
    @FoundryGuide("Username for login", .minLength(3), .maxLength(30), .pattern("^[a-zA-Z0-9_]+$"))
    let username: String
    
    @FoundryGuide("User's email address", .pattern("^[\\w\\.-]+@[\\w\\.-]+\\.\\w+$"))
    let email: String
    
    @FoundryGuide("User's full name", .minLength(2), .maxLength(100))
    let fullName: String
    
    @FoundryGuide("User's age", .range(13...120))
    let age: Int
    
    @FoundryGuide("Account type", .anyOf(["free", "premium", "enterprise"]))
    let accountType: String
    
    @FoundryGuide("Account creation date", .pattern("^\\d{4}-\\d{2}-\\d{2}$"))
    let createdDate: String
    
    @FoundryGuide("Is email verified")
    let isEmailVerified: Bool
    
    @FoundryGuide("User's bio", .maxLength(500))
    let bio: String?
    
    @FoundryGuide("Social media handles")
    let socialHandles: [String]?
}
