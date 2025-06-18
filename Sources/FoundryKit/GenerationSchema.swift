import Foundation

/// A runtime representation of a generation schema for guided generation
public struct RuntimeGenerationSchema {
    public let root: SchemaNode
    public let dependencies: [SchemaNode]
    
    /// Initialize from a Generable type
    public init<T: Generable>(from type: T.Type) {
        self.root = SchemaNode(from: type)
        self.dependencies = []
    }
    
    /// Initialize with a dynamic schema
    public init(root: DynamicGenerationSchema, dependencies: [DynamicGenerationSchema] = []) throws {
        self.root = try SchemaNode(from: root)
        self.dependencies = try dependencies.map { try SchemaNode(from: $0) }
    }
    
    /// Get valid properties at a given path
    public func getValidProperties(at path: [String]) -> Set<String> {
        return root.getValidProperties(at: path)
    }
    
    /// Get the schema type for a property at a given path
    public func getSchemaType(at path: [String], property: String) -> SchemaType? {
        return root.getSchemaType(at: path, property: property)
    }
}

/// Node representation for schema traversal
public struct SchemaNode {
    let name: String
    let type: SchemaType
    let properties: [String: SchemaNode]
    let required: Set<String>
    let constraints: [Constraint]
    
    /// Initialize from a Generable type using reflection
    init<T: Generable>(from type: T.Type) {
        self.name = String(describing: type)
        
        // Extract schema information from the Generable type
        let schema = type.generationSchema
        
        // Parse the schema dictionary
        if let schemaDict = type.generationSchema as? [String: Any],
           let typeStr = schemaDict["type"] as? String {
            
            switch typeStr {
            case "object":
                var props: [String: SchemaNode] = [:]
                var reqs = Set<String>()
                
                if let properties = schemaDict["properties"] as? [String: Any] {
                    for (key, value) in properties {
                        if let propDict = value as? [String: Any] {
                            props[key] = SchemaNode(from: propDict, name: key)
                        }
                    }
                }
                
                if let required = schemaDict["required"] as? [String] {
                    reqs = Set(required)
                }
                
                self.type = .object(properties: props.mapValues { $0.type })
                self.properties = props
                self.required = reqs
                
            case "array":
                if let items = schemaDict["items"] as? [String: Any] {
                    let itemNode = SchemaNode(from: items, name: "item")
                    self.type = .array(elementType: itemNode.type)
                } else {
                    self.type = .array(elementType: .string)
                }
                self.properties = [:]
                self.required = []
                
            case "string":
                self.type = .string
                self.properties = [:]
                self.required = []
                
            case "number", "integer":
                self.type = .number
                self.properties = [:]
                self.required = []
                
            case "boolean":
                self.type = .boolean
                self.properties = [:]
                self.required = []
                
            default:
                self.type = .string
                self.properties = [:]
                self.required = []
            }
        } else {
            self.type = .string
            self.properties = [:]
            self.required = []
        }
        
        // Extract constraints
        self.constraints = SchemaNode.extractConstraints(from: schema)
    }
    
    /// Initialize from a dictionary representation
    init(from dict: [String: Any], name: String) {
        self.name = name
        
        // Similar parsing logic as above
        if let typeStr = dict["type"] as? String {
            switch typeStr {
            case "object":
                var props: [String: SchemaNode] = [:]
                if let properties = dict["properties"] as? [String: Any] {
                    for (key, value) in properties {
                        if let propDict = value as? [String: Any] {
                            props[key] = SchemaNode(from: propDict, name: key)
                        }
                    }
                }
                self.type = .object(properties: props.mapValues { $0.type })
                self.properties = props
                
            case "array":
                if let items = dict["items"] as? [String: Any] {
                    let itemNode = SchemaNode(from: items, name: "item")
                    self.type = .array(elementType: itemNode.type)
                } else {
                    self.type = .array(elementType: .string)
                }
                self.properties = [:]
                
            case "string":
                self.type = .string
                self.properties = [:]
                
            case "number", "integer":
                self.type = .number
                self.properties = [:]
                
            case "boolean":
                self.type = .boolean
                self.properties = [:]
                
            default:
                self.type = .string
                self.properties = [:]
            }
            
            self.required = Set(dict["required"] as? [String] ?? [])
        } else {
            self.type = .string
            self.properties = [:]
            self.required = []
        }
        
        self.constraints = SchemaNode.extractConstraints(from: dict)
    }
    
