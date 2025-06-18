import Foundation
@testable import FoundryKit

// MARK: - Test Data

struct TestData: Sendable {
    static let simplePrompt = "Hello, world!"
    static let complexPrompt = "Write a detailed explanation of quantum computing"
    
    static let defaultOptions = FoundryGenerationOptions(
        sampling: .random(top: 40, seed: 42),
        temperature: 0.7,
        frequencyPenalty: 0.2,
        presencePenalty: 0.1,
        maxTokens: 100,
        topP: 0.9,
        useGuidedGeneration: false
    )
    
    static let minimalOptions = FoundryGenerationOptions(
        temperature: 0.5
    )
    
    static let sampleJSONSchemaString = """
    {
        "type": "object",
        "properties": {
            "name": {"type": "string"},
            "age": {"type": "integer", "minimum": 0},
            "email": {"type": "string", "format": "email"}
        },
        "required": ["name", "age"]
    }
    """
    
    static let complexJSONSchemaString = """
    {
        "type": "object",
        "properties": {
            "users": {
                "type": "array",
                "items": {
                    "type": "object",
                    "properties": {
                        "id": {"type": "integer"},
                        "name": {"type": "string"},
                        "roles": {
                            "type": "array",
                            "items": {"type": "string"}
                        }
                    },
                    "required": ["id", "name"]
                }
            },
            "metadata": {
                "type": "object",
                "properties": {
                    "version": {"type": "string"},
                    "timestamp": {"type": "string", "format": "date-time"}
                }
            }
        },
        "required": ["users"]
    }
    """
    
    nonisolated(unsafe) static let complexJSONSchema: [String: Any] = [
        "type": "object",
        "properties": [
            "users": [
                "type": "array",
                "items": [
                    "type": "object",
                    "properties": [
                        "id": ["type": "integer"],
                        "name": ["type": "string"],
                        "roles": [
                            "type": "array",
                            "items": ["type": "string"]
                        ]
                    ],
                    "required": ["id", "name"]
                ]
            ],
            "metadata": [
                "type": "object",
                "properties": [
                    "version": ["type": "string"],
                    "timestamp": ["type": "string", "format": "date-time"]
                ]
            ]
        ],
        "required": ["users"]
    ]
}

// MARK: - Async Test Helpers

extension AsyncSequence where Element == String {
    func collectToString() async throws -> String {
        var result = ""
        for try await chunk in self {
            result += chunk
        }
        return result
    }
}

