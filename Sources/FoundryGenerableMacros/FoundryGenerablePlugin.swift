import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct FoundryGenerablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        FoundryGenerableMacro.self,
        FoundryGuideMacro.self,
        FoundryValidationMacro.self
    ]
}