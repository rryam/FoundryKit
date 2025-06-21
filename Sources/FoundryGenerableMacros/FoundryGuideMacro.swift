import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Macro for adding descriptions to properties
public struct FoundryGuideMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // Validate that this macro is applied to a property
        guard declaration.is(VariableDeclSyntax.self) else {
            throw MacroError.invalidApplication("@FoundryGuide can only be applied to properties")
        }
        
        // Validate that a description string is provided
        guard let arguments = node.arguments,
              let labeledExprList = arguments.as(LabeledExprListSyntax.self),
              let firstArg = labeledExprList.first,
              firstArg.expression.is(StringLiteralExprSyntax.self) else {
            throw MacroError.missingArgument("@FoundryGuide requires a string description argument")
        }
        
        // This is a marker macro - actual code generation happens in FoundryGenerableMacro
        // We've validated the usage, now return empty array as the expansion is handled elsewhere
        return []
    }
}

/// Macro for adding validation rules to properties
public struct FoundryValidationMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // Validate that this macro is applied to a property
        guard declaration.is(VariableDeclSyntax.self) else {
            throw MacroError.invalidApplication("@FoundryValidation can only be applied to properties")
        }
        
        // Validate that arguments are provided
        guard let arguments = node.arguments,
              let labeledExprList = arguments.as(LabeledExprListSyntax.self),
              !labeledExprList.isEmpty else {
            throw MacroError.missingArgument("@FoundryValidation requires at least one validation parameter")
        }
        
        // Validate known parameter names
        let validParameters = Set(["min", "max", "minLength", "maxLength", "minItems", "maxItems", "pattern", "enumValues"])
        for arg in labeledExprList {
            if let label = arg.label?.text, !validParameters.contains(label) {
                throw MacroError.invalidArgument("Unknown validation parameter: '\(label)'. Valid parameters are: \(validParameters.sorted().joined(separator: ", "))")
            }
        }
        
        // This is a marker macro - actual code generation happens in FoundryGenerableMacro
        // We've validated the usage, now return empty array as the expansion is handled elsewhere
        return []
    }
}

// MARK: - Macro Errors

enum MacroError: Error, CustomStringConvertible {
    case invalidApplication(String)
    case missingArgument(String)
    case invalidArgument(String)
    
    var description: String {
        switch self {
        case .invalidApplication(let message):
            return message
        case .missingArgument(let message):
            return message
        case .invalidArgument(let message):
            return message
        }
    }
}