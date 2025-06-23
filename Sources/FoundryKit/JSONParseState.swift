import Foundation

// MARK: - JSON Parse State Machine

/// Core JSON parsing state machine for constrained generation
internal class JSONParseState {
  private let schema: RuntimeGenerationSchema
  private var state: State = .start

  internal init(schema: RuntimeGenerationSchema) {
    self.schema = schema
  }

  // MARK: - State Definition

  indirect enum State {
    case start
    case inObject(path: [String])
    case expectingPropertyName(path: [String])
    case inPropertyName(path: [String], partial: String)
    case afterPropertyName(path: [String], property: String)
    case expectingColon(path: [String], property: String)
    case expectingValue(path: [String], property: String, type: SchemaType)
    case inStringValue(path: [String], property: String, partial: String)
    case inNumberValue(path: [String], property: String, partial: String)
    case inBooleanValue(path: [String], property: String, partial: String)
    case inNullValue(path: [String], property: String, partial: String)
    case inArray(path: [String], property: String, elementType: SchemaType, count: Int)
    case inArrayStringElement(
      path: [String], property: String, elementType: SchemaType, count: Int, partial: String)
    case inArrayNumberElement(
      path: [String], property: String, elementType: SchemaType, count: Int, partial: String)
    case inArrayBooleanElement(
      path: [String], property: String, elementType: SchemaType, count: Int, partial: String)
    case inArrayNullElement(
      path: [String], property: String, elementType: SchemaType, count: Int, partial: String)
    case afterValue(path: [String])
    case complete
  }

  // MARK: - Public Interface