    /// Initialize from a DynamicGenerationSchema
    init(from dynamic: DynamicGenerationSchema) throws {
        self.name = dynamic.name
        
        switch dynamic.type {
        case .object:
            var props: [String: SchemaNode] = [:]
            for property in dynamic.properties {
                props[property.name] = try SchemaNode(from: property.schema)
            }
            self.type = .object(properties: props.mapValues { $0.type })
            self.properties = props
            self.required = Set(dynamic.required)
            
        case .array:
            if let elementSchema = dynamic.items {
                let itemNode = try SchemaNode(from: elementSchema)
                self.type = .array(elementType: itemNode.type)
            } else {
                self.type = .array(elementType: .string)
            }
            self.properties = [:]
            self.required = []
            
        case .string:
            self.type = .string
            self.properties = [:]
            self.required = []
            
        case .number:
            self.type = .number
            self.properties = [:]
            self.required = []
            
        case .boolean:
            self.type = .boolean
            self.properties = [:]
            self.required = []
            
        case .null:
            self.type = .null
            self.properties = [:]
            self.required = []
        }
        
        self.constraints = dynamic.constraints.map { constraint in
            switch constraint {
            case .minLength(let min):
                return Constraint.minLength(min)
            case .maxLength(let max):
                return Constraint.maxLength(max)
            case .pattern(let pattern):
                return Constraint.pattern(pattern)
            case .minimum(let min):
                return Constraint.minimum(min)
            case .maximum(let max):
                return Constraint.maximum(max)
            case .enum(let values):
                return Constraint.enum(values)
            }
        }
    }
    
    /// Extract constraints from schema dictionary
    private static func extractConstraints(from schema: Any) -> [Constraint] {
        guard let dict = schema as? [String: Any] else { return [] }
        
        var constraints: [Constraint] = []
        
        if let minLength = dict["minLength"] as? Int {
            constraints.append(.minLength(minLength))
        }
        
        if let maxLength = dict["maxLength"] as? Int {
            constraints.append(.maxLength(maxLength))
        }
        
        if let pattern = dict["pattern"] as? String {
            constraints.append(.pattern(pattern))
        }
        
        if let minimum = dict["minimum"] as? Double {
            constraints.append(.minimum(minimum))
        }
        
        if let maximum = dict["maximum"] as? Double {
            constraints.append(.maximum(maximum))
        }
        
        if let enumValues = dict["enum"] as? [Any] {
            constraints.append(.enum(enumValues))
        }
        
        return constraints
    }
    
    /// Get valid properties at a given path
    func getValidProperties(at path: [String]) -> Set<String> {
        if path.isEmpty {
            return Set(properties.keys)
        }
        
        guard let firstKey = path.first,
              let node = properties[firstKey] else {
            return []
        }
        
        return node.getValidProperties(at: Array(path.dropFirst()))
    }
    
    /// Get schema type for a property
    func getSchemaType(at path: [String], property: String) -> SchemaType? {
        if path.isEmpty {
            return properties[property]?.type
        }
        
        guard let firstKey = path.first,
              let node = properties[firstKey] else {
            return nil
        }
        
        return node.getSchemaType(at: Array(path.dropFirst()), property: property)
    }
}

/// Constraint types for schema validation
public enum Constraint {
    case minLength(Int)
    case maxLength(Int)
    case pattern(String)
    case minimum(Double)
    case maximum(Double)
    case `enum`([Any])
}

/// Dynamic schema builder for runtime schema creation
public final class DynamicGenerationSchema {
    public let name: String
    public let type: SchemaType
    public var properties: [Property] = []
    public var required: [String] = []
    public var items: DynamicGenerationSchema?
    public var constraints: [DynamicConstraint] = []
    public var anyOf: [String]?
    
    /// Property definition for object schemas
    public final class Property {
        public let name: String
        public let schema: DynamicGenerationSchema
        
        public init(name: String, schema: DynamicGenerationSchema) {
            self.name = name
            self.schema = schema
        }
    }
    
    /// Dynamic constraint definition
    public enum DynamicConstraint {
        case minLength(Int)
        case maxLength(Int)
        case pattern(String)
        case minimum(Double)
        case maximum(Double)
        case `enum`([String])
    }
    
    /// Initialize with basic type
    public init(name: String, type: SchemaType = .object(properties: [:])) {
        self.name = name
        self.type = type
    }
    
    /// Initialize with enum values
    public init(name: String, anyOf values: [String]) {
        self.name = name
        self.type = .string
        self.anyOf = values
        self.constraints = [.enum(values)]
    }
    
    /// Add a property (for object types)
    public func addProperty(_ property: Property, required: Bool = false) {
        properties.append(property)
        if required {
            self.required.append(property.name)
        }
    }
    
    /// Add a constraint
    public func addConstraint(_ constraint: DynamicConstraint) {
        constraints.append(constraint)
    }
}

/// Extension to SchemaType to make it public
extension SchemaType {
    public init(from string: String) {
        switch string {
        case "string": self = .string
        case "number", "integer": self = .number
        case "boolean": self = .boolean
        case "array": self = .array(elementType: .string)
        case "object": self = .object(properties: [:])
        case "null": self = .null
        default: self = .string
        }
    }
}