//
//  TokenTracking.swift
//  Foundation Models Token Tracking Extension
//
//  A standalone extension for Apple's Foundation Models framework to track
//  token usage for input prompts and generated outputs.
//
//  Usage:
//  1. Add this file to your project
//  2. Call estimateTokens() on any string or response
//  3. Use TokenUsage to track input/output counts
//

import Foundation
import FoundationModels

// MARK: - Supported Languages

/// Languages supported by Apple Intelligence as of June 2025.
/// Initial support for US English in iOS 18.1 (Oct 2024)
/// Expanded English variants in iOS 18.2 (Dec 2024)
/// Major language expansion in iOS 18.4 (March 2025)
/// Additional languages announced at WWDC 2025 coming by end of year
public enum AppleIntelligenceLanguage: String, CaseIterable, Sendable {
  // English variants
  case englishUS = "en-US"  // iOS 18.1 (Oct 2024)
  case englishUK = "en-GB"  // iOS 18.2 (Dec 2024)
  case englishAustralia = "en-AU"  // iOS 18.2 (Dec 2024)
  case englishCanada = "en-CA"  // iOS 18.2 (Dec 2024)
  case englishIreland = "en-IE"  // iOS 18.2 (Dec 2024)
  case englishNewZealand = "en-NZ"  // iOS 18.2 (Dec 2024)
  case englishSouthAfrica = "en-ZA"  // iOS 18.2 (Dec 2024)
  case englishIndia = "en-IN"  // iOS 18.4 (March 2025)
  case englishSingapore = "en-SG"  // iOS 18.4 (March 2025)

  // Languages added in iOS 18.4 (March 2025)
  case french = "fr"
  case german = "de"
  case italian = "it"
  case portugueseBrazil = "pt-BR"
  case spanish = "es"
  case japanese = "ja"
  case korean = "ko"
  case chineseSimplified = "zh-Hans"
  case vietnamese = "vi"

  // Coming by end of 2025 (announced at WWDC 2025)
  case danish = "da"
  case dutch = "nl"
  case norwegian = "no"
  case portuguesePortugal = "pt-PT"
  case swedish = "sv"
  case turkish = "tr"
  case chineseTraditional = "zh-Hant"

  /// The ISO 639-1 language code (2-letter code).
  public var languageCode: String {
    switch self {
    case .englishUS, .englishUK, .englishAustralia, .englishCanada,
      .englishIreland, .englishNewZealand, .englishSouthAfrica,
      .englishIndia, .englishSingapore:
      return "en"
    case .french:
      return "fr"
    case .german:
      return "de"
    case .italian:
      return "it"
    case .portugueseBrazil, .portuguesePortugal:
      return "pt"
    case .spanish:
      return "es"
    case .japanese:
      return "ja"
    case .korean:
      return "ko"
    case .chineseSimplified, .chineseTraditional:
      return "zh"
    case .vietnamese:
      return "vi"
    case .danish:
      return "da"
    case .dutch:
      return "nl"
    case .norwegian:
      return "no"
    case .swedish:
      return "sv"
    case .turkish:
      return "tr"
    }
  }

  /// Estimated characters per token for this language.
  public var charactersPerToken: Int {
    switch languageCode {
    case "en":
      return 4
    case "zh", "ja", "ko":
      return 2  // CJK languages typically use fewer chars per token
    case "tr":
      return 3  // Turkish has agglutinative structure
    default:
      return 3  // Conservative estimate for European languages
    }
  }

  /// Whether this language is currently available (June 2025).
  public var isCurrentlyAvailable: Bool {
    switch self {
    case .danish, .dutch, .norwegian, .portuguesePortugal, .swedish, .turkish, .chineseTraditional:
      return false  // Coming by end of 2025
    default:
      return true  // Available as of iOS 18.4
    }
  }
}

// MARK: - Token Usage

/// Token usage information for a generation request.
public struct TokenUsage: Sendable {
  /// Number of tokens in the input prompt.
  public let inputTokens: Int

  /// Number of tokens in the generated output.
  public let outputTokens: Int

  /// Total tokens used (input + output).
  public var totalTokens: Int {
    inputTokens + outputTokens
  }

  public init(inputTokens: Int, outputTokens: Int) {
    self.inputTokens = inputTokens
    self.outputTokens = outputTokens
  }
}

// MARK: - Token Estimation

extension String {
  /// Estimates token count using 1:4 character ratio.
  public var estimatedTokenCount: Int {
    count / 4
  }

