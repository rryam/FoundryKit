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
        
        // Generate MLX tool call schema
        let toolSchemaDecl = try generateToolCallSchema(for: structName, properties: properties)
        generatedMembers.append(DeclSyntax(toolSchemaDecl))
        
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
    var min: Int?
    var max: Int?
    var minLength: Int?
    var maxLength: Int?
    var minItems: Int?
    var maxItems: Int?
    var pattern: String?
    var enumValues: [String]?
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
        
        // Extract @FoundryGuide description and constraints
        let (description, validation) = extractGuideInfo(from: varDecl.attributes)
        
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

private func extractGuideInfo(from attributes: AttributeListSyntax) -> (description: String?, validation: ValidationInfo?) {
    for attribute in attributes {
        if let attr = attribute.as(AttributeSyntax.self),
           attr.attributeName.description.contains("FoundryGuide"),
           let args = attr.arguments?.as(LabeledExprListSyntax.self),
           !args.isEmpty {
            
            // Extract description from first argument
            var description: String? = nil
            if let firstArg = args.first,
               let stringLiteral = firstArg.expression.as(StringLiteralExprSyntax.self) {
                description = stringLiteral.segments.description.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
            }
            
            // Extract validation constraints from remaining arguments
            var validation: ValidationInfo? = nil
            if args.count > 1 {
                var min: Int? = nil
                var max: Int? = nil
                var minLength: Int? = nil
                var maxLength: Int? = nil
                var minItems: Int? = nil
                var maxItems: Int? = nil
                var pattern: String? = nil
                var enumValues: [String]? = nil
                
                for (index, arg) in args.enumerated() {
                    if index == 0 { continue } // Skip description
                    
                    // Handle function call expressions like .range(1...10)
                    if let funcCall = arg.expression.as(FunctionCallExprSyntax.self),
                       let memberAccess = funcCall.calledExpression.as(MemberAccessExprSyntax.self) {
                        let constraintName = memberAccess.declName.baseName.text
                        
                        switch constraintName {
                        case "minimum":
                            if let value = extractIntFromFunctionCall(funcCall) {
                                min = value
                            }
                        case "maximum":
                            if let value = extractIntFromFunctionCall(funcCall) {
                                max = value
                            }
                        case "range":
                            if let (lower, upper) = extractRangeFromFunctionCall(funcCall) {
                                min = lower
                                max = upper
                            }
                        case "minLength":
                            if let value = extractIntFromFunctionCall(funcCall) {
                                minLength = value
                            }
                        case "maxLength":
                            if let value = extractIntFromFunctionCall(funcCall) {
                                maxLength = value
                            }
                        case "minimumCount":
                            if let value = extractIntFromFunctionCall(funcCall) {
                                minItems = value
                            }
                        case "maximumCount":
                            if let value = extractIntFromFunctionCall(funcCall) {
                                maxItems = value
                            }
                        case "count":
                            if let value = extractIntFromFunctionCall(funcCall) {
                                minItems = value
                                maxItems = value
                            }
                        case "countRange":
                            if let (lower, upper) = extractRangeFromFunctionCall(funcCall) {
                                minItems = lower
                                maxItems = upper
                            }
                        case "pattern":
                            if let value = extractStringFromFunctionCall(funcCall) {
                                pattern = value
                            }
                        case "anyOf":
                            if let values = extractStringArrayFromFunctionCall(funcCall) {
                                enumValues = values
                            }
                        case "constant":
                            if let value = extractStringFromFunctionCall(funcCall) {
                                enumValues = [value]
                            }
                        default:
                            break
                        }
                    } else if arg.expression.is(MemberAccessExprSyntax.self) {
                        // Handle simple member access without function call (if needed in future)
                        // For now, this would be an error case handled by validation
                    }
                }
                
                validation = ValidationInfo(
                    min: min, max: max,
                    minLength: minLength, maxLength: maxLength,
                    minItems: minItems, maxItems: maxItems,
                    pattern: pattern, enumValues: enumValues
                )
            }
            
            return (description, validation)
        }
    }
    
    // Also check for legacy @FoundryValidation if no @FoundryGuide constraints found
    let validation = extractValidation(from: attributes)
    return (nil, validation)
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
            let elementType = extractArrayElementType(type)
            let itemType: String
            switch elementType {
            case "String": itemType = "string"
            case "Int", "Int32", "Int64": itemType = "integer"
            case "Double", "Float": itemType = "number"
            case "Bool": itemType = "boolean"
            default: itemType = "object"
            }
            propSchema["items"] = ["type": itemType]
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

private func generateToolCallSchema(for structName: String, properties: [PropertyInfo]) throws -> VariableDeclSyntax {
    // Build the parameters schema following MLX tool call format
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
            let elementType = extractArrayElementType(type)
            let itemType: String
            switch elementType {
            case "String": itemType = "string"
            case "Int", "Int32", "Int64": itemType = "integer"
            case "Double", "Float": itemType = "number"
            case "Bool": itemType = "boolean"
            default: itemType = "object"
            }
            propSchema["items"] = ["type": itemType]
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
    
    // Build the complete tool schema
    let toolSchema: [String: Any] = [
        "type": "function",
        "function": [
            "name": "generate_\(structName.camelCaseToSnakeCase())",
            "description": "Generate a structured \(structName) object",
            "parameters": [
                "type": "object",
                "properties": propertiesDict,
                "required": required
            ]
        ]
    ]
    
    let schemaJSON = try serializeJSON(toolSchema)
    
    return try VariableDeclSyntax(
        """
        static var toolCallSchema: [String: Any] {
            \(raw: schemaJSON)
        }
        """
    )
}

private func generateExampleJSON(properties: [PropertyInfo]) throws -> VariableDeclSyntax {
    // Build Swift code that generates the example dictionary
    var propertyAssignments: [String] = []
    
    for property in properties {
        if property.isOptional && Bool.random() {
            continue // Randomly skip optional properties
        }
        
        let exampleValue = generateExampleValue(
            for: property.type,
            validation: property.validation,
            description: property.description
        )
        
        let swiftValue = convertToSwiftLiteral(exampleValue)
        propertyAssignments.append("\"\(property.name)\": \(swiftValue)")
    }
    
    let dictionaryContent = propertyAssignments.joined(separator: ",\n                ")
    
    return try VariableDeclSyntax(
        """
        static var exampleJSON: String? {
            let example: [String: Any] = [
                \(raw: dictionaryContent)
            ]
            
            guard let data = try? JSONSerialization.data(withJSONObject: example, options: .prettyPrinted),
                  let json = String(data: data, encoding: .utf8) else {
                return nil
            }
            return json
        }
        """
    )
}

private func convertToSwiftLiteral(_ value: Any) -> String {
    switch value {
    case let str as String:
        return "\"\(str)\""
    case let num as Int:
        return String(num)
    case let num as Double:
        return String(num)
    case let bool as Bool:
        return String(bool)
    case let array as [Any]:
        let elements = array.map { convertToSwiftLiteral($0) }.joined(separator: ", ")
        return "[\(elements)]"
    case let dict as [String: Any]:
        let pairs = dict.map { key, value in
            "\"\(key)\": \(convertToSwiftLiteral(value))"
        }.joined(separator: ", ")
        return "[\(pairs)]"
    default:
        return "nil"
    }
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
    // Handle negative numbers wrapped in PrefixOperatorExprSyntax
    if let prefixOp = expr.as(PrefixOperatorExprSyntax.self),
       prefixOp.operator.text == "-",
       let intLiteral = prefixOp.expression.as(IntegerLiteralExprSyntax.self) {
        return -Int(intLiteral.literal.text)!
    }
    
    // Handle positive numbers
    if let intLiteral = expr.as(IntegerLiteralExprSyntax.self) {
        return Int(intLiteral.literal.text)
    }
    return nil
}

private func extractStringValue(from expr: ExprSyntax) -> String? {
    if let stringLiteral = expr.as(StringLiteralExprSyntax.self) {
        // Get the actual string content without quotes
        let segments = stringLiteral.segments
        if segments.count == 1,
           let segment = segments.first?.as(StringSegmentSyntax.self) {
            return segment.content.text
        }
        // Fallback for complex string literals
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

private func extractIntFromFunctionCall(_ funcCall: FunctionCallExprSyntax) -> Int? {
    guard let firstArg = funcCall.arguments.first else { return nil }
    return extractIntValue(from: firstArg.expression)
}

private func extractStringFromFunctionCall(_ funcCall: FunctionCallExprSyntax) -> String? {
    guard let firstArg = funcCall.arguments.first else { return nil }
    return extractStringValue(from: firstArg.expression)
}

private func extractStringArrayFromFunctionCall(_ funcCall: FunctionCallExprSyntax) -> [String]? {
    guard let firstArg = funcCall.arguments.first else { return nil }
    return extractEnumValues(from: firstArg.expression)
}

private func extractRangeFromFunctionCall(_ funcCall: FunctionCallExprSyntax) -> (Int, Int)? {
    guard let firstArg = funcCall.arguments.first else { return nil }
    
    // Handle range literal syntax like 1...10
    if let rangeExpr = firstArg.expression.as(SequenceExprSyntax.self),
       rangeExpr.elements.count == 3,
       let lowerBound = rangeExpr.elements.first?.as(IntegerLiteralExprSyntax.self),
       let upperBound = rangeExpr.elements.last?.as(IntegerLiteralExprSyntax.self),
       let lower = Int(lowerBound.literal.text),
       let upper = Int(upperBound.literal.text) {
        return (lower, upper)
    }
    
    return nil
}

private func extractArrayElementType(_ arrayType: String) -> String {
    // Extract element type from [Type] format
    let cleaned = arrayType.replacingOccurrences(of: "[", with: "")
        .replacingOccurrences(of: "]", with: "")
        .trimmingCharacters(in: .whitespaces)
    
    return cleaned
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
        return (0..<count).map { index in
            // Generate appropriate values for common array element types
            switch elementType {
            case "String":
                if let desc = description?.lowercased(), desc.contains("email") {
                    return "user\(index + 1)@example.com"
                }
                return "item\(index + 1)"
            case "Int", "Int32", "Int64":
                return index + 1
            case "Double", "Float":
                return Double(index + 1) * 1.5
            case "Bool":
                return index % 2 == 0
            default:
                return generateExampleValue(for: elementType, validation: nil, description: nil)
            }
        } as [Any]
        
    default:
        return ["nested": "object"]
    }
}

private func serializeJSON(_ object: Any) throws -> String {
    // Convert the object to a Swift dictionary literal recursively
    return convertToSwiftDictionaryLiteral(object, indent: "    ")
}

private func convertToSwiftDictionaryLiteral(_ value: Any, indent: String) -> String {
    if let dict = value as? [String: Any] {
        if dict.isEmpty {
            return "[:]"
        }
        let nextIndent = indent + "    "
        var result = "[\n"
        let sortedKeys = dict.keys.sorted()
        for (index, key) in sortedKeys.enumerated() {
            result += "\(nextIndent)\"\(key)\": \(convertToSwiftDictionaryLiteral(dict[key]!, indent: nextIndent))"
            if index < sortedKeys.count - 1 {
                result += ","
            }
            result += "\n"
        }
        result += "\(indent)]"
        return result
    } else if let array = value as? [Any] {
        if array.isEmpty {
            return "[]"
        }
        let nextIndent = indent + "    "
        var result = "[\n"
        for (index, item) in array.enumerated() {
            result += "\(nextIndent)\(convertToSwiftDictionaryLiteral(item, indent: nextIndent))"
            if index < array.count - 1 {
                result += ","
            }
            result += "\n"
        }
        result += "\(indent)]"
        return result
    } else if let string = value as? String {
        // Escape quotes and backslashes in strings
        let escaped = string
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
        return "\"\(escaped)\""
    } else if let number = value as? NSNumber {
        if CFBooleanGetTypeID() == CFGetTypeID(number) {
            return number.boolValue ? "true" : "false"
        } else {
            return "\(number)"
        }
    } else if value is NSNull {
        return "nil"
    } else {
        return "\"\(value)\""
    }
}

extension String {
    func camelCaseToSnakeCase() -> String {
        let pattern = "([a-z0-9])([A-Z])"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: self.utf16.count)
        return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2").lowercased()
    }
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