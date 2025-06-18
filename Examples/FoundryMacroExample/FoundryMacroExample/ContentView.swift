import SwiftUI
import FoundryKit

struct ContentView: View {
    @State private var selectedModel = ModelType.product
    @State private var showingMLXSchema = false
    
    enum ModelType: String, CaseIterable {
        case product = "Product"
        case userProfile = "User Profile"
        
        var systemImage: String {
            switch self {
            case .product: return "shippingbox"
            case .userProfile: return "person.circle"
            }
        }
    }
    
    var body: some View {
        NavigationSplitView {
            List(ModelType.allCases, id: \.self, selection: $selectedModel) { model in
                Label(model.rawValue, systemImage: model.systemImage)
            }
            .navigationTitle("FoundryKit Models")
            #if os(macOS)
            .navigationSplitViewColumnWidth(min: 200, ideal: 250)
            #endif
        } detail: {
            ModelDetailView(modelType: selectedModel, showingMLXSchema: $showingMLXSchema)
                .navigationTitle(selectedModel.rawValue)
                #if os(iOS)
                .navigationBarTitleDisplayMode(.large)
                #endif
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Toggle(isOn: $showingMLXSchema) {
                            Label("MLX Format", systemImage: showingMLXSchema ? "function" : "curlybraces")
                        }
                        .toggleStyle(.button)
                    }
                }
        }
    }
}

struct ModelDetailView: View {
    let modelType: ContentView.ModelType
    @Binding var showingMLXSchema: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                switch modelType {
                case .product:
                    ModelSchemaView(
                        title: "Product Model",
                        description: "E-commerce product with comprehensive validation",
                        jsonSchema: Product.jsonSchema,
                        toolCallSchema: Product.toolCallSchema,
                        exampleJSON: Product.exampleJSON,
                        showingMLXSchema: showingMLXSchema
                    )
                case .userProfile:
                    ModelSchemaView(
                        title: "User Profile Model",
                        description: "User account with validation patterns",
                        jsonSchema: UserProfile.jsonSchema,
                        toolCallSchema: UserProfile.toolCallSchema,
                        exampleJSON: UserProfile.exampleJSON,
                        showingMLXSchema: showingMLXSchema
                    )
                }
            }
            .padding()
        }
        .background(Color(white: 0.98))
    }
}

struct ModelSchemaView: View {
    let title: String
    let description: String
    let jsonSchema: [String: Any]
    let toolCallSchema: [String: Any]
    let exampleJSON: String?
    let showingMLXSchema: Bool
    
    @State private var copiedSection: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text(description)
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom)
            
            // Schema Display
            SchemaSection(
                title: showingMLXSchema ? "MLX Tool Call Schema" : "JSON Schema",
                icon: showingMLXSchema ? "function" : "curlybraces",
                schema: showingMLXSchema ? toolCallSchema : jsonSchema,
                copiedSection: $copiedSection,
                sectionId: "schema"
            )
            
            // Example JSON
            if let exampleJSON = exampleJSON {
                ExampleSection(
                    exampleJSON: exampleJSON,
                    copiedSection: $copiedSection
                )
            }
            
            // Properties Summary
            PropertiesSummary(schema: jsonSchema)
        }
    }
}

struct SchemaSection: View {
    let title: String
    let icon: String
    let schema: [String: Any]
    @Binding var copiedSection: String?
    let sectionId: String
    
    var formattedJSON: String {
        guard let data = try? JSONSerialization.data(withJSONObject: schema, options: [.prettyPrinted, .sortedKeys]),
              let string = String(data: data, encoding: .utf8) else {
            return "{}"
        }
        return string
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(title, systemImage: icon)
                    .font(.headline)
                Spacer()
                CopyButton(
                    text: formattedJSON,
                    copiedSection: $copiedSection,
                    sectionId: sectionId
                )
            }
            
            CodeView(content: formattedJSON)
        }
    }
}

struct ExampleSection: View {
    let exampleJSON: String
    @Binding var copiedSection: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Example JSON", systemImage: "doc.text")
                    .font(.headline)
                Spacer()
                CopyButton(
                    text: exampleJSON,
                    copiedSection: $copiedSection,
                    sectionId: "example"
                )
            }
            
            CodeView(content: exampleJSON)
        }
    }
}

struct PropertiesSummary: View {
    let schema: [String: Any]
    
    struct PropertyInfo: Identifiable {
        let id = UUID()
        let name: String
        let type: String
        let isRequired: Bool
        let constraints: [String]
    }
    
    var properties: [PropertyInfo] {
        guard let schemaProps = schema["properties"] as? [String: Any],
              let required = schema["required"] as? [String] else { return [] }
        
        return schemaProps.compactMap { key, value in
            guard let propSchema = value as? [String: Any],
                  let type = propSchema["type"] as? String else { return nil }
            
            var constraints: [String] = []
            
            // Collect constraints
            if let min = propSchema["minimum"] as? Int { constraints.append("min: \(min)") }
            if let max = propSchema["maximum"] as? Int { constraints.append("max: \(max)") }
            if let minLength = propSchema["minLength"] as? Int { constraints.append("minLength: \(minLength)") }
            if let maxLength = propSchema["maxLength"] as? Int { constraints.append("maxLength: \(maxLength)") }
            if let minItems = propSchema["minItems"] as? Int { constraints.append("minItems: \(minItems)") }
            if let maxItems = propSchema["maxItems"] as? Int { constraints.append("maxItems: \(maxItems)") }
            if let pattern = propSchema["pattern"] as? String { constraints.append("pattern") }
            if let enumValues = propSchema["enum"] as? [String] { 
                constraints.append("enum: [\(enumValues.joined(separator: ", "))]") 
            }
            
            return PropertyInfo(
                name: key,
                type: type,
                isRequired: required.contains(key),
                constraints: constraints
            )
        }.sorted { $0.name < $1.name }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Properties Summary", systemImage: "list.bullet")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(properties) { property in
                    HStack(alignment: .top) {
                        Text(property.name)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.primary)
                        
                        Text("(\(property.type))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if property.isRequired {
                            Text("Required")
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(4)
                        }
                        
                        Spacer()
                        
                        if !property.constraints.isEmpty {
                            Text(property.constraints.joined(separator: ", "))
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

struct CodeView: View {
    let content: String
    
    var body: some View {
        ScrollView(.horizontal) {
            Text(content)
                .font(.system(.body, design: .monospaced))
                .textSelection(.enabled)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

struct CopyButton: View {
    let text: String
    @Binding var copiedSection: String?
    let sectionId: String
    
    var body: some View {
        Button(action: {
            copyToClipboard(text)
            withAnimation {
                copiedSection = sectionId
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                copiedSection = nil
            }
        }) {
            Label(
                copiedSection == sectionId ? "Copied!" : "Copy",
                systemImage: copiedSection == sectionId ? "checkmark.circle.fill" : "doc.on.doc"
            )
            .foregroundColor(copiedSection == sectionId ? .green : .accentColor)
        }
        .buttonStyle(.bordered)
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

#Preview {
    ContentView()
}