  /// More sophisticated token estimation considering word boundaries.
  public var estimatedTokens: Int {
    let words = split { $0.isWhitespace || $0.isPunctuation }.count
    let chars = count

    // Use the higher of word count or character-based estimate
    return max(words, chars / 4)
  }

  /// Estimates tokens with language-specific adjustments using AppleIntelligenceLanguage enum.
  public func estimatedTokens(for language: AppleIntelligenceLanguage = .englishUS) -> Int {
    count / language.charactersPerToken
  }

  /// Estimates tokens using a language code string (e.g., "en", "zh", "ja").
  /// This method is useful when working with Locale.current.language.languageCode?.identifier
  public func estimatedTokens(forLanguageCode languageCode: String) -> Int {
    switch languageCode {
    case "en":
      return count / 4
    case "zh", "ja", "ko":
      return count / 2  // CJK languages typically use fewer chars per token
    default:
      return count / 3  // Conservative estimate for other languages
    }
  }
}

// MARK: - Response Token Counting

extension LanguageModelSession.Response where Content == String {
  /// Calculates token usage for this response.
  /// - Parameter inputPrompt: The original input prompt string
  /// - Returns: TokenUsage with estimated counts
  public func tokenUsage(for inputPrompt: String) -> TokenUsage {
    let inputTokens = inputPrompt.estimatedTokens
    let outputTokens = content.estimatedTokens
    return TokenUsage(inputTokens: inputTokens, outputTokens: outputTokens)
  }

  /// Calculates token usage by analyzing transcript entries.
  /// - Returns: TokenUsage based on transcript analysis
  public var tokenUsageFromTranscript: TokenUsage {
    var inputChars = 0
    var outputChars = 0

    for entry in transcriptEntries {
      // Handle different entry types based on what's available
      // You may need to adjust this based on actual Transcript.Entry API
      let entryString = String(describing: entry)

      // Simple heuristic: responses typically contain "response" in description
      if entryString.lowercased().contains("response") {
        outputChars += entryString.count
      } else {
        inputChars += entryString.count
      }
    }

    let inputTokens = inputChars / 4
    let outputTokens = outputChars / 4
    return TokenUsage(inputTokens: inputTokens, outputTokens: outputTokens)
  }
}

// MARK: - Usage Examples

/*
// Example 1: Count input tokens BEFORE making a request
let prompt = "Explain quantum computing in simple terms"
let estimatedInputTokens = prompt.estimatedTokens
print("This prompt will use approximately \(estimatedInputTokens) input tokens")

// Make the API call
let session = LanguageModelSession(model: .default)
let response = try await session.respond(to: prompt)

// Count output tokens AFTER getting the response
let outputTokens = response.content.estimatedTokens
print("Response used approximately \(outputTokens) output tokens")
print("Total tokens: \(estimatedInputTokens + outputTokens)")

// Example 2: Count tokens after getting a response (all-in-one)
let usage = response.tokenUsage(for: prompt)
print("Input: \(usage.inputTokens), Output: \(usage.outputTokens), Total: \(usage.totalTokens)")

// Example 3: Analyzing transcript entries (when you don't have the original prompt)
let usageFromTranscript = response.tokenUsageFromTranscript
print("Tokens from transcript - Input: \(usageFromTranscript.inputTokens), Output: \(usageFromTranscript.outputTokens)")

// Example 4: Estimate tokens for any text
let longText = "This is a longer piece of text that you want to check before sending to avoid exceeding token limits"
let tokens = longText.estimatedTokens
print("This text would use approximately \(tokens) tokens")

// Example 5: Check if prompt fits within token budget
let tokenBudget = 1000
let myPrompt = "Your very long prompt here..."
if myPrompt.estimatedTokens > tokenBudget {
    print("Warning: Prompt exceeds token budget!")
}

// Example 6: Language-specific estimation using enum
let chineseText = "你好世界"
let chineseTokens = chineseText.estimatedTokens(for: .chineseSimplified)
print("Chinese text tokens: \(chineseTokens)")

// Example 7: Using current device language
if let currentLanguageCode = Locale.current.language.languageCode?.identifier {
    let tokens = myPrompt.estimatedTokens(forLanguageCode: currentLanguageCode)
    print("Tokens for current language (\(currentLanguageCode)): \(tokens)")
}

// Example 8: List all supported languages
print("Supported languages:")
for language in AppleIntelligenceLanguage.allCases {
    print("- \(language.rawValue): \(language.charactersPerToken) chars/token")
}
*/
