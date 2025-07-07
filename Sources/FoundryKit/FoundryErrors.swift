import Foundation

/// An error that occurs while generating a response.
public enum FoundryGenerationError: Error, LocalizedError {
    
    /// The context in which the error occurred.
    public struct Context: Sendable {
        /// A debug description to help developers diagnose issues during development.
        public let debugDescription: String
        
        /// The underlying errors that caused this error.
        public let underlyingErrors: [any Error]
        
        /// Creates a context.
        public init(debugDescription: String, underlyingErrors: [any Error] = []) {
            self.debugDescription = debugDescription
            self.underlyingErrors = underlyingErrors
        }
    }
    
    /// The transcript or prompt exceeded the model's context window size.
    case exceededContextWindowSize(Context)
    
    /// The assets required for the session are unavailable.
    case assetsUnavailable(Context)
    
    /// The system's safety guardrails are triggered by content.
    case guardrailViolation(Context)
    
    /// A generation guide with an unsupported pattern was used.
    case unsupportedGuide(Context)
    
    /// The model is prompted to respond in an unsupported language.
    case unsupportedLanguageOrLocale(Context)
    
    /// Failed to deserialize a valid generable type from model output.
    case decodingFailure(Context)
    
    /// The specified model could not be loaded.
    case modelLoadingFailed(Context)
    
    /// The model backend is not available on this platform.
    case backendUnavailable(Context)
    
    /// A network error occurred while downloading or using a model.
    case networkError(Context)
    
    /// The requested feature is not supported.
    case unsupportedFeature(Context)
    
    /// The request was rate limited.
    case rateLimited(Context)
    
    /// An unknown error occurred during generation.
    case unknown(Context)
    
    public var errorDescription: String? {
        switch self {
        case .exceededContextWindowSize:
            return "The prompt or conversation exceeded the model's context window size."
        case .assetsUnavailable:
            return "The model assets are unavailable."
        case .guardrailViolation:
            return "Content violates safety guardrails."
        case .unsupportedGuide:
            return "An unsupported generation guide was used."
        case .unsupportedLanguageOrLocale:
            return "The requested language or locale is not supported."
        case .decodingFailure:
            return "Failed to decode the model's response into the requested type."
        case .modelLoadingFailed:
            return "Failed to load the specified model."
        case .backendUnavailable:
            return "The model backend is not available on this platform."
        case .networkError:
            return "A network error occurred."
        case .unsupportedFeature:
            return "The requested feature is not supported."
        case .rateLimited:
            return "The request was rate limited. Please try again later."
        case .unknown:
            return "An unknown error occurred."
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .exceededContextWindowSize:
            return "Try using a shorter prompt or start a new session."
        case .assetsUnavailable:
            return "Check your internet connection and try again later."
        case .guardrailViolation:
            return "Modify your prompt to avoid potentially harmful content."
        case .unsupportedGuide:
            return "Use a supported generation guide pattern."
        case .unsupportedLanguageOrLocale:
            return "Try using a supported language or locale."
        case .decodingFailure:
            return "Check your @Generable type definition and try again."
        case .modelLoadingFailed:
            return "Verify the model identifier and check your internet connection."
        case .backendUnavailable:
            return "Use a different model or upgrade to a supported platform."
        case .networkError:
            return "Check your internet connection and try again."
        case .unsupportedFeature:
            return "Use an alternative approach or check the documentation for supported features."
        case .rateLimited:
            return "Wait a moment before retrying or reduce the frequency of your requests."
        case .unknown:
            return "Try again or contact support if the problem persists."
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .exceededContextWindowSize(let context),
             .assetsUnavailable(let context),
             .guardrailViolation(let context),
             .unsupportedGuide(let context),
             .unsupportedLanguageOrLocale(let context),
             .decodingFailure(let context),
             .modelLoadingFailed(let context),
             .backendUnavailable(let context),
             .networkError(let context),
             .unsupportedFeature(let context),
             .rateLimited(let context),
             .unknown(let context):
            return context.debugDescription
        }
    }
}

/// An error that occurs while a model is calling a tool.
public struct FoundryToolCallError: Error, LocalizedError {
    
    /// The tool that produced the error.
    public var toolName: String
    
    /// The underlying error that was thrown during a tool call.
    public var underlyingError: any Error
    
    /// Creates a tool call error.
    public init(toolName: String, underlyingError: any Error) {
        self.toolName = toolName
        self.underlyingError = underlyingError
    }
    
    public var errorDescription: String? {
        return "Tool '\(toolName)' failed with error: \(underlyingError.localizedDescription)"
    }
}