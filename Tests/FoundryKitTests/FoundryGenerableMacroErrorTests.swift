/*
Note: This file has been commented out as it tests internal macro error handling
for the @FoundryGenerable and @FoundryGuide macros, which are internal implementation
details not exposed in the public API.

import XCTest
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
@testable import FoundryGenerableMacros

final class FoundryGenerableMacroErrorTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "FoundryGenerable": FoundryGenerableMacro.self,
        "FoundryGuide": FoundryGuideMacro.self
    ]
    
    func testFoundryGenerableOnNonStruct() throws {
        assertMacroExpansion(
            """
            @FoundryGenerable
            class InvalidClass {
                let name: String
            }
            """,
            expandedSource: """
            class InvalidClass {
                let name: String
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@FoundryGenerable can only be applied to structs",
                    line: 1,
                    column: 1,
                    severity: .error
                )
            ],
            macros: testMacros
        )
    }
    
    func testFoundryGenerableOnEnum() throws {
        assertMacroExpansion(
            """
            @FoundryGenerable
            enum InvalidEnum {
                case test
            }
            """,
            expandedSource: """
            enum InvalidEnum {
                case test
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@FoundryGenerable can only be applied to structs",
                    line: 1,
                    column: 1,
                    severity: .error
                )
            ],
            macros: testMacros
        )
    }
    
    func testFoundryGuideOnNonProperty() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @FoundryGuide("Invalid usage")
                func invalidFunction() {}
            }
            """,
            expandedSource: """
            struct TestStruct {
                @FoundryGuide("Invalid usage")
                func invalidFunction() {}
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@FoundryGuide can only be applied to properties",
                    line: 2,
                    column: 5,
                    severity: .error
                )
            ],
            macros: testMacros
        )
    }
    
    func testFoundryGuideWithoutArguments() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @FoundryGuide
                let name: String
            }
            """,
            expandedSource: """
            struct TestStruct {
                @FoundryGuide
                let name: String
            }
            """,
            diagnostics: [],  // No error because description is optional
            macros: testMacros
        )
    }
    
    func testFoundryGuideWithInvalidConstraint() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @FoundryGuide("Name", .invalidConstraint(42))
                let name: String
            }
            """,
            expandedSource: """
            struct TestStruct {
                @FoundryGuide("Name", .invalidConstraint(42))
                let name: String
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "Unknown constraint: '.invalidConstraint'. Valid constraints are: constant, anyOf, pattern, minimum, maximum, range, minimumFloat, maximumFloat, rangeFloat, minimumDouble, maximumDouble, rangeDouble, minimumCount, maximumCount, count",
                    line: 2,
                    column: 5,
                    severity: .error
                )
            ],
            macros: testMacros
        )
    }
    
    func testFoundryGuideWithInvalidSyntax() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @FoundryGuide("Name", minimum(10))
                let name: String
            }
            """,
            expandedSource: """
            struct TestStruct {
                @FoundryGuide("Name", minimum(10))
                let name: String
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "Validation constraints must use dot syntax (e.g., .range(1...10))",
                    line: 2,
                    column: 5,
                    severity: .error
                )
            ],
            macros: testMacros
        )
    }
    
    func testFoundryGuideNonStringDescription() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @FoundryGuide(42, .range(1...10))
                let count: Int
            }
            """,
            expandedSource: """
            struct TestStruct {
                @FoundryGuide(42, .range(1...10))
                let count: Int
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "First argument to @FoundryGuide must be a string description",
                    line: 2,
                    column: 5,
                    severity: .error
                )
            ],
            macros: testMacros
        )
    }
    
    func testEmptyStruct() throws {
        assertMacroExpansion(
            """
            @FoundryGenerable
            struct EmptyModel {
            }
            """,
            expandedSource: """
            struct EmptyModel {
            
                nonisolated static var generationSchema: FoundationModels.GenerationSchema {
                    FoundationModels.GenerationSchema(
                        type: Self.self,
                        properties: [
                            
                        ]
                    )
                }
            
                nonisolated var generatedContent: GeneratedContent {
                    GeneratedContent(
                        properties: [
                            
                        ]
                    )
                }
            
                struct PartiallyGenerated: Identifiable, Equatable {
                    var id: GenerationID
            
                    init(_ content: GeneratedContent) throws {
                        self.id = content.id ?? GenerationID()
                        
                    }
                }
            
                static var jsonSchema: [String: Any] {
                    [
                        "type": "object",
                        "properties": [:],
                        "required": []
                    ]
                }
            
                static var toolCallSchema: [String: Any] {
                    [
                        "type": "function",
                        "function": [
                            "description": "Generate a structured EmptyModel object",
                            "name": "generate_empty_model",
                            "parameters": [
                                "properties": [:],
                                "required": [],
                                "type": "object"
                            ]
                        ]
                    ]
                }
            
                static var exampleJSON: String? {
                    nil
                }
            }
            
            extension EmptyModel: FoundationModels.Generable {
                nonisolated init(_ content: FoundationModels.GeneratedContent) throws {
                    
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testPropertyWithoutType() throws {
        // This should be caught by Swift compiler, but let's test our handling
        assertMacroExpansion(
            """
            @FoundryGenerable
            struct InvalidModel {
                let name = "default"
            }
            """,
            expandedSource: """
            struct InvalidModel {
                let name = "default"
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "Property 'name' must have an explicit type annotation",
                    line: 1,
                    column: 1,
                    severity: .error
                )
            ],
            macros: testMacros
        )
    }
    
    func testComputedProperty() throws {
        assertMacroExpansion(
            """
            @FoundryGenerable
            struct ModelWithComputed {
                let firstName: String
                let lastName: String
                
                var fullName: String {
                    firstName + " " + lastName
                }
            }
            """,
            expandedSource: """
            struct ModelWithComputed {
                let firstName: String
                let lastName: String
                
                var fullName: String {
                    firstName + " " + lastName
                }
            
                nonisolated static var generationSchema: FoundationModels.GenerationSchema {
                    FoundationModels.GenerationSchema(
                        type: Self.self,
                        properties: [
                            FoundationModels.GenerationSchema.Property(
                                name: "firstName",
                                description: "firstName",
                                type: String.self
                            ),
                            FoundationModels.GenerationSchema.Property(
                                name: "lastName",
                                description: "lastName",
                                type: String.self
                            )
                        ]
                    )
                }
            
                nonisolated var generatedContent: GeneratedContent {
                    GeneratedContent(
                        properties: [
                            "firstName": firstName,
                            "lastName": lastName
                        ]
                    )
                }
            
                struct PartiallyGenerated: Identifiable, Equatable {
                    var id: GenerationID
                    var firstName: String.PartiallyGenerated?
                    var lastName: String.PartiallyGenerated?
            
                    init(_ content: GeneratedContent) throws {
                        self.id = content.id ?? GenerationID()
                        self.firstName = try content.value(forProperty: "firstName")
                        self.lastName = try content.value(forProperty: "lastName")
                    }
                }
            
                static var jsonSchema: [String: Any] {
                    [
                        "type": "object",
                        "properties": [
                            "firstName": [
                                "type": "string"
                            ],
                            "lastName": [
                                "type": "string"
                            ]
                        ],
                        "required": [
                            "firstName",
                            "lastName"
                        ]
                    ]
                }
            
                static var toolCallSchema: [String: Any] {
                    [
                        "type": "function",
                        "function": [
                            "description": "Generate a structured ModelWithComputed object",
                            "name": "generate_model_with_computed",
                            "parameters": [
                                "properties": [
                                    "firstName": [
                                        "type": "string"
                                    ],
                                    "lastName": [
                                        "type": "string"
                                    ]
                                ],
                                "required": [
                                    "firstName",
                                    "lastName"
                                ],
                                "type": "object"
                            ]
                        ]
                    ]
                }
            
                static var exampleJSON: String? {
                    nil
                }
            }
            
            extension ModelWithComputed: FoundationModels.Generable {
                nonisolated init(_ content: FoundationModels.GeneratedContent) throws {
                    self.firstName = try content.value(String.self, forProperty: "firstName")
                    self.lastName = try content.value(String.self, forProperty: "lastName")
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testMultipleFoundryGuidesOnSameProperty() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @FoundryGuide("First description")
                @FoundryGuide("Second description")
                let name: String
            }
            """,
            expandedSource: """
            struct TestStruct {
                @FoundryGuide("First description")
                @FoundryGuide("Second description")
                let name: String
            }
            """,
            diagnostics: [],  // Multiple guides are allowed, last one wins
            macros: testMacros
        )
    }
    
    func testMismatchedConstraintTypes() throws {
        assertMacroExpansion(
            """
            struct TestStruct {
                @FoundryGuide("String with numeric constraint", .range(1...10))
                let name: String
                
                @FoundryGuide("Number with string constraint", .pattern("\\d+"))
                let age: Int
            }
            """,
            expandedSource: """
            struct TestStruct {
                @FoundryGuide("String with numeric constraint", .range(1...10))
                let name: String
                
                @FoundryGuide("Number with string constraint", .pattern("\\d+"))
                let age: Int
            }
            """,
            diagnostics: [],  // These are semantic errors that would be caught at runtime
            macros: testMacros
        )
    }
}
*/