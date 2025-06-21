import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Macro for adding descriptions and validation constraints to properties
/// Matches Foundation Models Framework's @Guide pattern
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
        
        // Validate that arguments are provided (description is optional)
        guard let arguments = node.arguments,
              let labeledExprList = arguments.as(LabeledExprListSyntax.self) else {
            // No arguments is valid - description is optional
            return []
        }
        
        // If arguments exist, check if first is a description string or a constraint
        var startIndex = 0
        if let firstArg = labeledExprList.first {
            // Check if it's a string literal (description) or a constraint
            if firstArg.expression.is(StringLiteralExprSyntax.self) {
                startIndex = 1  // Skip description when validating constraints
            }
        }
        
        // Validate constraint arguments (if any)
        for (index, arg) in labeledExprList.enumerated() {
            if index < startIndex { continue } // Skip description if present
                
                // Validate constraint syntax
                let constraintName: String
                
                // Handle function call expressions like .range(1...10)
                if let funcCall = arg.expression.as(FunctionCallExprSyntax.self),
                   let memberAccess = funcCall.calledExpression.as(MemberAccessExprSyntax.self) {
                    constraintName = memberAccess.declName.baseName.text
                } else if let memberAccess = arg.expression.as(MemberAccessExprSyntax.self) {
                    // Handle simple member access without function call
                    constraintName = memberAccess.declName.baseName.text
                } else {
                    throw MacroError.invalidArgument("Validation constraints must use dot syntax (e.g., .range(1...10))")
                }
                
                let validConstraints = [
                    "constant", "anyOf", "pattern",
                    "minimum", "maximum", "range",
                    "minimumFloat", "maximumFloat", "rangeFloat",
                    "minimumDouble", "maximumDouble", "rangeDouble",
                    "minimumCount", "maximumCount", "count"
                ]
                
                if !validConstraints.contains(constraintName) {
                    throw MacroError.invalidArgument("Unknown constraint: '.\(constraintName)'. Valid constraints are: \(validConstraints.joined(separator: ", "))")
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