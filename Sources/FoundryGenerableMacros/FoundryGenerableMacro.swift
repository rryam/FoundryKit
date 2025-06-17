import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

/// The main macro that generates Generable conformance and JSON schema
public struct FoundryGenerableMacro: MemberMacro, ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // Extract the struct/class declaration
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw FoundryGenerableError.notAStruct
        }
        
        let structName = structDecl.name.text
        let members = structDecl.memberBlock.members
        
        // Extract properties and their metadata
        let properties = try extractProperties(from: members)
        
        // Generate the required members
        var generatedMembers: [DeclSyntax] = []
        
        // Generate generationSchema
        let schemaDecl = try generateGenerationSchema(for: structName, properties: properties)
        generatedMembers.append(DeclSyntax(schemaDecl))
        
        // Generate generatedContent property
        let contentDecl = try generateGeneratedContent(properties: properties)
        generatedMembers.append(DeclSyntax(contentDecl))
        
        // Generate PartiallyGenerated nested type
        let partialDecl = try generatePartiallyGenerated(for: structName, properties: properties)
        generatedMembers.append(DeclSyntax(partialDecl))
        
        // Generate JSON schema static property
        let jsonSchemaDecl = try generateJSONSchema(properties: properties)
        generatedMembers.append(DeclSyntax(jsonSchemaDecl))
        
        // Generate example JSON if validation rules are present
        if hasValidationRules(properties) {
            let exampleDecl = try generateExampleJSON(properties: properties)
            generatedMembers.append(DeclSyntax(exampleDecl))
        }
        
        return generatedMembers
    }
    
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        let structName = type.description.trimmingCharacters(in: .whitespacesAndNewlines)
        let members = (declaration as? StructDeclSyntax)?.memberBlock.members ?? []
        let properties = try extractProperties(from: members)
        
        // Generate extension with Generable conformance
        let extensionDecl = try ExtensionDeclSyntax(
            """
            extension \(raw: structName): FoundationModels.Generable {
                nonisolated init(_ content: FoundationModels.GeneratedContent) throws {
                    \(raw: generateInitializerBody(properties: properties))
                }
            }
            """
        )
        
        return [extensionDecl]
    }
}

// MARK: - Property Extraction

struct PropertyInfo {
    let name: String
    let type: String
    let isOptional: Bool
    let description: String?
    let validation: ValidationInfo?
}

struct ValidationInfo {
    let min: Int?
    let max: Int?
    let minLength: Int?
    let maxLength: Int?
    let minItems: Int?
    let maxItems: Int?
    let pattern: String?
    let enumValues: [String]?
}

private func extractProperties(from members: MemberBlockItemListSyntax) throws -> [PropertyInfo] {
    var properties: [PropertyInfo] = []
    
    for member in members {
        guard let varDecl = member.decl.as(VariableDeclSyntax.self),
              let binding = varDecl.bindings.first,
              let identifier = binding.pattern.as(IdentifierPatternSyntax.self),
              let typeAnnotation = binding.typeAnnotation else {
            continue
        }
        
        let propertyName = identifier.identifier.text
        let propertyType = typeAnnotation.type.description.trimmingCharacters(in: .whitespacesAndNewlines)
        let isOptional = propertyType.hasSuffix("?")
        
        // Extract @FoundryGuide description
        let description = extractGuideDescription(from: varDecl.attributes)
        
        // Extract @FoundryValidation rules
        let validation = extractValidation(from: varDecl.attributes)
        
        properties.append(PropertyInfo(
            name: propertyName,
            type: propertyType.replacingOccurrences(of: "?", with: ""),
            isOptional: isOptional,
            description: description,
            validation: validation
        ))
    }
    
    return properties
}

private func extractGuideDescription(from attributes: AttributeListSyntax) -> String? {
    for attribute in attributes {
        if let attr = attribute.as(AttributeSyntax.self),
           attr.attributeName.description.contains("FoundryGuide"),
           let args = attr.arguments?.as(LabeledExprListSyntax.self),
           let firstArg = args.first,
           let stringLiteral = firstArg.expression.as(StringLiteralExprSyntax.self) {
            return stringLiteral.segments.description.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
        }
    }
    return nil
}