  internal func processCharacter(_ char: Character) {
    // State machine transitions based on character
    switch (state, char) {

    // === WHITESPACE HANDLING (universal) ===
    case (_, " "), (_, "\n"), (_, "\r"), (_, "\t"):
      // Allow whitespace in most states (JSON is whitespace-agnostic)
      break

    // === OBJECT START ===
    case (.start, "{"):
      state = .expectingPropertyName(path: [])

    // === PROPERTY NAME PARSING ===
    case (.expectingPropertyName, "\""):
      state = .inPropertyName(path: getCurrentPath(), partial: "")

    case (.inPropertyName(let path, let partial), "\""):
      state = .afterPropertyName(path: path, property: partial)

    case (.inPropertyName(let path, let partial), _):
      state = .inPropertyName(path: path, partial: partial + String(char))

    // === COLON HANDLING ===
    case (.afterPropertyName(let path, let prop), ":"):
      if let propSchema = getPropertySchema(name: prop, at: path) {
        state = .expectingValue(path: path, property: prop, type: propSchema.type)
      }

    // === VALUE PARSING BY TYPE ===
    case (.expectingValue(let path, let prop, .string), "\""):
      state = .inStringValue(path: path, property: prop, partial: "")

    case (.expectingValue(let path, let prop, .number), _),
      (.expectingValue(let path, let prop, .integer), _)
    where "0123456789-".contains(char):
      state = .inNumberValue(path: path, property: prop, partial: String(char))

    case (.expectingValue(let path, let prop, .boolean), "t"),
      (.expectingValue(let path, let prop, .boolean), "f"):
      state = .inBooleanValue(path: path, property: prop, partial: String(char))

    case (.expectingValue(let path, let prop, .null), "n"):
      state = .inNullValue(path: path, property: prop, partial: String(char))

    case (.expectingValue(let path, let prop, .object), "{"):
      state = .expectingPropertyName(path: path + [prop])

    case (.expectingValue(let path, let prop, .array(let elementType)), "["):
      state = .inArray(path: path, property: prop, elementType: elementType, count: 0)

    // === STRING VALUE HANDLING ===
    case (.inStringValue(let path, let prop, let partial), "\""):
      // End of string value (only if not escaped)
      if !partial.hasSuffix("\\") {
        state = .afterValue(path: path)
      } else {
        state = .inStringValue(path: path, property: prop, partial: partial + String(char))
      }

    case (.inStringValue(let path, let prop, let partial), _):
      state = .inStringValue(path: path, property: prop, partial: partial + String(char))

    // === NUMBER VALUE HANDLING ===
    case (.inNumberValue(let path, let prop, let partial), _) where "0123456789.eE+-".contains(char):
      let newPartial = partial + String(char)
      // Only advance if the new partial could still be a valid number
      if couldBeValidNumber(newPartial) {
        state = .inNumberValue(path: path, property: prop, partial: newPartial)
      }
    // If invalid, stay in current state (ignore the character)

    case (.inNumberValue(let path, _, _), ","):
      state = .afterValue(path: path)

    case (.inNumberValue(let path, _, _), "}"):
      state = .afterValue(path: path)

    // === BOOLEAN VALUE HANDLING ===
    case (.inBooleanValue(let path, let prop, let partial), _)
    where
      ("true".hasPrefix(partial + String(char)) || "false".hasPrefix(partial + String(char))):
      let newPartial = partial + String(char)
      if newPartial == "true" || newPartial == "false" {
        state = .afterValue(path: path)
      } else {
        state = .inBooleanValue(path: path, property: prop, partial: newPartial)
      }

    // === NULL VALUE HANDLING ===
    case (.inNullValue(let path, let prop, let partial), _)
    where "null".hasPrefix(
      partial + String(char)):
      let newPartial = partial + String(char)
      if newPartial == "null" {
        state = .afterValue(path: path)
      } else {
        state = .inNullValue(path: path, property: prop, partial: newPartial)
      }

    // === ARRAY HANDLING ===
    case (.inArray(let path, _, _, _), "]"):
      state = .afterValue(path: path)

    case (.inArray(let path, let prop, let elementType, let count), ","):
      // Stay in array, expecting next element
      state = .inArray(path: path, property: prop, elementType: elementType, count: count)

    // Array element value handling - treat array elements like object values
    case (.inArray(let path, let prop, .string, let count), "\""):
      state = .inArrayStringElement(
        path: path, property: prop, elementType: .string, count: count, partial: "")

    case (.inArray(let path, let prop, .number, let count), _),
      (.inArray(let path, let prop, .integer, let count), _)
    where "0123456789-".contains(char):
      state = .inArrayNumberElement(
        path: path, property: prop, elementType: .number, count: count, partial: String(char))

    case (.inArray(let path, let prop, .boolean, let count), "t"),
      (.inArray(let path, let prop, .boolean, let count), "f"):
      state = .inArrayBooleanElement(
        path: path, property: prop, elementType: .boolean, count: count, partial: String(char))

    case (.inArray(let path, let prop, .null, let count), "n"):
      state = .inArrayNullElement(
        path: path, property: prop, elementType: .null, count: count, partial: String(char))

    // === ARRAY ELEMENT COMPLETION ===
    case (.inArrayStringElement(let path, let prop, let elemType, let count, _), "\""):
      // End of array string element
      state = .inArray(path: path, property: prop, elementType: elemType, count: count + 1)

    case (.inArrayStringElement(let path, let prop, let elemType, let count, let partial), _):
      // Continue building string
      state = .inArrayStringElement(
        path: path, property: prop, elementType: elemType, count: count,
        partial: partial + String(char))

    case (.inArrayNumberElement(let path, let prop, let elemType, let count, let partial), _)
    where "0123456789.eE+-".contains(char):
      let newPartial = partial + String(char)
      if couldBeValidNumber(newPartial) {
        state = .inArrayNumberElement(
          path: path, property: prop, elementType: elemType, count: count, partial: newPartial)
      }

    case (.inArrayNumberElement(let path, let prop, let elemType, let count, _), ","),
      (.inArrayNumberElement(let path, let prop, let elemType, let count, _), "]"):
      state = .inArray(path: path, property: prop, elementType: elemType, count: count + 1)

    case (.inArrayBooleanElement(let path, let prop, let elemType, let count, let partial), _)
    where ("true".hasPrefix(partial + String(char)) || "false".hasPrefix(partial + String(char))):
      let newPartial = partial + String(char)
      if newPartial == "true" || newPartial == "false" {
        state = .inArray(path: path, property: prop, elementType: elemType, count: count + 1)
      } else {
        state = .inArrayBooleanElement(
          path: path, property: prop, elementType: elemType, count: count, partial: newPartial)
      }

    case (.inArrayNullElement(let path, let prop, let elemType, let count, let partial), _)
    where "null".hasPrefix(partial + String(char)):
      let newPartial = partial + String(char)
      if newPartial == "null" {
        state = .inArray(path: path, property: prop, elementType: elemType, count: count + 1)
      } else {
        state = .inArrayNullElement(
          path: path, property: prop, elementType: elemType, count: count, partial: newPartial)
      }

    // === AFTER VALUE HANDLING ===
    case (.afterValue(let path), ","):
      if path.isEmpty {
        // Root level - expect another property
        state = .expectingPropertyName(path: [])
      } else {
        // Nested object - expect another property
        state = .expectingPropertyName(path: path)
      }

    case (.afterValue(let path), "}"):
      if path.isEmpty {
        // Completed root object
        state = .complete
      } else {
        // Completed nested object - go back up one level
        let parentPath = Array(path.dropLast())
        state = .afterValue(path: parentPath)
      }

    // === FALLBACK ===
    default:
      // Invalid character for current state - stay in current state
      break
    }
  }

