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
        // This is a marker macro - no code generation needed
        // The description is extracted by FoundryGenerableMacro
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
        // This is a marker macro - no code generation needed
        // The validation rules are extracted by FoundryGenerableMacro
        return []
    }
}