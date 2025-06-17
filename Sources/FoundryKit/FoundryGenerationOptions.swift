import Foundation
import FoundationModels

/// Options that control how the model generates its response to a prompt.
public struct FoundryGenerationOptions: Sendable, Equatable {
    
    /// A type that defines how values are sampled from a probability distribution.
    public struct SamplingMode: Sendable, Equatable {
        
        /// A sampling mode that always chooses the most likely token.
        public static var greedy: FoundryGenerationOptions.SamplingMode {
            FoundryGenerationOptions.SamplingMode(mode: .greedy)
        }
        
        /// A sampling mode that considers a fixed number of high-probability tokens.
        public static func random(top k: Int, seed: UInt64? = nil) -> FoundryGenerationOptions.SamplingMode {
            FoundryGenerationOptions.SamplingMode(mode: .randomTop(k, seed: seed))
        }
        
        /// A mode that considers a variable number of high-probability tokens
        /// based on the specified threshold.
        public static func random(probabilityThreshold: Double, seed: UInt64? = nil) -> FoundryGenerationOptions.SamplingMode {
            FoundryGenerationOptions.SamplingMode(mode: .randomThreshold(probabilityThreshold, seed: seed))
        }
        
        internal enum Mode: Sendable, Equatable {
            case greedy
            case randomTop(Int, seed: UInt64?)
            case randomThreshold(Double, seed: UInt64?)
        }
        
        internal let mode: Mode
        
        private init(mode: Mode) {
            self.mode = mode
        }
        
        public static func == (lhs: FoundryGenerationOptions.SamplingMode, rhs: FoundryGenerationOptions.SamplingMode) -> Bool {
            lhs.mode == rhs.mode
        }
    }
    
    /// A sampling strategy for how the model picks tokens when generating a response.
    public var sampling: FoundryGenerationOptions.SamplingMode?
    
    /// Temperature influences the confidence of the models response.
    /// The value must be between 0 and 2 inclusive.
    public var temperature: Double?
    
    /// Penalty applied to tokens based on their frequency in the text so far.
    public var frequencyPenalty: Double?
    
    /// Penalty applied to tokens based on whether they appear in the text so far.
    public var presencePenalty: Double?
    
    /// The maximum number of tokens to generate.
    public var maxTokens: Int?
    
    /// Creates generation options with default values.
    public init() {
        self.sampling = nil
        self.temperature = nil
        self.frequencyPenalty = nil
        self.presencePenalty = nil
        self.maxTokens = nil
    }
    
    /// Creates generation options with the specified parameters.
    public init(
        sampling: FoundryGenerationOptions.SamplingMode? = nil,
        temperature: Double? = nil,
        frequencyPenalty: Double? = nil,
        presencePenalty: Double? = nil,
        maxTokens: Int? = nil
    ) {
        self.sampling = sampling
        self.temperature = temperature
        self.frequencyPenalty = frequencyPenalty
        self.presencePenalty = presencePenalty
        self.maxTokens = maxTokens
    }
    
    public static func == (lhs: FoundryGenerationOptions, rhs: FoundryGenerationOptions) -> Bool {
        lhs.sampling == rhs.sampling &&
        lhs.temperature == rhs.temperature &&
        lhs.frequencyPenalty == rhs.frequencyPenalty &&
        lhs.presencePenalty == rhs.presencePenalty &&
        lhs.maxTokens == rhs.maxTokens
    }
}

extension FoundryGenerationOptions {
    /// Converts to Foundation Models GenerationOptions.
    internal func toFoundationModels() -> GenerationOptions {
        var options = GenerationOptions()
        
        if let sampling = self.sampling {
            switch sampling.mode {
            case .greedy:
                options.sampling = .greedy
            case .randomTop(let top, let seed):
                options.sampling = .random(top: top, seed: seed)
            case .randomThreshold(let probabilityThreshold, let seed):
                options.sampling = .random(probabilityThreshold: probabilityThreshold, seed: seed)
            }
        }
        
        if let temperature = self.temperature {
            options.temperature = temperature
        }
        
        // Note: Foundation Models doesn't support these options yet
        // They would be used for MLX backend instead
        // if let frequencyPenalty = self.frequencyPenalty { ... }
        // if let presencePenalty = self.presencePenalty { ... }
        // if let maxTokens = self.maxTokens { ... }
        
        return options
    }
}