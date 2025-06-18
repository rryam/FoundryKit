import Testing
import Foundation
@testable import FoundryKit

@Suite("FoundryGenerationError Tests")
struct FoundryGenerationErrorTests {
    
    @Test("Backend unavailable error")
    func testBackendUnavailable() {
        let context = FoundryGenerationError.Context(
            debugDescription: "Service is down",
            underlyingErrors: []
        )
        let error = FoundryGenerationError.backendUnavailable(context)
        
        #expect(error.errorDescription == "The model backend is not available on this platform.")
        #expect(error.failureReason == "Service is down")
        #expect(error.recoverySuggestion == "Use a different model or upgrade to a supported platform.")
    }
    
    @Test("Model loading failed error")
    func testModelLoadingFailed() {
        let context = FoundryGenerationError.Context(
            debugDescription: "Model 'gpt-99' not found",
            underlyingErrors: []
        )
        let error = FoundryGenerationError.modelLoadingFailed(context)
        
        #expect(error.errorDescription == "Failed to load the specified model.")
        #expect(error.failureReason == "Model 'gpt-99' not found")
        #expect(error.recoverySuggestion == "Verify the model identifier and check your internet connection.")
    }
    
    @Test("Exceeded context window size")
    func testExceededContextWindowSize() {
        let context = FoundryGenerationError.Context(
            debugDescription: "Prompt exceeds 4096 tokens",
            underlyingErrors: []
        )
        let error = FoundryGenerationError.exceededContextWindowSize(context)
        
        #expect(error.errorDescription == "The prompt or conversation exceeded the model's context window size.")
        #expect(error.failureReason == "Prompt exceeds 4096 tokens")
        #expect(error.recoverySuggestion == "Try using a shorter prompt or start a new session.")
    }
    
    @Test("Network error with underlying error")
    func testNetworkErrorWithUnderlying() {
        let nsError = NSError(domain: "NetworkDomain", code: -1001, userInfo: [NSLocalizedDescriptionKey: "Request timeout"])
        let context = FoundryGenerationError.Context(
            debugDescription: "Network request failed",
            underlyingErrors: [nsError]
        )
        let error = FoundryGenerationError.networkError(context)
        
        #expect(error.errorDescription == "A network error occurred.")
        #expect(error.failureReason == "Network request failed")
        #expect(error.recoverySuggestion == "Check your internet connection and try again.")
        #expect(context.underlyingErrors.count == 1)
    }
    
    @Test("Decoding failure error")
    func testDecodingFailure() {
        let context = FoundryGenerationError.Context(
            debugDescription: "Failed to parse JSON: missing required field 'name'",
            underlyingErrors: []
        )
        let error = FoundryGenerationError.decodingFailure(context)
        
        #expect(error.errorDescription == "Failed to decode the model's response into the requested type.")
        #expect(error.failureReason == "Failed to parse JSON: missing required field 'name'")
        #expect(error.recoverySuggestion == "Check your @Generable type definition and try again.")
    }
    
    @Test("Guardrail violation error")
    func testGuardrailViolation() {
        let context = FoundryGenerationError.Context(
            debugDescription: "Content flagged as inappropriate",
            underlyingErrors: []
        )
        let error = FoundryGenerationError.guardrailViolation(context)
        
        #expect(error.errorDescription == "Content violates safety guardrails.")
        #expect(error.failureReason == "Content flagged as inappropriate")
        #expect(error.recoverySuggestion == "Modify your prompt to avoid potentially harmful content.")
    }
    
    @Test("Unsupported feature error")
    func testUnsupportedFeature() {
        let context = FoundryGenerationError.Context(
            debugDescription: "Guided generation not supported on this backend",
            underlyingErrors: []
        )
        let error = FoundryGenerationError.unsupportedFeature(context)
        
        #expect(error.errorDescription == "The requested feature is not supported.")
        #expect(error.failureReason == "Guided generation not supported on this backend")
        #expect(error.recoverySuggestion == "Use an alternative approach or check the documentation for supported features.")
    }
    
    @Test("Assets unavailable error")
    func testAssetsUnavailable() {
        let context = FoundryGenerationError.Context(
            debugDescription: "Model weights not downloaded",
            underlyingErrors: []
        )
        let error = FoundryGenerationError.assetsUnavailable(context)
        
        #expect(error.errorDescription == "The model assets are unavailable.")
        #expect(error.failureReason == "Model weights not downloaded")
        #expect(error.recoverySuggestion == "Check your internet connection and try again later.")
    }
    
    @Test("Unknown error")
    func testUnknownError() {
        let context = FoundryGenerationError.Context(
            debugDescription: "An unexpected error occurred",
            underlyingErrors: []
        )
        let error = FoundryGenerationError.unknown(context)
        
        #expect(error.errorDescription == "An unknown error occurred.")
        #expect(error.failureReason == "An unexpected error occurred")
        #expect(error.recoverySuggestion == "Try again or contact support if the problem persists.")
    }
    
    @Test("Context with multiple underlying errors")
    func testContextWithMultipleErrors() {
        let error1 = NSError(domain: "Domain1", code: 1, userInfo: nil)
        let error2 = NSError(domain: "Domain2", code: 2, userInfo: nil)
        
        let context = FoundryGenerationError.Context(
            debugDescription: "Multiple failures occurred",
            underlyingErrors: [error1, error2]
        )
        
        #expect(context.debugDescription == "Multiple failures occurred")
        #expect(context.underlyingErrors.count == 2)
    }
    
    @Test("FoundryToolCallError")
    func testToolCallError() {
        let underlyingError = NSError(domain: "ToolDomain", code: 500, userInfo: [NSLocalizedDescriptionKey: "Tool execution failed"])
        let toolError = FoundryToolCallError(toolName: "Calculator", underlyingError: underlyingError)
        
        #expect(toolError.toolName == "Calculator")
        #expect(toolError.errorDescription == "Tool 'Calculator' failed with error: Tool execution failed")
    }
}