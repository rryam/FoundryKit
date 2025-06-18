import Testing
@testable import FoundryKit

@Suite("FoundryKit Main Tests")
struct FoundryKitTests {
    
    @Test("FoundryKit module imports correctly")
    func testModuleImport() {
        // If this compiles, the module is imported correctly
        #expect(true)
    }
    
    @Test("Public types are accessible")
    func testPublicTypesAccessible() {
        // Test that we can reference public types
        _ = FoundryGenerationOptions()
        _ = FoundryGenerationError.Context(debugDescription: "test")
        #expect(true)
    }
    
    @Test("All error cases are defined")
    func testErrorCasesComplete() {
        let context = FoundryGenerationError.Context(debugDescription: "test")
        let errorCases: [FoundryGenerationError] = [
            .exceededContextWindowSize(context),
            .assetsUnavailable(context),
            .guardrailViolation(context),
            .unsupportedGuide(context),
            .unsupportedLanguageOrLocale(context),
            .decodingFailure(context),
            .modelLoadingFailed(context),
            .backendUnavailable(context),
            .networkError(context),
            .unsupportedFeature(context),
            .unknown(context)
        ]
        
        #expect(errorCases.count == 11)
    }
    
    @Test("Schema types are comprehensive")
    func testSchemaTypesComplete() {
        let schemaTypes: [SchemaType] = [
            .string,
            .number,
            .integer,
            .boolean,
            .array(elementType: .string),
            .object(properties: [:]),
            .null,
            .any
        ]
        
        #expect(schemaTypes.count == 8)
    }
}
