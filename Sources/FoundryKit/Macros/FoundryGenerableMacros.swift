import Foundation

// MARK: - Macro Declarations

/// A macro that generates `Generable` conformance and JSON schema for structured generation.
///
/// This macro automatically generates:
/// - Conformance to `Generable` protocol
/// - JSON schema representation
/// - Example JSON based on validation rules
/// - Partial generation support
///
/// Example usage:
/// ```swift
/// @FoundryGenerable
/// struct WeatherInfo {
///     @FoundryGuide("City name")
///     let location: String
///     
///     @FoundryGuide("Temperature in Celsius", .range(-50...50))
///     let temperature: Int
///     
///     @FoundryGuide("Weather conditions", .anyOf(["sunny", "cloudy", "rainy", "snowy"]))
///     let conditions: String
///     
///     @FoundryGuide("Hourly forecast", .count(24))
///     let hourlyTemperatures: [Int]
/// }
/// ```
@attached(member, names: named(generationSchema), named(generatedContent), named(PartiallyGenerated), named(jsonSchema), named(toolCallSchema), named(exampleJSON))
@attached(extension, conformances: Generable, names: named(init(_:)))
public macro FoundryGenerable() = #externalMacro(
    module: "FoundryGenerableMacros",
    type: "FoundryGenerableMacro"
)

/// Adds a description and optional validation constraints to a property for structured generation.
/// This matches the Foundation Models Framework's @Guide pattern.
///
/// Example:
/// ```swift
/// @FoundryGuide("User's email address")
/// let email: String
/// 
/// @FoundryGuide("User's age", .range(18...100))
/// let age: Int
/// 
/// @FoundryGuide("Search terms", .count(5))
/// let terms: [String]
/// ```
@attached(peer)
public macro FoundryGuide(_ description: String, _ constraints: ValidationConstraint...) = #externalMacro(
    module: "FoundryGenerableMacros",
    type: "FoundryGuideMacro"
)


// MARK: - Supporting Types

/// Protocol that combines FoundryGenerable functionality with StructuredOutput
public protocol FoundryStructuredOutput: StructuredOutput, Generable {
    /// Validation rules for the type
    static var validationRules: [String: ValidationRule] { get }
}

/// Represents a validation rule for a property
public struct ValidationRule {
    public let propertyName: String
    public let rules: [ValidationConstraint]
    
    public init(propertyName: String, rules: [ValidationConstraint]) {
        self.propertyName = propertyName
        self.rules = rules
    }
}

/// Type-safe validation constraints for guided generation, matching Foundation Models Framework patterns
public enum ValidationConstraint: Sendable {
    // MARK: - String Constraints
    
    /// Enforces that the string be precisely the given value
    case constant(String)
    
    /// Enforces that the string be one of the provided values
    case anyOf([String])
    
    /// Enforces that the string follows the pattern
    case pattern(String)  // We use String instead of Regex for broader compatibility
    
    /// Enforces minimum string length
    case minLength(Int)
    
    /// Enforces maximum string length  
    case maxLength(Int)
    
    // MARK: - Numeric Constraints
    
    /// Enforces a minimum value (inclusive)
    case minimum(Int)
    
    /// Enforces a maximum value (inclusive)
    case maximum(Int)
    
    /// Enforces values fall within a range
    case range(ClosedRange<Int>)
    
    // MARK: - Array Constraints
    
    /// Enforces a minimum number of elements in the array (inclusive)
    case minimumCount(Int)
    
    /// Enforces a maximum number of elements in the array (inclusive)
    case maximumCount(Int)
    
    /// Enforces that the array has exactly a certain number of elements
    case count(Int)
    
    /// Enforces that the number of elements in the array fall within a closed range
    case countRange(ClosedRange<Int>)
    
}

// MARK: - Validation Extensions

extension FoundryStructuredOutput {
    /// Validates an instance against the defined validation rules
    public func validate() throws {
        let mirror = Mirror(reflecting: self)
        
        for (label, value) in mirror.children {
            guard let propertyName = label,
                  let rule = Self.validationRules[propertyName] else {
                continue
            }
            
            try validateProperty(
                name: propertyName,
                value: value,
                constraints: rule.rules
            )
        }
    }
    
