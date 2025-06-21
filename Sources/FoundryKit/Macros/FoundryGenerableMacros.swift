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
/// @FoundryGuide("Search terms", .count(5))  // Exact count
/// let terms: [String]
/// 
/// @FoundryGuide("Tags", .count(1...10))  // Count range
/// let tags: [String]
/// ```
@attached(peer)
public macro FoundryGuide(_ description: String? = nil, _ constraints: ValidationConstraint...) = #externalMacro(
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
    case pattern(String)  // Note: FMF uses Regex type, we use String for compatibility
    
    // MARK: - Numeric Constraints (Int)
    
    /// Enforces a minimum value (inclusive)
    case minimum(Int)
    
    /// Enforces a maximum value (inclusive)
    case maximum(Int)
    
    /// Enforces values fall within a range
    case range(ClosedRange<Int>)
    
    // MARK: - Numeric Constraints (Float)
    
    /// Enforces a minimum Float value (inclusive)
    case minimumFloat(Float)
    
    /// Enforces a maximum Float value (inclusive)
    case maximumFloat(Float)
    
    /// Enforces Float values fall within a range
    case rangeFloat(ClosedRange<Float>)
    
    // MARK: - Numeric Constraints (Double)
    
    /// Enforces a minimum Double value (inclusive)
    case minimumDouble(Double)
    
    /// Enforces a maximum Double value (inclusive)
    case maximumDouble(Double)
    
    /// Enforces Double values fall within a range
    case rangeDouble(ClosedRange<Double>)
    
    // MARK: - Array Constraints
    
    /// Enforces a minimum number of elements in the array (inclusive)
    case minimumCount(Int)
    
    /// Enforces a maximum number of elements in the array (inclusive)
    case maximumCount(Int)
    
    /// Enforces that the array has exactly a certain number of elements or falls within a range
    case count(CountConstraint)
    
}

/// Represents count constraints for arrays
public enum CountConstraint: Sendable {
    case exact(Int)
    case range(ClosedRange<Int>)
}

// MARK: - Convenience Extensions

extension ValidationConstraint {
    /// Convenience method for exact count
    public static func count(_ value: Int) -> ValidationConstraint {
        return .count(.exact(value))
    }
    
    /// Convenience method for count range
    public static func count(_ range: ClosedRange<Int>) -> ValidationConstraint {
        return .count(.range(range))
    }
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
            case .minimumFloat(let minValue):
                if let floatValue = value as? Float, floatValue < minValue {
                    throw ValidationError.belowMinimumFloat(name, minValue)
                }
            case .maximumFloat(let maxValue):
                if let floatValue = value as? Float, floatValue > maxValue {
                    throw ValidationError.aboveMaximumFloat(name, maxValue)
                }
            case .rangeFloat(let range):
                if let floatValue = value as? Float, !range.contains(floatValue) {
                    throw ValidationError.outOfRangeFloat(name, range)
                }
            case .minimumDouble(let minValue):
                if let doubleValue = value as? Double, doubleValue < minValue {
                    throw ValidationError.belowMinimumDouble(name, minValue)
                }
            case .maximumDouble(let maxValue):
                if let doubleValue = value as? Double, doubleValue > maxValue {
                    throw ValidationError.aboveMaximumDouble(name, maxValue)
                }
            case .rangeDouble(let range):
                if let doubleValue = value as? Double, !range.contains(doubleValue) {
                    throw ValidationError.outOfRangeDouble(name, range)
                }
            case .minimumCount(let minCount):
                if let arrayValue = value as? [Any], arrayValue.count < minCount {
                    throw ValidationError.tooFewItems(name, minCount)
                }
            case .maximumCount(let maxCount):
                if let arrayValue = value as? [Any], arrayValue.count > maxCount {
                    throw ValidationError.tooManyItems(name, maxCount)
                }
            case .count(let constraint):
                if let arrayValue = value as? [Any] {
                    switch constraint {
                    case .exact(let exactCount):
                        if arrayValue.count != exactCount {
                            throw ValidationError.wrongItemCount(name, exactCount, arrayValue.count)
                        }
                    case .range(let range):
                        if !range.contains(arrayValue.count) {
                            throw ValidationError.itemCountOutOfRange(name, range, arrayValue.count)
                        }
                    }
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
    case belowMinimumFloat(String, Float)
    case aboveMaximumFloat(String, Float)
    case outOfRangeFloat(String, ClosedRange<Float>)
    case belowMinimumDouble(String, Double)
    case aboveMaximumDouble(String, Double)
    case outOfRangeDouble(String, ClosedRange<Double>)
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
        case .belowMinimumFloat(let property, let min):
            return "\(property) is below minimum value of \(min)"
        case .aboveMaximumFloat(let property, let max):
            return "\(property) is above maximum value of \(max)"
        case .outOfRangeFloat(let property, let range):
            return "\(property) is outside the valid range \(range.lowerBound)...\(range.upperBound)"
        case .belowMinimumDouble(let property, let min):
            return "\(property) is below minimum value of \(min)"
        case .aboveMaximumDouble(let property, let max):
            return "\(property) is above maximum value of \(max)"
        case .outOfRangeDouble(let property, let range):
            return "\(property) is outside the valid range \(range.lowerBound)...\(range.upperBound)"
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