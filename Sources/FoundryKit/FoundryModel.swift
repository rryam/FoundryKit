import Foundation
import MLXLMCommon
import FoundationModels

/// Represents different types of language models available in FoundryKit.
public enum FoundryModel: Sendable, Equatable {
    /// Represents an MLX model source.
    public enum MLXSource: Sendable, Equatable {
        /// Model identified by its Hugging Face ID string.
        case id(String)
        /// Model from the MLXLMRegistry.
        case registry(ModelConfiguration)
        
        public static func == (lhs: MLXSource, rhs: MLXSource) -> Bool {
            switch (lhs, rhs) {
            case let (.id(lhsId), .id(rhsId)):
                return lhsId == rhsId
            case let (.registry(lhsConfig), .registry(rhsConfig)):
                return lhsConfig.id == rhsConfig.id
            default:
                return false
            }
        }
    }
    
    /// An MLX model that can be specified by ID or registry configuration.
    /// 
    /// Examples:
    /// - `.mlx("mlx-community/Qwen3-4B-4bit")`
    /// - `.mlx(.llama3_2_1B_4bit)`
    case mlx(MLXSource)
    
    /// Apple's Foundation Models (Apple Intelligence).
    /// Uses the system's default on-device language model.
    case foundation
    
    // MARK: - Convenience Initializers
    
    /// Creates an MLX model from a string ID.
    public static func mlx(_ id: String) -> FoundryModel {
        .mlx(.id(id))
    }
    
    /// Creates an MLX model from a registry configuration.
    public static func mlx(_ config: ModelConfiguration) -> FoundryModel {
        .mlx(.registry(config))
    }
    
    /// Returns a Boolean value indicating whether two values are equal.
    public static func == (lhs: FoundryModel, rhs: FoundryModel) -> Bool {
        switch (lhs, rhs) {
        case let (.mlx(lhsSource), .mlx(rhsSource)):
            return lhsSource == rhsSource
        case (.foundation, .foundation):
            return true
        default:
            return false
        }
    }
}

extension FoundryModel {
    /// Returns true if this model uses MLX backend.
    public var isMLX: Bool {
        switch self {
        case .mlx:
            return true
        case .foundation:
            return false
        }
    }
    
    /// Returns true if this model uses Foundation Models backend.
    public var isFoundation: Bool {
        switch self {
        case .foundation:
            return true
        case .mlx:
            return false
        }
    }
    
    /// Returns the model identifier string.
    public var identifier: String {
        switch self {
        case .mlx(let source):
            switch source {
            case .id(let id):
                return id
            case .registry(let config):
                return String(describing: config.id)
            }
        case .foundation:
            return "foundation.default"
        }
    }
}