  internal func advance(with text: String) {
    for char in text {
      processCharacter(char)
    }
  }

  internal func getValidNextCharacters() -> Set<Character> {
    switch state {
    case .start:
      return ["{"]

    case .inObject(_):
      // Same as expecting property name
      var chars = Set<Character>()
      chars.insert("\"")  // Start property name
      chars.insert(" ")  // Allow whitespace
      chars.insert("}")  // Close empty object
      return chars

    case .expectingPropertyName:
      var chars = Set<Character>()
      chars.insert("\"")  // Start property name
      chars.insert(" ")  // Allow whitespace
      chars.insert("}")  // Close empty object
      return chars

    case .inPropertyName:
      var chars = Set<Character>()
      chars.insert("\"")  // End property name
      // Allow any printable characters for property names
      for i in 32...126 {
        if let char = UnicodeScalar(i) {
          chars.insert(Character(char))
        }
      }
      return chars

    case .afterPropertyName:
      return [":"]  // Must have colon after property name

    case .expectingColon:
      return [":"]

    case .expectingValue(_, _, let type):
      return getValidValueStartCharacters(for: type)

    case .inStringValue:
      var chars = Set<Character>()
      chars.insert("\"")  // End string
      // Allow any printable characters in strings
      for i in 32...126 {
        if let char = UnicodeScalar(i) {
          chars.insert(Character(char))
        }
      }
      return chars

    case .inNumberValue(_, _, let partial):
      var validChars = Set<Character>("0123456789")

      // Allow decimal point if not already present
      if !partial.contains(".") && !partial.isEmpty && partial != "-" {
        validChars.insert(".")
      }

      // Allow scientific notation
      if !partial.isEmpty && !partial.contains("e") && !partial.contains("E") {
        validChars.insert("e")
        validChars.insert("E")
      }

      // Allow +/- after e/E
      if partial.hasSuffix("e") || partial.hasSuffix("E") {
        validChars.insert("+")
        validChars.insert("-")
      }

      // Can end number with comma or closing brace
      if isValidNumberSoFar(partial) {
        validChars.insert(",")
        validChars.insert("}")
      }

      return validChars

    case .inBooleanValue(_, _, let partial):
      var validChars = Set<Character>()

      // Check if we can continue building "true"
      if "true".hasPrefix(partial) && partial.count < "true".count {
        let nextIndex = "true".index("true".startIndex, offsetBy: partial.count)
        validChars.insert("true"[nextIndex])
      }

      // Check if we can continue building "false"
      if "false".hasPrefix(partial) && partial.count < "false".count {
        let nextIndex = "false".index("false".startIndex, offsetBy: partial.count)
        validChars.insert("false"[nextIndex])
      }

      // If we have a complete boolean value, allow terminators
      if partial == "true" || partial == "false" {
        validChars.insert(",")
        validChars.insert("}")
      }

      return validChars

    case .inNullValue(_, _, let partial):
      var validChars = Set<Character>()

      // Check if we can continue building "null"
      if "null".hasPrefix(partial) && partial.count < "null".count {
        let nextIndex = "null".index("null".startIndex, offsetBy: partial.count)
        validChars.insert("null"[nextIndex])
      }

      // If we have a complete null value, allow terminators
      if partial == "null" {
        validChars.insert(",")
        validChars.insert("}")
      }

      return validChars

    case .inArrayStringElement(_, _, _, _, _):
      var validChars = Set<Character>()
      // Allow any characters except quotes (end string)
      validChars.insert("\"")
      // Allow any printable characters for string content
      for i in 32...126 {
        if let char = UnicodeScalar(i) {
          validChars.insert(Character(char))
        }
      }
      return validChars

    case .inArrayNumberElement(_, _, _, _, let partial):
      var validChars = Set<Character>("0123456789")

      // Allow decimal point if not already present
      if !partial.contains(".") && !partial.isEmpty && partial != "-" {
        validChars.insert(".")
      }

      // Allow scientific notation
      if !partial.isEmpty && !partial.contains("e") && !partial.contains("E") {
        validChars.insert("e")
        validChars.insert("E")
      }

      // Allow +/- after e/E
      if partial.hasSuffix("e") || partial.hasSuffix("E") {
        validChars.insert("+")
        validChars.insert("-")
      }

      // Can end number with comma or closing bracket
      if isValidNumberSoFar(partial) {
        validChars.insert(",")
        validChars.insert("]")
      }

      return validChars

    case .inArrayBooleanElement(_, _, _, _, let partial):
      var validChars = Set<Character>()

      // Check if we can continue building "true"
      if "true".hasPrefix(partial) && partial.count < "true".count {
        let nextIndex = "true".index("true".startIndex, offsetBy: partial.count)
        validChars.insert("true"[nextIndex])
      }

      // Check if we can continue building "false"
      if "false".hasPrefix(partial) && partial.count < "false".count {
        let nextIndex = "false".index("false".startIndex, offsetBy: partial.count)
        validChars.insert("false"[nextIndex])
      }

      // If we have a complete boolean value, allow terminators
      if partial == "true" || partial == "false" {
        validChars.insert(",")
        validChars.insert("]")
      }

      return validChars

    case .inArrayNullElement(_, _, _, _, let partial):
      var validChars = Set<Character>()

      // Check if we can continue building "null"
      if "null".hasPrefix(partial) && partial.count < "null".count {
        let nextIndex = "null".index("null".startIndex, offsetBy: partial.count)
        validChars.insert("null"[nextIndex])
      }

      // If we have a complete null value, allow terminators
      if partial == "null" {
        validChars.insert(",")
        validChars.insert("]")
      }

      return validChars

    case .inArray(_, _, let elementType, _):
      var validChars = Set<Character>()

      // Always allow closing the array
      validChars.insert("]")

      // Always allow starting a new element of the correct type
      validChars.formUnion(getValidValueStartCharacters(for: elementType))

      return validChars

    case .afterValue:
      return [",", "}"]

    case .complete:
      return []  // No more valid characters
    }
  }

