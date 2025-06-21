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
///     @FoundryGuide("Temperature in Celsius")
///     @FoundryValidation(min: -50, max: 50)
///     let temperature: Double
///     
///     @FoundryGuide("Weather conditions")
///     let conditions: String
/// }
/// ```
@attached(member, names: named(generationSchema), named(generatedContent), named(PartiallyGenerated), named(jsonSchema), named(toolCallSchema), named(exampleJSON))
@attached(extension, conformances: Generable, names: named(init(_:)))
public macro FoundryGenerable() = #externalMacro(
    module: "FoundryGenerableMacros",
    type: "FoundryGenerableMacro"
)

/// Adds a description to a property for structured generation guidance.
///
/// Example:
/// ```swift
/// @FoundryGuide("User's email address")
/// let email: String
/// ```
@attached(peer)
public macro FoundryGuide(_ description: String) = #externalMacro(
    module: "FoundryGenerableMacros",
    type: "FoundryGuideMacro"
)

/// Adds validation rules to a property for structured generation.
///
/// Available validation parameters:
/// - `min`: Minimum value for numeric types
/// - `max`: Maximum value for numeric types
/// - `minLength`: Minimum length for strings
/// - `maxLength`: Maximum length for strings
/// - `minItems`: Minimum items for arrays
/// - `maxItems`: Maximum items for arrays
/// - `pattern`: Regex pattern for strings
/// - `enumValues`: Allowed values
///
/// Example:
/// ```swift
/// @FoundryValidation(min: 1, max: 5)
/// let rating: Int
///
/// @FoundryValidation(minLength: 10, maxLength: 200)
/// let description: String
///
/// @FoundryValidation(enumValues: ["small", "medium", "large"])
/// let size: String
/// ```
@attached(peer)
public macro FoundryValidation(
    min: Int? = nil,
    max: Int? = nil,
    minLength: Int? = nil,
    maxLength: Int? = nil,
    minItems: Int? = nil,
    maxItems: Int? = nil,
    pattern: String? = nil,
    enumValues: [String]? = nil
) = #externalMacro(
    module: "FoundryGenerableMacros",
    type: "FoundryValidationMacro"
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

/// Types of validation constraints
public enum ValidationConstraint {
    case min(Int)
    case max(Int)
    case minLength(Int)
    case maxLength(Int)
    case minItems(Int)
    case maxItems(Int)
    case pattern(String)
    case enumValues([String])
    case custom((Any) -> Bool)
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
            case .min(let minValue):
                if let intValue = value as? Int, intValue < minValue {
                    throw ValidationError.belowMinimum(name, minValue)
                }
            case .max(let maxValue):
                if let intValue = value as? Int, intValue > maxValue {
                    throw ValidationError.aboveMaximum(name, maxValue)
                }
            case .minLength(let minLen):
                if let stringValue = value as? String, stringValue.count < minLen {
                    throw ValidationError.tooShort(name, minLen)
                }
            case .maxLength(let maxLen):
                if let stringValue = value as? String, stringValue.count > maxLen {
                    throw ValidationError.tooLong(name, maxLen)
                }
            case .minItems(let minCount):
                if let arrayValue = value as? [Any], arrayValue.count < minCount {
                    throw ValidationError.tooFewItems(name, minCount)
                }
            case .maxItems(let maxCount):
                if let arrayValue = value as? [Any], arrayValue.count > maxCount {
                    throw ValidationError.tooManyItems(name, maxCount)
                }
            case .pattern(let regex):
                if let stringValue = value as? String {
                    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
                    if !predicate.evaluate(with: stringValue) {
                        throw ValidationError.patternMismatch(name, regex)
                    }
                }
            case .enumValues(let allowed):
                if let stringValue = value as? String, !allowed.contains(stringValue) {
                    throw ValidationError.invalidEnumValue(name, stringValue, allowed)
                }
            case .custom(let validator):
                if !validator(value) {
                    throw ValidationError.customValidationFailed(name)
                }
            }
        }
    }
}

/// Validation errors
public enum ValidationError: LocalizedError {
    case belowMinimum(String, Int)
    case aboveMaximum(String, Int)
    case tooShort(String, Int)
    case tooLong(String, Int)
    case tooFewItems(String, Int)
    case tooManyItems(String, Int)
    case patternMismatch(String, String)
    case invalidEnumValue(String, String, [String])
    case customValidationFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .belowMinimum(let property, let min):
            return "\(property) is below minimum value of \(min)"
        case .aboveMaximum(let property, let max):
            return "\(property) is above maximum value of \(max)"
        case .tooShort(let property, let minLength):
            return "\(property) is shorter than minimum length of \(minLength)"
        case .tooLong(let property, let maxLength):
            return "\(property) is longer than maximum length of \(maxLength)"
        case .tooFewItems(let property, let minItems):
            return "\(property) has fewer than \(minItems) items"
        case .tooManyItems(let property, let maxItems):
            return "\(property) has more than \(maxItems) items"
        case .patternMismatch(let property, let pattern):
            return "\(property) does not match pattern: \(pattern)"
        case .invalidEnumValue(let property, let value, let allowed):
            return "\(property) value '\(value)' is not in allowed values: \(allowed.joined(separator: ", "))"
        case .customValidationFailed(let property):
            return "\(property) failed custom validation"
        }
    }
}