import Foundation
#if canImport(FoundationModels)
import FoundationModels
#endif

/// Represents different types of language models available in FoundryKit.
public enum FoundryModel: Sendable, Equatable {
    /// An MLX model identified by its Hugging Face model ID.
    /// 
    /// Examples:
    /// - `"mlx-community/Qwen3-4B-4bit"`
    /// - `"mistralai/Mistral-7B-v0.1"`
    /// - `"microsoft/Phi-3.5-mini-instruct"`
    case mlx(String)
    
    /// Apple's Foundation Models (Apple Intelligence).
    /// Uses the system's default on-device language model.
    case foundation
    
    /// A custom model with a specific identifier.
    /// Reserved for future use with custom model implementations.
    case custom(String)
    
    /// Returns a Boolean value indicating whether two values are equal.
    public static func == (lhs: FoundryModel, rhs: FoundryModel) -> Bool {
        switch (lhs, rhs) {
        case let (.mlx(lhsId), .mlx(rhsId)):
            return lhsId == rhsId
        case (.foundation, .foundation):
            return true
        case let (.custom(lhsId), .custom(rhsId)):
            return lhsId == rhsId
        default:
            return false
        }
    }
}

extension FoundryModel {
    /// Returns true if this model uses MLX backend.
    var isMLX: Bool {
        switch self {
        case .mlx, .custom:
            return true
        case .foundation:
            return false
        }
    }
    
    /// Returns true if this model uses Foundation Models backend.
    var isFoundation: Bool {
        switch self {
        case .foundation:
            return true
        case .mlx, .custom:
            return false
        }
    }
    
    /// Returns the model identifier string.
    var identifier: String {
        switch self {
        case .mlx(let id):
            return id
        case .foundation:
            return "foundation.default"
        case .custom(let id):
            return id
        }
    }
}