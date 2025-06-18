import Foundation
import FoundryKit
import FoundationModels

@FoundryGenerable
struct Product {
    @FoundryGuide("Product name")
    @FoundryValidation(minLength: 3, maxLength: 200)
    let name: String
    
    @FoundryGuide("Product description")
    @FoundryValidation(maxLength: 1000)
    let description: String
    
    @FoundryGuide("Price in USD")
    @FoundryValidation(min: 0, max: 999999)
    let price: Double
    
    @FoundryGuide("Product category")
    @FoundryValidation(enumValues: ["electronics", "clothing", "food", "books", "home", "sports"])
    let category: String
    
    @FoundryGuide("Available stock quantity")
    @FoundryValidation(min: 0, max: 10000)
    let stock: Int
    
    @FoundryGuide("Product tags for search")
    @FoundryValidation(minItems: 1, maxItems: 10)
    let tags: [String]
    
    @FoundryGuide("Product SKU code")
    @FoundryValidation(pattern: "^[A-Z]{3}-\\d{4}-[A-Z]{2}$")
    let sku: String
    
    @FoundryGuide("Is the product currently available")
    let isAvailable: Bool
    
    @FoundryGuide("Optional discount percentage")
    @FoundryValidation(min: 0, max: 100)
    let discountPercentage: Int?
    
    @FoundryGuide("Product images URLs")
    @FoundryValidation(minItems: 1, maxItems: 5)
    let imageUrls: [String]?
}

// MARK: - User Profile Model
@FoundryGenerable
struct UserProfile {
    @FoundryGuide("User's unique identifier")
    let userId: String
    
    @FoundryGuide("Username for login")
    @FoundryValidation(minLength: 3, maxLength: 30, pattern: "^[a-zA-Z0-9_]+$")
    let username: String
    
    @FoundryGuide("User's email address")
    @FoundryValidation(pattern: "^[\\w\\.-]+@[\\w\\.-]+\\.\\w+$")
    let email: String
    
    @FoundryGuide("User's full name")
    @FoundryValidation(minLength: 2, maxLength: 100)
    let fullName: String
    
    @FoundryGuide("User's age")
    @FoundryValidation(min: 13, max: 120)
    let age: Int
    
    @FoundryGuide("Account type")
    @FoundryValidation(enumValues: ["free", "premium", "enterprise"])
    let accountType: String
    
    @FoundryGuide("Account creation date")
    @FoundryValidation(pattern: "^\\d{4}-\\d{2}-\\d{2}$")
    let createdDate: String
    
    @FoundryGuide("Is email verified")
    let isEmailVerified: Bool
    
    @FoundryGuide("User's bio")
    @FoundryValidation(maxLength: 500)
    let bio: String?
    
    @FoundryGuide("Social media handles")
    let socialHandles: [String]?
}
