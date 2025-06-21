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
        
        // Validate that arguments are provided
        guard let arguments = node.arguments,
              let labeledExprList = arguments.as(LabeledExprListSyntax.self),
              !labeledExprList.isEmpty else {
            throw MacroError.missingArgument("@FoundryGuide requires at least a description argument")
        }
        
        // First argument must be a description string
        guard let firstArg = labeledExprList.first,
              firstArg.expression.is(StringLiteralExprSyntax.self) else {
            throw MacroError.invalidArgument("First argument to @FoundryGuide must be a string description")
        }
        
        // Validate constraint arguments (if any)
        if labeledExprList.count > 1 {
            for (index, arg) in labeledExprList.enumerated() {
                if index == 0 { continue } // Skip description
                
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
                    "constant", "anyOf", "pattern", "minLength", "maxLength",
                    "minimum", "maximum", "range", 
                    "minimumCount", "maximumCount", "count", "countRange"
                ]
                
                if !validConstraints.contains(constraintName) {
                    throw MacroError.invalidArgument("Unknown constraint: '.\(constraintName)'. Valid constraints are: \(validConstraints.joined(separator: ", "))")
                }
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