  internal var isComplete: Bool {
    if case .complete = state {
      return true
    }
    return false
  }

  internal var currentStateKey: String {
    switch state {
    case .start: return "start"
    case .inObject(let path): return "obj:\(path.joined(separator: "."))"
    case .expectingPropertyName(let path): return "prop:\(path.joined(separator: "."))"
    case .inPropertyName(let path, let partial):
      return "inProp:\(path.joined(separator: ".")):\(partial)"
    case .afterPropertyName(let path, let prop):
      return "afterProp:\(path.joined(separator: ".")):\(prop)"
    case .expectingColon(let path, let prop):
      return "colon:\(path.joined(separator: ".")):\(prop)"
    case .expectingValue(let path, let prop, let type):
      return "val:\(path.joined(separator: ".")):\(prop):\(type)"
    case .inStringValue(let path, let prop, let partial):
      return "str:\(path.joined(separator: ".")):\(prop):\(partial)"
    case .inNumberValue(let path, let prop, let partial):
      return "num:\(path.joined(separator: ".")):\(prop):\(partial)"
    case .inBooleanValue(let path, let prop, let partial):
      return "bool:\(path.joined(separator: ".")):\(prop):\(partial)"
    case .inNullValue(let path, let prop, let partial):
      return "null:\(path.joined(separator: ".")):\(prop):\(partial)"
    case .inArray(let path, let prop, let elemType, let count):
      return "arr:\(path.joined(separator: ".")):\(prop):\(elemType):\(count)"
    case .inArrayStringElement(let path, let prop, let elemType, let count, let partial):
      return "arrStr:\(path.joined(separator: ".")):\(prop):\(elemType):\(count):\(partial)"
    case .inArrayNumberElement(let path, let prop, let elemType, let count, let partial):
      return "arrNum:\(path.joined(separator: ".")):\(prop):\(elemType):\(count):\(partial)"
    case .inArrayBooleanElement(let path, let prop, let elemType, let count, let partial):
      return "arrBool:\(path.joined(separator: ".")):\(prop):\(elemType):\(count):\(partial)"
    case .inArrayNullElement(let path, let prop, let elemType, let count, let partial):
      return "arrNull:\(path.joined(separator: ".")):\(prop):\(elemType):\(count):\(partial)"
    case .afterValue(let path): return "after:\(path.joined(separator: "."))"
    case .complete: return "complete"
    }
  }