private func extractValidation(from attributes: AttributeListSyntax) -> ValidationInfo? {
    for attribute in attributes {
        if let attr = attribute.as(AttributeSyntax.self),
           attr.attributeName.description.contains("FoundryValidation"),
           let args = attr.arguments?.as(LabeledExprListSyntax.self) {
            
            var validation = ValidationInfo(
                min: nil, max: nil,
                minLength: nil, maxLength: nil,
                minItems: nil, maxItems: nil,
                pattern: nil, enumValues: nil
            )
            
            for arg in args {
                let label = arg.label?.text ?? ""
                
                switch label {
                case "min":
                    validation.min = extractIntValue(from: arg.expression)
                case "max":
                    validation.max = extractIntValue(from: arg.expression)
                case "minLength":
                    validation.minLength = extractIntValue(from: arg.expression)
                case "maxLength":
                    validation.maxLength = extractIntValue(from: arg.expression)
                case "minItems":
                    validation.minItems = extractIntValue(from: arg.expression)
                case "maxItems":
                    validation.maxItems = extractIntValue(from: arg.expression)
                case "pattern":
                    validation.pattern = extractStringValue(from: arg.expression)
                case "enumValues":
                    validation.enumValues = extractEnumValues(from: arg.expression)
                default:
                    break
                }
            }
            
            return validation
        }
    }
    return nil
}

// MARK: - Schema Generation

private func generateGenerationSchema(for structName: String, properties: [PropertyInfo]) throws -> VariableDeclSyntax {
    let propertyDeclarations = properties.map { property in
        let description = property.description ?? property.name
        return """
            FoundationModels.GenerationSchema.Property(
                name: "\(property.name)",
                description: "\(description)",
                type: \(property.type).self
            )
            """
    }.joined(separator: ",\n            ")
    
    return try VariableDeclSyntax(
        """
        nonisolated static var generationSchema: FoundationModels.GenerationSchema {
            FoundationModels.GenerationSchema(
                type: Self.self,
                properties: [
                    \(raw: propertyDeclarations)
                ]
            )
        }
        """
    )
}

private func generateGeneratedContent(properties: [PropertyInfo]) throws -> VariableDeclSyntax {
    let propertyAssignments = properties.map { property in
        """
            "\(property.name)": \(property.name)
            """
    }.joined(separator: ",\n            ")
    
    return try VariableDeclSyntax(
        """
        nonisolated var generatedContent: GeneratedContent {
            GeneratedContent(
                properties: [
                    \(raw: propertyAssignments)
                ]
            )
        }
        """
    )
}

private func generatePartiallyGenerated(for structName: String, properties: [PropertyInfo]) throws -> StructDeclSyntax {
    let propertyDeclarations = properties.map { property in
        let typeStr = property.isOptional ? 
            "\(property.type).PartiallyGenerated?" : 
            "\(property.type).PartiallyGenerated?"
        return "var \(property.name): \(typeStr)"
    }.joined(separator: "\n        ")
    
    let propertyInitializations = properties.map { property in
        """
        self.\(property.name) = try content.value(forProperty: "\(property.name)")
        """
    }.joined(separator: "\n            ")
    
    return try StructDeclSyntax(
        """
        nonisolated struct PartiallyGenerated: Identifiable, ConvertibleFromGeneratedContent {
            var id: GenerationID
            \(raw: propertyDeclarations)
            
            nonisolated init(_ content: FoundationModels.GeneratedContent) throws {
                self.id = content.id ?? GenerationID()
                \(raw: propertyInitializations)
            }
        }
        """
    )
}

private func generateJSONSchema(properties: [PropertyInfo]) throws -> VariableDeclSyntax {
    var schemaDict: [String: Any] = ["type": "object"]
    var propertiesDict: [String: Any] = [:]
    var required: [String] = []
    
    for property in properties {
        var propSchema: [String: Any] = [:]
        
        // Determine JSON type
        switch property.type {
        case "String":
            propSchema["type"] = "string"
        case "Int", "Int32", "Int64":
            propSchema["type"] = "integer"
        case "Double", "Float":
            propSchema["type"] = "number"
        case "Bool":
            propSchema["type"] = "boolean"
        case let type where type.hasPrefix("["):
            propSchema["type"] = "array"
            propSchema["items"] = ["type": extractArrayElementType(type)]
        default:
            propSchema["type"] = "object"
        }
        
        // Add description
        if let desc = property.description {
            propSchema["description"] = desc
        }
        
        // Add validation rules
        if let validation = property.validation {
            if let min = validation.min { propSchema["minimum"] = min }
            if let max = validation.max { propSchema["maximum"] = max }
            if let minLength = validation.minLength { propSchema["minLength"] = minLength }
            if let maxLength = validation.maxLength { propSchema["maxLength"] = maxLength }
            if let minItems = validation.minItems { propSchema["minItems"] = minItems }
            if let maxItems = validation.maxItems { propSchema["maxItems"] = maxItems }
            if let pattern = validation.pattern { propSchema["pattern"] = pattern }
            if let enumValues = validation.enumValues { propSchema["enum"] = enumValues }
        }
        
        propertiesDict[property.name] = propSchema
        
        if !property.isOptional {
            required.append(property.name)
        }
    }
    
    schemaDict["properties"] = propertiesDict
    if !required.isEmpty {
        schemaDict["required"] = required
    }
    
    let schemaJSON = try serializeJSON(schemaDict)
    
    return try VariableDeclSyntax(
        """
        static var jsonSchema: [String: Any] {
            \(raw: schemaJSON)
        }
        """
    )
}

