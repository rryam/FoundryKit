import SwiftUI
import FoundryKit

struct GuidedGenerationView: View {
    @State private var generationType = GenerationType.staticSchema
    @State private var isGenerating = false
    @State private var generatedContent: String = ""
    @State private var errorMessage: String?
    @State private var selectedBackend = BackendType.foundation
    
    enum GenerationType: String, CaseIterable {
        case staticSchema = "Static Schema"
        case dynamicSchema = "Dynamic Schema"
        case constrainedGeneration = "Constrained Generation"
        
        var description: String {
            switch self {
            case .staticSchema:
                return "Generate structured data using compile-time types"
            case .dynamicSchema:
                return "Generate data with runtime-defined schemas"
            case .constrainedGeneration:
                return "Generate data with advanced constraints"
            }
        }
    }
    
    enum BackendType: String, CaseIterable {
        case foundation = "Foundation Models"
        case mlx = "MLX (Local)"
        
        var model: FoundryModel {
            switch self {
            case .foundation: return .foundation
            case .mlx: return .mlx("mlx-community/Qwen2.5-1.5B-Instruct-4bit")
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("Guided Generation Demo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Generate structured data with guaranteed schema compliance")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            
            // Backend Selection
            VStack(alignment: .leading, spacing: 12) {
                Text("Backend")
                    .font(.headline)
                Picker("Backend", selection: $selectedBackend) {
                    ForEach(BackendType.allCases, id: \.self) { backend in
                        Text(backend.rawValue).tag(backend)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            // Generation Type Selection
            VStack(alignment: .leading, spacing: 12) {
                Text("Generation Type")
                    .font(.headline)
                Picker("Generation Type", selection: $generationType) {
                    ForEach(GenerationType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Text(generationType.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Example Display
            GroupBox {
                switch generationType {
                case .staticSchema:
                    StaticSchemaExample()
                case .dynamicSchema:
                    DynamicSchemaExample()
                case .constrainedGeneration:
                    ConstrainedGenerationExample()
                }
            }
            
            // Generate Button
            HStack {
                Button(action: generateContent) {
                    Label(
                        isGenerating ? "Generating..." : "Generate",
                        systemImage: isGenerating ? "hourglass" : "sparkle"
                    )
                }
                .buttonStyle(.borderedProminent)
                .disabled(isGenerating)
                
                if selectedBackend == .mlx && generationType == .dynamicSchema {
                    Text("(Not yet supported for MLX)")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            
            // Results
            if !generatedContent.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Label("Generated Content", systemImage: "doc.text.fill")
                            .font(.headline)
                        Spacer()
                        Button("Copy") {
                            copyToClipboard(generatedContent)
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    CodeView(content: generatedContent)
                }
            }
            
            // Error Display
            if let errorMessage = errorMessage {
                Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding()
    }
    
    func generateContent() {
        isGenerating = true
        errorMessage = nil
        generatedContent = ""
        
        Task {
            do {
                let session = FoundryModelSession(model: selectedBackend.model)
                
                switch generationType {
                case .staticSchema:
                    let restaurant = try await session.respond(
                        to: "Create a fancy restaurant menu with appetizers, main courses, and desserts",
                        generating: Restaurant.self
                    )
                    generatedContent = formatJSON(restaurant.content)
                    
                case .dynamicSchema:
                    if selectedBackend == .mlx {
                        throw FoundryGenerationError.unsupportedFeature(
                            FoundryGenerationError.Context(
                                debugDescription: "Dynamic schemas not yet supported for MLX"
                            )
                        )
                    }
                    
                    // Create dynamic schema at runtime
                    let weatherSchema = DynamicGenerationSchema(name: "Weather")
                    weatherSchema.addProperty(
                        DynamicGenerationSchema.Property(
                            name: "location",
                            schema: DynamicGenerationSchema(name: "location", type: .string)
                        ),
                        required: true
                    )
                    weatherSchema.addProperty(
                        DynamicGenerationSchema.Property(
                            name: "temperature",
                            schema: DynamicGenerationSchema(name: "temperature", type: .number)
                        ),
                        required: true
                    )
                    weatherSchema.addProperty(
                        DynamicGenerationSchema.Property(
                            name: "conditions",
                            schema: DynamicGenerationSchema(
                                name: "conditions",
                                anyOf: ["Sunny", "Cloudy", "Rainy", "Snowy", "Stormy"]
                            )
                        ),
                        required: true
                    )
                    
                    let response = try await session.respond(
                        to: "Generate weather data for a major city",
                        schema: weatherSchema
                    )
                    generatedContent = formatGeneratedContent(response.content)
                    
                case .constrainedGeneration:
                    let profile = try await session.respond(
                        to: "Create a user profile for a software developer",
                        generating: ConstrainedProfile.self
                    )
                    generatedContent = formatJSON(profile.content)
                }
                
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isGenerating = false
        }
    }
    
    func formatJSON<T: Encodable>(_ object: T) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        if let data = try? encoder.encode(object),
           let string = String(data: data, encoding: .utf8) {
            return string
        }
        return "Failed to format JSON"
    }
    
    func formatGeneratedContent(_ content: GeneratedContent) -> String {
        // For now, return a simple string representation
        return String(describing: content)
    }
    
    func copyToClipboard(_ text: String) {
        #if os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
        #else
        UIPasteboard.general.string = text
        #endif
    }
}

// MARK: - Example Views

struct StaticSchemaExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Static Schema: Restaurant")
                .font(.headline)
            
            Text("""
            @FoundryGenerable
            struct Restaurant {
                @FoundryGuide("Restaurant name")
                let name: String
                
                @FoundryGuide("Type of cuisine")
                @FoundryValidation(enumValues: ["Italian", "French", "Japanese", "Mexican", "American"])
                let cuisine: String
                
                @FoundryGuide("Menu items")
                let menu: [MenuItem]
            }
            """)
            .font(.system(.caption, design: .monospaced))
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
    }
}

struct DynamicSchemaExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Dynamic Schema: Weather")
                .font(.headline)
            
            Text("""
            // Schema created at runtime
            var weatherSchema = DynamicGenerationSchema(name: "Weather")
            weatherSchema.addProperty(
                Property(name: "location", schema: .string),
                required: true
            )
            weatherSchema.addProperty(
                Property(name: "temperature", schema: .number),
                required: true
            )
            weatherSchema.addProperty(
                Property(name: "conditions", 
                        schema: .anyOf(["Sunny", "Cloudy", "Rainy"])),
                required: true
            )
            """)
            .font(.system(.caption, design: .monospaced))
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
    }
}

struct ConstrainedGenerationExample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Constrained Generation: Profile")
                .font(.headline)
            
            Text("""
            @FoundryGenerable
            struct ConstrainedProfile {
                @FoundryGuide("Username")
                @FoundryValidation(pattern: "^[a-zA-Z0-9_]{3,20}$")
                let username: String
                
                @FoundryGuide("Age")
                @FoundryValidation(min: 18, max: 120)
                let age: Int
                
                @FoundryGuide("Bio")
                @FoundryValidation(minLength: 10, maxLength: 200)
                let bio: String
                
                @FoundryGuide("Skills")
                @FoundryValidation(minItems: 1, maxItems: 5)
                let skills: [String]
            }
            """)
            .font(.system(.caption, design: .monospaced))
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
    }
}

// MARK: - Example Types

@FoundryGenerable
struct Restaurant {
    @FoundryGuide("Restaurant name")
    let name: String
    
    @FoundryGuide("Type of cuisine")
    @FoundryValidation(enumValues: ["Italian", "French", "Japanese", "Mexican", "American"])
    let cuisine: String
    
    @FoundryGuide("Price range")
    @FoundryValidation(enumValues: ["$", "$$", "$$$", "$$$$"])
    let priceRange: String
    
    @FoundryGuide("Menu items organized by category")
    let menu: [MenuItem]
    
    @FoundryGenerable
    struct MenuItem {
        @FoundryGuide("Item name")
        let name: String
        
        @FoundryGuide("Description of the dish")
        @FoundryValidation(minLength: 10, maxLength: 100)
        let description: String
        
        @FoundryGuide("Price in USD")
        @FoundryValidation(min: 1, max: 500)
        let price: Double
        
        @FoundryGuide("Category")
        @FoundryValidation(enumValues: ["Appetizer", "Main Course", "Dessert", "Beverage"])
        let category: String
    }
}

@FoundryGenerable
struct ConstrainedProfile {
    @FoundryGuide("Username (alphanumeric and underscore only)")
    @FoundryValidation(pattern: "^[a-zA-Z0-9_]{3,20}$")
    let username: String
    
    @FoundryGuide("User's age")
    @FoundryValidation(min: 18, max: 120)
    let age: Int
    
    @FoundryGuide("Short bio")
    @FoundryValidation(minLength: 10, maxLength: 200)
    let bio: String
    
    @FoundryGuide("List of skills")
    @FoundryValidation(minItems: 1, maxItems: 5)
    let skills: [String]
    
    @FoundryGuide("Years of experience")
    @FoundryValidation(min: 0, max: 50)
    let yearsOfExperience: Int
}

#Preview {
    GuidedGenerationView()
}