  // MARK: - Private Helper Methods

  private func getValidPropertyNames(at path: [String]) -> Set<String> {
    // Get valid property names from schema based on current path
    var validNames = Set<String>()

    // Start at root and traverse down the path
    var currentNode = schema.root

    // Navigate to the current path location in schema
    for pathComponent in path {
      guard let childNode = currentNode.properties[pathComponent] else {
        // Path doesn't exist in schema
        return Set()
      }
      currentNode = childNode
    }

    // Get all valid property names at this location
    for (propName, _) in currentNode.properties {
      validNames.insert(propName)
    }

    return validNames
  }

  private func getPropertySchema(name: String, at path: [String]) -> SchemaNode? {
    // Find property schema based on name and path
    var currentNode = schema.root

    // Navigate to the current path location in schema
    for pathComponent in path {
      guard let childNode = currentNode.properties[pathComponent] else {
        // Path doesn't exist in schema
        return nil
      }
      currentNode = childNode
    }

    // Return the specific property schema at this location
    return currentNode.properties[name]
  }

  private func isValidNumberSoFar(_ partial: String) -> Bool {
    // Check if the partial number string could be a valid number
    if partial.isEmpty || partial == "-" {
      return false
    }

    // Basic regex-like validation for JSON numbers
    let hasDigits = partial.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
    let validPattern =
      partial.range(
        of: #"^-?(\\d+\\.?\\d*|\\d*\\.\\d+)([eE][+-]?\\d+)?$"#, options: .regularExpression)
      != nil

    return hasDigits && validPattern
  }

  private func couldBeValidNumber(_ partial: String) -> Bool {
    // More lenient check - could this eventually become a valid number?
    if partial.isEmpty {
      return true
    }

    // Check for basic patterns that could lead to valid numbers
    let basicPattern =
      partial.range(of: #"^-?(\\d*\\.?\\d*)?([eE][+-]?\\d*)?$"#, options: .regularExpression) != nil

    return basicPattern
  }

  private func getValidValueStartCharacters(for type: SchemaType) -> Set<Character> {
    switch type {
    case .string:
      return ["\""]
    case .number, .integer:
      return Set("0123456789-")
    case .boolean:
      return ["t", "f"]  // true, false
    case .null:
      return ["n"]  // null
    case .object:
      return ["{"]
    case .array:
      return ["["]
    case .any:
      var chars: Set<Character> = ["\"", "{", "[", "t", "f", "n"]
      chars.formUnion(Set("0123456789-"))
      return chars
    }
  }

  private func getCurrentPath() -> [String] {
    switch state {
    case .inObject(let path), .expectingPropertyName(let path),
      .inPropertyName(let path, _), .afterPropertyName(let path, _),
      .expectingColon(let path, _), .expectingValue(let path, _, _),
      .inStringValue(let path, _, _), .inNumberValue(let path, _, _),
      .inBooleanValue(let path, _, _), .inNullValue(let path, _, _), .inArray(let path, _, _, _),
      .inArrayStringElement(let path, _, _, _, _), .inArrayNumberElement(let path, _, _, _, _),
      .inArrayBooleanElement(let path, _, _, _, _), .inArrayNullElement(let path, _, _, _, _),
      .afterValue(let path):
      return path
    default:
      return []
    }
  }
}