private func generateExampleJSON(properties: [PropertyInfo]) throws -> VariableDeclSyntax {
    var exampleDict: [String: Any] = [:]
    
    for property in properties {
        if property.isOptional && Bool.random() {
            continue // Randomly skip optional properties
        }
        
        exampleDict[property.name] = generateExampleValue(
            for: property.type,
            validation: property.validation,
            description: property.description
        )
    }
    
    let exampleJSON = try JSONSerialization.data(withJSONObject: exampleDict, options: .prettyPrinted)
    let exampleString = String(data: exampleJSON, encoding: .utf8) ?? "{}"
    
    return try VariableDeclSyntax(
        """
        static var exampleJSON: String? {
            \"\"\"
            \(raw: exampleString)
            \"\"\"
        }
        """
    )
}

// MARK: - Helper Functions

private func generateInitializerBody(properties: [PropertyInfo]) -> String {
    properties.map { property in
        """
        self.\(property.name) = try content.value(forProperty: "\(property.name)")
        """
    }.joined(separator: "\n        ")
}

private func hasValidationRules(_ properties: [PropertyInfo]) -> Bool {
    properties.contains { $0.validation != nil }
}

private func extractIntValue(from expr: ExprSyntax) -> Int? {
    if let intLiteral = expr.as(IntegerLiteralExprSyntax.self) {
        return Int(intLiteral.literal.text)
    }
    return nil
}

private func extractStringValue(from expr: ExprSyntax) -> String? {
    if let stringLiteral = expr.as(StringLiteralExprSyntax.self) {
        return stringLiteral.segments.description.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
    }
    return nil
}

private func extractEnumValues(from expr: ExprSyntax) -> [String]? {
    if let arrayExpr = expr.as(ArrayExprSyntax.self) {
        return arrayExpr.elements.compactMap { element in
            extractStringValue(from: element.expression)
        }
    }
    return nil
}

private func extractArrayElementType(_ arrayType: String) -> String {
    // Extract element type from [Type] format
    let cleaned = arrayType.replacingOccurrences(of: "[", with: "")
        .replacingOccurrences(of: "]", with: "")
    
    switch cleaned {
    case "String": return "string"
    case "Int", "Int32", "Int64": return "integer"
    case "Double", "Float": return "number"
    case "Bool": return "boolean"
    default: return "object"
    }
}

private func generateExampleValue(for type: String, validation: ValidationInfo?, description: String?) -> Any {
    switch type {
    case "String":
        if let enumValues = validation?.enumValues, !enumValues.isEmpty {
            return enumValues.randomElement()!
        }
        if let minLength = validation?.minLength {
            return String(repeating: "a", count: minLength + 5)
        }
        if let description = description?.lowercased() {
            if description.contains("email") { return "example@email.com" }
            if description.contains("name") { return "John Doe" }
            if description.contains("phone") { return "555-1234" }
            if description.contains("url") { return "https://example.com" }
        }
        return "example string"
        
    case "Int", "Int32", "Int64":
        if let min = validation?.min, let max = validation?.max {
            return Int.random(in: min...max)
        }
        if let min = validation?.min {
            return min + 10
        }
        if let max = validation?.max {
            return max - 10
        }
        return 42
        
    case "Double", "Float":
        if let min = validation?.min, let max = validation?.max {
            return Double.random(in: Double(min)...Double(max))
        }
        return 3.14
        
    case "Bool":
        return true
        
    case let arrayType where arrayType.hasPrefix("["):
        let elementType = extractArrayElementType(arrayType)
        let count = validation?.minItems ?? 2
        return (0..<count).map { _ in
            generateExampleValue(for: elementType, validation: nil, description: nil)
        }
        
    default:
        return ["nested": "object"]
    }
}

private func serializeJSON(_ object: Any) throws -> String {
    let data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
    var jsonString = String(data: data, encoding: .utf8) ?? "{}"
    
    // Convert to Swift dictionary literal format
    jsonString = jsonString
        .replacingOccurrences(of: "{\n", with: "[\n")
        .replacingOccurrences(of: "\n}", with: "\n]")
        .replacingOccurrences(of: "{", with: "[")
        .replacingOccurrences(of: "}", with: "]")
        .replacingOccurrences(of: " : ", with: ": ")
    
    return jsonString
}

// MARK: - Error Types

enum FoundryGenerableError: Error, CustomStringConvertible {
    case notAStruct
    case invalidProperty(String)
    case missingType(String)
    
    var description: String {
        switch self {
        case .notAStruct:
            return "@FoundryGenerable can only be applied to structs"
        case .invalidProperty(let name):
            return "Invalid property: \(name)"
        case .missingType(let name):
            return "Missing type annotation for property: \(name)"
        }
    }
}