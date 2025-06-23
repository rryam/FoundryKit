import Foundation
import MLX
import MLXLLM
import MLXLMCommon
@preconcurrency import Tokenizers

// MARK: - MLX LogitProcessor Integration

/// State container for thread-safe access
internal actor ProcessorState {
  var parseState: JSONParseState
  var validTokenCache: [String: Set<Int>] = [:]

  init(schema: RuntimeGenerationSchema) {
    self.parseState = JSONParseState(schema: schema)
  }

  func reset(schema: RuntimeGenerationSchema) {
    self.parseState = JSONParseState(schema: schema)
    self.validTokenCache.removeAll()
  }

  func updateWithToken(_ tokenId: Int, tokenizer: Tokenizer) {
    validTokenCache.removeAll()
    let text = tokenizer.decode(tokens: [tokenId])
    parseState.advance(with: text)
  }

  func getValidTokenIds(tokenizer: Tokenizer) -> Set<Int> {
    let stateKey = parseState.currentStateKey

    if let cached = validTokenCache[stateKey] {
      return cached
    }

    let validChars = parseState.getValidNextCharacters()
    var validTokenIds = Set<Int>()

    for char in validChars {
      let charString = String(char)
      let tokens = tokenizer.encode(text: charString)
      validTokenIds.formUnion(tokens)
    }

    if parseState.isComplete {
      if let eosId = tokenizer.eosTokenId {
        validTokenIds.insert(eosId)
      }
    }

    validTokenCache[stateKey] = validTokenIds
    return validTokenIds
  }

  var isComplete: Bool {
    return parseState.isComplete
  }
}

/// A constraint processor for guided JSON generation
/// Now conforms to MLX's LogitProcessor protocol for token-level constraints!
internal final class GuidedJSONProcessor: LogitProcessor, @unchecked Sendable {
  private let schema: RuntimeGenerationSchema
  private let tokenizer: Tokenizer
  private let state: ProcessorState

  // We need to maintain a reference to track state synchronously
  // This is a limitation of the LogitProcessor protocol which is synchronous
  private var cachedValidTokens: Set<Int> = []
  private var cachedIsComplete: Bool = false

  internal init(schema: RuntimeGenerationSchema, tokenizer: Tokenizer) {
    self.schema = schema
    self.tokenizer = tokenizer
    self.state = ProcessorState(schema: schema)

    // Initialize cached values
    Task {
      self.cachedValidTokens = await state.getValidTokenIds(tokenizer: tokenizer)
      self.cachedIsComplete = await state.isComplete
    }
  }

  // MARK: - LogitProcessor Protocol

  public func prompt(_ prompt: MLXArray) {
    // Reset state when a new prompt starts
    Task {
      await state.reset(schema: schema)
      self.cachedValidTokens = await state.getValidTokenIds(tokenizer: tokenizer)
      self.cachedIsComplete = await state.isComplete
    }
  }

  public func didSample(token: MLXArray) {
    // Update parse state with the sampled token
    let tokenId = token.item(Int.self)
    Task {
      await state.updateWithToken(tokenId, tokenizer: tokenizer)
      self.cachedValidTokens = await state.getValidTokenIds(tokenizer: tokenizer)
      self.cachedIsComplete = await state.isComplete
    }
  }

  public func process(logits: MLXArray) -> MLXArray {
    // Use cached values for synchronous processing
    let validTokenIds = cachedValidTokens

    // If we're complete or have no constraints, return original logits
    if cachedIsComplete || validTokenIds.isEmpty {
      return logits
    }

    // Get vocabulary size from logits shape
    let vocabSize = logits.shape.last ?? 0

    // Create mask: 1 for valid tokens, 0 for invalid
    var maskValues = [Float](repeating: 0, count: vocabSize)
    for tokenId in validTokenIds {
      if tokenId < vocabSize {
        maskValues[tokenId] = 1
      }
    }

    let mask = MLXArray(maskValues).reshaped(1, vocabSize)

    // Apply mask: set invalid tokens to -inf
    // Use broadcasting to apply mask
    let maskedLogits = MLX.where(
      mask .== 0,
      MLXArray(-Float.infinity),
      logits
    )

    return maskedLogits
  }
}

// MARK: - Alternative: Fully Synchronous Processor

/// Alternative implementation that avoids actors entirely
/// This is more suitable for the synchronous LogitProcessor protocol
internal final class SyncGuidedJSONProcessor: LogitProcessor, @unchecked Sendable {
  private let schema: RuntimeGenerationSchema
  private let tokenizer: Tokenizer
  private var parseState: JSONParseState
  private var validTokenCache: [String: Set<Int>] = [:]

  internal init(schema: RuntimeGenerationSchema, tokenizer: Tokenizer) {
    self.schema = schema
    self.tokenizer = tokenizer
    self.parseState = JSONParseState(schema: schema)
  }

  // MARK: - LogitProcessor Protocol

  public func prompt(_ prompt: MLXArray) {
    // Reset state when a new prompt starts
    self.parseState = JSONParseState(schema: schema)
    self.validTokenCache.removeAll()
  }

  public func didSample(token: MLXArray) {
    // Update parse state with the sampled token
    let tokenId = token.item(Int.self)
    updateStateWithToken(tokenId)
  }

  public func process(logits: MLXArray) -> MLXArray {
    let validTokenIds = getValidTokenIds()

    // If we're complete or have no constraints, return original logits
    if parseState.isComplete || validTokenIds.isEmpty {
      return logits
    }

    // Get vocabulary size from logits shape
    let vocabSize = logits.shape.last ?? 0

    // Create mask: 1 for valid tokens, 0 for invalid
    var maskValues = [Float](repeating: 0, count: vocabSize)
    for tokenId in validTokenIds {
      if tokenId < vocabSize {
        maskValues[tokenId] = 1
      }
    }

    let mask = MLXArray(maskValues).reshaped(1, vocabSize)

    // Apply mask: set invalid tokens to -inf
    let maskedLogits = MLX.where(
      mask .== 0,
      MLXArray(-Float.infinity),
      logits
    )

    return maskedLogits
  }

  // MARK: - Private Methods

  private func updateStateWithToken(_ tokenId: Int) {
    validTokenCache.removeAll()
    let text = tokenizer.decode(tokens: [tokenId])
    parseState.advance(with: text)
  }

  private func getValidTokenIds() -> Set<Int> {
    let stateKey = parseState.currentStateKey

    if let cached = validTokenCache[stateKey] {
      return cached
    }

    let validChars = parseState.getValidNextCharacters()
    var validTokenIds = Set<Int>()

    for char in validChars {
      let charString = String(char)
      let tokens = tokenizer.encode(text: charString)
      validTokenIds.formUnion(tokens)
    }

    if parseState.isComplete {
      if let eosId = tokenizer.eosTokenId {
        validTokenIds.insert(eosId)
      }
    }

    validTokenCache[stateKey] = validTokenIds
    return validTokenIds
  }
}