    private func validateProperty(
        name: String,
        value: Any,
        constraints: [ValidationConstraint]
    ) throws {
        for constraint in constraints {
            switch constraint {
            case .minimum(let minValue):
                if let intValue = value as? Int, intValue < minValue {
                    throw ValidationError.belowMinimum(name, minValue)
                }
            case .maximum(let maxValue):
                if let intValue = value as? Int, intValue > maxValue {
                    throw ValidationError.aboveMaximum(name, maxValue)
                }
            case .range(let range):
                if let intValue = value as? Int, !range.contains(intValue) {
                    throw ValidationError.outOfRange(name, range)
                }
            case .minLength(let minLen):
                if let stringValue = value as? String, stringValue.count < minLen {
                    throw ValidationError.tooShort(name, minLen)
                }
            case .maxLength(let maxLen):
                if let stringValue = value as? String, stringValue.count > maxLen {
                    throw ValidationError.tooLong(name, maxLen)
                }
            case .minimumCount(let minCount):
                if let arrayValue = value as? [Any], arrayValue.count < minCount {
                    throw ValidationError.tooFewItems(name, minCount)
                }
            case .maximumCount(let maxCount):
                if let arrayValue = value as? [Any], arrayValue.count > maxCount {
                    throw ValidationError.tooManyItems(name, maxCount)
                }
            case .count(let exactCount):
                if let arrayValue = value as? [Any], arrayValue.count != exactCount {
                    throw ValidationError.wrongItemCount(name, exactCount, arrayValue.count)
                }
            case .countRange(let range):
                if let arrayValue = value as? [Any], !range.contains(arrayValue.count) {
                    throw ValidationError.itemCountOutOfRange(name, range, arrayValue.count)
                }
            case .pattern(let regex):
                if let stringValue = value as? String {
                    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
                    if !predicate.evaluate(with: stringValue) {
                        throw ValidationError.patternMismatch(name, regex)
                    }
                }
            case .anyOf(let allowed):
                if let stringValue = value as? String, !allowed.contains(stringValue) {
                    throw ValidationError.invalidEnumValue(name, stringValue, allowed)
                }
            case .constant(let expected):
                if let stringValue = value as? String, stringValue != expected {
                    throw ValidationError.notEqualToConstant(name, expected, stringValue)
                }
            }
        }
    }
}

/// Validation errors
public enum ValidationError: LocalizedError {
    case belowMinimum(String, Int)
    case aboveMaximum(String, Int)
    case outOfRange(String, ClosedRange<Int>)
    case tooShort(String, Int)
    case tooLong(String, Int)
    case tooFewItems(String, Int)
    case tooManyItems(String, Int)
    case wrongItemCount(String, Int, Int)
    case itemCountOutOfRange(String, ClosedRange<Int>, Int)
    case patternMismatch(String, String)
    case invalidEnumValue(String, String, [String])
    case notEqualToConstant(String, String, String)
    case customValidationFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .belowMinimum(let property, let min):
            return "\(property) is below minimum value of \(min)"
        case .aboveMaximum(let property, let max):
            return "\(property) is above maximum value of \(max)"
        case .outOfRange(let property, let range):
            return "\(property) is outside the valid range \(range.lowerBound)...\(range.upperBound)"
        case .tooShort(let property, let minLength):
            return "\(property) is shorter than minimum length of \(minLength)"
        case .tooLong(let property, let maxLength):
            return "\(property) is longer than maximum length of \(maxLength)"
        case .tooFewItems(let property, let minItems):
            return "\(property) has fewer than \(minItems) items"
        case .tooManyItems(let property, let maxItems):
            return "\(property) has more than \(maxItems) items"
        case .wrongItemCount(let property, let expected, let actual):
            return "\(property) has \(actual) items but expected exactly \(expected)"
        case .itemCountOutOfRange(let property, let range, let actual):
            return "\(property) has \(actual) items but expected \(range.lowerBound)...\(range.upperBound)"
        case .patternMismatch(let property, let pattern):
            return "\(property) does not match pattern: \(pattern)"
        case .invalidEnumValue(let property, let value, let allowed):
            return "\(property) value '\(value)' is not in allowed values: \(allowed.joined(separator: ", "))"
        case .notEqualToConstant(let property, let expected, let actual):
            return "\(property) value '\(actual)' does not match expected constant '\(expected)'"
        case .customValidationFailed(let property):
            return "\(property) failed custom validation"
        }
    }
}