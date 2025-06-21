import XCTest
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
@testable import FoundryGenerableMacros

final class FoundryGenerableMacroExpansionTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "FoundryGenerable": FoundryGenerableMacro.self,
        "FoundryGuide": FoundryGuideMacro.self
    ]
    
    func testBasicStructExpansion() throws {
        assertMacroExpansion(
            """
            @FoundryGenerable
            struct SimpleModel {
                let name: String
                let age: Int
            }
            """,
            expandedSource: """
            struct SimpleModel {
                let name: String
                let age: Int
            
                nonisolated static var generationSchema: FoundationModels.GenerationSchema {
                    FoundationModels.GenerationSchema(
                        type: Self.self,
                        properties: [
                            FoundationModels.GenerationSchema.Property(
                                name: "name",
                                description: "name",
                                type: String.self
                            ),
                            FoundationModels.GenerationSchema.Property(
                                name: "age",
                                description: "age",
                                type: Int.self
                            )
                        ]
                    )
                }
            
                nonisolated var generatedContent: GeneratedContent {
                    GeneratedContent(
                        properties: [
                            "name": name,
                            "age": age
                        ]
                    )
                }
            
                struct PartiallyGenerated: Identifiable, Equatable {
                    var id: GenerationID
                    var name: String.PartiallyGenerated?
                    var age: Int.PartiallyGenerated?
            
                    init(_ content: GeneratedContent) throws {
                        self.id = content.id ?? GenerationID()
                        self.name = try content.value(forProperty: "name")
                        self.age = try content.value(forProperty: "age")
                    }
                }
            
                static var jsonSchema: [String: Any] {
                    [
                        "type": "object",
                        "properties": [
                            "age": [
                                "type": "integer"
                            ],
                            "name": [
                                "type": "string"
                            ]
                        ],
                        "required": [
                            "name",
                            "age"
                        ]
                    ]
                }
            
                static var toolCallSchema: [String: Any] {
                    [
                        "type": "function",
                        "function": [
                            "description": "Generate a structured SimpleModel object",
                            "name": "generate_simple_model",
                            "parameters": [
                                "properties": [
                                    "age": [
                                        "type": "integer"
                                    ],
                                    "name": [
                                        "type": "string"
                                    ]
                                ],
                                "required": [
                                    "name",
                                    "age"
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
            
            extension SimpleModel: FoundationModels.Generable {
                nonisolated init(_ content: FoundationModels.GeneratedContent) throws {
                    self.name = try content.value(String.self, forProperty: "name")
                    self.age = try content.value(Int.self, forProperty: "age")
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testStructWithFoundryGuideExpansion() throws {
        assertMacroExpansion(
            """
            @FoundryGenerable
            struct UserModel {
                @FoundryGuide("User's full name", .pattern("^.{2,100}$"))
                let name: String
                
                @FoundryGuide("User's age", .range(18...120))
                let age: Int
                
                @FoundryGuide("Account status", .anyOf(["active", "inactive", "suspended"]))
                let status: String
            }
            """,
            expandedSource: """
            struct UserModel {
                @FoundryGuide("User's full name", .pattern("^.{2,100}$"))
                let name: String
                
                @FoundryGuide("User's age", .range(18...120))
                let age: Int
                
                @FoundryGuide("Account status", .anyOf(["active", "inactive", "suspended"]))
                let status: String
            
                nonisolated static var generationSchema: FoundationModels.GenerationSchema {
                    FoundationModels.GenerationSchema(
                        type: Self.self,
                        properties: [
                            FoundationModels.GenerationSchema.Property(
                                name: "name",
                                description: "User's full name",
                                type: String.self
                            ),
                            FoundationModels.GenerationSchema.Property(
                                name: "age",
                                description: "User's age",
                                type: Int.self
                            ),
                            FoundationModels.GenerationSchema.Property(
                                name: "status",
                                description: "Account status",
                                type: String.self
                            )
                        ]
                    )
                }
            
                nonisolated var generatedContent: GeneratedContent {
                    GeneratedContent(
                        properties: [
                            "name": name,
                            "age": age,
                            "status": status
                        ]
                    )
                }
            
                struct PartiallyGenerated: Identifiable, Equatable {
                    var id: GenerationID
                    var name: String.PartiallyGenerated?
                    var age: Int.PartiallyGenerated?
                    var status: String.PartiallyGenerated?
            
                    init(_ content: GeneratedContent) throws {
                        self.id = content.id ?? GenerationID()
                        self.name = try content.value(forProperty: "name")
                        self.age = try content.value(forProperty: "age")
                        self.status = try content.value(forProperty: "status")
                    }
                }
            
                static var jsonSchema: [String: Any] {
                    [
                        "type": "object",
                        "properties": [
                            "age": [
                                "description": "User's age",
                                "maximum": 120,
                                "minimum": 18,
                                "type": "integer"
                            ],
                            "name": [
                                "description": "User's full name",
                                "pattern": "^.{2,100}$",
                                "type": "string"
                            ],
                            "status": [
                                "description": "Account status",
                                "enum": [
                                    "active",
                                    "inactive",
                                    "suspended"
                                ],
                                "type": "string"
                            ]
                        ],
                        "required": [
                            "name",
                            "age",
                            "status"
                        ]
                    ]
                }
            
                static var toolCallSchema: [String: Any] {
                    [
                        "type": "function",
                        "function": [
                            "description": "Generate a structured UserModel object",
                            "name": "generate_user_model",
                            "parameters": [
                                "properties": [
                                    "age": [
                                        "description": "User's age",
                                        "maximum": 120,
                                        "minimum": 18,
                                        "type": "integer"
                                    ],
                                    "name": [
                                        "description": "User's full name",
                                        "pattern": "^.{2,100}$",
                                        "type": "string"
                                    ],
                                    "status": [
                                        "description": "Account status",
                                        "enum": [
                                            "active",
                                            "inactive",
                                            "suspended"
                                        ],
                                        "type": "string"
                                    ]
                                ],
                                "required": [
                                    "name",
                                    "age",
                                    "status"
                                ],
                                "type": "object"
                            ]
                        ]
                    ]
                }
            
                static var exampleJSON: String? {
                    let example: [String: Any] = [
                        "age": 53,
                        "name": "John Doe",
                        "status": "suspended"
                    ]
                    
                    guard let data = try? JSONSerialization.data(withJSONObject: example, options: [.prettyPrinted]),
                          let json = String(data: data, encoding: .utf8) else { return nil }
                    return json
                }
            }
            
            extension UserModel: FoundationModels.Generable {
                nonisolated init(_ content: FoundationModels.GeneratedContent) throws {
                    self.name = try content.value(String.self, forProperty: "name")
                    self.age = try content.value(Int.self, forProperty: "age")
                    self.status = try content.value(String.self, forProperty: "status")
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testOptionalPropertiesExpansion() throws {
        assertMacroExpansion(
            """
            @FoundryGenerable
            struct ModelWithOptionals {
                @FoundryGuide("Required name")
                let name: String
                
                @FoundryGuide("Optional bio")
                let bio: String?
                
                @FoundryGuide("Optional age", .range(0...150))
                let age: Int?
            }
            """,
            expandedSource: """
            struct ModelWithOptionals {
                @FoundryGuide("Required name")
                let name: String
                
                @FoundryGuide("Optional bio")
                let bio: String?
                
                @FoundryGuide("Optional age", .range(0...150))
                let age: Int?
            
                nonisolated static var generationSchema: FoundationModels.GenerationSchema {
                    FoundationModels.GenerationSchema(
                        type: Self.self,
                        properties: [
                            FoundationModels.GenerationSchema.Property(
                                name: "name",
                                description: "Required name",
                                type: String.self
                            ),
                            FoundationModels.GenerationSchema.Property(
                                name: "bio",
                                description: "Optional bio",
                                type: String?.self
                            ),
                            FoundationModels.GenerationSchema.Property(
                                name: "age",
                                description: "Optional age",
                                type: Int?.self
                            )
                        ]
                    )
                }
            
                nonisolated var generatedContent: GeneratedContent {
                    GeneratedContent(
                        properties: [
                            "name": name,
                            "bio": bio,
                            "age": age
                        ]
                    )
                }
            
                struct PartiallyGenerated: Identifiable, Equatable {
                    var id: GenerationID
                    var name: String.PartiallyGenerated?
                    var bio: String.PartiallyGenerated?
                    var age: Int.PartiallyGenerated?
            
                    init(_ content: GeneratedContent) throws {
                        self.id = content.id ?? GenerationID()
                        self.name = try content.value(forProperty: "name")
                        self.bio = try content.value(forProperty: "bio")
                        self.age = try content.value(forProperty: "age")
                    }
                }
            
                static var jsonSchema: [String: Any] {
                    [
                        "type": "object",
                        "properties": [
                            "age": [
                                "description": "Optional age",
                                "maximum": 150,
                                "minimum": 0,
                                "type": "integer"
                            ],
                            "bio": [
                                "description": "Optional bio",
                                "type": "string"
                            ],
                            "name": [
                                "description": "Required name",
                                "type": "string"
                            ]
                        ],
                        "required": [
                            "name"
                        ]
                    ]
                }
            
                static var toolCallSchema: [String: Any] {
                    [
                        "type": "function",
                        "function": [
                            "description": "Generate a structured ModelWithOptionals object",
                            "name": "generate_model_with_optionals",
                            "parameters": [
                                "properties": [
                                    "age": [
                                        "description": "Optional age",
                                        "maximum": 150,
                                        "minimum": 0,
                                        "type": "integer"
                                    ],
                                    "bio": [
                                        "description": "Optional bio",
                                        "type": "string"
                                    ],
                                    "name": [
                                        "description": "Required name",
                                        "type": "string"
                                    ]
                                ],
                                "required": [
                                    "name"
                                ],
                                "type": "object"
                            ]
                        ]
                    ]
                }
            
                static var exampleJSON: String? {
                    let example: [String: Any] = [
                        "age": 48,
                        "name": "John Doe"
                    ]
                    
                    guard let data = try? JSONSerialization.data(withJSONObject: example, options: [.prettyPrinted]),
                          let json = String(data: data, encoding: .utf8) else { return nil }
                    return json
                }
            }
            
            extension ModelWithOptionals: FoundationModels.Generable {
                nonisolated init(_ content: FoundationModels.GeneratedContent) throws {
                    self.name = try content.value(String.self, forProperty: "name")
                    self.bio = try content.value(String?.self, forProperty: "bio")
                    self.age = try content.value(Int?.self, forProperty: "age")
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testArrayPropertiesWithValidation() throws {
        assertMacroExpansion(
            """
            @FoundryGenerable
            struct ModelWithArrays {
                @FoundryGuide("List of tags", .count(3))
                let tags: [String]
                
                @FoundryGuide("Email addresses", .minimumCount(1), .maximumCount(5))
                let emails: [String]
                
                @FoundryGuide("Scores", .count(2...10))
                let scores: [Int]
            }
            """,
            expandedSource: """
            struct ModelWithArrays {
                @FoundryGuide("List of tags", .count(3))
                let tags: [String]
                
                @FoundryGuide("Email addresses", .minimumCount(1), .maximumCount(5))
                let emails: [String]
                
                @FoundryGuide("Scores", .count(2...10))
                let scores: [Int]
            
                nonisolated static var generationSchema: FoundationModels.GenerationSchema {
                    FoundationModels.GenerationSchema(
                        type: Self.self,
                        properties: [
                            FoundationModels.GenerationSchema.Property(
                                name: "tags",
                                description: "List of tags",
                                type: [String].self
                            ),
                            FoundationModels.GenerationSchema.Property(
                                name: "emails",
                                description: "Email addresses",
                                type: [String].self
                            ),
                            FoundationModels.GenerationSchema.Property(
                                name: "scores",
                                description: "Scores",
                                type: [Int].self
                            )
                        ]
                    )
                }
            
                nonisolated var generatedContent: GeneratedContent {
                    GeneratedContent(
                        properties: [
                            "tags": tags,
                            "emails": emails,
                            "scores": scores
                        ]
                    )
                }
            
                struct PartiallyGenerated: Identifiable, Equatable {
                    var id: GenerationID
                    var tags: [String].PartiallyGenerated?
                    var emails: [String].PartiallyGenerated?
                    var scores: [Int].PartiallyGenerated?
            
                    init(_ content: GeneratedContent) throws {
                        self.id = content.id ?? GenerationID()
                        self.tags = try content.value(forProperty: "tags")
                        self.emails = try content.value(forProperty: "emails")
                        self.scores = try content.value(forProperty: "scores")
                    }
                }
            
                static var jsonSchema: [String: Any] {
                    [
                        "type": "object",
                        "properties": [
                            "emails": [
                                "description": "Email addresses",
                                "items": [
                                    "type": "string"
                                ],
                                "maxItems": 5,
                                "minItems": 1,
                                "type": "array"
                            ],
                            "scores": [
                                "description": "Scores",
                                "items": [
                                    "type": "integer"
                                ],
                                "maxItems": 10,
                                "minItems": 2,
                                "type": "array"
                            ],
                            "tags": [
                                "description": "List of tags",
                                "items": [
                                    "type": "string"
                                ],
                                "maxItems": 3,
                                "minItems": 3,
                                "type": "array"
                            ]
                        ],
                        "required": [
                            "tags",
                            "emails",
                            "scores"
                        ]
                    ]
                }
            
                static var toolCallSchema: [String: Any] {
                    [
                        "type": "function",
                        "function": [
                            "description": "Generate a structured ModelWithArrays object",
                            "name": "generate_model_with_arrays",
                            "parameters": [
                                "properties": [
                                    "emails": [
                                        "description": "Email addresses",
                                        "items": [
                                            "type": "string"
                                        ],
                                        "maxItems": 5,
                                        "minItems": 1,
                                        "type": "array"
                                    ],
                                    "scores": [
                                        "description": "Scores",
                                        "items": [
                                            "type": "integer"
                                        ],
                                        "maxItems": 10,
                                        "minItems": 2,
                                        "type": "array"
                                    ],
                                    "tags": [
                                        "description": "List of tags",
                                        "items": [
                                            "type": "string"
                                        ],
                                        "maxItems": 3,
                                        "minItems": 3,
                                        "type": "array"
                                    ]
                                ],
                                "required": [
                                    "tags",
                                    "emails",
                                    "scores"
                                ],
                                "type": "object"
                            ]
                        ]
                    ]
                }
            
                static var exampleJSON: String? {
                    let example: [String: Any] = [
                        "emails": [
                            "user1@example.com"
                        ],
                        "scores": [
                            1,
                            2
                        ],
                        "tags": [
                            "item1",
                            "item2",
                            "item3"
                        ]
                    ]
                    
                    guard let data = try? JSONSerialization.data(withJSONObject: example, options: [.prettyPrinted]),
                          let json = String(data: data, encoding: .utf8) else { return nil }
                    return json
                }
            }
            
            extension ModelWithArrays: FoundationModels.Generable {
                nonisolated init(_ content: FoundationModels.GeneratedContent) throws {
                    self.tags = try content.value([String].self, forProperty: "tags")
                    self.emails = try content.value([String].self, forProperty: "emails")
                    self.scores = try content.value([Int].self, forProperty: "scores")
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testSnakeCaseConversion() throws {
        assertMacroExpansion(
            """
            @FoundryGenerable
            struct HTTPSConnectionManager {
                let connectionID: String
            }
            """,
            expandedSource: """
            struct HTTPSConnectionManager {
                let connectionID: String
            
                nonisolated static var generationSchema: FoundationModels.GenerationSchema {
                    FoundationModels.GenerationSchema(
                        type: Self.self,
                        properties: [
                            FoundationModels.GenerationSchema.Property(
                                name: "connectionID",
                                description: "connectionID",
                                type: String.self
                            )
                        ]
                    )
                }
            
                nonisolated var generatedContent: GeneratedContent {
                    GeneratedContent(
                        properties: [
                            "connectionID": connectionID
                        ]
                    )
                }
            
                struct PartiallyGenerated: Identifiable, Equatable {
                    var id: GenerationID
                    var connectionID: String.PartiallyGenerated?
            
                    init(_ content: GeneratedContent) throws {
                        self.id = content.id ?? GenerationID()
                        self.connectionID = try content.value(forProperty: "connectionID")
                    }
                }
            
                static var jsonSchema: [String: Any] {
                    [
                        "type": "object",
                        "properties": [
                            "connectionID": [
                                "type": "string"
                            ]
                        ],
                        "required": [
                            "connectionID"
                        ]
                    ]
                }
            
                static var toolCallSchema: [String: Any] {
                    [
                        "type": "function",
                        "function": [
                            "description": "Generate a structured HTTPSConnectionManager object",
                            "name": "generate_httpsconnection_manager",
                            "parameters": [
                                "properties": [
                                    "connectionID": [
                                        "type": "string"
                                    ]
                                ],
                                "required": [
                                    "connectionID"
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
            
            extension HTTPSConnectionManager: FoundationModels.Generable {
                nonisolated init(_ content: FoundationModels.GeneratedContent) throws {
                    self.connectionID = try content.value(String.self, forProperty: "connectionID")
                }
            }
            """,
            macros: testMacros
        )
    }
}