

├── .github
    └── workflows
    │   └── swift.yml
├── .gitignore
├── .pre-commit-config.yaml
├── .swift-format
├── LICENSE
├── Package.resolved
├── Package.swift
├── README.md
├── Sources
    ├── Ast.swift
    ├── Environment.swift
    ├── Error.swift
    ├── Extensions
    │   └── StringExtension.swift
    ├── Lexer.swift
    ├── Parser.swift
    ├── Runtime.swift
    ├── Template.swift
    └── Utilities.swift
└── Tests
    ├── CoreTagTests.swift
    ├── FilterTests.swift
    ├── InterpreterTests.swift
    ├── LexerTests.swift
    ├── ParseTests.swift
    ├── Templates
        ├── ChatTemplateTests.swift
        ├── ChatTemplates.swift
        ├── DateFormatTests.swift
        ├── Messages.swift
        ├── ToolSpecs.swift
        ├── ToolUseTests.swift
        └── VisionTests.swift
    └── TestTests.swift


/.github/workflows/swift.yml:
--------------------------------------------------------------------------------
 1 | # This workflow will build a Swift project
 2 | # For more information see: https://docs.github.com/en/actions/automating-builds-and-tests/building-and-testing-swift
 3 | 
 4 | name: Swift
 5 | 
 6 | on:
 7 |   push:
 8 |     branches: [ "main" ]
 9 |   pull_request:
10 |     branches: [ "main" ]
11 | 
12 | jobs:
13 |   build:
14 |     name: Swift ${{ matrix.swift }} on Xcode ${{ matrix.xcode }}
15 |     strategy:
16 |       matrix:
17 |         include:
18 |           - swift: "5.9"
19 |             xcode: "15.2"
20 |           - swift: "5.10"
21 |             xcode: "15.2"
22 |     runs-on: macos-14
23 | 
24 |     steps:
25 |     - uses: actions/checkout@v4
26 | 
27 |     - name: Select Xcode
28 |       run: sudo xcode-select -s /Applications/Xcode_${{ matrix.xcode }}.app
29 | 
30 |     - name: Set up Swift
31 |       uses: swift-actions/setup-swift@v2
32 |       with:
33 |         swift-version: ${{ matrix.swift }}
34 | 
35 |     - name: Install swift-format
36 |       run: brew install swift-format
37 | 
38 |     - name: Run swift-format
39 |       if: ${{ matrix.swift == '5.9' }}
40 |       run: swift-format lint --recursive . --strict
41 | 
42 |     - name: Build
43 |       run: swift build -v
44 | 
45 |     - name: Run tests
46 |       run: swift test -v
47 | 


--------------------------------------------------------------------------------
/.gitignore:
--------------------------------------------------------------------------------
  1 | # Xcode
  2 | #
  3 | # gitignore contributors: remember to update Global/Xcode.gitignore, Objective-C.gitignore & Swift.gitignore
  4 | 
  5 | ## User settings
  6 | xcuserdata/
  7 | 
  8 | ## compatibility with Xcode 8 and earlier (ignoring not required starting Xcode 9)
  9 | *.xcscmblueprint
 10 | *.xccheckout
 11 | 
 12 | ## compatibility with Xcode 3 and earlier (ignoring not required starting Xcode 4)
 13 | build/
 14 | DerivedData/
 15 | *.moved-aside
 16 | *.pbxuser
 17 | !default.pbxuser
 18 | *.mode1v3
 19 | !default.mode1v3
 20 | *.mode2v3
 21 | !default.mode2v3
 22 | *.perspectivev3
 23 | !default.perspectivev3
 24 | 
 25 | ## Obj-C/Swift specific
 26 | *.hmap
 27 | 
 28 | ## App packaging
 29 | *.ipa
 30 | *.dSYM.zip
 31 | *.dSYM
 32 | 
 33 | ## Playgrounds
 34 | timeline.xctimeline
 35 | playground.xcworkspace
 36 | 
 37 | # Swift Package Manager
 38 | #
 39 | # Add this line if you want to avoid checking in source code from Swift Package Manager dependencies.
 40 | # Packages/
 41 | # Package.pins
 42 | # Package.resolved
 43 | # *.xcodeproj
 44 | #
 45 | # Xcode automatically generates this directory with a .xcworkspacedata file and xcuserdata
 46 | # hence it is not needed unless you have added a package configuration file to your project
 47 | # .swiftpm
 48 | 
 49 | .build/
 50 | 
 51 | # CocoaPods
 52 | #
 53 | # We recommend against adding the Pods directory to your .gitignore. However
 54 | # you should judge for yourself, the pros and cons are mentioned at:
 55 | # https://guides.cocoapods.org/using/using-cocoapods.html#should-i-check-the-pods-directory-into-source-control
 56 | #
 57 | # Pods/
 58 | #
 59 | # Add this line if you want to avoid checking in source code from the Xcode workspace
 60 | # *.xcworkspace
 61 | 
 62 | # Carthage
 63 | #
 64 | # Add this line if you want to avoid checking in source code from Carthage dependencies.
 65 | # Carthage/Checkouts
 66 | 
 67 | Carthage/Build/
 68 | 
 69 | # Accio dependency management
 70 | Dependencies/
 71 | .accio/
 72 | 
 73 | # fastlane
 74 | #
 75 | # It is recommended to not store the screenshots in the git repo.
 76 | # Instead, use fastlane to re-generate the screenshots whenever they are needed.
 77 | # For more information about the recommended setup visit:
 78 | # https://docs.fastlane.tools/best-practices/source-control/#source-control
 79 | 
 80 | fastlane/report.xml
 81 | fastlane/Preview.html
 82 | fastlane/screenshots/**/*.png
 83 | fastlane/test_output
 84 | 
 85 | # Code Injection
 86 | #
 87 | # After new code Injection tools there's a generated folder /iOSInjectionProject
 88 | # https://github.com/johnno1962/injectionforxcode
 89 | 
 90 | iOSInjectionProject/
 91 | 
 92 | .DS_Store
 93 | /.build
 94 | /Packages
 95 | .netrc
 96 | .idea
 97 | .swiftpm
 98 | 
 99 | # Specific to this package
100 | 
101 | *.code-workspace
102 | 


--------------------------------------------------------------------------------
/.pre-commit-config.yaml:
--------------------------------------------------------------------------------
1 | repos:
2 | - repo: https://github.com/slessans/pre-commit-swift-format
3 |   rev: "fd627de92bdf84a75c924ed95691336d14e94cf1"
4 |   hooks:
5 |     - id: swift-format
6 |       args: ["--configuration", ".swift-format"]
7 | 


--------------------------------------------------------------------------------
/.swift-format:
--------------------------------------------------------------------------------
 1 | {
 2 |   "version": 1,
 3 |   "indentation": {
 4 |     "spaces": 4
 5 |   },
 6 |   "lineLength": 120,
 7 |   "maximumBlankLines": 1,
 8 |   "respectsExistingLineBreaks": true,
 9 |   "lineBreakBeforeEachArgument": true,
10 |   "multiElementCollectionTrailingCommas": true,
11 |   "spacesAroundRangeFormationOperators": true,
12 |   "rules": {
13 |     "AlwaysUseLowerCamelCase": false
14 |   }
15 | }
16 | 


--------------------------------------------------------------------------------
/LICENSE:
--------------------------------------------------------------------------------
 1 | MIT License
 2 | 
 3 | Copyright (c) 2024 John Mai
 4 | 
 5 | Permission is hereby granted, free of charge, to any person obtaining a copy
 6 | of this software and associated documentation files (the "Software"), to deal
 7 | in the Software without restriction, including without limitation the rights
 8 | to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 9 | copies of the Software, and to permit persons to whom the Software is
10 | furnished to do so, subject to the following conditions:
11 | 
12 | The above copyright notice and this permission notice shall be included in all
13 | copies or substantial portions of the Software.
14 | 
15 | THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
16 | IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
17 | FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
18 | AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
19 | LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
20 | OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
21 | SOFTWARE.
22 | 


--------------------------------------------------------------------------------
/Package.resolved:
--------------------------------------------------------------------------------
 1 | {
 2 |   "pins" : [
 3 |     {
 4 |       "identity" : "swift-collections",
 5 |       "kind" : "remoteSourceControl",
 6 |       "location" : "https://github.com/apple/swift-collections.git",
 7 |       "state" : {
 8 |         "revision" : "671108c96644956dddcd89dd59c203dcdb36cec7",
 9 |         "version" : "1.1.4"
10 |       }
11 |     }
12 |   ],
13 |   "version" : 2
14 | }
15 | 


--------------------------------------------------------------------------------
/Package.swift:
--------------------------------------------------------------------------------
 1 | // swift-tools-version: 5.8
 2 | // The swift-tools-version declares the minimum version of Swift required to build this package.
 3 | 
 4 | import PackageDescription
 5 | 
 6 | let package = Package(
 7 |     name: "Jinja",
 8 |     platforms: [.iOS(.v16), .macOS(.v13)],
 9 |     products: [
10 |         // Products define the executables and libraries a package produces, making them visible to other packages.
11 |         .library(
12 |             name: "Jinja",
13 |             targets: ["Jinja"]
14 |         )
15 |     ],
16 |     dependencies: [
17 |         .package(url: "https://github.com/apple/swift-collections.git", from: "1.1.4")
18 |     ],
19 |     targets: [
20 |         // Targets are the basic building blocks of a package, defining a module or a test suite.
21 |         // Targets can depend on other targets in this package and products from dependencies.
22 |         .target(
23 |             name: "Jinja",
24 |             dependencies: [
25 |                 .product(name: "OrderedCollections", package: "swift-collections")
26 |             ],
27 |             path: "Sources",
28 |             swiftSettings: [.enableUpcomingFeature("BareSlashRegexLiterals")]
29 |         ),
30 |         .testTarget(
31 |             name: "JinjaTests",
32 |             dependencies: [
33 |                 "Jinja"
34 |             ],
35 |             path: "Tests",
36 |             swiftSettings: [.enableUpcomingFeature("BareSlashRegexLiterals")]
37 |         ),
38 |     ]
39 | )
40 | 


--------------------------------------------------------------------------------
/README.md:
--------------------------------------------------------------------------------
 1 | # Jinja
 2 | A minimalistic Swift implementation of the Jinja templating engine, specifically designed for parsing and rendering ML chat templates.
 3 | 
 4 | ## SwiftPM
 5 | 
 6 | To use `Jinja` with SwiftPM, you can add this to your `Package.swift`:
 7 | 
 8 | ```
 9 | dependencies: [
10 |     .package(url: "https://github.com/maiqingqiang/Jinja", branch: "main")
11 | ]
12 | ```
13 | 
14 | And then, add the Transformers library as a dependency to your target:
15 | 
16 | ```
17 | targets: [
18 |     .target(
19 |         name: "YourTargetName",
20 |         dependencies: [
21 |             .product(name: "Jinja", package: "Jinja")
22 |         ]
23 |     )
24 | ]
25 | ```
26 | 
27 | ## Usage
28 | 
29 | ```swift
30 | import Jinja
31 | 
32 | let template = """
33 | {% for item in items %}
34 | {{ item }}
35 | {% endfor %}
36 | """
37 | 
38 | let context = [
39 |     "items": [
40 |         "item1", 
41 |         "item2", 
42 |         "item3"
43 |     ]
44 | ]
45 | 
46 | let result = try Template(template).render(context)
47 | ```


--------------------------------------------------------------------------------
/Sources/Ast.swift:
--------------------------------------------------------------------------------
  1 | //
  2 | //  Ast.swift
  3 | //
  4 | //
  5 | //  Created by John Mai on 2024/3/20.
  6 | //
  7 | 
  8 | import Foundation
  9 | import OrderedCollections
 10 | 
 11 | protocol Statement {}
 12 | 
 13 | struct Program: Statement {
 14 |     var body: [Statement] = []
 15 | }
 16 | 
 17 | protocol Expression: Statement {}
 18 | 
 19 | protocol Literal: Expression {
 20 |     associatedtype T
 21 |     var value: T { get set }
 22 | }
 23 | 
 24 | struct StringLiteral: Literal {
 25 |     var value: String
 26 | }
 27 | 
 28 | struct NumericLiteral: Literal {
 29 |     var value: any Numeric
 30 | }
 31 | 
 32 | struct BoolLiteral: Literal {
 33 |     var value: Bool
 34 | }
 35 | 
 36 | struct ArrayLiteral: Literal {
 37 |     var value: [Expression]
 38 | }
 39 | 
 40 | struct TupleLiteral: Literal {
 41 |     var value: [Expression]
 42 | }
 43 | 
 44 | struct ObjectLiteral: Literal {
 45 |     var value: OrderedDictionary<String, Expression>
 46 | }
 47 | 
 48 | struct Set: Statement {
 49 |     var assignee: Expression
 50 |     var value: Expression
 51 | }
 52 | 
 53 | struct If: Statement, Expression {
 54 |     var test: Expression
 55 |     var body: [Statement]
 56 |     var alternate: [Statement]
 57 | }
 58 | 
 59 | struct Identifier: Expression {
 60 |     var value: String
 61 | }
 62 | 
 63 | typealias Loopvar = Expression
 64 | 
 65 | struct For: Statement {
 66 |     var loopvar: Loopvar
 67 |     var iterable: Expression
 68 |     var body: [Statement]
 69 |     var defaultBlock: [Statement]
 70 |     var test: Expression?
 71 | }
 72 | 
 73 | struct MemberExpression: Expression {
 74 |     var object: Expression
 75 |     var property: Expression
 76 |     var computed: Bool
 77 | }
 78 | 
 79 | struct CallExpression: Expression {
 80 |     var callee: Expression
 81 |     var args: [Expression]
 82 | }
 83 | 
 84 | struct BinaryExpression: Expression {
 85 |     var operation: Token
 86 |     var left: Expression
 87 |     var right: Expression
 88 | }
 89 | 
 90 | protocol Filter {}
 91 | extension Identifier: Filter {}
 92 | extension CallExpression: Filter {}
 93 | 
 94 | struct FilterExpression: Expression {
 95 |     var operand: Expression
 96 |     var filter: Identifier
 97 |     var args: [Expression]
 98 |     var kwargs: [KeywordArgumentExpression]
 99 |     var dyn_args: Expression?
100 |     var dyn_kwargs: Expression?
101 | }
102 | 
103 | struct TestExpression: Expression {
104 |     var operand: Expression
105 |     var negate: Bool
106 |     var test: Identifier
107 | }
108 | 
109 | struct UnaryExpression: Expression {
110 |     var operation: Token
111 |     var argument: Expression
112 | }
113 | 
114 | struct LogicalNegationExpression: Expression {
115 |     var argument: Expression
116 | }
117 | 
118 | struct SliceExpression: Expression {
119 |     var start: Expression?
120 |     var stop: Expression?
121 |     var step: Expression?
122 | }
123 | 
124 | struct KeywordArgumentExpression: Expression {
125 |     var key: Identifier
126 |     var value: any Expression
127 | }
128 | 
129 | struct NullLiteral: Literal {
130 |     var value: Any? = nil
131 | }
132 | 
133 | struct SelectExpression: Expression {
134 |     var iterable: Expression
135 |     var test: Expression
136 | }
137 | 
138 | struct Macro: Statement {
139 |     var name: Identifier
140 |     var args: [Expression]
141 |     var body: [Statement]
142 | }
143 | 
144 | struct KeywordArgumentsValue: RuntimeValue {
145 |     var value: [String: any RuntimeValue]
146 |     var builtins: [String: any RuntimeValue] = [:]
147 | 
148 |     func bool() -> Bool {
149 |         !value.isEmpty
150 |     }
151 | }
152 | 


--------------------------------------------------------------------------------
/Sources/Environment.swift:
--------------------------------------------------------------------------------
   1 | //
   2 | //  Environment.swift
   3 | //
   4 | //
   5 | //  Created by John Mai on 2024/3/23.
   6 | //
   7 | 
   8 | import Foundation
   9 | import OrderedCollections
  10 | 
  11 | class Environment {
  12 |     var parent: Environment?
  13 | 
  14 |     var variables: [String: any RuntimeValue] = [
  15 |         "namespace": FunctionValue(value: { args, _ in
  16 |             if args.isEmpty {
  17 |                 return ObjectValue(value: [:])
  18 |             }
  19 |             guard args.count == 1, let objectArg = args[0] as? ObjectValue else {
  20 |                 throw JinjaError.runtime("`namespace` expects either zero arguments or a single object argument")
  21 |             }
  22 |             return objectArg
  23 |         }),
  24 | 
  25 |         // Add strftime_now function to handle date formatting in templates
  26 |         "strftime_now": FunctionValue(value: { args, _ in
  27 |             let now = Date()
  28 | 
  29 |             if args.count > 0, let formatArg = args[0] as? StringValue {
  30 |                 let format = formatArg.value
  31 | 
  32 |                 let result = formatDate(now, withFormat: format)
  33 |                 return StringValue(value: result)
  34 |             }
  35 | 
  36 |             // Default format if no arguments
  37 |             let formatter = DateFormatter()
  38 |             formatter.dateFormat = "MMMM dd, yyyy"
  39 |             return StringValue(value: formatter.string(from: now))
  40 |         }),
  41 |     ]
  42 | 
  43 |     lazy var tests: [String: (any RuntimeValue...) throws -> Bool] = [
  44 |         "odd": { args in
  45 |             if let arg = args.first as? NumericValue, let intValue = arg.value as? Int {
  46 |                 return intValue % 2 != 0
  47 |             } else {
  48 |                 throw JinjaError.runtime(
  49 |                     "Cannot apply test 'odd' to type: \(type(of: args.first)) with value \(String(describing: args.first?.value))"
  50 |                 )
  51 |             }
  52 |         },
  53 |         "even": { args in
  54 |             if let arg = args.first as? NumericValue, let intValue = arg.value as? Int {
  55 |                 return intValue % 2 == 0
  56 |             } else {
  57 |                 throw JinjaError.runtime(
  58 |                     "Cannot apply test 'even' to type: \(type(of: args.first)) with value \(String(describing: args.first?.value))"
  59 |                 )
  60 |             }
  61 |         },
  62 |         "divisibleby": { args in
  63 |             guard let value = args[0] as? NumericValue,
  64 |                 let num = args[1] as? NumericValue,
  65 |                 let intValue = value.value as? Int,
  66 |                 let intNum = num.value as? Int
  67 |             else {
  68 |                 throw JinjaError.runtime("divisibleby test requires two integers")
  69 |             }
  70 |             return intValue % intNum == 0
  71 |         },
  72 |         "defined": { args in
  73 |             return !(args[0] is UndefinedValue)
  74 |         },
  75 |         "undefined": { args in
  76 |             return args[0] is UndefinedValue
  77 |         },
  78 |         "filter": { [weak self] (args: any RuntimeValue...) throws -> Bool in
  79 |             guard let name = args[0] as? StringValue else {
  80 |                 throw JinjaError.runtime("filter test requires a string")
  81 |             }
  82 |             return self?.filters.keys.contains(name.value) ?? false
  83 |         },
  84 |         "test": { [weak self] (args: any RuntimeValue...) throws -> Bool in
  85 |             guard let name = args[0] as? StringValue else {
  86 |                 throw JinjaError.runtime("test test requires a string")
  87 |             }
  88 |             return self?.tests.keys.contains(name.value) ?? false
  89 |         },
  90 |         "none": { args in
  91 |             return args[0] is NullValue
  92 |         },
  93 |         "boolean": { args in
  94 |             return args[0] is BooleanValue
  95 |         },
  96 |         "false": { args in
  97 |             if let arg = args[0] as? BooleanValue {
  98 |                 return !arg.value
  99 |             }
 100 |             return false
 101 |         },
 102 |         "true": { args in
 103 |             if let arg = args[0] as? BooleanValue {
 104 |                 return arg.value
 105 |             }
 106 |             return false
 107 |         },
 108 |         "integer": { args in
 109 |             if let arg = args[0] as? NumericValue {
 110 |                 return arg.value is Int
 111 |             }
 112 |             return false
 113 |         },
 114 |         "float": { args in
 115 |             if let numericValue = args[0] as? NumericValue {
 116 |                 return numericValue.value is Double
 117 |             }
 118 |             return false
 119 |         },
 120 |         "lower": { args in
 121 |             if let arg = args[0] as? StringValue {
 122 |                 return arg.value == arg.value.lowercased()
 123 |             }
 124 |             return false
 125 |         },
 126 |         "upper": { args in
 127 |             if let arg = args[0] as? StringValue {
 128 |                 return arg.value == arg.value.uppercased()
 129 |             }
 130 |             return false
 131 |         },
 132 |         "string": { args in
 133 |             return args[0] is StringValue
 134 |         },
 135 |         "mapping": { args in
 136 |             return args[0] is ObjectValue
 137 |         },
 138 |         "number": { args in
 139 |             return args[0] is NumericValue
 140 |         },
 141 |         "sequence": { args in
 142 |             let value = args[0]
 143 |             if value is ArrayValue || value is StringValue {
 144 |                 return true
 145 |             }
 146 |             return false
 147 |         },
 148 |         "iterable": { args in
 149 |             return args[0] is ArrayValue || args[0] is StringValue || args[0] is ObjectValue
 150 |         },
 151 |         "callable": { args in
 152 |             return args[0] is FunctionValue
 153 |         },
 154 |         // TODO: Implement "sameas"
 155 |         // TODO: Implement "escaped"
 156 |         "in": { args in
 157 |             guard let seq = args[1] as? ArrayValue else {
 158 |                 throw JinjaError.runtime("in test requires a sequence")
 159 |             }
 160 |             return seq.value.contains { item in
 161 |                 self.doEqualTo([args[0], item])
 162 |             }
 163 |         },
 164 |         "==": { args in self.doEqualTo(args) },
 165 |         "eq": { args in self.doEqualTo(args) },
 166 |         "equalto": { args in self.doEqualTo(args) },
 167 |         "!=": { args in
 168 |             guard args.count == 2 else {
 169 |                 throw JinjaError.runtime("!= test requires two arguments")
 170 |             }
 171 |             return !self.doEqualTo(args)
 172 |         },
 173 |         "ne": { args in
 174 |             guard args.count == 2 else {
 175 |                 throw JinjaError.runtime("ne test requires two arguments")
 176 |             }
 177 |             return !self.doEqualTo(args)
 178 |         },
 179 |         ">": { args in
 180 |             guard args.count == 2 else {
 181 |                 throw JinjaError.runtime("> test requires two arguments")
 182 |             }
 183 |             return try self.doGreaterThan(args)
 184 |         },
 185 |         "gt": { args in
 186 |             guard args.count == 2 else {
 187 |                 throw JinjaError.runtime("gt test requires two arguments")
 188 |             }
 189 |             return try self.doGreaterThan(args)
 190 |         },
 191 |         "greaterthan": { args in
 192 |             guard args.count == 2 else {
 193 |                 throw JinjaError.runtime("greaterthan test requires two arguments")
 194 |             }
 195 |             return try self.doGreaterThan(args)
 196 |         },
 197 |         ">=": { args in
 198 |             guard args.count == 2 else {
 199 |                 throw JinjaError.runtime(">= test requires two arguments")
 200 |             }
 201 |             return try self.doGreaterThanOrEqual(args)
 202 |         },
 203 |         "ge": { args in
 204 |             guard args.count == 2 else {
 205 |                 throw JinjaError.runtime("ge test requires two arguments")
 206 |             }
 207 |             return try self.doGreaterThanOrEqual(args)
 208 |         },
 209 |         "<": { args in
 210 |             guard args.count == 2 else {
 211 |                 throw JinjaError.runtime("< test requires two arguments")
 212 |             }
 213 |             return try self.doLessThan(args)
 214 |         },
 215 |         "lt": { args in
 216 |             guard args.count == 2 else {
 217 |                 throw JinjaError.runtime("lt test requires two arguments")
 218 |             }
 219 |             return try self.doLessThan(args)
 220 |         },
 221 |         "lessthan": { args in
 222 |             guard args.count == 2 else {
 223 |                 throw JinjaError.runtime("lessthan test requires two arguments")
 224 |             }
 225 |             return try self.doLessThan(args)
 226 |         },
 227 |         "<=": { args in
 228 |             guard args.count == 2 else {
 229 |                 throw JinjaError.runtime("<= test requires two arguments")
 230 |             }
 231 |             return try self.doLessThanOrEqual(args)
 232 |         },
 233 |         "le": { args in
 234 |             guard args.count == 2 else {
 235 |                 throw JinjaError.runtime("le test requires two arguments")
 236 |             }
 237 |             return try self.doLessThanOrEqual(args)
 238 |         },
 239 |     ]
 240 | 
 241 |     lazy var filters: [String: ([any RuntimeValue], Environment) throws -> any RuntimeValue] = [
 242 |         "abs": { args, env in
 243 |             guard args.count == 1 else {
 244 |                 throw JinjaError.runtime("abs filter requires exactly one argument, but \(args.count) were provided")
 245 |             }
 246 |             guard let numericValue = args[0] as? NumericValue else {
 247 |                 throw JinjaError.runtime("abs filter requires a number")
 248 |             }
 249 |             if let intValue = numericValue.value as? Int {
 250 |                 let absValue = abs(intValue)
 251 |                 return NumericValue(value: absValue)
 252 |             } else if let doubleValue = numericValue.value as? Double {
 253 |                 let absValue = abs(doubleValue)
 254 |                 return NumericValue(value: absValue)
 255 |             } else {
 256 |                 throw JinjaError.runtime("Unsupported numeric type for abs filter")
 257 |             }
 258 |         },
 259 |         "attr": { args, env in
 260 |             guard args.count >= 2 else {
 261 |                 throw JinjaError.runtime("attr filter requires an object and attribute name")
 262 |             }
 263 |             let obj = args[0]
 264 |             // Convert name to string (similar to str(name) in Python)
 265 |             let name: String
 266 |             if let stringValue = args[1] as? StringValue {
 267 |                 name = stringValue.value
 268 |             } else {
 269 |                 // Try to convert the name to string
 270 |                 do {
 271 |                     name = try stringify(args[1])
 272 |                 } catch {
 273 |                     return UndefinedValue()
 274 |                 }
 275 |             }
 276 |             // Handle different object types
 277 |             if let objectValue = obj as? ObjectValue {
 278 |                 // Return the raw value if it exists
 279 |                 if let value = objectValue.value[name] {
 280 |                     return value
 281 |                 }
 282 |             }
 283 |             // If attribute is not found, return undefined
 284 |             return UndefinedValue()
 285 |         },
 286 |         "batch": { args, env in
 287 |             guard let arrayValue = args[0] as? ArrayValue,
 288 |                 let linecount = args[1] as? NumericValue,
 289 |                 let count = linecount.value as? Int
 290 |             else {
 291 |                 throw JinjaError.runtime("batch filter requires an array and line count")
 292 |             }
 293 |             let fillWith = args.count > 2 ? args[2] : nil
 294 |             var result: [[any RuntimeValue]] = []
 295 |             var temp: [any RuntimeValue] = []
 296 |             for item in arrayValue.value {
 297 |                 if temp.count == count {
 298 |                     result.append(temp)
 299 |                     temp = []
 300 |                 }
 301 |                 temp.append(item)
 302 |             }
 303 |             if !temp.isEmpty {
 304 |                 if let fill = fillWith, temp.count < count {
 305 |                     temp += Array(repeating: fill, count: count - temp.count)
 306 |                 }
 307 |                 result.append(temp)
 308 |             }
 309 |             return ArrayValue(value: result.map { ArrayValue(value: $0) })
 310 |         },
 311 |         "capitalize": { args, env in
 312 |             guard let stringValue = args[0] as? StringValue else {
 313 |                 throw JinjaError.runtime("capitalize filter requires a string")
 314 |             }
 315 |             let str = stringValue.value
 316 |             guard let firstChar = str.first else {
 317 |                 return stringValue  // Empty string, return as is
 318 |             }
 319 |             return StringValue(value: String(firstChar).uppercased() + str.dropFirst().lowercased())
 320 |         },
 321 |         "center": { args, env in
 322 |             guard let stringValue = args[0] as? StringValue else {
 323 |                 throw JinjaError.runtime("center filter requires a string")
 324 |             }
 325 |             let width = (args.count > 1 && args[1] is NumericValue) ? (args[1] as! NumericValue).value as! Int : 80
 326 |             let str = stringValue.value
 327 | 
 328 |             // If string is longer than width, return original string
 329 |             if str.count >= width {
 330 |                 return stringValue
 331 |             }
 332 | 
 333 |             // Calculate total padding needed
 334 |             let padding = width - str.count
 335 | 
 336 |             // Calculate left and right padding
 337 |             // When padding is odd, the extra space goes to the right
 338 |             let leftPadding = padding / 2
 339 |             let rightPadding = padding - leftPadding  // This ensures extra padding goes to the right
 340 | 
 341 |             // Create padded string
 342 |             return StringValue(
 343 |                 value: String(repeating: " ", count: leftPadding) + str + String(repeating: " ", count: rightPadding)
 344 |             )
 345 |         },
 346 |         "count": { args, env in
 347 |             let value = args[0]
 348 |             if let arrayValue = value as? ArrayValue {
 349 |                 return NumericValue(value: arrayValue.value.count)
 350 |             } else if let stringValue = value as? StringValue {
 351 |                 return NumericValue(value: stringValue.value.count)
 352 |             } else if let objectValue = value as? ObjectValue {
 353 |                 return NumericValue(value: objectValue.value.count)
 354 |             }
 355 |             throw JinjaError.runtime("Cannot count value of type \(type(of: value))")
 356 |         },
 357 |         "d": { args, env in try self.doDefault(args, env) },
 358 |         "default": { args, env in try self.doDefault(args, env) },
 359 |         "dictsort": { args, env in
 360 |             guard let dict = args[0] as? ObjectValue else {
 361 |                 throw JinjaError.runtime("dictsort filter requires a dictionary")
 362 |             }
 363 |             let caseSensitive = args.count > 1 ? (args[1] as? BooleanValue)?.value ?? false : false
 364 |             let by = args.count > 2 ? (args[2] as? StringValue)?.value ?? "key" : "key"
 365 |             let reverse = args.count > 3 ? (args[3] as? BooleanValue)?.value ?? false : false
 366 |             let sortedDict = try dict.storage.sorted { (item1, item2) in
 367 |                 let a: Any, b: Any
 368 |                 if by == "key" {
 369 |                     a = item1.key
 370 |                     b = item2.key
 371 |                 } else if by == "value" {
 372 |                     a = item1.value
 373 |                     b = item2.value
 374 |                 } else {
 375 |                     throw JinjaError.runtime("Invalid 'by' argument for dictsort filter")
 376 |                 }
 377 |                 let result: Bool
 378 |                 if let aString = a as? String, let bString = b as? String {
 379 |                     result = caseSensitive ? aString < bString : aString.lowercased() < bString.lowercased()
 380 |                 } else if let aNumeric = a as? NumericValue, let bNumeric = b as? NumericValue {
 381 |                     if let aInt = aNumeric.value as? Int, let bInt = bNumeric.value as? Int {
 382 |                         result = aInt < bInt
 383 |                     } else if let aDouble = aNumeric.value as? Double, let bDouble = bNumeric.value as? Double {
 384 |                         result = aDouble < bDouble
 385 |                     } else {
 386 |                         throw JinjaError.runtime("Cannot compare values in dictsort filter")
 387 |                     }
 388 |                 } else {
 389 |                     throw JinjaError.runtime("Cannot compare values in dictsort filter")
 390 |                 }
 391 |                 return reverse ? !result : result
 392 |             }
 393 |             return ArrayValue(
 394 |                 value: sortedDict.map { (key, value) in
 395 |                     return ArrayValue(value: [StringValue(value: key), value])
 396 |                 }
 397 |             )
 398 |         },
 399 |         "e": { args, env in try self.doEscape(args, env) },
 400 |         "escape": { args, env in try self.doEscape(args, env) },
 401 |         "filesizeformat": { args, env in
 402 |             guard let value = args[0] as? NumericValue else {
 403 |                 throw JinjaError.runtime("filesizeformat filter requires a numeric value")
 404 |             }
 405 | 
 406 |             let size: Double
 407 |             if let intValue = value.value as? Int {
 408 |                 size = Double(intValue)
 409 |             } else if let doubleValue = value.value as? Double {
 410 |                 size = doubleValue
 411 |             } else {
 412 |                 throw JinjaError.runtime("filesizeformat filter requires a numeric value")
 413 |             }
 414 | 
 415 |             let binary = args.count > 1 ? (args[1] as? BooleanValue)?.value ?? false : false
 416 |             let units =
 417 |                 binary
 418 |                 ? [" Bytes", " KiB", " MiB", " GiB", " TiB", " PiB", " EiB", " ZiB", " YiB"]
 419 |                 : [" Bytes", " kB", " MB", " GB", " TB", " PB", " EB", " ZB", " YB"]
 420 |             let base: Double = binary ? 1024.0 : 1000.0
 421 | 
 422 |             if size < base {
 423 |                 return StringValue(value: "\(Int(size)) Bytes")
 424 |             }
 425 | 
 426 |             let exp = Int(log(size) / log(base))
 427 |             let unit = units[min(exp, units.count - 1)]
 428 |             let num = size / pow(base, Double(exp))
 429 |             return StringValue(value: String(format: "%.1f%@", num, unit))
 430 |         },
 431 |         "first": { args, env in
 432 |             guard let arrayValue = args[0] as? ArrayValue else {
 433 |                 throw JinjaError.runtime("first filter requires an array")
 434 |             }
 435 |             return arrayValue.value.first ?? UndefinedValue()
 436 |         },
 437 |         "float": { args, env in
 438 |             guard let value = args[0] as? NumericValue else {
 439 |                 return NumericValue(value: 0.0)
 440 |             }
 441 |             if let doubleValue = value.value as? Double {
 442 |                 return NumericValue(value: doubleValue)
 443 |             } else if let intValue = value.value as? Int {
 444 |                 return NumericValue(value: Double(intValue))
 445 |             } else {
 446 |                 return NumericValue(value: 0.0)
 447 |             }
 448 |         },
 449 |         "forceescape": { args, env in
 450 |             guard let stringValue = args[0] as? StringValue else {
 451 |                 throw JinjaError.runtime("forceescape filter requires a string")
 452 |             }
 453 |             return StringValue(
 454 |                 value: stringValue.value.replacingOccurrences(of: "&", with: "&amp;")
 455 |                     .replacingOccurrences(of: "<", with: "&lt;")
 456 |                     .replacingOccurrences(of: ">", with: "&gt;")
 457 |                     .replacingOccurrences(of: "\"", with: "&quot;")
 458 |                     .replacingOccurrences(of: "'", with: "&#39;")
 459 |             )
 460 |         },
 461 |         "format": { args, env in
 462 |             guard let format = args[0] as? StringValue else {
 463 |                 throw JinjaError.runtime("format filter requires a format string")
 464 |             }
 465 |             // Get the values after the format string
 466 |             let formatArgs = Array(args.dropFirst())
 467 |             // Convert the values to strings
 468 |             let formatValues = formatArgs.map { arg -> String in
 469 |                 if let stringValue = arg as? StringValue {
 470 |                     return stringValue.value
 471 |                 } else if let numericValue = arg as? NumericValue {
 472 |                     if let intValue = numericValue.value as? Int {
 473 |                         return String(intValue)
 474 |                     } else if let doubleValue = numericValue.value as? Double {
 475 |                         return String(doubleValue)
 476 |                     }
 477 |                 }
 478 |                 return String(describing: arg)
 479 |             }
 480 |             // Replace %s with values one by one
 481 |             var result = format.value
 482 |             for value in formatValues {
 483 |                 if let range = result.range(of: "%s") {
 484 |                     result.replaceSubrange(range, with: value)
 485 |                 } else if let range = result.range(of: "%d") {
 486 |                     result.replaceSubrange(range, with: value)
 487 |                 }
 488 |             }
 489 |             return StringValue(value: result)
 490 |         },
 491 |         "groupby": { args, env in
 492 |             guard let arrayValue = args[0] as? ArrayValue else {
 493 |                 throw JinjaError.runtime("groupby filter requires an array")
 494 |             }
 495 |             guard let attribute = args[1] as? StringValue else {
 496 |                 throw JinjaError.runtime("groupby filter requires an attribute name")
 497 |             }
 498 |             let defaultValue = args.count > 2 ? args[2] : nil
 499 |             let caseSensitive = args.count > 3 ? (args[3] as? BooleanValue)?.value ?? false : false
 500 | 
 501 |             // Helper function to get nested attribute value
 502 |             func getAttributeValue(_ obj: ObjectValue, _ path: String) -> any RuntimeValue {
 503 |                 let components = path.split(separator: ".")
 504 |                 var current: any RuntimeValue = obj
 505 | 
 506 |                 for component in components {
 507 |                     if let currentObj = current as? ObjectValue,
 508 |                         let value = currentObj.value[String(component)]
 509 |                     {
 510 |                         current = value
 511 |                     } else {
 512 |                         return defaultValue ?? UndefinedValue()
 513 |                     }
 514 |                 }
 515 |                 return current
 516 |             }
 517 | 
 518 |             // Sort the array first
 519 |             let sorted = arrayValue.value.sorted { (a, b) in
 520 |                 guard let aObj = a as? ObjectValue,
 521 |                     let bObj = b as? ObjectValue
 522 |                 else {
 523 |                     return false
 524 |                 }
 525 | 
 526 |                 let aValue = getAttributeValue(aObj, attribute.value)
 527 |                 let bValue = getAttributeValue(bObj, attribute.value)
 528 | 
 529 |                 if let aStr = aValue as? StringValue,
 530 |                     let bStr = bValue as? StringValue
 531 |                 {
 532 |                     let aCompare = caseSensitive ? aStr.value : aStr.value.lowercased()
 533 |                     let bCompare = caseSensitive ? bStr.value : bStr.value.lowercased()
 534 |                     return aCompare < bCompare
 535 |                 }
 536 |                 // Add other comparison types as needed
 537 |                 return false
 538 |             }
 539 | 
 540 |             // Group the sorted array
 541 |             var groups: [(grouper: any RuntimeValue, list: [any RuntimeValue])] = []
 542 |             var currentGroup: [any RuntimeValue] = []
 543 |             var currentKey: (any RuntimeValue)? = nil  // Changed to var and explicitly initialized as nil
 544 | 
 545 |             for item in sorted {
 546 |                 guard let obj = item as? ObjectValue else { continue }
 547 |                 let value = getAttributeValue(obj, attribute.value)
 548 |                 let key =
 549 |                     caseSensitive
 550 |                     ? value : (value as? StringValue).map { StringValue(value: $0.value.lowercased()) } ?? value
 551 | 
 552 |                 if let existingKey = currentKey {  // Changed to different name for binding
 553 |                     if self.doEqualTo([key, existingKey]) {
 554 |                         currentGroup.append(item)
 555 |                     } else {
 556 |                         if !currentGroup.isEmpty {
 557 |                             // Use the first item's actual value as the grouper
 558 |                             if let firstObj = currentGroup[0] as? ObjectValue {
 559 |                                 let grouper = getAttributeValue(firstObj, attribute.value)
 560 |                                 groups.append((grouper: grouper, list: currentGroup))
 561 |                             }
 562 |                         }
 563 |                         currentGroup = [item]
 564 |                         currentKey = key  // Now works because currentKey is var
 565 |                     }
 566 |                 } else {
 567 |                     currentGroup = [item]
 568 |                     currentKey = key
 569 |                 }
 570 |             }
 571 | 
 572 |             // Add the last group
 573 |             if !currentGroup.isEmpty {
 574 |                 if let firstObj = currentGroup[0] as? ObjectValue {
 575 |                     let grouper = getAttributeValue(firstObj, attribute.value)
 576 |                     groups.append((grouper: grouper, list: currentGroup))
 577 |                 }
 578 |             }
 579 | 
 580 |             // Convert groups to array of objects with 'grouper' and 'list' keys
 581 |             return ArrayValue(
 582 |                 value: groups.map { group in
 583 |                     ObjectValue(value: [
 584 |                         "grouper": group.grouper,
 585 |                         "list": ArrayValue(value: group.list),
 586 |                     ])
 587 |                 }
 588 |             )
 589 |         },
 590 |         "indent": { args, env in
 591 |             guard let stringValue = args[0] as? StringValue else {
 592 |                 throw JinjaError.runtime("indent filter requires a string")
 593 |             }
 594 |             // Determine indentation width
 595 |             var indent: String
 596 |             if args.count > 1 {
 597 |                 if let width = args[1] as? NumericValue, let intWidth = width.value as? Int {
 598 |                     indent = String(repeating: " ", count: intWidth)
 599 |                 } else if let stringWidth = args[1] as? StringValue {
 600 |                     indent = stringWidth.value
 601 |                 } else {
 602 |                     indent = String(repeating: " ", count: 4)  // Default
 603 |                 }
 604 |             } else {
 605 |                 indent = String(repeating: " ", count: 4)  // Default
 606 |             }
 607 |             let first = args.count > 2 ? (args[2] as? BooleanValue)?.value ?? false : false
 608 |             let blank = args.count > 3 ? (args[3] as? BooleanValue)?.value ?? false : false
 609 |             // Add a newline to the end of the string (Python quirk)
 610 |             let modifiedStringValue = stringValue.value + "\n"
 611 |             // Split into lines
 612 |             var lines = modifiedStringValue.components(separatedBy: "\n")
 613 |             // Remove the last line (which is always empty due to the added newline)
 614 |             lines.removeLast()
 615 |             if lines.isEmpty {
 616 |                 return StringValue(value: "")
 617 |             }
 618 |             var result: String
 619 |             // Handle first line
 620 |             if first {
 621 |                 result = indent + lines[0]
 622 |             } else {
 623 |                 result = lines[0]
 624 |             }
 625 |             // Process remaining lines
 626 |             if lines.count > 1 {
 627 |                 let remainingLines = lines.dropFirst().map { line -> String in
 628 |                     if line.isEmpty {
 629 |                         return blank ? indent + line : line
 630 |                     } else {
 631 |                         return indent + line
 632 |                     }
 633 |                 }
 634 |                 result += "\n" + remainingLines.joined(separator: "\n")
 635 |             }
 636 |             return StringValue(value: result)
 637 |         },
 638 |         "int": { args, env in
 639 |             if let numericValue = args[0] as? NumericValue {
 640 |                 if let intValue = numericValue.value as? Int {
 641 |                     return NumericValue(value: intValue)
 642 |                 } else if let doubleValue = numericValue.value as? Double {
 643 |                     return NumericValue(value: Int(doubleValue))
 644 |                 }
 645 |             } else if let stringValue = args[0] as? StringValue {
 646 |                 if let intValue = Int(stringValue.value) {
 647 |                     return NumericValue(value: intValue)
 648 |                 } else if let doubleValue = Double(stringValue.value) {
 649 |                     return NumericValue(value: Int(doubleValue))
 650 |                 }
 651 |             }
 652 |             // Return 0 for any other case (including invalid strings)
 653 |             return NumericValue(value: 0)
 654 |         },
 655 |         "items": { args, env in
 656 |             guard let value = args.first else {
 657 |                 throw JinjaError.runtime("items filter requires an argument")
 658 |             }
 659 |             // Handle undefined values by returning empty array
 660 |             if value is UndefinedValue {
 661 |                 return ArrayValue(value: [])
 662 |             }
 663 |             // Handle objects (mappings)
 664 |             if let objectValue = value as? ObjectValue {
 665 |                 return ArrayValue(
 666 |                     value: objectValue.storage.map { (key, value) in
 667 |                         ArrayValue(value: [StringValue(value: key), value])
 668 |                     }
 669 |                 )
 670 |             }
 671 | 
 672 |             throw JinjaError.runtime("Can only get item pairs from a mapping.")
 673 |         },
 674 |         "join": { args, env in
 675 |             guard let arrayValue = args[0] as? ArrayValue else {
 676 |                 throw JinjaError.runtime("join filter requires an array")
 677 |             }
 678 |             let separator = (args.count > 1 && args[1] is StringValue) ? (args[1] as! StringValue).value : ""
 679 |             // Convert all values to strings before joining
 680 |             let stringValues = try arrayValue.value.map { value -> String in
 681 |                 if let stringValue = value as? StringValue {
 682 |                     return stringValue.value
 683 |                 } else {
 684 |                     // Convert other types to string using stringify function
 685 |                     return try stringify(value)
 686 |                 }
 687 |             }
 688 |             return StringValue(value: stringValues.joined(separator: separator))
 689 |         },
 690 |         "last": { args, env in
 691 |             guard let arrayValue = args[0] as? ArrayValue else {
 692 |                 throw JinjaError.runtime("last filter requires an array")
 693 |             }
 694 |             return arrayValue.value.last ?? UndefinedValue()
 695 |         },
 696 |         "length": { args, env in
 697 |             guard let arg = args.first else {
 698 |                 throw JinjaError.runtime("length filter expects one argument")
 699 |             }
 700 | 
 701 |             if let arrayValue = arg as? ArrayValue {
 702 |                 return NumericValue(value: arrayValue.value.count)
 703 |             } else if let stringValue = arg as? StringValue {
 704 |                 return NumericValue(value: stringValue.value.count)
 705 |             } else if let objectValue = arg as? ObjectValue {
 706 |                 return NumericValue(value: objectValue.value.count)
 707 |             } else {
 708 |                 throw JinjaError.runtime("Cannot get length of type: \(type(of: arg))")
 709 |             }
 710 |         },
 711 |         "list": { args, env in
 712 |             guard let arrayValue = args[0] as? ArrayValue else {
 713 |                 throw JinjaError.runtime("list filter requires an array")
 714 |             }
 715 |             return arrayValue
 716 |         },
 717 |         "lower": { args, env in
 718 |             guard let stringValue = args[0] as? StringValue else {
 719 |                 throw JinjaError.runtime("lower filter requires a string")
 720 |             }
 721 |             return StringValue(value: stringValue.value.lowercased())
 722 |         },
 723 |         "map": { args, env in
 724 |             guard let arrayValue = args[0] as? ArrayValue else {
 725 |                 // Handle None/empty case
 726 |                 if args[0] is NullValue {
 727 |                     return ArrayValue(value: [])
 728 |                 }
 729 |                 throw JinjaError.runtime("map filter requires an array")
 730 |             }
 731 |             // Handle attribute mapping
 732 |             if args.count >= 2, let kwargs = args.last as? ObjectValue,
 733 |                 let attribute = kwargs.value["attribute"] as? StringValue
 734 |             {
 735 |                 let defaultValue = kwargs.value["default"]  // Get default value if provided
 736 |                 return ArrayValue(
 737 |                     value: arrayValue.value.map { item in
 738 |                         if let objectValue = item as? ObjectValue {
 739 |                             if let value = objectValue.value[attribute.value] {
 740 |                                 if value is UndefinedValue {
 741 |                                     // If value is explicitly undefined, return "None"
 742 |                                     return StringValue(value: "None")
 743 |                                 }
 744 |                                 if value is NullValue {
 745 |                                     // If value is explicitly null, return default if provided
 746 |                                     return defaultValue ?? StringValue(value: "None")
 747 |                                 }
 748 |                                 return value
 749 |                             } else {
 750 |                                 // If attribute doesn't exist, use default
 751 |                                 return defaultValue ?? StringValue(value: "None")
 752 |                             }
 753 |                         }
 754 |                         return defaultValue ?? StringValue(value: "None")
 755 |                     }
 756 |                 )
 757 |             }
 758 |             // Handle function mapping by name
 759 |             if let functionName = args[1] as? StringValue {
 760 |                 guard let filter = env.filters[functionName.value] else {
 761 |                     throw JinjaError.runtime("Unknown function: \(functionName.value)")
 762 |                 }
 763 |                 return ArrayValue(
 764 |                     value: try arrayValue.value.map { item in
 765 |                         try filter([item], env)
 766 |                     }
 767 |                 )
 768 |             }
 769 |             throw JinjaError.runtime("map filter requires either an attribute name or a function name")
 770 |         },
 771 |         "min": { args, env in
 772 |             guard let arrayValue = args[0] as? ArrayValue else {
 773 |                 throw JinjaError.runtime("min filter requires an array")
 774 |             }
 775 |             if arrayValue.value.isEmpty {
 776 |                 return UndefinedValue()
 777 |             }
 778 |             if let numericValues = arrayValue.value as? [NumericValue] {
 779 |                 let ints = numericValues.compactMap { $0.value as? Int }
 780 |                 let doubles = numericValues.compactMap { $0.value as? Double }
 781 |                 if !ints.isEmpty, doubles.isEmpty {
 782 |                     if let min = ints.min() {
 783 |                         return NumericValue(value: min)
 784 |                     } else {
 785 |                         throw JinjaError.runtime("min value of array in min filter could not be determined")
 786 |                     }
 787 |                 } else if !doubles.isEmpty, ints.isEmpty {
 788 |                     if let min = doubles.min() {
 789 |                         return NumericValue(value: min)
 790 |                     } else {
 791 |                         throw JinjaError.runtime("min value of array in min filter could not be determined")
 792 |                     }
 793 |                 } else {
 794 |                     throw JinjaError.runtime("min filter requires all array elements to be of type Int or Double")
 795 |                 }
 796 |             } else if let stringValues = arrayValue.value as? [StringValue] {
 797 |                 return StringValue(value: stringValues.map { $0.value }.min() ?? "")
 798 |             } else {
 799 |                 throw JinjaError.runtime("min filter requires an array of numbers or strings")
 800 |             }
 801 |         },
 802 |         "max": { args, env in
 803 |             guard let arrayValue = args[0] as? ArrayValue else {
 804 |                 throw JinjaError.runtime("max filter requires an array")
 805 |             }
 806 |             if arrayValue.value.isEmpty {
 807 |                 return UndefinedValue()
 808 |             }
 809 |             if let numericValues = arrayValue.value as? [NumericValue] {
 810 |                 let ints = numericValues.compactMap { $0.value as? Int }
 811 |                 let doubles = numericValues.compactMap { $0.value as? Double }
 812 |                 if !ints.isEmpty, doubles.isEmpty {
 813 |                     if let max = ints.max() {
 814 |                         return NumericValue(value: max)
 815 |                     } else {
 816 |                         throw JinjaError.runtime("max value of array in max filter cannot be determined")
 817 |                     }
 818 |                 } else if !doubles.isEmpty, ints.isEmpty {
 819 |                     if let max = doubles.max() {
 820 |                         return NumericValue(value: max)
 821 |                     } else {
 822 |                         throw JinjaError.runtime("max value of array in max filter cannot be determined")
 823 |                     }
 824 |                 } else {
 825 |                     throw JinjaError.runtime("max filter requires all array elements to be of type Int or Double")
 826 |                 }
 827 |             } else if let stringValues = arrayValue.value as? [StringValue] {
 828 |                 return StringValue(value: stringValues.map { $0.value }.max() ?? "")
 829 |             } else {
 830 |                 throw JinjaError.runtime("max filter requires an array of numbers or strings")
 831 |             }
 832 |         },
 833 |         "pprint": { args, env in
 834 |             guard let value = args.first else {
 835 |                 throw JinjaError.runtime("pprint filter expects one argument")
 836 |             }
 837 |             return StringValue(value: String(describing: value))
 838 |         },
 839 |         "random": { args, env in
 840 |             guard let arrayValue = args[0] as? ArrayValue else {
 841 |                 throw JinjaError.runtime("random filter requires an array")
 842 |             }
 843 |             if let randomIndex = arrayValue.value.indices.randomElement() {
 844 |                 return arrayValue.value[randomIndex]
 845 |             } else {
 846 |                 return UndefinedValue()
 847 |             }
 848 |         },
 849 |         "reject": { args, env in
 850 |             guard let arrayValue = args[0] as? ArrayValue else {
 851 |                 throw JinjaError.runtime("reject filter requires an array")
 852 |             }
 853 |             guard let testName = args[1] as? StringValue else {
 854 |                 throw JinjaError.runtime("reject filter requires a test name")
 855 |             }
 856 |             guard let test = env.tests[testName.value] else {
 857 |                 throw JinjaError.runtime("Unknown test '\(testName.value)'")
 858 |             }
 859 |             var result: [any RuntimeValue] = []
 860 |             for item in arrayValue.value {
 861 |                 // Correctly pass arguments to the test function
 862 |                 if try !test(item) {  // Negate the result for 'reject'
 863 |                     result.append(item)
 864 |                 }
 865 |             }
 866 |             return ArrayValue(value: result)
 867 |         },
 868 |         "rejectattr": { args, env in
 869 |             guard let arrayValue = args[0] as? ArrayValue else {
 870 |                 throw JinjaError.runtime("rejectattr filter requires an array")
 871 |             }
 872 |             guard let attribute = args[1] as? StringValue else {
 873 |                 throw JinjaError.runtime("rejectattr filter requires an attribute name")
 874 |             }
 875 |             var result: [any RuntimeValue] = []
 876 |             for item in arrayValue.value {
 877 |                 guard let objectValue = item as? ObjectValue,
 878 |                     let attrValue = objectValue.value[attribute.value]
 879 |                 else {
 880 |                     continue
 881 |                 }
 882 |                 if args.count == 2 {
 883 |                     if !attrValue.bool() {
 884 |                         result.append(item)
 885 |                     }
 886 |                 } else {
 887 |                     let testName = (args[2] as? StringValue)?.value ?? "defined"
 888 |                     guard let test = env.tests[testName] else {
 889 |                         throw JinjaError.runtime("Unknown test '\(testName)'")
 890 |                     }
 891 |                     // Correctly pass arguments to the test function
 892 |                     if try !test(attrValue) {  // Note the negation (!) for rejectattr
 893 |                         result.append(item)
 894 |                     }
 895 |                 }
 896 |             }
 897 |             return ArrayValue(value: result)
 898 |         },
 899 |         "replace": { args, env in
 900 |             guard let stringValue = args[0] as? StringValue else {
 901 |                 throw JinjaError.runtime("replace filter requires a string")
 902 |             }
 903 |             guard let oldValue = args[1] as? StringValue else {
 904 |                 throw JinjaError.runtime("replace filter requires an old value string")
 905 |             }
 906 |             guard let newValue = args[2] as? StringValue else {
 907 |                 throw JinjaError.runtime("replace filter requires a new value string")
 908 |             }
 909 |             let count = (args.count > 3 && args[3] is NumericValue) ? (args[3] as! NumericValue).value as! Int : Int.max
 910 |             return StringValue(
 911 |                 value: stringValue.value.replacingOccurrences(
 912 |                     of: oldValue.value,
 913 |                     with: newValue.value,
 914 |                     options: [],
 915 |                     range: nil
 916 |                 )
 917 |             )
 918 |         },
 919 |         "reverse": { args, env in
 920 |             guard let arrayValue = args[0] as? ArrayValue else {
 921 |                 throw JinjaError.runtime("reverse filter requires an array")
 922 |             }
 923 |             return ArrayValue(value: arrayValue.value.reversed())
 924 |         },
 925 |         "round": { args, env in
 926 |             guard let value = args[0] as? NumericValue, let number = value.value as? Double else {
 927 |                 throw JinjaError.runtime("round filter requires a number")
 928 |             }
 929 |             let precision = (args.count > 1 && args[1] is NumericValue) ? (args[1] as! NumericValue).value as! Int : 0
 930 |             let method = (args.count > 2 && args[2] is StringValue) ? (args[2] as! StringValue).value : "common"
 931 |             let factor = pow(10, Double(precision))
 932 |             let roundedNumber: Double
 933 |             if method == "common" {
 934 |                 roundedNumber = round(number * factor) / factor
 935 |             } else if method == "ceil" {
 936 |                 roundedNumber = ceil(number * factor) / factor
 937 |             } else if method == "floor" {
 938 |                 roundedNumber = floor(number * factor) / factor
 939 |             } else {
 940 |                 throw JinjaError.runtime("Invalid method for round filter")
 941 |             }
 942 |             return NumericValue(value: roundedNumber)
 943 |         },
 944 |         "safe": { args, env in
 945 |             guard let stringValue = args[0] as? StringValue else {
 946 |                 throw JinjaError.runtime("safe filter requires a string")
 947 |             }
 948 |             return stringValue  // In this minimal example, we don't handle marking strings as safe
 949 |         },
 950 |         "select": { args, env in
 951 |             guard let arrayValue = args[0] as? ArrayValue else {
 952 |                 throw JinjaError.runtime("select filter requires an array")
 953 |             }
 954 |             guard let testName = args[1] as? StringValue else {
 955 |                 throw JinjaError.runtime("select filter requires a test name")
 956 |             }
 957 |             guard let test = env.tests[testName.value] else {
 958 |                 throw JinjaError.runtime("Unknown test '\(testName.value)'")
 959 |             }
 960 |             var result: [any RuntimeValue] = []
 961 |             for item in arrayValue.value {
 962 |                 if try test(item) {
 963 |                     result.append(item)
 964 |                 }
 965 |             }
 966 |             return ArrayValue(value: result)
 967 |         },
 968 |         "selectattr": { args, env in
 969 |             guard let array = args[0] as? ArrayValue else {
 970 |                 throw JinjaError.runtime("selectattr filter requires an array")
 971 |             }
 972 |             guard let attribute = args[1] as? StringValue else {
 973 |                 throw JinjaError.runtime("selectattr filter requires an attribute name")
 974 |             }
 975 |             guard args.count > 2 else {
 976 |                 throw JinjaError.runtime("selectattr filter requires a test")
 977 |             }
 978 |             var result: [any RuntimeValue] = []
 979 |             for item in array.value {
 980 |                 if let obj = item as? ObjectValue,
 981 |                     let attrValue = obj.value[attribute.value]
 982 |                 {
 983 |                     if args[2] is StringValue && args[2].bool() {
 984 |                         // Simple boolean test
 985 |                         if attrValue.bool() {
 986 |                             result.append(item)
 987 |                         }
 988 |                     } else if args.count > 3 {
 989 |                         // Test with comparison value
 990 |                         if let testName = (args[2] as? StringValue)?.value {
 991 |                             let testValue = args[3]
 992 |                             if testName == "equalto" {
 993 |                                 // Handle equality test
 994 |                                 if let strAttr = attrValue as? StringValue,
 995 |                                     let strTest = testValue as? StringValue
 996 |                                 {
 997 |                                     if strAttr.value == strTest.value {
 998 |                                         result.append(item)
 999 |                                     }
1000 |                                 }
1001 |                             }
1002 |                         }
1003 |                     }
1004 |                 }
1005 |             }
1006 |             return ArrayValue(value: result)
1007 |         },
1008 |         "slice": { args, env in
1009 |             guard let arrayValue = args[0] as? ArrayValue else {
1010 |                 throw JinjaError.runtime("slice filter requires an array")
1011 |             }
1012 |             guard let slicesValue = args[1] as? NumericValue,
1013 |                 let slices = slicesValue.value as? Int,
1014 |                 slices > 0
1015 |             else {
1016 |                 throw JinjaError.runtime("slice filter requires a positive number of slices")
1017 |             }
1018 | 
1019 |             let fillWith = args.count > 2 ? args[2] : nil
1020 |             let seq = arrayValue.value
1021 |             let length = seq.count
1022 |             let itemsPerSlice = length / slices
1023 |             let slicesWithExtra = length % slices
1024 |             var offset = 0
1025 | 
1026 |             var result: [[any RuntimeValue]] = []
1027 | 
1028 |             for sliceNumber in 0 ..< slices {
1029 |                 let start = offset + sliceNumber * itemsPerSlice
1030 | 
1031 |                 if sliceNumber < slicesWithExtra {
1032 |                     offset += 1
1033 |                 }
1034 | 
1035 |                 let end = offset + (sliceNumber + 1) * itemsPerSlice
1036 |                 var tmp = Array(seq[start ..< end])
1037 | 
1038 |                 if let fillWith = fillWith, sliceNumber >= slicesWithExtra {
1039 |                     tmp.append(fillWith)
1040 |                 }
1041 | 
1042 |                 result.append(tmp)
1043 |             }
1044 | 
1045 |             return ArrayValue(value: result.map { ArrayValue(value: $0) })
1046 |         },
1047 |         "sort": { args, env in
1048 |             guard let arrayValue = args[0] as? ArrayValue else {
1049 |                 throw JinjaError.runtime("sort filter requires an array")
1050 |             }
1051 | 
1052 |             let reverse = args.count > 1 ? (args[1] as? BooleanValue)?.value ?? false : false
1053 |             let caseSensitive = args.count > 2 ? (args[2] as? BooleanValue)?.value ?? false : false
1054 |             let attributeStr = args.count > 3 ? (args[3] as? StringValue)?.value : nil
1055 | 
1056 |             // Helper function to get value from dot notation path
1057 |             func getValueFromPath(_ obj: any RuntimeValue, _ path: String) throws -> any RuntimeValue {
1058 |                 let components = path.split(separator: ".")
1059 |                 var current: any RuntimeValue = obj
1060 | 
1061 |                 for component in components {
1062 |                     if let currentObj = current as? ObjectValue,
1063 |                         let value = currentObj.value[String(component)]
1064 |                     {
1065 |                         current = value
1066 |                     } else if let currentArray = current as? ArrayValue,
1067 |                         let index = Int(component),
1068 |                         index >= 0 && index < currentArray.value.count
1069 |                     {
1070 |                         current = currentArray.value[index]
1071 |                     } else {
1072 |                         throw JinjaError.runtime("Cannot access '\(component)' in path '\(path)'")
1073 |                     }
1074 |                 }
1075 |                 return current
1076 |             }
1077 | 
1078 |             // Helper function to compare RuntimeValues
1079 |             func compare(_ a: any RuntimeValue, _ b: any RuntimeValue) throws -> Bool {
1080 |                 if let aStr = a as? StringValue, let bStr = b as? StringValue {
1081 |                     if caseSensitive {
1082 |                         return aStr.value < bStr.value
1083 |                     } else {
1084 |                         return aStr.value.lowercased() < bStr.value.lowercased()
1085 |                     }
1086 |                 } else if let aNum = a as? NumericValue, let bNum = b as? NumericValue {
1087 |                     if let aInt = aNum.value as? Int, let bInt = bNum.value as? Int {
1088 |                         return aInt < bInt
1089 |                     } else if let aDouble = aNum.value as? Double, let bDouble = bNum.value as? Double {
1090 |                         return aDouble < bDouble
1091 |                     } else if let aInt = aNum.value as? Int, let bDouble = bNum.value as? Double {
1092 |                         return Double(aInt) < bDouble
1093 |                     } else if let aDouble = aNum.value as? Double, let bInt = bNum.value as? Int {
1094 |                         return aDouble < Double(bInt)
1095 |                     }
1096 |                 }
1097 |                 throw JinjaError.runtime("Cannot compare values of different types")
1098 |             }
1099 | 
1100 |             // Sort the array
1101 |             let sortedArray = try arrayValue.value.sorted { (a, b) -> Bool in
1102 |                 if let attributeStr = attributeStr {
1103 |                     // Handle multiple attributes (comma-separated)
1104 |                     let attributes = attributeStr.split(separator: ",").map(String.init)
1105 | 
1106 |                     for attribute in attributes {
1107 |                         let aValue = try getValueFromPath(a, attribute.trimmingCharacters(in: .whitespaces))
1108 |                         let bValue = try getValueFromPath(b, attribute.trimmingCharacters(in: .whitespaces))
1109 | 
1110 |                         // If values are equal, continue to next attribute
1111 |                         if try compare(aValue, bValue) == compare(bValue, aValue) {
1112 |                             continue
1113 |                         }
1114 | 
1115 |                         return reverse ? try !compare(aValue, bValue) : try compare(aValue, bValue)
1116 |                     }
1117 |                     // All attributes were equal
1118 |                     return false
1119 |                 } else {
1120 |                     return reverse ? try !compare(a, b) : try compare(a, b)
1121 |                 }
1122 |             }
1123 | 
1124 |             return ArrayValue(value: sortedArray)
1125 |         },
1126 |         "string": { args, env in
1127 |             guard let arg = args.first else {
1128 |                 throw JinjaError.runtime("string filter expects one argument")
1129 |             }
1130 |             // In Jinja2 in Python, the `string` filter calls Python's `str` function on dicts, which which uses single quotes for strings. Here we're using double quotes in `tojson`, which is probably better for LLMs anyway, but this will result in differences with output from Jinja2.
1131 |             return try StringValue(value: stringify(arg, whitespaceControl: true))
1132 |         },
1133 |         "striptags": { args, env in
1134 |             guard let stringValue = args[0] as? StringValue else {
1135 |                 throw JinjaError.runtime("striptags filter requires a string")
1136 |             }
1137 |             // A very basic implementation to remove HTML tags
1138 |             let tagPattern = #"<[^>]+>"#
1139 |             let noTagsString = stringValue.value.replacingOccurrences(
1140 |                 of: tagPattern,
1141 |                 with: "",
1142 |                 options: .regularExpression
1143 |             )
1144 |             return StringValue(value: noTagsString)
1145 |         },
1146 |         "sum": { args, env in
1147 |             guard let arrayValue = args[0] as? ArrayValue else {
1148 |                 throw JinjaError.runtime("sum filter requires an array")
1149 |             }
1150 | 
1151 |             // Get attribute and start value from arguments
1152 |             let attribute = args.count > 1 ? args[1] : nil
1153 |             let start: Double = {
1154 |                 if args.count > 2, let numericValue = args[2] as? NumericValue {
1155 |                     if let intValue = numericValue.value as? Int {
1156 |                         return Double(intValue)
1157 |                     } else if let doubleValue = numericValue.value as? Double {
1158 |                         return doubleValue
1159 |                     }
1160 |                 }
1161 |                 return 0.0
1162 |             }()
1163 | 
1164 |             // Helper function to get value based on attribute
1165 |             func getValue(_ item: any RuntimeValue) throws -> Double {
1166 |                 if let attribute = attribute {
1167 |                     // Handle string attribute (object property)
1168 |                     if let strAttr = attribute as? StringValue,
1169 |                         let objectValue = item as? ObjectValue,
1170 |                         let attrValue = objectValue.value[strAttr.value]
1171 |                     {
1172 |                         if let numericValue = attrValue as? NumericValue {
1173 |                             if let intValue = numericValue.value as? Int {
1174 |                                 return Double(intValue)
1175 |                             } else if let doubleValue = numericValue.value as? Double {
1176 |                                 return doubleValue
1177 |                             }
1178 |                         }
1179 |                         throw JinjaError.runtime("Attribute '\(strAttr.value)' is not numeric")
1180 |                     }
1181 |                     // Handle integer attribute (array/string index)
1182 |                     else if let numAttr = attribute as? NumericValue,
1183 |                         let index = numAttr.value as? Int
1184 |                     {
1185 |                         if let arrayValue = item as? ArrayValue {
1186 |                             guard index >= 0 && index < arrayValue.value.count else {
1187 |                                 throw JinjaError.runtime("Index \(index) out of range")
1188 |                             }
1189 |                             if let numericValue = arrayValue.value[index] as? NumericValue {
1190 |                                 if let intValue = numericValue.value as? Int {
1191 |                                     return Double(intValue)
1192 |                                 } else if let doubleValue = numericValue.value as? Double {
1193 |                                     return doubleValue
1194 |                                 }
1195 |                             }
1196 |                             throw JinjaError.runtime("Value at index \(index) is not numeric")
1197 |                         }
1198 |                     }
1199 |                     throw JinjaError.runtime("Cannot get attribute '\(try stringify(attribute))' from item")
1200 |                 } else {
1201 |                     // No attribute - use item directly
1202 |                     if let numericValue = item as? NumericValue {
1203 |                         if let intValue = numericValue.value as? Int {
1204 |                             return Double(intValue)
1205 |                         } else if let doubleValue = numericValue.value as? Double {
1206 |                             return doubleValue
1207 |                         }
1208 |                     }
1209 |                     throw JinjaError.runtime("Item is not numeric")
1210 |                 }
1211 |             }
1212 | 
1213 |             // Sum all values
1214 |             var result = start
1215 |             for item in arrayValue.value {
1216 |                 do {
1217 |                     result += try getValue(item)
1218 |                 } catch {
1219 |                     throw JinjaError.runtime("Could not sum items: \(error.localizedDescription)")
1220 |                 }
1221 |             }
1222 | 
1223 |             // Return result as NumericValue
1224 |             // If the result has no decimal part, return as Int
1225 |             if result.truncatingRemainder(dividingBy: 1) == 0 {
1226 |                 return NumericValue(value: Int(result))
1227 |             }
1228 |             return NumericValue(value: result)
1229 |         },
1230 |         "title": { args, env in
1231 |             guard let stringValue = args[0] as? StringValue else {
1232 |                 throw JinjaError.runtime("title filter requires a string")
1233 |             }
1234 | 
1235 |             // Split the string by spaces, hyphens, and opening brackets/braces/parentheses
1236 |             let pattern = "([-\\s(\\{\\[<]+)"
1237 |             let regex = try! NSRegularExpression(pattern: pattern, options: [])
1238 |             let str = stringValue.value
1239 |             let range = NSRange(str.startIndex ..< str.endIndex, in: str)
1240 | 
1241 |             // Split the string and keep the delimiters
1242 |             let matches = regex.matches(in: str, options: [], range: range)
1243 |             var parts: [String] = []
1244 |             var currentIndex = str.startIndex
1245 | 
1246 |             // Add the first part if it exists
1247 |             if let firstMatch = matches.first,
1248 |                 let firstMatchRange = Range(firstMatch.range, in: str)
1249 |             {
1250 |                 if currentIndex < firstMatchRange.lowerBound {
1251 |                     parts.append(String(str[currentIndex ..< firstMatchRange.lowerBound]))
1252 |                 }
1253 |                 parts.append(String(str[firstMatchRange]))
1254 |                 currentIndex = firstMatchRange.upperBound
1255 |             }
1256 | 
1257 |             // Add remaining parts and delimiters
1258 |             for i in 1 ..< matches.count {
1259 |                 if let matchRange = Range(matches[i].range, in: str) {
1260 |                     if currentIndex < matchRange.lowerBound {
1261 |                         parts.append(String(str[currentIndex ..< matchRange.lowerBound]))
1262 |                     }
1263 |                     parts.append(String(str[matchRange]))
1264 |                     currentIndex = matchRange.upperBound
1265 |                 }
1266 |             }
1267 | 
1268 |             // Add the last part if it exists
1269 |             if currentIndex < str.endIndex {
1270 |                 parts.append(String(str[currentIndex ..< str.endIndex]))
1271 |             }
1272 | 
1273 |             // Process each part and join them
1274 |             let result = parts.filter { !$0.isEmpty }.map { part -> String in
1275 |                 if part.matches(of: try! Regex(pattern)).isEmpty {
1276 |                     // This is a word part, not a delimiter
1277 |                     if let first = part.first {
1278 |                         return String(first).uppercased() + part.dropFirst().lowercased()
1279 |                     }
1280 |                     return part
1281 |                 }
1282 |                 // This is a delimiter, keep it as is
1283 |                 return part
1284 |             }.joined()
1285 | 
1286 |             return StringValue(value: result)
1287 |         },
1288 |         "trim": { args, env in
1289 |             guard let stringValue = args[0] as? StringValue else {
1290 |                 throw JinjaError.runtime("trim filter requires a string")
1291 |             }
1292 |             return StringValue(value: stringValue.value.trimmingCharacters(in: .whitespacesAndNewlines))
1293 |         },
1294 |         "truncate": { args, env in
1295 |             guard let stringValue = args[0] as? StringValue else {
1296 |                 throw JinjaError.runtime("truncate filter requires a string")
1297 |             }
1298 |             let length = (args.count > 1 && args[1] is NumericValue) ? (args[1] as! NumericValue).value as! Int : 255
1299 |             let killwords = (args.count > 2 && args[2] is BooleanValue) ? (args[2] as! BooleanValue).value : false
1300 |             let end = (args.count > 3 && args[3] is StringValue) ? (args[3] as! StringValue).value : "..."
1301 |             if stringValue.value.count <= length {
1302 |                 return stringValue
1303 |             }
1304 |             if killwords {
1305 |                 return StringValue(value: String(stringValue.value.prefix(length - end.count)) + end)
1306 |             } else {
1307 |                 let truncated = String(stringValue.value.prefix(length - end.count))
1308 |                 if let lastSpace = truncated.lastIndex(of: " ") {
1309 |                     return StringValue(value: String(truncated[..<lastSpace]) + end)
1310 |                 } else {
1311 |                     return StringValue(value: truncated + end)
1312 |                 }
1313 |             }
1314 |         },
1315 |         "unique": { args, env in
1316 |             // Handle different iterable types
1317 |             func getIterableItems(_ value: any RuntimeValue) throws -> [any RuntimeValue] {
1318 |                 switch value {
1319 |                 case let arrayValue as ArrayValue:
1320 |                     return arrayValue.value
1321 |                 case let stringValue as StringValue:
1322 |                     // Always split string into characters as StringValues
1323 |                     return stringValue.value.map { StringValue(value: String($0)) }
1324 |                 case let objectValue as ObjectValue:
1325 |                     return objectValue.storage.map { key, value in
1326 |                         ArrayValue(value: [StringValue(value: key), value])
1327 |                     }
1328 |                 default:
1329 |                     throw JinjaError.runtime("Value must be iterable (array, string, or object)")
1330 |                 }
1331 |             }
1332 |             // Get the input iterable
1333 |             guard let input = args.first else {
1334 |                 throw JinjaError.runtime("unique filter requires an iterable")
1335 |             }
1336 |             let caseSensitive = args.count > 1 ? (args[1] as? BooleanValue)?.value ?? false : false
1337 |             let attribute = args.count > 2 ? args[2] : nil
1338 |             // Helper function to get value based on attribute
1339 |             func getValue(_ item: any RuntimeValue) throws -> String {
1340 |                 if let attribute = attribute {
1341 |                     // Handle string attribute (object property)
1342 |                     if let strAttr = attribute as? StringValue,
1343 |                         let objectValue = item as? ObjectValue
1344 |                     {
1345 |                         // Support dot notation
1346 |                         let components = strAttr.value.split(separator: ".")
1347 |                         var current: any RuntimeValue = objectValue
1348 | 
1349 |                         for component in components {
1350 |                             if let currentObj = current as? ObjectValue,
1351 |                                 let value = currentObj.value[String(component)]
1352 |                             {
1353 |                                 current = value
1354 |                             } else {
1355 |                                 throw JinjaError.runtime("Cannot access '\(component)' in path '\(strAttr.value)'")
1356 |                             }
1357 |                         }
1358 |                         return try stringify(current)
1359 |                     }
1360 |                     // Handle integer attribute (array/string index)
1361 |                     else if let numAttr = attribute as? NumericValue,
1362 |                         let index = numAttr.value as? Int
1363 |                     {
1364 |                         if let stringValue = item as? StringValue {
1365 |                             let str = stringValue.value
1366 |                             guard index >= 0 && index < str.count else {
1367 |                                 throw JinjaError.runtime("Index \(index) out of range")
1368 |                             }
1369 |                             let stringIndex = str.index(str.startIndex, offsetBy: index)
1370 |                             return String(str[stringIndex])
1371 |                         } else if let arrayValue = item as? ArrayValue {
1372 |                             guard index >= 0 && index < arrayValue.value.count else {
1373 |                                 throw JinjaError.runtime("Index \(index) out of range")
1374 |                             }
1375 |                             return try stringify(arrayValue.value[index])
1376 |                         }
1377 |                     }
1378 |                 }
1379 |                 // No attribute - use item directly
1380 |                 return try stringify(item)
1381 |             }
1382 |             var seen: [String: Bool] = [:]
1383 |             var result: [any RuntimeValue] = []
1384 |             // Process all items from the iterable
1385 |             let items = try getIterableItems(input)
1386 |             for item in items {
1387 |                 let key = try getValue(item)
1388 |                 let lookupKey = caseSensitive ? key : key.lowercased()
1389 | 
1390 |                 if seen[lookupKey] == nil {
1391 |                     seen[lookupKey] = true
1392 |                     result.append(item)
1393 |                 }
1394 |             }
1395 |             return ArrayValue(value: result)
1396 |         },
1397 |         "upper": { args, env in
1398 |             guard let stringValue = args[0] as? StringValue else {
1399 |                 throw JinjaError.runtime("upper filter requires a string")
1400 |             }
1401 |             return StringValue(value: stringValue.value.uppercased())
1402 |         },
1403 |         "urlencode": { args, env in
1404 |             guard let stringValue = args[0] as? StringValue else {
1405 |                 throw JinjaError.runtime("urlencode filter requires a string")
1406 |             }
1407 | 
1408 |             let encodedString = stringValue.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
1409 |             return StringValue(value: encodedString)
1410 |         },
1411 |         "urlize": { args, env in
1412 |             guard let stringValue = args[0] as? StringValue else {
1413 |                 throw JinjaError.runtime("urlize filter requires a string")
1414 |             }
1415 |             let trimUrlLimit =
1416 |                 (args.count > 1 && args[1] is NumericValue) ? (args[1] as! NumericValue).value as? Int : nil
1417 |             let nofollow = (args.count > 2 && args[2] is BooleanValue) ? (args[2] as! BooleanValue).value : false
1418 |             let target = (args.count > 3 && args[3] is StringValue) ? (args[3] as! StringValue).value : nil
1419 |             let urlPattern =
1420 |                 #"(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})"#
1421 |             var urlizedString = stringValue.value
1422 |             if let regex = try? NSRegularExpression(pattern: urlPattern, options: []) {
1423 |                 let nsRange = NSRange(
1424 |                     stringValue.value.startIndex ..< stringValue.value.endIndex,
1425 |                     in: stringValue.value
1426 |                 )
1427 |                 let matches = regex.matches(in: stringValue.value, options: [], range: nsRange)
1428 | 
1429 |                 for match in matches.reversed() {
1430 |                     let urlRange = Range(match.range, in: stringValue.value)!
1431 |                     let url = String(stringValue.value[urlRange])
1432 |                     var trimmedUrl = url
1433 |                     if let limit = trimUrlLimit, url.count > limit {
1434 |                         trimmedUrl = String(url.prefix(limit)) + "..."
1435 |                     }
1436 |                     var link = "<a href=\"\(url)\""
1437 |                     if nofollow {
1438 |                         link += " rel=\"nofollow\""
1439 |                     }
1440 |                     if let target = target {
1441 |                         link += " target=\"\(target)\""
1442 |                     }
1443 |                     link += ">\(trimmedUrl)</a>"
1444 |                     urlizedString.replaceSubrange(urlRange, with: link)
1445 |                 }
1446 |             }
1447 | 
1448 |             return StringValue(value: urlizedString)
1449 |         },
1450 |         "wordcount": { args, env in
1451 |             guard let stringValue = args[0] as? StringValue else {
1452 |                 throw JinjaError.runtime("wordcount filter requires a string")
1453 |             }
1454 |             let words = stringValue.value.split(separator: " ")
1455 |             return NumericValue(value: words.count)
1456 |         },
1457 |         "wordwrap": { args, env in
1458 |             guard let stringValue = args[0] as? StringValue else {
1459 |                 throw JinjaError.runtime("wordwrap filter requires a string")
1460 |             }
1461 |             let width = (args.count > 1 && args[1] is NumericValue) ? (args[1] as! NumericValue).value as! Int : 79
1462 |             let breakLongWords = (args.count > 2 && args[2] is BooleanValue) ? (args[2] as! BooleanValue).value : true
1463 |             let wrapString = (args.count > 3 && args[3] is StringValue) ? (args[3] as! StringValue).value : "\n"
1464 |             var result = ""
1465 |             var currentLineLength = 0
1466 |             for word in stringValue.value.split(separator: " ", omittingEmptySubsequences: false) {
1467 |                 if currentLineLength + word.count > width {
1468 |                     if currentLineLength > 0 {
1469 |                         result += wrapString
1470 |                         currentLineLength = 0
1471 |                     }
1472 |                     if word.count > width && breakLongWords {
1473 |                         var remainingWord = word[...]
1474 |                         while remainingWord.count > width {
1475 |                             result += remainingWord.prefix(width)
1476 |                             result += wrapString
1477 |                             remainingWord = remainingWord.dropFirst(width)
1478 |                         }
1479 |                         if !remainingWord.isEmpty {
1480 |                             result += remainingWord
1481 |                             currentLineLength = remainingWord.count
1482 |                         }
1483 |                         continue
1484 |                     }
1485 |                 }
1486 |                 if !result.isEmpty && currentLineLength == 0 {
1487 |                     result += word
1488 |                     currentLineLength = word.count
1489 |                 } else {
1490 |                     if !result.isEmpty {
1491 |                         result += " "
1492 |                         currentLineLength += 1
1493 |                     }
1494 |                     result += word
1495 |                     currentLineLength += word.count
1496 |                 }
1497 |             }
1498 |             return StringValue(value: result)
1499 |         },
1500 |         "xmlattr": { args, env in
1501 |             guard let dict = args[0] as? ObjectValue else {
1502 |                 throw JinjaError.runtime("xmlattr filter requires a dictionary")
1503 |             }
1504 |             let autospace = args.count > 1 ? (args[1] as? BooleanValue)?.value ?? true : true
1505 |             var result = ""
1506 |             for (key, value) in dict.storage {
1507 |                 if !(value is UndefinedValue) && !(value is NullValue) {
1508 |                     if autospace {
1509 |                         result += " "
1510 |                     }
1511 |                     if let stringValue = value as? StringValue {
1512 |                         result +=
1513 |                             "\(key)=\"\(stringValue.value.replacingOccurrences(of: "&", with: "&amp;").replacingOccurrences(of: "\"", with: "&quot;"))\""
1514 |                     } else {
1515 |                         result += "\(key)=\"\(value)\""
1516 |                     }
1517 |                 }
1518 |             }
1519 |             return StringValue(value: result)
1520 |         },
1521 |         "tojson": { args, env in
1522 |             guard let firstArg = args.first else {
1523 |                 throw JinjaError.runtime("tojson filter expects at least one argument")
1524 |             }
1525 |             var indent: Int? = nil
1526 |             if args.count > 1, let kwargs = args.last as? ObjectValue,
1527 |                 let indentArg = kwargs.value["indent"] as? NumericValue,
1528 |                 let indentInt = indentArg.value as? Int
1529 |             {
1530 |                 indent = indentInt
1531 |             }
1532 |             return try StringValue(value: toJSON(firstArg, indent: indent, whitespaceControl: false))
1533 |         },
1534 |     ]
1535 | 
1536 |     init(parent: Environment? = nil) {
1537 |         self.parent = parent
1538 |     }
1539 | 
1540 |     //    func isFunction<T>(_ value: Any, functionType: T.Type) -> Bool {
1541 |     //        return value is T
1542 |     //    }
1543 | 
1544 |     func convertToRuntimeValues(input: Any?) throws -> any RuntimeValue {
1545 |         // Handle already converted RuntimeValue
1546 |         if let runtimeValue = input as? any RuntimeValue {
1547 |             return runtimeValue
1548 |         }
1549 |         // Handle nil values
1550 |         if input == nil {
1551 |             return NullValue()
1552 |         }
1553 |         if case Optional<Any>.none = input {
1554 |             return NullValue()
1555 |         }
1556 |         // Helper function to handle any OrderedDictionary type
1557 |         func convertOrderedDictionary<T>(_ dict: OrderedDictionary<String, T>) throws -> ObjectValue {
1558 |             var object: [String: any RuntimeValue] = [:]
1559 |             var keyOrder: [String] = []
1560 | 
1561 |             for (key, value) in dict {
1562 |                 // Crucial: Convert Optional<T> to T, using NullValue if nil
1563 |                 let convertedValue = (value as Any?) ?? NullValue()
1564 |                 object[key] = try self.convertToRuntimeValues(input: convertedValue)
1565 |                 keyOrder.append(key)
1566 |             }
1567 |             return ObjectValue(value: object, keyOrder: keyOrder)
1568 |         }
1569 |         // Handle other values
1570 |         switch input {
1571 |         case let value as Bool:
1572 |             return BooleanValue(value: value)
1573 |         case let value as Int:
1574 |             return NumericValue(value: value)
1575 |         case let value as Double:
1576 |             return NumericValue(value: value)
1577 |         case let value as Float:
1578 |             return NumericValue(value: value)
1579 |         case let value as String:
1580 |             return StringValue(value: value)
1581 |         case let data as Data:
1582 |             guard let string = String(data: data, encoding: .utf8) else {
1583 |                 throw JinjaError.runtime("Failed to convert data to string")
1584 |             }
1585 |             return StringValue(value: string)
1586 |         case let fn as (String) throws -> Void:
1587 |             return FunctionValue { args, _ in
1588 |                 guard let stringArg = args[0] as? StringValue else {
1589 |                     throw JinjaError.runtime("Argument must be a StringValue")
1590 |                 }
1591 |                 try fn(stringArg.value)
1592 |                 return NullValue()
1593 |             }
1594 |         case let fn as (Bool) throws -> Void:
1595 |             return FunctionValue { args, _ in
1596 |                 guard let boolArg = args[0] as? BooleanValue else {
1597 |                     throw JinjaError.runtime("Argument must be a BooleanValue")
1598 |                 }
1599 |                 try fn(boolArg.value)
1600 |                 return NullValue()
1601 |             }
1602 |         case let fn as (Int, Int?, Int) -> [Int]:
1603 |             return FunctionValue { args, _ in
1604 |                 guard args.count > 0, let arg0 = args[0] as? NumericValue, let int0 = arg0.value as? Int else {
1605 |                     throw JinjaError.runtime("First argument must be an Int")
1606 |                 }
1607 |                 var int1: Int? = nil
1608 |                 if args.count > 1 {
1609 |                     if let numericValue = args[1] as? NumericValue, let tempInt1 = numericValue.value as? Int {
1610 |                         int1 = tempInt1
1611 |                     } else if !(args[1] is NullValue) {  // Accept NullValue for optional second argument
1612 |                         throw JinjaError.runtime("Second argument must be an Int or nil")
1613 |                     }
1614 |                 }
1615 |                 var int2: Int = 1
1616 |                 if args.count > 2 {
1617 |                     if let numericValue = args[2] as? NumericValue, let tempInt2 = numericValue.value as? Int {
1618 |                         int2 = tempInt2
1619 |                     } else {
1620 |                         throw JinjaError.runtime("Third argument must be an Int")
1621 |                     }
1622 |                 }
1623 |                 let result = fn(int0, int1, int2)
1624 |                 return ArrayValue(value: result.map { NumericValue(value: $0) })
1625 |             }
1626 |         case let values as [Any?]:
1627 |             let items = try values.map { try self.convertToRuntimeValues(input: $0) }
1628 |             return ArrayValue(value: items)
1629 |         case let orderedDict as OrderedDictionary<String, String>:
1630 |             return try convertOrderedDictionary(orderedDict)
1631 |         case let orderedDict as OrderedDictionary<String, OrderedDictionary<String, Any>>:
1632 |             return try convertOrderedDictionary(orderedDict)
1633 |         case let orderedDict as OrderedDictionary<String, OrderedDictionary<String, String>>:
1634 |             return try convertOrderedDictionary(orderedDict)
1635 |         case let orderedDict as OrderedDictionary<String, Any?>:
1636 |             return try convertOrderedDictionary(orderedDict)
1637 |         case let orderedDict as OrderedDictionary<String, Any>:
1638 |             return try convertOrderedDictionary(orderedDict)
1639 |         case let dictionary as [String: Any?]:
1640 |             var object: [String: any RuntimeValue] = [:]
1641 |             var keyOrder: [String] = []
1642 |             for (key, value) in dictionary {
1643 |                 object[key] = try self.convertToRuntimeValues(input: value)
1644 |                 keyOrder.append(key)
1645 |             }
1646 |             return ObjectValue(value: object, keyOrder: keyOrder)
1647 |         default:
1648 |             throw JinjaError.runtime(
1649 |                 "Cannot convert to runtime value: \(String(describing: input)) type:\(type(of: input))"
1650 |             )
1651 |         }
1652 |     }
1653 | 
1654 |     @discardableResult
1655 |     func set(name: String, value: Any) throws -> any RuntimeValue {
1656 |         let runtimeValue = try self.convertToRuntimeValues(input: value)
1657 |         return try self.declareVariable(name: name, value: runtimeValue)
1658 |     }
1659 | 
1660 |     private func declareVariable(name: String, value: any RuntimeValue) throws -> any RuntimeValue {
1661 |         if self.variables.keys.contains(name) {
1662 |             throw JinjaError.syntax("Variable already declared: \(name)")
1663 |         }
1664 | 
1665 |         self.variables[name] = value
1666 |         return value
1667 |     }
1668 | 
1669 |     @discardableResult
1670 |     func setVariable(name: String, value: any RuntimeValue) throws -> any RuntimeValue {
1671 |         self.variables[name] = value
1672 |         return value
1673 |     }
1674 | 
1675 |     private func resolve(name: String) throws -> Environment {
1676 |         if self.variables.keys.contains(name) {
1677 |             return self
1678 |         }
1679 | 
1680 |         if let parent = self.parent {
1681 |             return try parent.resolve(name: name)
1682 |         }
1683 | 
1684 |         throw JinjaError.runtime("Unknown variable: \(name)")
1685 |     }
1686 | 
1687 |     func lookupVariable(name: String) -> any RuntimeValue {
1688 |         do {
1689 |             // Look up the variable in the environment chain
1690 |             let env = try self.resolve(name: name)
1691 | 
1692 |             // Get the value, handling potential conversions from Swift native types
1693 |             if let value = env.variables[name] {
1694 |                 // If we have a raw Swift boolean, ensure it's properly converted to BooleanValue
1695 |                 if let boolValue = value.value as? Bool {
1696 |                     return BooleanValue(value: boolValue)
1697 |                 }
1698 |                 return value
1699 |             }
1700 | 
1701 |             // Variable doesn't exist
1702 |             return UndefinedValue()
1703 |         } catch {
1704 |             // Cannot resolve variable name
1705 |             return UndefinedValue()
1706 |         }
1707 |     }
1708 | 
1709 |     // Filters
1710 | 
1711 |     private func doDefault(_ args: [any RuntimeValue], _ env: Environment) throws -> any RuntimeValue {
1712 |         let value = args[0]
1713 |         let defaultValue = args.count > 1 ? args[1] : StringValue(value: "")
1714 |         let boolean = args.count > 2 ? (args[2] as? BooleanValue)?.value ?? false : false
1715 | 
1716 |         if value is UndefinedValue {
1717 |             return defaultValue
1718 |         }
1719 | 
1720 |         if boolean {
1721 |             if !value.bool() {
1722 |                 return defaultValue
1723 |             }
1724 |             // If it's a boolean value, return its string representation
1725 |             if let boolValue = value as? BooleanValue {
1726 |                 return StringValue(value: String(boolValue.value))
1727 |             }
1728 |         }
1729 | 
1730 |         return value
1731 |     }
1732 | 
1733 |     private func doEscape(_ args: [any RuntimeValue], _ env: Environment) throws -> any RuntimeValue {
1734 |         guard let stringValue = args[0] as? StringValue else {
1735 |             throw JinjaError.runtime("escape filter requires a string")
1736 |         }
1737 |         return StringValue(
1738 |             value: stringValue.value.replacingOccurrences(of: "&", with: "&amp;")
1739 |                 .replacingOccurrences(of: "<", with: "&lt;")
1740 |                 .replacingOccurrences(of: ">", with: "&gt;")
1741 |                 .replacingOccurrences(of: "\"", with: "&quot;")
1742 |                 .replacingOccurrences(of: "'", with: "&#39;")
1743 |         )
1744 |     }
1745 | 
1746 |     private func doEqualTo(_ args: [any RuntimeValue]) -> Bool {
1747 |         if args.count == 2 {
1748 |             if let left = args[0] as? StringValue, let right = args[1] as? StringValue {
1749 |                 return left.value == right.value
1750 |             } else if let left = args[0] as? NumericValue, let right = args[1] as? NumericValue,
1751 |                 let leftInt = left.value as? Int, let rightInt = right.value as? Int
1752 |             {
1753 |                 return leftInt == rightInt
1754 |             } else if let left = args[0] as? BooleanValue, let right = args[1] as? BooleanValue {
1755 |                 return left.value == right.value
1756 |             } else {
1757 |                 return false
1758 |             }
1759 |         } else {
1760 |             return false
1761 |         }
1762 |     }
1763 | 
1764 |     // Tests
1765 | 
1766 |     private func doGreaterThan(_ args: [any RuntimeValue]) throws -> Bool {
1767 |         if let left = args[0] as? StringValue, let right = args[1] as? StringValue {
1768 |             return left.value > right.value
1769 |         } else if let left = args[0] as? NumericValue, let right = args[1] as? NumericValue {
1770 |             if let leftInt = left.value as? Int, let rightInt = right.value as? Int {
1771 |                 return leftInt > rightInt
1772 |             } else if let leftDouble = left.value as? Double, let rightDouble = right.value as? Double {
1773 |                 return leftDouble > rightDouble
1774 |             } else if let leftInt = left.value as? Int, let rightDouble = right.value as? Double {
1775 |                 return Double(leftInt) > rightDouble
1776 |             } else if let leftDouble = left.value as? Double, let rightInt = right.value as? Int {
1777 |                 return leftDouble > Double(rightInt)
1778 |             }
1779 |         }
1780 |         throw JinjaError.runtime("Cannot compare values of different types")
1781 |     }
1782 | 
1783 |     private func doGreaterThanOrEqual(_ args: [any RuntimeValue]) throws -> Bool {
1784 |         return try doGreaterThan(args) || doEqualTo(args)
1785 |     }
1786 | 
1787 |     private func doLessThan(_ args: [any RuntimeValue]) throws -> Bool {
1788 |         if let left = args[0] as? StringValue, let right = args[1] as? StringValue {
1789 |             return left.value < right.value
1790 |         } else if let left = args[0] as? NumericValue, let right = args[1] as? NumericValue {
1791 |             if let leftInt = left.value as? Int, let rightInt = right.value as? Int {
1792 |                 return leftInt < rightInt
1793 |             } else if let leftDouble = left.value as? Double, let rightDouble = right.value as? Double {
1794 |                 return leftDouble < rightDouble
1795 |             } else if let leftInt = left.value as? Int, let rightDouble = right.value as? Double {
1796 |                 return Double(leftInt) < rightDouble
1797 |             } else if let leftDouble = left.value as? Double, let rightInt = right.value as? Int {
1798 |                 return leftDouble < Double(rightInt)
1799 |             }
1800 |         }
1801 |         throw JinjaError.runtime("Cannot compare values of different types")
1802 |     }
1803 | 
1804 |     private func doLessThanOrEqual(_ args: [any RuntimeValue]) throws -> Bool {
1805 |         return try doLessThan(args) || doEqualTo(args)
1806 |     }
1807 | 
1808 |     /// Formats a date using strftime-style format specifiers
1809 |     /// - Parameters:
1810 |     ///   - date: The date to format
1811 |     ///   - format: A strftime-compatible format string
1812 |     /// - Returns: The formatted date string
1813 |     static func formatDate(_ date: Date, withFormat format: String) -> String {
1814 | 
1815 |         let calendar = Calendar.current
1816 |         let components = calendar.dateComponents(
1817 |             [
1818 |                 .year, .month, .day, .weekday, .hour, .minute, .second, .nanosecond, .timeZone, .weekOfYear,
1819 |                 .yearForWeekOfYear, .weekdayOrdinal, .quarter,
1820 |             ],
1821 |             from: date
1822 |         )
1823 | 
1824 |         var result = ""
1825 |         var i = 0
1826 | 
1827 |         while i < format.count {
1828 |             let currentIndex = format.index(format.startIndex, offsetBy: i)
1829 |             let currentChar = format[currentIndex]
1830 | 
1831 |             if currentChar == "%" && i + 1 < format.count {
1832 |                 let nextIndex = format.index(format.startIndex, offsetBy: i + 1)
1833 |                 let nextChar = format[nextIndex]
1834 | 
1835 |                 // Check for non-padded variant
1836 |                 var isPadded = true
1837 |                 var formatChar = nextChar
1838 | 
1839 |                 if nextChar == "-" && i + 2 < format.count {
1840 |                     isPadded = false
1841 |                     let formatCharIndex = format.index(format.startIndex, offsetBy: i + 2)
1842 |                     formatChar = format[formatCharIndex]
1843 |                     i += 1  // Skip the "-" character
1844 |                 }
1845 | 
1846 |                 switch formatChar {
1847 |                 case "a":
1848 |                     let formatter = DateFormatter()
1849 |                     formatter.dateFormat = "EEE"
1850 |                     result += formatter.string(from: date)
1851 |                 case "A":
1852 |                     let formatter = DateFormatter()
1853 |                     formatter.dateFormat = "EEEE"
1854 |                     result += formatter.string(from: date)
1855 |                 case "w":
1856 |                     let weekday = (components.weekday ?? 1) - 1
1857 |                     result += "\(weekday)"
1858 |                 case "d":
1859 |                     let day = components.day ?? 1
1860 |                     result += isPadded ? String(format: "%02d", day) : "\(day)"
1861 |                 case "b":
1862 |                     let formatter = DateFormatter()
1863 |                     formatter.dateFormat = "MMM"
1864 |                     result += formatter.string(from: date)
1865 |                 case "B":
1866 |                     let formatter = DateFormatter()
1867 |                     formatter.dateFormat = "MMMM"
1868 |                     result += formatter.string(from: date)
1869 |                 case "m":
1870 |                     let month = components.month ?? 1
1871 |                     result += isPadded ? String(format: "%02d", month) : "\(month)"
1872 |                 case "y":
1873 |                     let year = components.year ?? 0
1874 |                     let shortYear = year % 100
1875 |                     result += isPadded ? String(format: "%02d", shortYear) : "\(shortYear)"
1876 |                 case "Y":
1877 |                     let year = components.year ?? 0
1878 |                     result += "\(year)"
1879 |                 case "H":
1880 |                     let hour = components.hour ?? 0
1881 |                     result += isPadded ? String(format: "%02d", hour) : "\(hour)"
1882 |                 case "I":
1883 |                     var hour12 = (components.hour ?? 0) % 12
1884 |                     if hour12 == 0 { hour12 = 12 }
1885 |                     result += isPadded ? String(format: "%02d", hour12) : "\(hour12)"
1886 |                 case "p":
1887 |                     let hour = components.hour ?? 0
1888 |                     result += hour < 12 ? "AM" : "PM"
1889 |                 case "M":
1890 |                     let minute = components.minute ?? 0
1891 |                     result += isPadded ? String(format: "%02d", minute) : "\(minute)"
1892 |                 case "S":
1893 |                     let second = components.second ?? 0
1894 |                     result += isPadded ? String(format: "%02d", second) : "\(second)"
1895 |                 case "f":
1896 |                     let nano = components.nanosecond ?? 0
1897 |                     let micro = nano / 1000
1898 |                     result += String(format: "%06d", micro)
1899 |                 case "z":
1900 |                     guard let timeZone = components.timeZone else {
1901 |                         result += "+0000"
1902 |                         break
1903 |                     }
1904 |                     let hours = timeZone.secondsFromGMT() / 3600
1905 |                     let minutes = abs(timeZone.secondsFromGMT() % 3600) / 60
1906 |                     let sign = hours >= 0 ? "+" : "-"
1907 |                     result += "\(sign)\(String(format: "%02d", abs(hours)))\(String(format: "%02d", minutes))"
1908 |                 case "Z":
1909 |                     guard let timeZone = components.timeZone else {
1910 |                         result += ""
1911 |                         break
1912 |                     }
1913 |                     result += timeZone.abbreviation() ?? ""
1914 |                 case "j":
1915 |                     let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
1916 |                     result += isPadded ? String(format: "%03d", dayOfYear) : "\(dayOfYear)"
1917 |                 case "U":
1918 |                     var cal = Calendar(identifier: .gregorian)
1919 |                     cal.firstWeekday = 1  // Sunday
1920 |                     let week = cal.component(.weekOfYear, from: date)
1921 |                     result += String(format: "%02d", week)
1922 |                 case "W":
1923 |                     var cal = Calendar(identifier: .gregorian)
1924 |                     cal.firstWeekday = 2  // Monday
1925 |                     let week = cal.component(.weekOfYear, from: date)
1926 |                     result += String(format: "%02d", week)
1927 |                 case "c":
1928 |                     let formatter = DateFormatter()
1929 |                     formatter.dateStyle = .full
1930 |                     formatter.timeStyle = .full
1931 |                     result += formatter.string(from: date)
1932 |                 case "x":
1933 |                     let formatter = DateFormatter()
1934 |                     formatter.dateStyle = .short
1935 |                     formatter.timeStyle = .none
1936 |                     result += formatter.string(from: date)
1937 |                 case "X":
1938 |                     let formatter = DateFormatter()
1939 |                     formatter.dateStyle = .none
1940 |                     formatter.timeStyle = .medium
1941 |                     result += formatter.string(from: date)
1942 |                 case "%":
1943 |                     result += "%"
1944 |                 default:
1945 |                     // Unknown format, just append as is
1946 |                     result += "%\(formatChar)"
1947 |                 }
1948 | 
1949 |                 i += 2  // Skip the % and the format character
1950 |             } else {
1951 |                 result.append(currentChar)
1952 |                 i += 1
1953 |             }
1954 |         }
1955 |         return result
1956 |     }
1957 | }
1958 | 


--------------------------------------------------------------------------------
/Sources/Error.swift:
--------------------------------------------------------------------------------
 1 | //
 2 | //  Error.swift
 3 | //
 4 | //
 5 | //  Created by John Mai on 2024/3/20.
 6 | //
 7 | 
 8 | import Foundation
 9 | 
10 | enum JinjaError: Error, LocalizedError, Equatable {
11 |     case syntax(String)
12 |     case parser(String)
13 |     case runtime(String)
14 |     case todo(String)
15 |     case syntaxNotSupported(String)
16 | 
17 |     var errorDescription: String? {
18 |         switch self {
19 |         case .syntax(let message): return "Syntax error: \(message)"
20 |         case .parser(let message): return "Parser error: \(message)"
21 |         case .runtime(let message): return "Runtime error: \(message)"
22 |         case .todo(let message): return "Todo error: \(message)"
23 |         case .syntaxNotSupported(let string): return "Syntax not supported: \(string)"
24 |         }
25 |     }
26 | 
27 |     var id: String {
28 |         errorDescription ?? ""
29 |     }
30 | }
31 | 


--------------------------------------------------------------------------------
/Sources/Extensions/StringExtension.swift:
--------------------------------------------------------------------------------
 1 | //
 2 | //  StringExtension.swift
 3 | //
 4 | //
 5 | //  Created by John Mai on 2024/3/20.
 6 | //
 7 | 
 8 | import Foundation
 9 | 
10 | extension String {
11 |     subscript(i: Int) -> Character {
12 |         self[index(startIndex, offsetBy: i)]
13 |     }
14 | 
15 |     func slice(start: Int, end: Int) -> Self {
16 |         let startPosition = index(startIndex, offsetBy: start)
17 |         let endPosition = index(startIndex, offsetBy: end)
18 |         return String(self[startPosition ..< endPosition])
19 |     }
20 | }
21 | 


--------------------------------------------------------------------------------
/Sources/Lexer.swift:
--------------------------------------------------------------------------------
  1 | //
  2 | //  Lexer.swift
  3 | //
  4 | //
  5 | //  Created by John Mai on 2024/3/20.
  6 | //
  7 | 
  8 | import Foundation
  9 | 
 10 | enum TokenType: String {
 11 |     case text = "Text"
 12 | 
 13 |     case numericLiteral = "NumericLiteral"
 14 |     case booleanLiteral = "BooleanLiteral"
 15 |     case nullLiteral = "NullLiteral"
 16 |     case stringLiteral = "StringLiteral"
 17 |     case identifier = "Identifier"
 18 |     case equals = "Equals"
 19 |     case openParen = "OpenParen"
 20 |     case closeParen = "CloseParen"
 21 |     case openStatement = "OpenStatement"
 22 |     case closeStatement = "CloseStatement"
 23 |     case openExpression = "OpenExpression"
 24 |     case closeExpression = "CloseExpression"
 25 |     case openSquareBracket = "OpenSquareBracket"
 26 |     case closeSquareBracket = "CloseSquareBracket"
 27 |     case openCurlyBracket = "OpenCurlyBracket"
 28 |     case closeCurlyBracket = "CloseCurlyBracket"
 29 |     case comma = "Comma"
 30 |     case dot = "Dot"
 31 |     case colon = "Colon"
 32 |     case pipe = "Pipe"
 33 | 
 34 |     case callOperator = "CallOperator"
 35 |     case additiveBinaryOperator = "AdditiveBinaryOperator"
 36 |     case multiplicativeBinaryOperator = "MultiplicativeBinaryOperator"
 37 |     case comparisonBinaryOperator = "ComparisonBinaryOperator"
 38 |     case unaryOperator = "UnaryOperator"
 39 | 
 40 |     case set = "Set"
 41 |     case `if` = "If"
 42 |     case `for` = "For"
 43 |     case `in` = "In"
 44 |     case `is` = "Is"
 45 |     case notIn = "NotIn"
 46 |     case `else` = "Else"
 47 |     case endIf = "EndIf"
 48 |     case elseIf = "ElseIf"
 49 |     case endFor = "EndFor"
 50 |     case and = "And"
 51 |     case or = "Or"
 52 |     case not = "Not"
 53 |     case macro = "Macro"
 54 |     case endMacro = "EndMacro"
 55 | }
 56 | 
 57 | struct Token: Equatable {
 58 |     var value: String
 59 |     var type: TokenType
 60 | }
 61 | 
 62 | let keywords: [String: TokenType] = [
 63 |     "set": .set,
 64 |     "for": .for,
 65 |     "in": .in,
 66 |     "is": .is,
 67 |     "if": .if,
 68 |     "else": .else,
 69 |     "endif": .endIf,
 70 |     "elif": .elseIf,
 71 |     "endfor": .endFor,
 72 |     "and": .and,
 73 |     "or": .or,
 74 |     "not": .not,
 75 |     "macro": .macro,
 76 |     "endmacro": .endMacro,
 77 |     // Literals
 78 |     "true": .booleanLiteral,
 79 |     "false": .booleanLiteral,
 80 |     "none": .nullLiteral,
 81 | ]
 82 | 
 83 | func isWord(char: String) -> Bool {
 84 |     char.range(of: #"\w"#, options: .regularExpression) != nil
 85 | }
 86 | 
 87 | func isInteger(char: String) -> Bool {
 88 |     char.range(of: #"^[0-9]+

quot;#, options: .regularExpression) != nil
 89 | }
 90 | 
 91 | func isWhile(char: String) -> Bool {
 92 |     char.range(of: #"\s"#, options: .regularExpression) != nil
 93 | }
 94 | 
 95 | let orderedMappingTable: [(String, TokenType)] = [
 96 |     ("{%", .openStatement),
 97 |     ("%}", .closeStatement),
 98 |     ("{{", .openExpression),
 99 |     ("}}", .closeExpression),
100 |     ("(", .openParen),
101 |     (")", .closeParen),
102 |     ("{", .openCurlyBracket),
103 |     ("}", .closeCurlyBracket),
104 |     ("[", .openSquareBracket),
105 |     ("]", .closeSquareBracket),
106 |     (",", .comma),
107 |     (".", .dot),
108 |     (":", .colon),
109 |     ("|", .pipe),
110 |     ("<=", .comparisonBinaryOperator),
111 |     (">=", .comparisonBinaryOperator),
112 |     ("==", .comparisonBinaryOperator),
113 |     ("!=", .comparisonBinaryOperator),
114 |     ("<", .comparisonBinaryOperator),
115 |     (">", .comparisonBinaryOperator),
116 |     ("+", .additiveBinaryOperator),
117 |     ("-", .additiveBinaryOperator),
118 |     ("*", .multiplicativeBinaryOperator),
119 |     ("/", .multiplicativeBinaryOperator),
120 |     ("%", .multiplicativeBinaryOperator),
121 |     ("=", .equals),
122 | ]
123 | 
124 | let escapeCharacters: [String: String] = [
125 |     "n": "\n",
126 |     "t": "\t",
127 |     "r": "\r",
128 |     "b": "\u{0008}",
129 |     "f": "\u{000C}",
130 |     "v": "\u{000B}",
131 |     "'": "'",
132 |     "\"": "\"",
133 |     "\\": "\\",
134 | ]
135 | 
136 | struct PreprocessOptions {
137 |     var trimBlocks: Bool?
138 |     var lstripBlocks: Bool?
139 | }
140 | 
141 | func preprocess(template: String, options: PreprocessOptions = PreprocessOptions()) -> String {
142 |     var template = template
143 |     if template.hasSuffix("\n") {
144 |         template.removeLast()
145 |     }
146 |     template = template.replacing(#/{#.*?#}/#, with: "{##}")
147 |     if options.lstripBlocks == true {
148 |         template = template.replacing(#/(?m)^[ \t]*({[#%])/#, with: { $0.output.1 })
149 |     }
150 |     if options.trimBlocks == true {
151 |         template = template.replacing(#/([#%]})\n/#, with: { $0.output.1 })
152 |     }
153 |     return
154 |         template
155 |         .replacing(#/{##}/#, with: "")
156 |         .replacing(#/-%}\s*/#, with: "%}")
157 |         .replacing(#/\s*{%-/#, with: "{%")
158 |         .replacing(#/-}}\s*/#, with: "}}")
159 |         .replacing(#/\s*{{-/#, with: "{{")
160 | }
161 | 
162 | func tokenize(_ source: String, options: PreprocessOptions = PreprocessOptions()) throws -> [Token] {
163 |     var tokens: [Token] = []
164 |     let src = preprocess(template: source, options: options)
165 |     var cursorPosition = 0
166 | 
167 |     @discardableResult
168 |     func consumeWhile(predicate: (String) -> Bool) throws -> String {
169 |         var str = ""
170 |         while cursorPosition < src.count, predicate(String(src[cursorPosition])) {
171 |             if src[cursorPosition] == "\\" {
172 |                 cursorPosition += 1
173 |                 if cursorPosition >= src.count {
174 |                     throw JinjaError.syntax("Unexpected end of input")
175 |                 }
176 |                 let escaped = String(src[cursorPosition])
177 |                 cursorPosition += 1
178 |                 guard let unescaped = escapeCharacters[escaped] else {
179 |                     throw JinjaError.syntax("Unexpected escaped character: \(escaped)")
180 |                 }
181 |                 str.append(unescaped)
182 |                 continue
183 |             }
184 |             str.append(String(src[cursorPosition]))
185 |             cursorPosition += 1
186 |             if cursorPosition >= src.count {
187 |                 throw JinjaError.syntax("Unexpected end of input")
188 |             }
189 |         }
190 |         return str
191 |     }
192 | 
193 |     main: while cursorPosition < src.count {
194 |         let lastTokenType = tokens.last?.type
195 |         if lastTokenType == nil || lastTokenType == .closeStatement || lastTokenType == .closeExpression {
196 |             var text = ""
197 | 
198 |             while cursorPosition < src.count,
199 |                 !(src[cursorPosition] == "{" && (src[cursorPosition + 1] == "%" || src[cursorPosition + 1] == "{"))
200 |             {
201 |                 text.append(src[cursorPosition])
202 |                 cursorPosition += 1
203 |             }
204 | 
205 |             if !text.isEmpty {
206 |                 tokens.append(Token(value: text, type: .text))
207 |                 continue
208 |             }
209 |         }
210 |         try consumeWhile(predicate: isWhile)
211 |         let char = String(src[cursorPosition])
212 |         if char == "-" || char == "+" {
213 |             let lastTokenType = tokens.last?.type
214 |             if lastTokenType == .text || lastTokenType == nil {
215 |                 throw JinjaError.syntax("Unexpected character: \(char)")
216 |             }
217 |             switch lastTokenType {
218 |             case .identifier,
219 |                 .numericLiteral,
220 |                 .booleanLiteral,
221 |                 .nullLiteral,
222 |                 .stringLiteral,
223 |                 .closeParen,
224 |                 .closeSquareBracket:
225 |                 break
226 |             default:
227 |                 cursorPosition += 1
228 |                 let num = try consumeWhile(predicate: isInteger)
229 |                 tokens.append(Token(value: "\(char)\(num)", type: num.isEmpty ? .unaryOperator : .numericLiteral))
230 |                 continue
231 |             }
232 |         }
233 |         for (char, token) in orderedMappingTable {
234 |             let slice = src.slice(start: cursorPosition, end: cursorPosition + char.count)
235 |             if slice == char {
236 |                 tokens.append(Token(value: char, type: token))
237 |                 cursorPosition += char.count
238 |                 continue main
239 |             }
240 |         }
241 |         if char == "'" || char == "\"" {
242 |             cursorPosition += 1
243 |             let str = try consumeWhile { str in
244 |                 str != char
245 |             }
246 |             tokens.append(Token(value: str, type: .stringLiteral))
247 |             cursorPosition += 1
248 |             continue
249 |         }
250 |         if isInteger(char: char) {
251 |             let num = try consumeWhile(predicate: isInteger)
252 |             tokens.append(Token(value: num, type: .numericLiteral))
253 |             continue
254 |         }
255 |         if isWord(char: char) {
256 |             let word = try consumeWhile(predicate: isWord)
257 |             let type: TokenType = keywords.contains(where: { $0.key == word }) ? keywords[word]! : .identifier
258 |             if type == .in, tokens.last?.type == .not {
259 |                 _ = tokens.popLast()
260 |                 tokens.append(Token(value: "not in", type: .notIn))
261 |             } else {
262 |                 tokens.append(Token(value: word, type: type))
263 |             }
264 |             continue
265 |         }
266 |         throw JinjaError.syntax("Unexpected character: \(char)")
267 |     }
268 |     return tokens
269 | }
270 | 


--------------------------------------------------------------------------------
/Sources/Parser.swift:
--------------------------------------------------------------------------------
  1 | //
  2 | //  Parser.swift
  3 | //
  4 | //
  5 | //  Created by John Mai on 2024/3/21.
  6 | //
  7 | 
  8 | import Foundation
  9 | import OrderedCollections
 10 | 
 11 | func parse(tokens: [Token]) throws -> Program {
 12 |     var program = Program()
 13 |     var current = 0
 14 | 
 15 |     @discardableResult
 16 |     func expect(type: TokenType, error: String) throws -> Token {
 17 |         let prev = tokens[current]
 18 |         current += 1
 19 |         if prev.type != type {
 20 |             throw JinjaError.parser("Parser Error: \(error). \(prev.type) != \(type).")
 21 |         }
 22 | 
 23 |         return prev
 24 |     }
 25 | 
 26 |     func parseArgumentsList() throws -> [Expression] {
 27 |         var args: [Expression] = []
 28 |         while !typeof(.closeParen) {
 29 |             var argument = try parseExpression()
 30 |             if typeof(.equals) {
 31 |                 current += 1  // consume equals
 32 |                 if let identifier = argument as? Identifier {
 33 |                     let value = try parseExpression()
 34 |                     argument = KeywordArgumentExpression(key: identifier, value: value)
 35 |                 } else {
 36 |                     throw JinjaError.syntax("Expected identifier for keyword argument")
 37 |                 }
 38 |             }
 39 |             args.append(argument)
 40 |             if typeof(.comma) {
 41 |                 current += 1  // consume comma
 42 |             }
 43 |         }
 44 |         return args
 45 |     }
 46 | 
 47 |     func parseArgs() throws -> [Expression] {
 48 |         try expect(type: .openParen, error: "Expected opening parenthesis for arguments list")
 49 |         let args = try parseArgumentsList()
 50 |         try expect(type: .closeParen, error: "Expected closing parenthesis for arguments list")
 51 |         return args
 52 |     }
 53 | 
 54 |     func parseText() throws -> StringLiteral {
 55 |         try StringLiteral(value: expect(type: .text, error: "Expected text token").value)
 56 |     }
 57 | 
 58 |     func parseCallExpression(callee: Expression) throws -> Expression {
 59 |         let args = try parseArgs()
 60 |         var expression: Expression = CallExpression(callee: callee, args: args)
 61 |         // Handle potential array indexing after method call
 62 |         if typeof(.openSquareBracket) {
 63 |             expression = MemberExpression(
 64 |                 object: expression,
 65 |                 property: try parseMemberExpressionArgumentsList(),
 66 |                 computed: true
 67 |             )
 68 |         }
 69 |         // Handle potential chained method calls
 70 |         if typeof(.openParen) {
 71 |             expression = try parseCallExpression(callee: expression)
 72 |         }
 73 |         return expression
 74 |     }
 75 | 
 76 |     func parseMemberExpressionArgumentsList() throws -> Expression {
 77 |         var slices: [Expression?] = []
 78 |         var isSlice = false
 79 |         while !typeof(.closeSquareBracket) {
 80 |             if typeof(.colon) {
 81 |                 slices.append(nil)
 82 |                 current += 1  // consume colon
 83 |                 isSlice = true
 84 |             } else {
 85 |                 // Handle negative numbers as indices
 86 |                 if typeof(.additiveBinaryOperator) && tokens[current].value == "-" {
 87 |                     current += 1  // consume the minus sign
 88 |                     if typeof(.numericLiteral) {
 89 |                         let num = tokens[current].value
 90 |                         current += 1
 91 |                         slices.append(NumericLiteral(value: -Int(num)!))
 92 |                     } else {
 93 |                         throw JinjaError.syntax("Expected number after minus sign in array index")
 94 |                     }
 95 |                 } else {
 96 |                     slices.append(try parseExpression())
 97 |                 }
 98 |                 if typeof(.colon) {
 99 |                     current += 1  // consume colon
100 |                     isSlice = true
101 |                 }
102 |             }
103 |         }
104 |         if slices.isEmpty {
105 |             throw JinjaError.syntax("Expected at least one argument for member/slice expression")
106 |         }
107 |         if isSlice {
108 |             if slices.count > 3 {
109 |                 throw JinjaError.syntax("Expected 0-3 arguments for slice expression")
110 |             }
111 |             return SliceExpression(
112 |                 start: slices[0],
113 |                 stop: slices.count > 1 ? slices[1] : nil,
114 |                 step: slices.count > 2 ? slices[2] : nil
115 |             )
116 |         }
117 |         return slices[0]!  // normal member expression
118 |     }
119 | 
120 |     func parseMemberExpression() throws -> Expression {
121 |         var object = try parsePrimaryExpression()
122 |         while typeof(.dot) || typeof(.openSquareBracket) {
123 |             let operation = tokens[current]
124 |             current += 1
125 |             var property: Expression
126 |             let computed = operation.type != .dot
127 |             if computed {
128 |                 property = try parseMemberExpressionArgumentsList()
129 |                 try expect(type: .closeSquareBracket, error: "Expected closing square bracket")
130 |             } else {
131 |                 property = try parsePrimaryExpression()
132 |                 if !(property is Identifier) {
133 |                     throw JinjaError.syntax("Expected identifier following dot operator")
134 |                 }
135 |                 // Handle method calls
136 |                 if typeof(.openParen) {
137 |                     let methodCall = CallExpression(
138 |                         callee: MemberExpression(object: object, property: property, computed: false),
139 |                         args: try parseArgs()
140 |                     )
141 |                     // Handle array indexing after method call
142 |                     if typeof(.openSquareBracket) {
143 |                         current += 1  // consume [
144 |                         let index = try parseExpression()
145 |                         try expect(type: .closeSquareBracket, error: "Expected closing square bracket")
146 |                         object = MemberExpression(object: methodCall, property: index, computed: true)
147 |                         continue
148 |                     }
149 |                     object = methodCall
150 |                     continue
151 |                 }
152 |             }
153 |             object = MemberExpression(
154 |                 object: object,
155 |                 property: property,
156 |                 computed: computed
157 |             )
158 |         }
159 |         return object
160 |     }
161 | 
162 |     func parseCallMemberExpression() throws -> Expression {
163 |         let member = try parseMemberExpression()
164 |         if typeof(.openParen) {
165 |             return try parseCallExpression(callee: member)
166 |         }
167 |         return member
168 |     }
169 | 
170 |     func parseFilterExpression() throws -> Expression {
171 |         var operand = try parseCallMemberExpression()
172 |         while typeof(.pipe) {
173 |             current += 1  // consume pipe
174 |             guard let filterName = try parsePrimaryExpression() as? Identifier else {
175 |                 throw JinjaError.syntax("Expected identifier for the filter")
176 |             }
177 |             var args: [Expression] = []
178 |             var kwargs: [KeywordArgumentExpression] = []
179 |             var dyn_args: Expression?
180 |             var dyn_kwargs: Expression?
181 |             if typeof(.openParen) {
182 |                 // Handle filter with arguments
183 |                 (args, kwargs, dyn_args, dyn_kwargs) = try parseCallArgs()
184 |             }
185 |             operand = FilterExpression(
186 |                 operand: operand,
187 |                 filter: filterName,
188 |                 args: args,
189 |                 kwargs: kwargs,
190 |                 dyn_args: dyn_args,
191 |                 dyn_kwargs: dyn_kwargs
192 |             )
193 |         }
194 |         return operand
195 |     }
196 | 
197 |     func parseCallArgs() throws -> (
198 |         [Expression], [KeywordArgumentExpression], Expression?, Expression?
199 |     ) {
200 |         try expect(type: .openParen, error: "Expected opening parenthesis for arguments list")
201 |         var args: [Expression] = []
202 |         var kwargs: [KeywordArgumentExpression] = []
203 |         var dynArgs: Expression?
204 |         var dynKwargs: Expression?
205 |         var requireComma = false
206 |         while !typeof(.closeParen) {
207 |             if requireComma {
208 |                 try expect(type: .comma, error: "Expected comma between arguments")
209 |                 if typeof(.closeParen) {
210 |                     break
211 |                 }
212 |             }
213 |             if typeof(.multiplicativeBinaryOperator), tokens[current].value == "*" {
214 |                 current += 1  // Consume *
215 |                 if dynArgs != nil || dynKwargs != nil {
216 |                     throw JinjaError.syntax("Multiple dynamic positional arguments are not allowed.")
217 |                 }
218 |                 dynArgs = try parseExpression()
219 |             } else if typeof(.multiplicativeBinaryOperator), tokens[current].value == "**" {
220 |                 current += 1  // Consume **
221 |                 if dynKwargs != nil {
222 |                     throw JinjaError.syntax("Multiple dynamic keyword arguments are not allowed.")
223 |                 }
224 |                 dynKwargs = try parseExpression()
225 |             } else {
226 |                 if typeof(.identifier), tokens.count > current + 1, tokens[current + 1].type == .equals {
227 |                     // Parse keyword argument
228 |                     guard let key = try parsePrimaryExpression() as? Identifier else {
229 |                         throw JinjaError.syntax("Expected identifier for keyword argument key")
230 |                     }
231 |                     try expect(type: .equals, error: "Expected '=' after keyword argument key")
232 |                     let value = try parseExpression()
233 |                     if dynKwargs != nil {
234 |                         throw JinjaError.syntax("Keyword arguments must be after dynamic keyword arguments")
235 |                     }
236 |                     kwargs.append(KeywordArgumentExpression(key: key, value: value))
237 |                 } else {
238 |                     // Parse positional argument
239 |                     if !kwargs.isEmpty || dynKwargs != nil {
240 |                         throw JinjaError.syntax("Positional argument after keyword argument")
241 |                     }
242 |                     if dynArgs != nil {
243 |                         throw JinjaError.syntax("Positional arguments must be after dynamic positional arguments")
244 |                     }
245 |                     args.append(try parseExpression())
246 |                 }
247 |             }
248 |             requireComma = true
249 |         }
250 |         try expect(type: .closeParen, error: "Expected closing parenthesis for arguments list")
251 |         return (args, kwargs, dynArgs, dynKwargs)
252 |     }
253 | 
254 |     func parseTestExpression() throws -> Expression {
255 |         var operand = try parseFilterExpression()
256 |         while typeof(.is) {
257 |             current += 1
258 |             let negate = typeof(.not)
259 |             if negate {
260 |                 current += 1
261 |             }
262 |             var filter = try parsePrimaryExpression()
263 |             if let boolLiteralFilter = filter as? BoolLiteral {
264 |                 filter = Identifier(value: String(boolLiteralFilter.value))
265 |             } else if filter is NullLiteral {
266 |                 filter = Identifier(value: "none")
267 |             }
268 |             if let test = filter as? Identifier {
269 |                 operand = TestExpression(operand: operand, negate: negate, test: test)
270 |             } else {
271 |                 throw JinjaError.syntax("Expected identifier for the test")
272 |             }
273 |         }
274 |         return operand
275 |     }
276 | 
277 |     func parseMultiplicativeExpression() throws -> Expression {
278 |         var left = try parseTestExpression()
279 |         while typeof(.multiplicativeBinaryOperator) {
280 |             let operation = tokens[current]
281 |             current += 1
282 |             let right = try parseTestExpression()
283 |             left = BinaryExpression(operation: operation, left: left, right: right)
284 |         }
285 |         return left
286 |     }
287 | 
288 |     func parseAdditiveExpression() throws -> Expression {
289 |         var left = try parseMultiplicativeExpression()
290 |         while typeof(.additiveBinaryOperator) {
291 |             let operation = tokens[current]
292 |             current += 1
293 |             let right = try parseMultiplicativeExpression()
294 |             left = BinaryExpression(operation: operation, left: left, right: right)
295 |         }
296 |         return left
297 |     }
298 | 
299 |     func parseComparisonExpression() throws -> Expression {
300 |         var left = try parseAdditiveExpression()
301 |         while typeof(.comparisonBinaryOperator) || typeof(.in) || typeof(.notIn)
302 |             || (typeof(.is)
303 |                 && (tokens.count > current + 1
304 |                     && (tokens[current + 1].type == .identifier || tokens[current + 1].type == .not)))
305 |         {
306 |             let operation = tokens[current]
307 |             current += 1
308 |             if operation.type == .is {
309 |                 if typeof(.not) {
310 |                     current += 1
311 |                     if typeof(.identifier), tokens[current].value == "none" {
312 |                         current += 1
313 |                         left = TestExpression(operand: left, negate: true, test: Identifier(value: "none"))
314 |                         continue
315 |                     } else {
316 |                         throw JinjaError.syntax("Expected 'none' after 'is not'")
317 |                     }
318 |                 } else if typeof(.identifier), tokens[current].value == "defined" {
319 |                     current += 1
320 |                     left = TestExpression(operand: left, negate: false, test: Identifier(value: "defined"))
321 |                     continue
322 |                 } else {
323 |                     throw JinjaError.syntax("Expected 'defined' or 'not' after 'is'")
324 |                 }
325 |             } else if operation.type == .notIn {
326 |                 let right = try parseAdditiveExpression()
327 |                 left = BinaryExpression(operation: operation, left: left, right: right)
328 |             } else {
329 |                 let right = try parseAdditiveExpression()
330 |                 left = BinaryExpression(operation: operation, left: left, right: right)
331 |             }
332 |         }
333 |         return left
334 |     }
335 | 
336 |     func parseLogicalNegationExpression() throws -> Expression {
337 |         if typeof(.not) {
338 |             let operation = tokens[current]
339 |             current += 1
340 |             let argument = try parseLogicalNegationExpression()
341 |             return UnaryExpression(operation: operation, argument: argument)
342 |         } else {
343 |             return try parseComparisonExpression()
344 |         }
345 |     }
346 | 
347 |     func parseLogicalAndExpression() throws -> Expression {
348 |         var left = try parseLogicalNegationExpression()
349 |         while typeof(.and) {
350 |             let operation = tokens[current]
351 |             current += 1
352 |             let right = try parseLogicalNegationExpression()
353 |             left = BinaryExpression(operation: operation, left: left, right: right)
354 |         }
355 |         return left
356 |     }
357 | 
358 |     func parseLogicalOrExpression() throws -> Expression {
359 |         var left = try parseLogicalAndExpression()
360 |         while typeof(.or) {
361 |             current += 1  // Consume 'or'
362 |             let right = try parseLogicalAndExpression()
363 |             left = BinaryExpression(operation: Token(value: "or", type: .or), left: left, right: right)
364 |         }
365 |         return left
366 |     }
367 | 
368 |     func parseTernaryExpression() throws -> Expression {
369 |         let a = try parseLogicalOrExpression()
370 |         if typeof(.if) {
371 |             current += 1  // consume if token
372 |             let predicate = try parseLogicalOrExpression()
373 |             if typeof(.else) {
374 |                 // Ternary expression with else
375 |                 current += 1  // consume else token
376 |                 let b = try parseLogicalOrExpression()
377 |                 return If(test: predicate, body: [a], alternate: [b])
378 |             } else {
379 |                 // Select expression on iterable
380 |                 return SelectExpression(iterable: a, test: predicate)
381 |             }
382 |         }
383 |         return a
384 |     }
385 | 
386 |     func parseExpression() throws -> Expression {
387 |         try parseTernaryExpression()
388 |     }
389 | 
390 |     func typeof(_ types: TokenType...) -> Bool {
391 |         guard current + types.count <= tokens.count else {
392 |             return false
393 |         }
394 |         for (index, type) in types.enumerated() {
395 |             if type != tokens[current + index].type {
396 |                 return false
397 |             }
398 |         }
399 |         return true
400 |     }
401 | 
402 |     func parseSetStatement() throws -> Statement {
403 |         let left = try parseExpression()
404 |         if typeof(.equals) {
405 |             current += 1  // consume equals
406 |             // Parse the right-hand side as an expression
407 |             let value = try parseExpression()
408 |             try expect(type: .closeStatement, error: "Expected closing statement token")
409 |             return Set(assignee: left, value: value)
410 |         }
411 |         // If there's no equals sign, treat it as an expression statement
412 |         try expect(type: .closeStatement, error: "Expected closing statement token")
413 |         return left
414 |     }
415 | 
416 |     func parseIfStatement() throws -> Statement {
417 |         let test = try parseExpression()
418 |         try expect(type: .closeStatement, error: "Expected closing statement token")
419 |         var body: [Statement] = []
420 |         var alternate: [Statement] = []
421 |         while !(tokens[current].type == .openStatement
422 |             && (tokens[current + 1].type == .elseIf || tokens[current + 1].type == .else
423 |                 || tokens[current + 1].type == .endIf))
424 |         {
425 |             body.append(try parseAny())
426 |         }
427 |         if tokens[current].type == .openStatement, tokens[current + 1].type != .endIf {
428 |             current += 1
429 |             if typeof(.elseIf) {
430 |                 try expect(type: .elseIf, error: "Expected elseif token")
431 |                 alternate.append(try parseIfStatement())
432 |             } else {
433 |                 try expect(type: .else, error: "Expected else token")
434 |                 try expect(type: .closeStatement, error: "Expected closing statement token")
435 | 
436 |                 while !(tokens[current].type == .openStatement && tokens[current + 1].type == .endIf) {
437 |                     alternate.append(try parseAny())
438 |                 }
439 |             }
440 |         }
441 |         return If(test: test, body: body, alternate: alternate)
442 |     }
443 | 
444 |     func parsePrimaryExpression() throws -> Expression {
445 |         let token = tokens[current]
446 |         switch token.type {
447 |         case .numericLiteral:
448 |             current += 1
449 |             if let intValue = Int(token.value) {
450 |                 return NumericLiteral(value: intValue)
451 |             } else if let doubleValue = Double(token.value) {
452 |                 return NumericLiteral(value: doubleValue)
453 |             } else {
454 |                 throw JinjaError.parser("Invalid numeric literal: \(token.value)")
455 |             }
456 |         case .stringLiteral:
457 |             current += 1
458 |             return StringLiteral(value: token.value)
459 |         case .booleanLiteral:
460 |             current += 1
461 |             return BoolLiteral(value: token.value == "true")
462 |         case .nullLiteral:
463 |             current += 1
464 |             return NullLiteral()
465 |         case .identifier:
466 |             current += 1
467 |             return Identifier(value: token.value)
468 |         case .openParen:
469 |             current += 1
470 |             let expression = try parseExpressionSequence()
471 |             if tokens[current].type != .closeParen {
472 |                 throw JinjaError.syntax("Expected closing parenthesis, got \(tokens[current].type) instead")
473 |             }
474 |             current += 1
475 |             return expression
476 |         case .openSquareBracket:
477 |             current += 1
478 |             var values: [Expression] = []
479 |             while !typeof(.closeSquareBracket) {
480 |                 try values.append(parseExpression())
481 |                 if typeof(.comma) {
482 |                     current += 1
483 |                 }
484 |             }
485 |             current += 1
486 |             return ArrayLiteral(value: values)
487 |         case .openCurlyBracket:
488 |             current += 1
489 |             var values = OrderedDictionary<String, Expression>()
490 |             while !typeof(.closeCurlyBracket) {
491 |                 let key = try parseExpression()
492 |                 try expect(type: .colon, error: "Expected colon between key and value in object literal")
493 |                 let value = try parseExpression()
494 | 
495 |                 if let key = key as? StringLiteral {
496 |                     values[key.value] = value
497 |                 } else if let key = key as? Identifier {
498 |                     values[key.value] = value
499 |                 } else {
500 |                     throw JinjaError.syntax("Expected string literal or identifier as key in object literal")
501 |                 }
502 | 
503 |                 if typeof(.comma) {
504 |                     current += 1
505 |                 }
506 |             }
507 |             current += 1
508 |             return ObjectLiteral(value: values)
509 |         default:
510 |             throw JinjaError.syntax("Unexpected token: \(token.type)")
511 |         }
512 |     }
513 | 
514 |     func parseExpressionSequence(primary: Bool = false) throws -> Expression {
515 |         let fn = primary ? parsePrimaryExpression : parseExpression
516 |         var expressions: [Expression] = try [fn()]
517 |         let isTuple = typeof(.comma)
518 |         while isTuple {
519 |             current += 1  // consume comma
520 |             try expressions.append(fn())
521 |             if !typeof(.comma) {
522 |                 break
523 |             }
524 |         }
525 |         // Return either a tuple or single expression
526 |         return isTuple ? TupleLiteral(value: expressions) : expressions[0]
527 |     }
528 | 
529 |     func not(_ types: TokenType...) -> Bool {
530 |         guard current + types.count <= tokens.count else {
531 |             return false
532 |         }
533 |         return types.enumerated().contains { i, type -> Bool in
534 |             type != tokens[current + i].type
535 |         }
536 |     }
537 | 
538 |     func parseForStatement() throws -> Statement {
539 |         let loopVariable = try parseExpressionSequence(primary: true)
540 |         if !(loopVariable is Identifier || loopVariable is TupleLiteral) {
541 |             throw JinjaError.syntax(
542 |                 "Expected identifier/tuple for the loop variable, got \(type(of: loopVariable)) instead"
543 |             )
544 |         }
545 |         try expect(type: .in, error: "Expected `in` keyword following loop variable")
546 |         let iterable = try parseExpression()
547 |         // Handle optional if condition for filtering
548 |         var test: Expression? = nil
549 |         if typeof(.if) {
550 |             current += 1  // consume if token
551 |             test = try parseExpression()
552 |         }
553 |         try expect(type: .closeStatement, error: "Expected closing statement token")
554 |         var body: [Statement] = []
555 |         var defaultBlock: [Statement] = []
556 |         while not(.openStatement, .endFor) && not(.openStatement, .else) {
557 |             body.append(try parseAny())
558 |         }
559 |         if typeof(.openStatement, .else) {
560 |             current += 1  // consume {%
561 |             try expect(type: .else, error: "Expected else token")
562 |             try expect(type: .closeStatement, error: "Expected closing statement token")
563 | 
564 |             while not(.openStatement, .endFor) {
565 |                 defaultBlock.append(try parseAny())
566 |             }
567 |         }
568 |         return For(
569 |             loopvar: loopVariable,
570 |             iterable: iterable,
571 |             body: body,
572 |             defaultBlock: defaultBlock,
573 |             test: test
574 |         )
575 |     }
576 | 
577 |     func parseMacroStatement() throws -> Macro {
578 |         let name = try parsePrimaryExpression()
579 |         if !(name is Identifier) {
580 |             throw JinjaError.syntax("Expected identifier following macro statement")
581 |         }
582 |         let args = try parseArgs()
583 |         try expect(type: .closeStatement, error: "Expected closing statement token")
584 |         var body: [Statement] = []
585 |         while not(.openStatement, .endMacro) {
586 |             body.append(try parseAny())
587 |         }
588 |         return Macro(name: name as! Identifier, args: args, body: body)
589 |     }
590 | 
591 |     func parseJinjaStatement() throws -> Statement {
592 |         // Consume {% %} tokens
593 |         try expect(type: .openStatement, error: "Expected opening statement token")
594 |         var result: Statement
595 | 
596 |         switch tokens[current].type {
597 |         case .set:
598 |             current += 1  // consume 'set' token
599 |             result = try parseSetStatement()
600 |         case .if:
601 |             current += 1  // consume 'if' token
602 |             result = try parseIfStatement()
603 |             try expect(type: .openStatement, error: "Expected {% token")
604 |             try expect(type: .endIf, error: "Expected endif token")
605 |             try expect(type: .closeStatement, error: "Expected %} token")
606 |         case .macro:
607 |             current += 1  // consume 'macro' token
608 |             result = try parseMacroStatement()
609 |             try expect(type: .openStatement, error: "Expected {% token")
610 |             try expect(type: .endMacro, error: "Expected endmacro token")
611 |             try expect(type: .closeStatement, error: "Expected %} token")
612 |         case .for:
613 |             current += 1  // consume 'for' token
614 |             result = try parseForStatement()
615 |             try expect(type: .openStatement, error: "Expected {% token")
616 |             try expect(type: .endFor, error: "Expected endfor token")
617 |             try expect(type: .closeStatement, error: "Expected %} token")
618 |         default:
619 |             // Handle expressions within statements
620 |             result = try parseExpression()
621 |             try expect(type: .closeStatement, error: "Expected closing statement token")
622 |         }
623 | 
624 |         return result
625 |     }
626 | 
627 |     func parseJinjaExpression() throws -> Statement {
628 |         try expect(type: .openExpression, error: "Expected opening expression token")
629 |         let result = try parseExpression()
630 |         try expect(type: .closeExpression, error: "Expected closing expression token")
631 |         return result
632 |     }
633 | 
634 |     func parseAny() throws -> Statement {
635 |         switch tokens[current].type {
636 |         case .text:
637 |             return try parseText()
638 |         case .openStatement:
639 |             return try parseJinjaStatement()
640 |         case .openExpression:
641 |             return try parseJinjaExpression()
642 |         default:
643 |             throw JinjaError.syntax("Unexpected token type: \(tokens[current].type)")
644 |         }
645 |     }
646 | 
647 |     while current < tokens.count {
648 |         try program.body.append(parseAny())
649 |     }
650 | 
651 |     return program
652 | }
653 | 


--------------------------------------------------------------------------------
/Sources/Runtime.swift:
--------------------------------------------------------------------------------
   1 | //
   2 | //  Runtime.swift
   3 | //
   4 | //
   5 | //  Created by John Mai on 2024/3/22.
   6 | //
   7 | 
   8 | import Foundation
   9 | import OrderedCollections
  10 | 
  11 | protocol RuntimeValue {
  12 |     associatedtype ValueType
  13 | 
  14 |     var value: ValueType { get }
  15 |     var builtins: [String: any RuntimeValue] { get set }
  16 | 
  17 |     func bool() -> Bool
  18 | }
  19 | 
  20 | struct NumericValue: RuntimeValue {
  21 |     var value: any Numeric
  22 |     var builtins: [String: any RuntimeValue] = [:]
  23 | 
  24 |     func bool() -> Bool {
  25 |         if let intValue = self.value as? Int {
  26 |             return intValue != 0
  27 |         } else if let doubleValue = self.value as? Double {
  28 |             return doubleValue != 0.0
  29 |         }
  30 |         return false
  31 |     }
  32 | }
  33 | 
  34 | struct BooleanValue: RuntimeValue {
  35 |     var value: Bool
  36 |     var builtins: [String: any RuntimeValue] = [:]
  37 | 
  38 |     func bool() -> Bool {
  39 |         self.value
  40 |     }
  41 | }
  42 | 
  43 | struct NullValue: RuntimeValue {
  44 |     let value: Any? = nil
  45 |     var builtins: [String: any RuntimeValue] = [:]
  46 | 
  47 |     func bool() -> Bool {
  48 |         false
  49 |     }
  50 | }
  51 | 
  52 | struct UndefinedValue: RuntimeValue {
  53 |     let value: Any? = nil
  54 |     var builtins: [String: any RuntimeValue] = [:]
  55 | 
  56 |     func bool() -> Bool {
  57 |         false
  58 |     }
  59 | }
  60 | 
  61 | struct ArrayValue: RuntimeValue {
  62 |     var value: [any RuntimeValue]
  63 |     var builtins: [String: any RuntimeValue] = [:]
  64 | 
  65 |     init(value: [any RuntimeValue]) {
  66 |         self.value = value
  67 |         self.builtins["length"] = FunctionValue(value: { _, _ in
  68 |             NumericValue(value: value.count)
  69 |         })
  70 |     }
  71 | 
  72 |     func bool() -> Bool {
  73 |         return !self.value.isEmpty
  74 |     }
  75 | }
  76 | 
  77 | struct TupleValue: RuntimeValue {
  78 |     var value: [any RuntimeValue]
  79 |     var builtins: [String: any RuntimeValue] = [:]
  80 | 
  81 |     init(value: [any RuntimeValue]) {
  82 |         self.value = value
  83 |         self.builtins["length"] = FunctionValue(value: { _, _ in
  84 |             NumericValue(value: value.count)
  85 |         })
  86 |     }
  87 | 
  88 |     func bool() -> Bool {
  89 |         !self.value.isEmpty
  90 |     }
  91 | }
  92 | 
  93 | class ObjectValue: RuntimeValue, Sequence {
  94 |     var storage: OrderedDictionary<String, any RuntimeValue>
  95 |     var builtins: [String: any RuntimeValue]
  96 | 
  97 |     var value: [String: any RuntimeValue] { Dictionary(uniqueKeysWithValues: storage.map { ($0, $1) }) }
  98 |     var orderedKeys: [String] { Array(storage.keys) }
  99 | 
 100 |     init(value: [String: any RuntimeValue], keyOrder: [String]? = nil) {
 101 |         // If keyOrder is provided, use it; otherwise, maintain the original order from the dictionary
 102 |         let orderedKeys = keyOrder ?? Array(value.keys)
 103 |         let orderedPairs = orderedKeys.compactMap { key in
 104 |             value[key].map { (key, $0) }
 105 |         }
 106 | 
 107 |         // Recursively create OrderedDictionary for nested objects
 108 |         let processedPairs = orderedPairs.map { key, value -> (String, any RuntimeValue) in
 109 |             if let objectValue = value as? ObjectValue {
 110 |                 // Already an ObjectValue, use it directly
 111 |                 return (key, objectValue)
 112 |             } else if let dictValue = value.value as? [String: any RuntimeValue] {
 113 |                 // If the value contains a dictionary, convert it to ObjectValue
 114 |                 return (key, ObjectValue(value: dictValue))
 115 |             }
 116 |             return (key, value)
 117 |         }
 118 | 
 119 |         self.storage = OrderedDictionary(uniqueKeysWithValues: processedPairs)
 120 |         self.builtins = [
 121 |             "get": FunctionValue(value: { args, _ in
 122 |                 guard let key = args[0] as? StringValue else {
 123 |                     throw JinjaError.runtime("Object key must be a string: got \(type(of: args[0]))")
 124 |                 }
 125 |                 if let value = value[key.value] {
 126 |                     return value
 127 |                 } else if args.count > 1 {
 128 |                     return args[1]
 129 |                 }
 130 |                 return NullValue()
 131 |             }),
 132 |             "items": FunctionValue(value: { _, _ in
 133 |                 ArrayValue(
 134 |                     value: orderedPairs.map { key, value in
 135 |                         ArrayValue(value: [StringValue(value: key), value])
 136 |                     }
 137 |                 )
 138 |             }),
 139 |         ]
 140 |     }
 141 | 
 142 |     func setValue(key: String, value: any RuntimeValue) {
 143 |         storage[key] = value
 144 |     }
 145 | 
 146 |     func bool() -> Bool {
 147 |         !storage.isEmpty
 148 |     }
 149 | 
 150 |     func makeIterator() -> OrderedDictionary<String, any RuntimeValue>.Iterator {
 151 |         return storage.makeIterator()
 152 |     }
 153 | }
 154 | 
 155 | struct FunctionValue: RuntimeValue {
 156 |     var value: ([any RuntimeValue], Environment) throws -> any RuntimeValue
 157 |     var builtins: [String: any RuntimeValue] = [:]
 158 | 
 159 |     func bool() -> Bool {
 160 |         true
 161 |     }
 162 | }
 163 | 
 164 | struct StringValue: RuntimeValue {
 165 |     var value: String
 166 |     var builtins: [String: any RuntimeValue] = [:]
 167 | 
 168 |     init(value: String) {
 169 |         self.value = value
 170 |         self.builtins = [
 171 |             "upper": FunctionValue(value: { _, _ in
 172 |                 StringValue(value: value.uppercased())
 173 |             }),
 174 |             "lower": FunctionValue(value: { _, _ in
 175 |                 StringValue(value: value.lowercased())
 176 |             }),
 177 |             "strip": FunctionValue(value: { _, _ in
 178 |                 StringValue(value: value.trimmingCharacters(in: .whitespacesAndNewlines))
 179 |             }),
 180 |             "title": FunctionValue(value: { _, _ in
 181 |                 StringValue(value: value.titleCase())
 182 |             }),
 183 |             "length": FunctionValue(value: { _, _ in
 184 |                 NumericValue(value: value.count)
 185 |             }),
 186 |             "rstrip": FunctionValue(value: { _, _ in
 187 |                 StringValue(value: value.replacingOccurrences(of: "\\s+

quot;, with: "", options: .regularExpression))
 188 |             }),
 189 |             "lstrip": FunctionValue(value: { _, _ in
 190 |                 StringValue(value: value.replacingOccurrences(of: "^\\s+", with: "", options: .regularExpression))
 191 |             }),
 192 |             "split": FunctionValue(value: { args, _ in
 193 |                 guard let separatorArg = args.first as? StringValue else {
 194 |                     // Default split by whitespace if no separator is provided or if it's not a string
 195 |                     // (This mimics Python's str.split() behavior loosely)
 196 |                     let components = value.split(whereSeparator: { $0.isWhitespace })
 197 |                     return ArrayValue(value: components.map { StringValue(value: String($0)) })
 198 |                 }
 199 |                 let separator = separatorArg.value
 200 |                 // TODO: Add optional maxsplit argument handling if needed
 201 |                 let components = value.components(separatedBy: separator)
 202 |                 return ArrayValue(value: components.map { StringValue(value: $0) })
 203 |             }),
 204 |             "startswith": FunctionValue(value: { args, _ in
 205 |                 guard let prefixArg = args.first as? StringValue else {
 206 |                     throw JinjaError.runtime("startswith requires a string prefix argument")
 207 |                 }
 208 |                 return BooleanValue(value: value.hasPrefix(prefixArg.value))
 209 |             }),
 210 |             "endswith": FunctionValue(value: { args, _ in
 211 |                 guard let suffixArg = args.first as? StringValue else {
 212 |                     throw JinjaError.runtime("endswith requires a string suffix argument")
 213 |                 }
 214 |                 return BooleanValue(value: value.hasSuffix(suffixArg.value))
 215 |             }),
 216 |         ]
 217 |     }
 218 | 
 219 |     func bool() -> Bool {
 220 |         !self.value.isEmpty
 221 |     }
 222 | }
 223 | 
 224 | struct Interpreter {
 225 |     var global: Environment
 226 | 
 227 |     init(env: Environment?) {
 228 |         self.global = env ?? Environment()
 229 |     }
 230 | 
 231 |     func run(program: Program) throws -> any RuntimeValue {
 232 |         try self.evaluate(statement: program, environment: self.global)
 233 |     }
 234 | 
 235 |     func evaluateBlock(statements: [Statement], environment: Environment) throws -> StringValue {
 236 |         var result = ""
 237 |         for statement in statements {
 238 |             let lastEvaluated = try self.evaluate(statement: statement, environment: environment)
 239 |             if !(lastEvaluated is NullValue), !(lastEvaluated is UndefinedValue) {
 240 |                 if let stringValue = lastEvaluated as? StringValue {
 241 |                     result += stringValue.value
 242 |                 } else if let numericValue = lastEvaluated as? NumericValue {
 243 |                     result += String(describing: numericValue.value)
 244 |                 } else if let booleanValue = lastEvaluated as? BooleanValue {
 245 |                     result += String(booleanValue.value)
 246 |                 } else if let arrayValue = lastEvaluated as? ArrayValue {
 247 |                     // Convert array to JSON string
 248 |                     result += try toJSON(arrayValue)
 249 |                 } else if let objectValue = lastEvaluated as? ObjectValue {
 250 |                     // Convert object to JSON string
 251 |                     result += try toJSON(objectValue)
 252 |                 } else {
 253 |                     throw JinjaError.runtime("Cannot convert to string: \(type(of: lastEvaluated))")
 254 |                 }
 255 |             }
 256 |         }
 257 |         return StringValue(value: result)
 258 |     }
 259 | 
 260 |     func evalProgram(program: Program, environment: Environment) throws -> StringValue {
 261 |         try self.evaluateBlock(statements: program.body, environment: environment)
 262 |     }
 263 | 
 264 |     func evaluateSet(node: Set, environment: Environment) throws -> NullValue {
 265 |         let rhs = try self.evaluate(statement: node.value, environment: environment)
 266 |         if let identifier = node.assignee as? Identifier {
 267 |             let variableName = identifier.value
 268 |             try environment.setVariable(name: variableName, value: rhs)
 269 |         } else if let member = node.assignee as? MemberExpression {
 270 |             let object = try self.evaluate(statement: member.object, environment: environment)
 271 |             guard let objectValue = object as? ObjectValue else {
 272 |                 throw JinjaError.runtime("Cannot assign to member of non-object")
 273 |             }
 274 |             guard let property = member.property as? Identifier else {
 275 |                 throw JinjaError.runtime("Cannot assign to member with non-identifier property")
 276 |             }
 277 |             // Modify the copy
 278 |             objectValue.setValue(key: property.value, value: rhs)
 279 |             // Update the environment with the modified copy
 280 |             if let parentIdentifier = member.object as? Identifier {
 281 |                 try environment.setVariable(name: parentIdentifier.value, value: objectValue)
 282 |             } else {
 283 |                 throw JinjaError.runtime("Cannot assign to computed member expression")
 284 |             }
 285 |         } else {
 286 |             throw JinjaError.runtime("Invalid LHS inside assignment expression: \(node.assignee)")
 287 |         }
 288 |         return NullValue()
 289 |     }
 290 | 
 291 |     func evaluateIf(node: If, environment: Environment) throws -> StringValue {
 292 |         // Special handling for direct variable checks
 293 |         if let identifier = node.test as? Identifier {
 294 |             // For cases like {% if thinking %}, get the variable directly
 295 |             let value = environment.lookupVariable(name: identifier.value)
 296 |             // Use the bool method which will return false for undefined values
 297 |             let testResult = value.bool()
 298 |             return try self.evaluateBlock(statements: testResult ? node.body : node.alternate, environment: environment)
 299 |         }
 300 | 
 301 |         // For non-identifier checks, evaluate normally
 302 |         let test = try self.evaluate(statement: node.test, environment: environment)
 303 |         return try self.evaluateBlock(statements: test.bool() ? node.body : node.alternate, environment: environment)
 304 |     }
 305 | 
 306 |     func evaluateIdentifier(node: Identifier, environment: Environment) throws -> any RuntimeValue {
 307 |         let value = environment.lookupVariable(name: node.value)
 308 |         return value
 309 |     }
 310 | 
 311 |     func evaluateFor(node: For, environment: Environment) throws -> StringValue {
 312 |         // Scope for the for loop
 313 |         let scope = Environment(parent: environment)
 314 |         let test: Expression?
 315 |         let iterable: any RuntimeValue
 316 |         if let selectExpression = node.iterable as? SelectExpression {
 317 |             iterable = try self.evaluate(statement: selectExpression.iterable, environment: scope)
 318 |             test = selectExpression.test
 319 |         } else {
 320 |             iterable = try self.evaluate(statement: node.iterable, environment: scope)
 321 |             test = nil
 322 |         }
 323 |         var items: [any RuntimeValue] = []
 324 |         var scopeUpdateFunctions: [(Environment) throws -> Void] = []
 325 |         // Keep track of the indices of the original iterable that passed the test
 326 |         var filteredIndices: [Int] = []
 327 |         var originalIndex = 0
 328 |         // Handle ArrayValue
 329 |         if let arrayIterable = iterable as? ArrayValue {
 330 |             for current in arrayIterable.value {
 331 |                 let loopScope = Environment(parent: scope)
 332 |                 var scopeUpdateFunction: (Environment) throws -> Void
 333 |                 if let identifier = node.loopvar as? Identifier {
 334 |                     scopeUpdateFunction = { scope in
 335 |                         try scope.setVariable(name: identifier.value, value: current)
 336 |                     }
 337 |                 } else if let tupleLiteral = node.loopvar as? TupleLiteral {
 338 |                     guard let currentArray = current as? ArrayValue else {
 339 |                         throw JinjaError.runtime("Cannot unpack non-iterable type: \(type(of: current))")
 340 |                     }
 341 |                     if tupleLiteral.value.count != currentArray.value.count {
 342 |                         throw JinjaError.runtime(
 343 |                             "Too \(tupleLiteral.value.count > currentArray.value.count ? "few" : "many") items to unpack"
 344 |                         )
 345 |                     }
 346 |                     scopeUpdateFunction = { scope in
 347 |                         for (i, value) in tupleLiteral.value.enumerated() {
 348 |                             guard let identifier = value as? Identifier else {
 349 |                                 throw JinjaError.runtime("Cannot unpack non-identifier type: \(type(of: value))")
 350 |                             }
 351 |                             try scope.setVariable(name: identifier.value, value: currentArray.value[i])
 352 |                         }
 353 |                     }
 354 |                 } else {
 355 |                     throw JinjaError.runtime("Invalid loop variable(s): \(type(of: node.loopvar))")
 356 |                 }
 357 |                 // Evaluate the test before adding the item
 358 |                 if let test {
 359 |                     try scopeUpdateFunction(loopScope)
 360 |                     let testValue = try self.evaluate(statement: test, environment: loopScope)
 361 |                     if !testValue.bool() {
 362 |                         originalIndex += 1
 363 |                         continue
 364 |                     }
 365 |                 }
 366 |                 items.append(current)
 367 |                 scopeUpdateFunctions.append(scopeUpdateFunction)
 368 |                 filteredIndices.append(originalIndex)
 369 |                 originalIndex += 1
 370 |             }
 371 |             // Handle StringValue as a special case
 372 |         } else if let stringIterable = iterable as? StringValue {
 373 |             // Treat the string as an iterable of characters
 374 |             for char in stringIterable.value {
 375 |                 let current = StringValue(value: String(char))
 376 |                 let loopScope = Environment(parent: scope)
 377 |                 var scopeUpdateFunction: (Environment) throws -> Void
 378 |                 if let identifier = node.loopvar as? Identifier {
 379 |                     scopeUpdateFunction = { scope in
 380 |                         try scope.setVariable(name: identifier.value, value: current)
 381 |                     }
 382 |                 } else {
 383 |                     throw JinjaError.runtime("Invalid loop variable(s): \(type(of: node.loopvar))")
 384 |                 }
 385 |                 // Evaluate the test before adding the item
 386 |                 if let test = test {
 387 |                     try scopeUpdateFunction(loopScope)
 388 |                     let testValue = try self.evaluate(statement: test, environment: loopScope)
 389 |                     if !testValue.bool() {
 390 |                         originalIndex += 1
 391 |                         continue
 392 |                     }
 393 |                 }
 394 |                 items.append(current)
 395 |                 scopeUpdateFunctions.append(scopeUpdateFunction)
 396 |                 filteredIndices.append(originalIndex)
 397 |                 originalIndex += 1
 398 |             }
 399 |             // Handle ObjectValue (dictionary)
 400 |         } else if let objectIterable = iterable as? ObjectValue {
 401 |             // Treat the dictionary as an iterable of key-value pairs
 402 |             for (key, value) in objectIterable {
 403 |                 let current = ArrayValue(value: [StringValue(value: key), value])
 404 |                 let loopScope = Environment(parent: scope)
 405 |                 var scopeUpdateFunction: (Environment) throws -> Void
 406 |                 if let identifier = node.loopvar as? Identifier {
 407 |                     scopeUpdateFunction = { scope in
 408 |                         try scope.setVariable(name: identifier.value, value: current)
 409 |                     }
 410 |                 } else if let tupleLiteral = node.loopvar as? TupleLiteral {
 411 |                     // Support unpacking of key-value pairs into two variables
 412 |                     if tupleLiteral.value.count != 2 {
 413 |                         throw JinjaError.runtime(
 414 |                             "Cannot unpack dictionary entry: expected 2 variables, got \(tupleLiteral.value.count)"
 415 |                         )
 416 |                     }
 417 |                     guard let keyIdentifier = tupleLiteral.value[0] as? Identifier else {
 418 |                         throw JinjaError.runtime(
 419 |                             "Cannot unpack dictionary entry into non-identifier: \(type(of: tupleLiteral.value[0]))"
 420 |                         )
 421 |                     }
 422 |                     guard let valueIdentifier = tupleLiteral.value[1] as? Identifier else {
 423 |                         throw JinjaError.runtime(
 424 |                             "Cannot unpack dictionary entry into non-identifier: \(type(of: tupleLiteral.value[1]))"
 425 |                         )
 426 |                     }
 427 |                     scopeUpdateFunction = { scope in
 428 |                         try scope.setVariable(name: keyIdentifier.value, value: StringValue(value: key))
 429 |                         try scope.setVariable(name: valueIdentifier.value, value: value)
 430 |                     }
 431 |                 } else {
 432 |                     throw JinjaError.runtime("Invalid loop variable(s): \(type(of: node.loopvar))")
 433 |                 }
 434 |                 // Evaluate the test before adding the item
 435 |                 if let test = test {
 436 |                     try scopeUpdateFunction(loopScope)
 437 |                     let testValue = try self.evaluate(statement: test, environment: loopScope)
 438 |                     if !testValue.bool() {
 439 |                         originalIndex += 1
 440 |                         continue
 441 |                     }
 442 |                 }
 443 |                 items.append(current)
 444 |                 scopeUpdateFunctions.append(scopeUpdateFunction)
 445 |                 filteredIndices.append(originalIndex)
 446 |                 originalIndex += 1
 447 |             }
 448 |         } else {
 449 |             throw JinjaError.runtime("Expected iterable type in for loop: got \(type(of: iterable))")
 450 |         }
 451 |         var result = ""
 452 |         var noIteration = true
 453 |         for i in 0 ..< items.count {
 454 |             // Get the previous and next items that passed the filter
 455 |             let previousIndex = filteredIndices.firstIndex(of: filteredIndices[i])! - 1
 456 |             let nextIndex = filteredIndices.firstIndex(of: filteredIndices[i])! + 1
 457 |             let previtem: any RuntimeValue
 458 |             if previousIndex >= 0 {
 459 |                 let previousFilteredIndex = filteredIndices[previousIndex]
 460 |                 if let arrayIterable = iterable as? ArrayValue {
 461 |                     previtem = arrayIterable.value[previousFilteredIndex]
 462 |                 } else if let stringIterable = iterable as? StringValue {
 463 |                     let index = stringIterable.value.index(
 464 |                         stringIterable.value.startIndex,
 465 |                         offsetBy: previousFilteredIndex
 466 |                     )
 467 |                     previtem = StringValue(value: String(stringIterable.value[index]))
 468 |                 } else if let objectIterable = iterable as? ObjectValue {
 469 |                     let (key, value) = objectIterable.storage.elements[previousFilteredIndex]
 470 |                     previtem = ArrayValue(value: [StringValue(value: key), value])
 471 |                 } else {
 472 |                     previtem = UndefinedValue()
 473 |                 }
 474 |             } else {
 475 |                 previtem = UndefinedValue()
 476 |             }
 477 |             let nextitem: any RuntimeValue
 478 |             if nextIndex < filteredIndices.count {
 479 |                 let nextFilteredIndex = filteredIndices[nextIndex]
 480 |                 if let arrayIterable = iterable as? ArrayValue {
 481 |                     nextitem = arrayIterable.value[nextFilteredIndex]
 482 |                 } else if let stringIterable = iterable as? StringValue {
 483 |                     let index = stringIterable.value.index(stringIterable.value.startIndex, offsetBy: nextFilteredIndex)
 484 |                     nextitem = StringValue(value: String(stringIterable.value[index]))
 485 |                 } else if let objectIterable = iterable as? ObjectValue {
 486 |                     let (key, value) = objectIterable.storage.elements[nextFilteredIndex]
 487 |                     nextitem = ArrayValue(value: [StringValue(value: key), value])
 488 |                 } else {
 489 |                     nextitem = UndefinedValue()
 490 |                 }
 491 |             } else {
 492 |                 nextitem = UndefinedValue()
 493 |             }
 494 |             let loop: [String: any RuntimeValue] = [
 495 |                 "index": NumericValue(value: i + 1),
 496 |                 "index0": NumericValue(value: i),
 497 |                 "revindex": NumericValue(value: items.count - i),
 498 |                 "revindex0": NumericValue(value: items.count - i - 1),
 499 |                 "first": BooleanValue(value: i == 0),
 500 |                 "last": BooleanValue(value: i == items.count - 1),
 501 |                 "length": NumericValue(value: items.count),
 502 |                 "previtem": previtem,
 503 |                 "nextitem": nextitem,
 504 |             ]
 505 |             try scope.setVariable(name: "loop", value: ObjectValue(value: loop))
 506 |             try scopeUpdateFunctions[i](scope)
 507 |             let evaluated = try self.evaluateBlock(statements: node.body, environment: scope)
 508 |             result += evaluated.value
 509 |             noIteration = false
 510 |         }
 511 |         if noIteration {
 512 |             let defaultEvaluated = try self.evaluateBlock(statements: node.defaultBlock, environment: scope)
 513 |             result += defaultEvaluated.value
 514 |         }
 515 |         return StringValue(value: result)
 516 |     }
 517 | 
 518 |     func evaluateBinaryExpression(node: BinaryExpression, environment: Environment) throws -> any RuntimeValue {
 519 |         let left = try self.evaluate(statement: node.left, environment: environment)
 520 |         let right = try self.evaluate(statement: node.right, environment: environment)
 521 |         // Handle 'or'
 522 |         if node.operation.value == "or" {
 523 |             if left.bool() {
 524 |                 return left
 525 |             } else {
 526 |                 return right
 527 |             }
 528 |         }
 529 |         // Handle 'and'
 530 |         if node.operation.value == "and" {
 531 |             if !left.bool() {
 532 |                 return left
 533 |             } else {
 534 |                 return right
 535 |             }
 536 |         }
 537 |         // ==
 538 |         if node.operation.value == "==" {
 539 |             // Handle array indexing for right operand
 540 |             if let memberExpr = node.right as? MemberExpression,
 541 |                 let arrayValue = try self.evaluate(statement: memberExpr.object, environment: environment)
 542 |                     as? ArrayValue,
 543 |                 let indexExpr = memberExpr.property as? NumericLiteral,
 544 |                 let index = indexExpr.value as? Int
 545 |             {
 546 | 
 547 |                 // Handle negative indices
 548 |                 let actualIndex = index < 0 ? arrayValue.value.count + index : index
 549 |                 if actualIndex >= 0 && actualIndex < arrayValue.value.count {
 550 |                     let rightValue = arrayValue.value[actualIndex]
 551 |                     return BooleanValue(value: try areEqual(left, rightValue))
 552 |                 }
 553 |             }
 554 | 
 555 |             return BooleanValue(value: try areEqual(left, right))
 556 |         }
 557 |         // !=
 558 |         if node.operation.value == "!=" {
 559 |             if let left = left as? StringValue, let right = right as? StringValue {
 560 |                 return BooleanValue(value: left.value != right.value)
 561 |             } else if let left = left as? NumericValue, let right = right as? NumericValue {
 562 |                 if let leftInt = left.value as? Int, let rightInt = right.value as? Int {
 563 |                     return BooleanValue(value: leftInt != rightInt)
 564 |                 } else if let leftDouble = left.value as? Double, let rightDouble = right.value as? Double {
 565 |                     return BooleanValue(value: leftDouble != rightDouble)
 566 |                 } else if let leftInt = left.value as? Int, let rightDouble = right.value as? Double {
 567 |                     return BooleanValue(value: Double(leftInt) != rightDouble)
 568 |                 } else if let leftDouble = left.value as? Double, let rightInt = right.value as? Int {
 569 |                     return BooleanValue(value: leftDouble != Double(rightInt))
 570 |                 } else {
 571 |                     throw JinjaError.runtime("Unsupported numeric types for inequality comparison")
 572 |                 }
 573 |             } else if let left = left as? BooleanValue, let right = right as? BooleanValue {
 574 |                 return BooleanValue(value: left.value != right.value)
 575 |             } else if left is NullValue, right is NullValue {
 576 |                 return BooleanValue(value: false)
 577 |             } else if left is UndefinedValue, right is UndefinedValue {
 578 |                 return BooleanValue(value: false)
 579 |             } else if type(of: left) == type(of: right) {
 580 |                 return BooleanValue(value: true)
 581 |             } else {
 582 |                 return BooleanValue(value: true)
 583 |             }
 584 |         }
 585 | 
 586 |         // Handle operations with undefined or null values
 587 |         if left is UndefinedValue || right is UndefinedValue || left is NullValue || right is NullValue {
 588 |             // Boolean operations return false
 589 |             if ["and", "or", "==", "!=", ">", "<", ">=", "<=", "in", "not in"].contains(node.operation.value) {
 590 |                 return BooleanValue(value: false)
 591 |             }
 592 | 
 593 |             // String concatenation with undefined/null
 594 |             if node.operation.value == "+" {
 595 |                 if left is StringValue && !(right is UndefinedValue || right is NullValue) {
 596 |                     return left
 597 |                 } else if right is StringValue && !(left is UndefinedValue || left is NullValue) {
 598 |                     return right
 599 |                 }
 600 |                 return StringValue(value: "")
 601 |             }
 602 | 
 603 |             // Math operations with undefined/null
 604 |             if ["-", "*", "/", "%"].contains(node.operation.value) {
 605 |                 return NumericValue(value: 0)
 606 |             }
 607 | 
 608 |             return BooleanValue(value: false)
 609 |         } else if let left = left as? NumericValue, let right = right as? NumericValue {
 610 |             switch node.operation.value {
 611 |             case "+":
 612 |                 if let leftInt = left.value as? Int, let rightInt = right.value as? Int {
 613 |                     return NumericValue(value: leftInt + rightInt)
 614 |                 } else if let leftDouble = left.value as? Double, let rightDouble = right.value as? Double {
 615 |                     return NumericValue(value: leftDouble + rightDouble)
 616 |                 } else if let leftInt = left.value as? Int, let rightDouble = right.value as? Double {
 617 |                     return NumericValue(value: Double(leftInt) + rightDouble)
 618 |                 } else if let leftDouble = left.value as? Double, let rightInt = right.value as? Int {
 619 |                     return NumericValue(value: leftDouble + Double(rightInt))
 620 |                 } else {
 621 |                     throw JinjaError.runtime("Unsupported numeric types for addition")
 622 |                 }
 623 |             case "-":
 624 |                 if let leftInt = left.value as? Int, let rightInt = right.value as? Int {
 625 |                     return NumericValue(value: leftInt - rightInt)
 626 |                 } else if let leftDouble = left.value as? Double, let rightDouble = right.value as? Double {
 627 |                     return NumericValue(value: leftDouble - rightDouble)
 628 |                 } else if let leftInt = left.value as? Int, let rightDouble = right.value as? Double {
 629 |                     return NumericValue(value: Double(leftInt) - rightDouble)
 630 |                 } else if let leftDouble = left.value as? Double, let rightInt = right.value as? Int {
 631 |                     return NumericValue(value: leftDouble - Double(rightInt))
 632 |                 } else {
 633 |                     throw JinjaError.runtime("Unsupported numeric types for subtraction")
 634 |                 }
 635 |             case "*":
 636 |                 if let leftInt = left.value as? Int, let rightInt = right.value as? Int {
 637 |                     return NumericValue(value: leftInt * rightInt)
 638 |                 } else if let leftDouble = left.value as? Double, let rightDouble = right.value as? Double {
 639 |                     return NumericValue(value: leftDouble * rightDouble)
 640 |                 } else if let leftInt = left.value as? Int, let rightDouble = right.value as? Double {
 641 |                     return NumericValue(value: Double(leftInt) * rightDouble)
 642 |                 } else if let leftDouble = left.value as? Double, let rightInt = right.value as? Int {
 643 |                     return NumericValue(value: leftDouble * Double(rightInt))
 644 |                 } else {
 645 |                     throw JinjaError.runtime("Unsupported numeric types for multiplication")
 646 |                 }
 647 |             case "/":
 648 |                 if let leftInt = left.value as? Int, let rightInt = right.value as? Int {
 649 |                     return NumericValue(value: leftInt / rightInt)
 650 |                 } else if let leftDouble = left.value as? Double, let rightDouble = right.value as? Double {
 651 |                     return NumericValue(value: leftDouble / rightDouble)
 652 |                 } else if let leftInt = left.value as? Int, let rightDouble = right.value as? Double {
 653 |                     return NumericValue(value: Double(leftInt) / rightDouble)
 654 |                 } else if let leftDouble = left.value as? Double, let rightInt = right.value as? Int {
 655 |                     return NumericValue(value: leftDouble / Double(rightInt))
 656 |                 } else {
 657 |                     throw JinjaError.runtime("Unsupported numeric types for division")
 658 |                 }
 659 |             case "%":
 660 |                 if let leftInt = left.value as? Int, let rightInt = right.value as? Int {
 661 |                     return NumericValue(value: leftInt % rightInt)
 662 |                 } else {
 663 |                     throw JinjaError.runtime("Unsupported numeric types for modulus")
 664 |                 }
 665 |             case "<":
 666 |                 if let leftInt = left.value as? Int, let rightInt = right.value as? Int {
 667 |                     return BooleanValue(value: leftInt < rightInt)
 668 |                 } else if let leftDouble = left.value as? Double, let rightDouble = right.value as? Double {
 669 |                     return BooleanValue(value: leftDouble < rightDouble)
 670 |                 } else if let leftInt = left.value as? Int, let rightDouble = right.value as? Double {
 671 |                     return BooleanValue(value: Double(leftInt) < rightDouble)
 672 |                 } else if let leftDouble = left.value as? Double, let rightInt = right.value as? Int {
 673 |                     return BooleanValue(value: leftDouble < Double(rightInt))
 674 |                 } else {
 675 |                     throw JinjaError.runtime("Unsupported numeric types for less than comparison")
 676 |                 }
 677 |             case ">":
 678 |                 if let leftInt = left.value as? Int, let rightInt = right.value as? Int {
 679 |                     return BooleanValue(value: leftInt > rightInt)
 680 |                 } else if let leftDouble = left.value as? Double, let rightDouble = right.value as? Double {
 681 |                     return BooleanValue(value: leftDouble > rightDouble)
 682 |                 } else if let leftInt = left.value as? Int, let rightDouble = right.value as? Double {
 683 |                     return BooleanValue(value: Double(leftInt) > rightDouble)
 684 |                 } else if let leftDouble = left.value as? Double, let rightInt = right.value as? Int {
 685 |                     return BooleanValue(value: leftDouble > Double(rightInt))
 686 |                 } else {
 687 |                     throw JinjaError.runtime("Unsupported numeric types for greater than comparison")
 688 |                 }
 689 |             case ">=":
 690 |                 if let leftInt = left.value as? Int, let rightInt = right.value as? Int {
 691 |                     return BooleanValue(value: leftInt >= rightInt)
 692 |                 } else if let leftDouble = left.value as? Double, let rightDouble = right.value as? Double {
 693 |                     return BooleanValue(value: leftDouble >= rightDouble)
 694 |                 } else if let leftInt = left.value as? Int, let rightDouble = right.value as? Double {
 695 |                     return BooleanValue(value: Double(leftInt) >= rightDouble)
 696 |                 } else if let leftDouble = left.value as? Double, let rightInt = right.value as? Int {
 697 |                     return BooleanValue(value: leftDouble >= Double(rightInt))
 698 |                 } else {
 699 |                     throw JinjaError.runtime("Unsupported numeric types for greater than or equal to comparison")
 700 |                 }
 701 |             case "<=":
 702 |                 if let leftInt = left.value as? Int, let rightInt = right.value as? Int {
 703 |                     return BooleanValue(value: leftInt <= rightInt)
 704 |                 } else if let leftDouble = left.value as? Double, let rightDouble = right.value as? Double {
 705 |                     return BooleanValue(value: leftDouble <= rightDouble)
 706 |                 } else if let leftInt = left.value as? Int, let rightDouble = right.value as? Double {
 707 |                     return BooleanValue(value: Double(leftInt) <= rightDouble)
 708 |                 } else if let leftDouble = left.value as? Double, let rightInt = right.value as? Int {
 709 |                     return BooleanValue(value: leftDouble <= Double(rightInt))
 710 |                 } else {
 711 |                     throw JinjaError.runtime("Unsupported numeric types for less than or equal to comparison")
 712 |                 }
 713 |             default:
 714 |                 throw JinjaError.runtime("Unknown operation type:\(node.operation.value)")
 715 |             }
 716 |         } else if let left = left as? ArrayValue, let right = right as? ArrayValue {
 717 |             switch node.operation.value {
 718 |             case "+":
 719 |                 return ArrayValue(value: left.value + right.value)
 720 |             default:
 721 |                 throw JinjaError.runtime("Unknown operation type:\(node.operation.value)")
 722 |             }
 723 |         } else if let right = right as? ArrayValue {
 724 |             let member: Bool
 725 |             if let left = left as? StringValue {
 726 |                 member = right.value.contains {
 727 |                     if let item = $0 as? StringValue {
 728 |                         return item.value == left.value
 729 |                     }
 730 |                     return false
 731 |                 }
 732 |             } else if let left = left as? NumericValue {
 733 |                 member = right.value.contains {
 734 |                     if let item = $0 as? NumericValue {
 735 |                         return item.value as! Int == left.value as! Int
 736 |                     }
 737 |                     return false
 738 |                 }
 739 |             } else if let left = left as? BooleanValue {
 740 |                 member = right.value.contains {
 741 |                     if let item = $0 as? BooleanValue {
 742 |                         return item.value == left.value
 743 |                     }
 744 |                     return false
 745 |                 }
 746 |             } else {
 747 |                 throw JinjaError.runtime("Unsupported left type for 'in'/'not in' operation with ArrayValue")
 748 |             }
 749 |             switch node.operation.value {
 750 |             case "in":
 751 |                 return BooleanValue(value: member)
 752 |             case "not in":
 753 |                 return BooleanValue(value: !member)
 754 |             default:
 755 |                 throw JinjaError.runtime("Unknown operation type:\(node.operation.value)")
 756 |             }
 757 |         }
 758 |         if let left = left as? StringValue {
 759 |             switch node.operation.value {
 760 |             case "+":
 761 |                 let rightValue: String
 762 |                 if let rightString = right as? StringValue {
 763 |                     rightValue = rightString.value
 764 |                 } else if let rightNumeric = right as? NumericValue {
 765 |                     rightValue = String(describing: rightNumeric.value)
 766 |                 } else if let rightBoolean = right as? BooleanValue {
 767 |                     rightValue = String(rightBoolean.value)
 768 |                 } else if right is UndefinedValue || right is NullValue {
 769 |                     rightValue = ""
 770 |                 } else {
 771 |                     throw JinjaError.runtime("Unsupported right operand type for string concatenation")
 772 |                 }
 773 |                 return StringValue(value: left.value + rightValue)
 774 |             case "in":
 775 |                 if let right = right as? StringValue {
 776 |                     return BooleanValue(value: right.value.contains(left.value))
 777 |                 } else if let right = right as? ObjectValue {
 778 |                     return BooleanValue(value: right.value.keys.contains(left.value))
 779 |                 } else if let right = right as? ArrayValue {
 780 |                     return BooleanValue(
 781 |                         value: right.value.contains {
 782 |                             if let item = $0 as? StringValue {
 783 |                                 return item.value == left.value
 784 |                             }
 785 |                             return false
 786 |                         }
 787 |                     )
 788 |                 } else {
 789 |                     throw JinjaError.runtime("Right operand of 'in' must be a StringValue, ArrayValue, or ObjectValue")
 790 |                 }
 791 |             case "not in":
 792 |                 if let right = right as? StringValue {
 793 |                     return BooleanValue(value: !right.value.contains(left.value))
 794 |                 } else if let right = right as? ObjectValue {
 795 |                     return BooleanValue(value: !right.value.keys.contains(left.value))
 796 |                 } else if let right = right as? ArrayValue {
 797 |                     return BooleanValue(
 798 |                         value: !right.value.contains {
 799 |                             if let item = $0 as? StringValue {
 800 |                                 return item.value == left.value
 801 |                             }
 802 |                             return false
 803 |                         }
 804 |                     )
 805 |                 } else {
 806 |                     throw JinjaError.runtime(
 807 |                         "Right operand of 'not in' must be a StringValue, ArrayValue, or ObjectValue"
 808 |                     )
 809 |                 }
 810 |             default:
 811 |                 break
 812 |             }
 813 |         } else if let right = right as? StringValue {
 814 |             if node.operation.value == "+" {
 815 |                 if let leftString = left as? StringValue {
 816 |                     return StringValue(value: leftString.value + right.value)
 817 |                 } else if let leftNumeric = left as? NumericValue {
 818 |                     return StringValue(value: String(describing: leftNumeric.value) + right.value)
 819 |                 } else if let leftBoolean = left as? BooleanValue {
 820 |                     return StringValue(value: String(leftBoolean.value) + right.value)
 821 |                 } else {
 822 |                     throw JinjaError.runtime("Unsupported left operand type for string concatenation")
 823 |                 }
 824 |             }
 825 |         }
 826 |         if let left = left as? StringValue, let right = right as? ObjectValue {
 827 |             switch node.operation.value {
 828 |             case "in":
 829 |                 return BooleanValue(value: right.value.keys.contains(left.value))
 830 |             case "not in":
 831 |                 return BooleanValue(value: !right.value.keys.contains(left.value))
 832 |             default:
 833 |                 throw JinjaError.runtime(
 834 |                     "Unsupported operation '\(node.operation.value)' between StringValue and ObjectValue"
 835 |                 )
 836 |             }
 837 |         }
 838 |         throw JinjaError.syntax(
 839 |             "Unknown operator '\(node.operation.value)' between \(type(of:left)) and \(type(of:right))"
 840 |         )
 841 |     }
 842 | 
 843 |     func evaluateSliceExpression(
 844 |         object: any RuntimeValue,
 845 |         expr: SliceExpression,
 846 |         environment: Environment
 847 |     ) throws -> any RuntimeValue {
 848 |         if !(object is ArrayValue || object is StringValue) {
 849 |             throw JinjaError.runtime("Slice object must be an array or string")
 850 |         }
 851 |         let start = try self.evaluate(statement: expr.start, environment: environment)
 852 |         let stop = try self.evaluate(statement: expr.stop, environment: environment)
 853 |         let step = try self.evaluate(statement: expr.step, environment: environment)
 854 |         if !(start is NumericValue || start is UndefinedValue) {
 855 |             throw JinjaError.runtime("Slice start must be numeric or undefined")
 856 |         }
 857 |         if !(stop is NumericValue || stop is UndefinedValue) {
 858 |             throw JinjaError.runtime("Slice stop must be numeric or undefined")
 859 |         }
 860 |         if !(step is NumericValue || step is UndefinedValue) {
 861 |             throw JinjaError.runtime("Slice step must be numeric or undefined")
 862 |         }
 863 |         if let object = object as? ArrayValue {
 864 |             return ArrayValue(
 865 |                 value: slice(
 866 |                     object.value,
 867 |                     start: (start as? NumericValue)?.value as? Int,
 868 |                     stop: (stop as? NumericValue)?.value as? Int,
 869 |                     step: (step as? NumericValue)?.value as? Int
 870 |                 )
 871 |             )
 872 |         } else if let object = object as? StringValue {
 873 |             return StringValue(
 874 |                 value: slice(
 875 |                     Array(object.value),
 876 |                     start: (start as? NumericValue)?.value as? Int,
 877 |                     stop: (stop as? NumericValue)?.value as? Int,
 878 |                     step: (step as? NumericValue)?.value as? Int
 879 |                 ).map { String($0) }.joined()
 880 |             )
 881 |         }
 882 |         throw JinjaError.runtime("Slice object must be an array or string")
 883 |     }
 884 | 
 885 |     func evaluateMemberExpression(expr: MemberExpression, environment: Environment) throws -> any RuntimeValue {
 886 |         let object = try self.evaluate(statement: expr.object, environment: environment)
 887 |         var property: any RuntimeValue
 888 |         if expr.computed {
 889 |             if let property = expr.property as? SliceExpression {
 890 |                 return try self.evaluateSliceExpression(object: object, expr: property, environment: environment)
 891 |             } else {
 892 |                 property = try self.evaluate(statement: expr.property, environment: environment)
 893 |             }
 894 |         } else {
 895 |             property = StringValue(value: (expr.property as! Identifier).value)
 896 |         }
 897 |         var value: (any RuntimeValue)?
 898 |         if let object = object as? ObjectValue {
 899 |             if let property = property as? StringValue {
 900 |                 value = object.value[property.value] ?? object.builtins[property.value]
 901 |             } else {
 902 |                 throw JinjaError.runtime("Cannot access property with non-string: got \(type(of:property))")
 903 |             }
 904 |         } else if let object = object as? ArrayValue {
 905 |             if let property = property as? NumericValue {
 906 |                 if let index = property.value as? Int {
 907 |                     let actualIndex = index < 0 ? object.value.count + index : index
 908 |                     if actualIndex >= 0 && actualIndex < object.value.count {
 909 |                         value = object.value[actualIndex]
 910 |                     } else {
 911 |                         value = UndefinedValue()
 912 |                     }
 913 |                 } else {
 914 |                     throw JinjaError.runtime("Array index must be an integer")
 915 |                 }
 916 |             } else if let property = property as? StringValue {
 917 |                 value = object.builtins[property.value]
 918 |             } else {
 919 |                 throw JinjaError.runtime(
 920 |                     "Cannot access property with non-string/non-number: got \(type(of: property))"
 921 |                 )
 922 |             }
 923 |         } else if let object = object as? StringValue {
 924 |             if let property = property as? NumericValue {
 925 |                 if let index = property.value as? Int {
 926 |                     if index >= 0 && index < object.value.count {
 927 |                         let strIndex = object.value.index(object.value.startIndex, offsetBy: index)
 928 |                         value = StringValue(value: String(object.value[strIndex]))
 929 |                     } else if index < 0 && index >= -object.value.count {
 930 |                         let strIndex = object.value.index(object.value.startIndex, offsetBy: object.value.count + index)
 931 |                         value = StringValue(value: String(object.value[strIndex]))
 932 |                     } else {
 933 |                         value = UndefinedValue()
 934 |                     }
 935 |                 } else {
 936 |                     throw JinjaError.runtime("String index must be an integer")
 937 |                 }
 938 |             } else if let property = property as? StringValue {
 939 |                 value = object.builtins[property.value]
 940 |             } else {
 941 |                 throw JinjaError.runtime(
 942 |                     "Cannot access property with non-string/non-number: got \(type(of: property))"
 943 |                 )
 944 |             }
 945 |         } else {
 946 |             if let property = property as? StringValue {
 947 |                 value = object.builtins[property.value]
 948 |             } else {
 949 |                 throw JinjaError.runtime("Cannot access property with non-string: got \(type(of:property))")
 950 |             }
 951 |         }
 952 |         if let value {
 953 |             return value
 954 |         } else {
 955 |             return UndefinedValue()
 956 |         }
 957 |     }
 958 | 
 959 |     func evaluateUnaryExpression(node: UnaryExpression, environment: Environment) throws -> any RuntimeValue {
 960 |         let argument = try self.evaluate(statement: node.argument, environment: environment)
 961 |         switch node.operation.value {
 962 |         case "not":
 963 |             return BooleanValue(value: !argument.bool())
 964 |         default:
 965 |             throw JinjaError.syntax("Unknown operator: \(node.operation.value)")
 966 |         }
 967 |     }
 968 | 
 969 |     func evaluateCallExpression(expr: CallExpression, environment: Environment) throws -> any RuntimeValue {
 970 |         var args: [any RuntimeValue] = []
 971 |         var kwargs: [String: any RuntimeValue] = [:]
 972 |         for argument in expr.args {
 973 |             if let argument = argument as? KeywordArgumentExpression {
 974 |                 kwargs[argument.key.value] = try self.evaluate(statement: argument.value, environment: environment)
 975 |             } else {
 976 |                 try args.append(self.evaluate(statement: argument, environment: environment))
 977 |             }
 978 |         }
 979 |         if !kwargs.isEmpty {
 980 |             args.append(ObjectValue(value: kwargs))
 981 |         }
 982 |         let fn = try self.evaluate(statement: expr.callee, environment: environment)
 983 |         if let fn = fn as? FunctionValue {
 984 |             return try fn.value(args, environment)
 985 |         } else {
 986 |             throw JinjaError.runtime("Cannot call something that is not a function: got \(type(of:fn))")
 987 |         }
 988 |     }
 989 | 
 990 |     func evaluateFilterExpression(node: FilterExpression, environment: Environment, whitespaceControl: Bool) throws
 991 |         -> any RuntimeValue
 992 |     {
 993 |         let operand = try self.evaluate(statement: node.operand, environment: environment)
 994 |         let filterName = node.filter.value
 995 |         guard let filter = environment.filters[filterName] else {
 996 |             throw JinjaError.runtime("No filter named '\(filterName)'")
 997 |         }
 998 |         // Evaluate positional arguments
 999 |         let evaluatedPositionalArgs = try node.args.map { arg in
1000 |             try self.evaluate(statement: arg, environment: environment)
1001 |         }
1002 |         // Create args array starting with operand
1003 |         var args: [any RuntimeValue] = [operand]
1004 |         args.append(contentsOf: evaluatedPositionalArgs)
1005 |         // If we have keyword arguments, add them as a final ObjectValue argument
1006 |         if !node.kwargs.isEmpty {
1007 |             var kwargs: [String: any RuntimeValue] = [:]
1008 |             for kwarg in node.kwargs {
1009 |                 kwargs[kwarg.key.value] = try self.evaluate(statement: kwarg.value, environment: environment)
1010 |             }
1011 |             args.append(ObjectValue(value: kwargs))
1012 |         }
1013 |         return try filter(args, environment)
1014 |     }
1015 | 
1016 |     func evaluateTestExpression(node: TestExpression, environment: Environment) throws -> any RuntimeValue {
1017 |         let operand = try self.evaluate(statement: node.operand, environment: environment)
1018 |         guard let testFunction = environment.tests[node.test.value] else {
1019 |             throw JinjaError.runtime("Unknown test: \(node.test.value)")
1020 |         }
1021 |         let result = try testFunction(operand)
1022 |         return BooleanValue(value: node.negate ? !result : result)
1023 |     }
1024 | 
1025 |     func evaluateMacro(node: Macro, environment: Environment) throws -> NullValue {
1026 |         try environment.setVariable(
1027 |             name: node.name.value,
1028 |             value: FunctionValue(value: { args, scope in
1029 |                 let macroScope = Environment(parent: scope)
1030 |                 var args = args
1031 |                 var kwargs: [String: any RuntimeValue] = [:]
1032 |                 if let lastArg = args.last, let keywordArgsValue = lastArg as? KeywordArgumentsValue {
1033 |                     kwargs = keywordArgsValue.value
1034 |                     args.removeLast()
1035 |                 }
1036 |                 for i in 0 ..< node.args.count {
1037 |                     let nodeArg = node.args[i]
1038 |                     let passedArg = args.count > i ? args[i] : nil
1039 | 
1040 |                     if let identifier = nodeArg as? Identifier {
1041 |                         if passedArg == nil {
1042 |                             if let defaultValue = kwargs[identifier.value] {
1043 |                                 try macroScope.setVariable(name: identifier.value, value: defaultValue)
1044 |                             } else {
1045 |                                 throw JinjaError.runtime("Missing argument: \(identifier.value)")
1046 |                             }
1047 |                         } else {
1048 |                             try macroScope.setVariable(name: identifier.value, value: passedArg!)
1049 |                         }
1050 |                     } else if let kwarg = nodeArg as? KeywordArgumentExpression {
1051 |                         let value =
1052 |                             try kwargs[kwarg.key.value]
1053 |                             ?? (passedArg ?? (try self.evaluate(statement: kwarg.value, environment: macroScope)))
1054 | 
1055 |                         try macroScope.setVariable(name: kwarg.key.value, value: value)
1056 |                     } else {
1057 |                         throw JinjaError.runtime("Unknown argument type: \(type(of: nodeArg))")
1058 |                     }
1059 |                 }
1060 |                 return try self.evaluateBlock(statements: node.body, environment: macroScope)
1061 |             })
1062 |         )
1063 |         return NullValue()
1064 |     }
1065 | 
1066 |     func evaluateArguments(
1067 |         args: [Expression],
1068 |         environment: Environment
1069 |     ) throws -> ([any RuntimeValue], [String: any RuntimeValue]) {
1070 |         var positionalArguments: [any RuntimeValue] = []
1071 |         var keywordArguments: [String: any RuntimeValue] = [:]
1072 |         for argument in args {
1073 |             if let keywordArgument = argument as? KeywordArgumentExpression {
1074 |                 keywordArguments[keywordArgument.key.value] = try self.evaluate(
1075 |                     statement: keywordArgument.value,
1076 |                     environment: environment
1077 |                 )
1078 |             } else {
1079 |                 if !keywordArguments.isEmpty {
1080 |                     throw JinjaError.runtime("Positional arguments must come before keyword arguments")
1081 |                 }
1082 |                 positionalArguments.append(try self.evaluate(statement: argument, environment: environment))
1083 |             }
1084 |         }
1085 | 
1086 |         return (positionalArguments, keywordArguments)
1087 |     }
1088 | 
1089 |     func evaluate(statement: Statement?, environment: Environment, whitespaceControl: Bool = false) throws
1090 |         -> any RuntimeValue
1091 |     {
1092 |         if let statement {
1093 |             switch statement {
1094 |             case let statement as Program:
1095 |                 return try self.evalProgram(program: statement, environment: environment)
1096 |             case let statement as If:
1097 |                 return try self.evaluateIf(node: statement, environment: environment)
1098 |             case let statement as StringLiteral:
1099 |                 return StringValue(value: statement.value)
1100 |             case let statement as Set:
1101 |                 return try self.evaluateSet(node: statement, environment: environment)
1102 |             case let statement as For:
1103 |                 return try self.evaluateFor(node: statement, environment: environment)
1104 |             case let statement as Identifier:
1105 |                 return try self.evaluateIdentifier(node: statement, environment: environment)
1106 |             case let statement as BinaryExpression:
1107 |                 return try self.evaluateBinaryExpression(node: statement, environment: environment)
1108 |             case let statement as MemberExpression:
1109 |                 return try self.evaluateMemberExpression(expr: statement, environment: environment)
1110 |             case let statement as UnaryExpression:
1111 |                 return try self.evaluateUnaryExpression(node: statement, environment: environment)
1112 |             case let statement as NumericLiteral:
1113 |                 if let intValue = statement.value as? Int {
1114 |                     return NumericValue(value: intValue)
1115 |                 } else if let doubleValue = statement.value as? Double {
1116 |                     return NumericValue(value: doubleValue)
1117 |                 } else {
1118 |                     throw JinjaError.runtime("Invalid numeric literal value")
1119 |                 }
1120 |             case let statement as CallExpression:
1121 |                 return try self.evaluateCallExpression(expr: statement, environment: environment)
1122 |             case let statement as BoolLiteral:
1123 |                 return BooleanValue(value: statement.value)
1124 |             case let statement as FilterExpression:
1125 |                 return try self.evaluateFilterExpression(
1126 |                     node: statement,
1127 |                     environment: environment,
1128 |                     whitespaceControl: whitespaceControl
1129 |                 )
1130 |             case let statement as TestExpression:
1131 |                 return try self.evaluateTestExpression(node: statement, environment: environment)
1132 |             case let statement as ArrayLiteral:
1133 |                 return ArrayValue(
1134 |                     value: try statement.value.map { try self.evaluate(statement: $0, environment: environment) }
1135 |                 )
1136 |             case let statement as TupleLiteral:
1137 |                 return TupleValue(
1138 |                     value: try statement.value.map { try self.evaluate(statement: $0, environment: environment) }
1139 |                 )
1140 |             case let statement as ObjectLiteral:
1141 |                 var mapping: [String: any RuntimeValue] = [:]
1142 |                 for (key, value) in statement.value {
1143 |                     mapping[key] = try self.evaluate(statement: value, environment: environment)
1144 |                 }
1145 |                 return ObjectValue(value: mapping)
1146 |             case let statement as Macro:
1147 |                 return try self.evaluateMacro(node: statement, environment: environment)
1148 |             case is NullLiteral:
1149 |                 return NullValue()
1150 |             default:
1151 |                 throw JinjaError.runtime(
1152 |                     "Unknown node type: \(type(of:statement)), statement: \(String(describing: statement))"
1153 |                 )
1154 |             }
1155 |         } else {
1156 |             return UndefinedValue()
1157 |         }
1158 |     }
1159 | }
1160 | 


--------------------------------------------------------------------------------
/Sources/Template.swift:
--------------------------------------------------------------------------------
 1 | //
 2 | //  Template.swift
 3 | //
 4 | //
 5 | //  Created by John Mai on 2024/3/23.
 6 | //
 7 | 
 8 | import Foundation
 9 | 
10 | public struct Template {
11 |     var parsed: Program
12 | 
13 |     public init(_ template: String) throws {
14 |         let tokens = try tokenize(template, options: PreprocessOptions(trimBlocks: true, lstripBlocks: true))
15 |         self.parsed = try parse(tokens: tokens)
16 |     }
17 | 
18 |     public func render(_ items: [String: Any?]) throws -> String {
19 |         let env = Environment()
20 | 
21 |         try env.set(name: "false", value: false)
22 |         try env.set(name: "true", value: true)
23 |         try env.set(name: "none", value: NullValue())
24 |         try env.set(
25 |             name: "raise_exception",
26 |             value: { (args: String) throws in
27 |                 throw JinjaError.runtime("\(args)")
28 |             }
29 |         )
30 |         try env.set(name: "range", value: range)
31 | 
32 |         for (key, value) in items {
33 |             if let value {
34 |                 try env.set(name: key, value: value)
35 |             }
36 |         }
37 | 
38 |         let interpreter = Interpreter(env: env)
39 |         let result = try interpreter.run(program: self.parsed) as! StringValue
40 | 
41 |         return result.value
42 |     }
43 | }
44 | 


--------------------------------------------------------------------------------
/Sources/Utilities.swift:
--------------------------------------------------------------------------------
  1 | //
  2 | //  Utilities.swift
  3 | //
  4 | //
  5 | //  Created by John Mai on 2024/3/20.
  6 | //
  7 | 
  8 | import Foundation
  9 | 
 10 | func range(start: Int, stop: Int? = nil, step: Int = 1) -> [Int] {
 11 |     let stopUnwrapped = stop ?? start
 12 |     let startValue = stop == nil ? 0 : start
 13 |     let stopValue = stop == nil ? start : stopUnwrapped
 14 | 
 15 |     return stride(from: startValue, to: stopValue, by: step).map { $0 }
 16 | }
 17 | 
 18 | func slice<T>(_ array: [T], start: Int? = nil, stop: Int? = nil, step: Int? = 1) -> [T] {
 19 |     let arrayCount = array.count
 20 |     let startValue = start ?? 0
 21 |     let stopValue = stop ?? arrayCount
 22 |     let step = step ?? 1
 23 |     var slicedArray = [T]()
 24 |     if step > 0 {
 25 |         let startIndex = startValue < 0 ? max(arrayCount + startValue, 0) : min(startValue, arrayCount)
 26 |         let stopIndex = stopValue < 0 ? max(arrayCount + stopValue, 0) : min(stopValue, arrayCount)
 27 |         for i in stride(from: startIndex, to: stopIndex, by: step) {
 28 |             slicedArray.append(array[i])
 29 |         }
 30 |     } else {
 31 |         let startIndex = startValue < 0 ? max(arrayCount + startValue, -1) : min(startValue, arrayCount - 1)
 32 |         let stopIndex = stopValue < -1 ? max(arrayCount + stopValue, -1) : min(stopValue, arrayCount - 1)
 33 |         for i in stride(from: startIndex, through: stopIndex, by: step) {
 34 |             slicedArray.append(array[i])
 35 |         }
 36 |     }
 37 |     return slicedArray
 38 | }
 39 | 
 40 | func toJSON(_ input: any RuntimeValue, indent: Int? = nil, depth: Int = 0, whitespaceControl: Bool = false) throws
 41 |     -> String
 42 | {
 43 |     // If whitespaceControl is true, output compact JSON
 44 |     if whitespaceControl {
 45 |         switch input {
 46 |         case is NullValue, is UndefinedValue:
 47 |             return "null"
 48 |         case let value as NumericValue:
 49 |             return String(describing: value.value)
 50 |         case let value as StringValue:
 51 |             let escapedValue = value.value
 52 |                 .replacingOccurrences(of: "\\", with: "\\\\")
 53 |                 .replacingOccurrences(of: "\"", with: "\\\"")
 54 |                 .replacingOccurrences(of: "\n", with: "\\n")
 55 |                 .replacingOccurrences(of: "\r", with: "\\r")
 56 |                 .replacingOccurrences(of: "\t", with: "\\t")
 57 |             return "\"\(escapedValue)\""
 58 |         case let value as BooleanValue:
 59 |             return value.value ? "true" : "false"
 60 |         case let arr as ArrayValue:
 61 |             let elements = try arr.value.map {
 62 |                 try toJSON($0, indent: nil, depth: 0, whitespaceControl: true)
 63 |             }
 64 |             return "[\(elements.joined(separator: ", "))]"
 65 |         case let obj as ObjectValue:
 66 |             let pairs = try obj.orderedKeys.map { key in
 67 |                 guard let value = obj.value[key] else {
 68 |                     throw JinjaError.runtime("Missing value for key: \(key)")
 69 |                 }
 70 |                 let jsonValue = try toJSON(value, indent: nil, depth: 0, whitespaceControl: true)
 71 |                 return "\"\(key)\": \(jsonValue)"
 72 |             }
 73 |             return "{\(pairs.joined(separator: ", "))}"
 74 |         default:
 75 |             throw JinjaError.runtime("Cannot convert to JSON: \(type(of: input))")
 76 |         }
 77 |     }
 78 |     let currentDepth = depth
 79 |     let indentValue = indent != nil ? String(repeating: " ", count: indent!) : ""
 80 |     let basePadding = indent != nil ? "\n" + String(repeating: indentValue, count: currentDepth) : ""
 81 |     let childrenPadding = indent != nil ? basePadding + indentValue : ""
 82 |     switch input {
 83 |     case is NullValue, is UndefinedValue:
 84 |         return "null"
 85 |     case let value as NumericValue:
 86 |         return String(describing: value.value)
 87 |     case let value as StringValue:
 88 |         // Properly escape special characters for JSON strings
 89 |         let escapedValue = value.value
 90 |             .replacingOccurrences(of: "\\", with: "\\\\")
 91 |             .replacingOccurrences(of: "\"", with: "\\\"")
 92 |             .replacingOccurrences(of: "\n", with: "\\n")
 93 |             .replacingOccurrences(of: "\r", with: "\\r")
 94 |             .replacingOccurrences(of: "\t", with: "\\t")
 95 |         return "\"\(escapedValue)\""
 96 |     case let value as BooleanValue:
 97 |         return value.value ? "true" : "false"
 98 |     case let arr as ArrayValue:
 99 |         let core = try arr.value.map {
100 |             try toJSON($0, indent: indent, depth: currentDepth + 1, whitespaceControl: whitespaceControl)
101 |         }
102 |         if indent != nil && !whitespaceControl {
103 |             return "[\(childrenPadding)\(core.joined(separator: ",\(childrenPadding)"))\(basePadding)]"
104 |         } else {
105 |             return "[\(core.joined(separator: ", "))]"
106 |         }
107 |     case let obj as ObjectValue:
108 |         // Use orderedKeys to maintain insertion order
109 |         let pairs = try obj.orderedKeys.map { key in
110 |             guard let value = obj.value[key] else {
111 |                 throw JinjaError.runtime("Missing value for key: \(key)")
112 |             }
113 |             let jsonValue = try toJSON(
114 |                 value,
115 |                 indent: indent,
116 |                 depth: currentDepth + 1,
117 |                 whitespaceControl: whitespaceControl
118 |             )
119 |             return "\"\(key)\": \(jsonValue)"
120 |         }
121 |         if indent != nil && !whitespaceControl {
122 |             return "{\(childrenPadding)\(pairs.joined(separator: ",\(childrenPadding)"))\(basePadding)}"
123 |         } else {
124 |             return "{\(pairs.joined(separator: ", "))}"
125 |         }
126 |     default:
127 |         throw JinjaError.runtime("Cannot convert to JSON: \(type(of: input))")
128 |     }
129 | }
130 | 
131 | // Helper function to convert values to JSON strings
132 | func jsonString(_ value: Any) throws -> String {
133 |     let data = try JSONSerialization.data(withJSONObject: value)
134 |     guard let string = String(data: data, encoding: .utf8) else {
135 |         throw JinjaError.runtime("Failed to convert value to JSON string")
136 |     }
137 |     return string
138 | }
139 | 
140 | extension String {
141 |     func titleCase() -> String {
142 |         return self.components(separatedBy: .whitespacesAndNewlines)
143 |             .map { word in
144 |                 guard let firstChar = word.first else { return "" }
145 |                 return String(firstChar).uppercased() + word.dropFirst()
146 |             }
147 |             .joined(separator: " ")
148 |     }
149 | 
150 |     func indent(_ width: Int, first: Bool = false, blank: Bool = false) -> String {
151 |         let indentString = String(repeating: " ", count: width)
152 |         return self.components(separatedBy: .newlines)
153 |             .enumerated()
154 |             .map { (index, line) in
155 |                 if line.isEmpty && !blank {
156 |                     return line
157 |                 }
158 |                 if index == 0 && !first {
159 |                     return line
160 |                 }
161 |                 return indentString + line
162 |             }
163 |             .joined(separator: "\n")
164 |     }
165 | }
166 | 
167 | func stringify(_ value: any RuntimeValue, indent: Int = 4, whitespaceControl: Bool = false) throws -> String {
168 |     if let stringValue = value as? StringValue {
169 |         return "\"\(stringValue.value)\""
170 |     } else if let numericValue = value as? NumericValue {
171 |         return String(describing: numericValue.value)
172 |     } else if let booleanValue = value as? BooleanValue {
173 |         return booleanValue.value ? "true" : "false"
174 |     } else if let objectValue = value as? ObjectValue {
175 |         return try toJSON(objectValue, indent: indent, whitespaceControl: whitespaceControl)
176 |     } else if let arrayValue = value as? ArrayValue {
177 |         return try toJSON(arrayValue, indent: indent, whitespaceControl: whitespaceControl)
178 |     } else if value is NullValue {
179 |         return "null"
180 |     } else if value is UndefinedValue {
181 |         return "undefined"
182 |     } else {
183 |         return ""
184 |     }
185 | }
186 | 
187 | func areEqual(_ left: any RuntimeValue, _ right: any RuntimeValue) throws -> Bool {
188 |     if let leftObj = left as? ObjectValue, let rightObj = right as? ObjectValue {
189 |         // Compare ObjectValues by their contents
190 |         guard leftObj.storage.keys == rightObj.storage.keys else {
191 |             return false
192 |         }
193 | 
194 |         for key in leftObj.storage.keys {
195 |             guard let leftValue = leftObj.storage[key],
196 |                 let rightValue = rightObj.storage[key],
197 |                 try areEqual(leftValue, rightValue)
198 |             else {
199 |                 return false
200 |             }
201 |         }
202 |         return true
203 |     } else if let leftStr = left as? StringValue, let rightStr = right as? StringValue {
204 |         return leftStr.value == rightStr.value
205 |     } else if let leftNum = left as? NumericValue, let rightNum = right as? NumericValue {
206 |         if let leftInt = leftNum.value as? Int, let rightInt = rightNum.value as? Int {
207 |             return leftInt == rightInt
208 |         } else if let leftDouble = leftNum.value as? Double, let rightDouble = rightNum.value as? Double {
209 |             return leftDouble == rightDouble
210 |         }
211 |     } else if let leftArr = left as? ArrayValue, let rightArr = right as? ArrayValue {
212 |         guard leftArr.value.count == rightArr.value.count else {
213 |             return false
214 |         }
215 |         for (leftItem, rightItem) in zip(leftArr.value, rightArr.value) {
216 |             guard try areEqual(leftItem, rightItem) else {
217 |                 return false
218 |             }
219 |         }
220 |         return true
221 |     } else if left is NullValue && right is NullValue {
222 |         return true
223 |     } else if left is UndefinedValue && right is UndefinedValue {
224 |         return true
225 |     } else if let leftBool = left as? BooleanValue, let rightBool = right as? BooleanValue {
226 |         return leftBool.value == rightBool.value
227 |     }
228 |     // If types don't match, return false
229 |     return false
230 | }
231 | 


--------------------------------------------------------------------------------
/Tests/CoreTagTests.swift:
--------------------------------------------------------------------------------
  1 | //
  2 | //  CoreTagTests.swift
  3 | //  Jinja
  4 | //
  5 | //  Created by Anthony DePasquale on 07.01.2025.
  6 | //
  7 | 
  8 | // Adapted from https://github.com/pallets/jinja/blob/main/tests/test_core_tags.py
  9 | 
 10 | import XCTest
 11 | @testable import Jinja
 12 | 
 13 | final class IfConditionTests: XCTestCase {
 14 |     // MARK: - If Condition Tests
 15 | 
 16 |     func testSimpleIf() throws {
 17 |         let template = try Template("{% if true %}...{% endif %}")
 18 |         let result = try template.render([:])
 19 |         XCTAssertEqual(result, "...")
 20 |     }
 21 | 
 22 |     func testIfElif() throws {
 23 |         let template = try Template(
 24 |             """
 25 |             {% if false %}XXX{% elif true %}...{% else %}XXX{% endif %}
 26 |             """
 27 |         )
 28 |         let result = try template.render([:])
 29 |         XCTAssertEqual(result, "...")
 30 |     }
 31 | 
 32 |     func testIfElse() throws {
 33 |         let template = try Template("{% if false %}XXX{% else %}...{% endif %}")
 34 |         let result = try template.render([:])
 35 |         XCTAssertEqual(result, "...")
 36 |     }
 37 | 
 38 |     func testEmptyIf() throws {
 39 |         let template = try Template("[{% if true %}{% else %}{% endif %}]")
 40 |         let result = try template.render([:])
 41 |         XCTAssertEqual(result, "[]")
 42 |     }
 43 | 
 44 |     // TODO: Make this test pass
 45 |     //    func testCompleteIf() throws {
 46 |     //        let template = try Template(
 47 |     //            """
 48 |     //            {% if a %}A{% elif b %}B{% elif c == d %}C{% else %}D{% endif %}
 49 |     //            """
 50 |     //        )
 51 |     //        let result = try template.render([
 52 |     //            "a": 0,
 53 |     //            "b": false,
 54 |     //            "c": 42,
 55 |     //            "d": 42.0,
 56 |     //        ])
 57 |     //        XCTAssertEqual(result, "C")
 58 |     //    }
 59 | 
 60 |     // MARK: - Set Tests
 61 | 
 62 |     func testNormalSet() throws {
 63 |         let template = try Template("{% set foo = 1 %}{{ foo }}")
 64 |         let result = try template.render([:])
 65 |         XCTAssertEqual(result, "1")
 66 |     }
 67 | 
 68 |     // TODO: Make this test pass
 69 |     //    func testBlockSet() throws {
 70 |     //        let template = try Template("{% set foo %}42{% endset %}{{ foo }}")
 71 |     //        let result = try template.render([:])
 72 |     //        XCTAssertEqual(result, "42")
 73 |     //    }
 74 | 
 75 |     func testNamespace() throws {
 76 |         let template = try Template(
 77 |             """
 78 |             {% set ns = namespace() %}{% set ns.bar = '42' %}{{ ns.bar }}
 79 |             """
 80 |         )
 81 |         let result = try template.render([:])
 82 |         XCTAssertEqual(result, "42")
 83 |     }
 84 | 
 85 |     // TODO: Make this test pass
 86 |     //    func testNamespaceLoop() throws {
 87 |     //        let template = try Template(
 88 |     //            """
 89 |     //            {% set ns = namespace(found=false) %}\
 90 |     //            {% for x in range(4) %}\
 91 |     //            {% if x == v %}\
 92 |     //            {% set ns.found = true %}\
 93 |     //            {% endif %}\
 94 |     //            {% endfor %}\
 95 |     //            {{ ns.found }}
 96 |     //            """
 97 |     //        )
 98 |     //
 99 |     //        let result1 = try template.render(["v": 3])
100 |     //        XCTAssertEqual(result1, "true")
101 |     //
102 |     //        let result2 = try template.render(["v": 4])
103 |     //        XCTAssertEqual(result2, "false")
104 |     //    }
105 | }
106 | 
107 | final class ForLoopTests: XCTestCase {
108 |     // MARK: - For Loop Tests
109 | 
110 |     func testSimpleForLoop() throws {
111 |         let template = try Template("{% for item in seq %}{{ item }}{% endfor %}")
112 |         let result = try template.render(["seq": Array(0 ... 9)])
113 |         XCTAssertEqual(result, "0123456789")
114 |     }
115 | 
116 |     // TODO: Make this test pass
117 |     //    func testForLoopWithElse() throws {
118 |     //        let template = try Template("{% for item in seq %}XXX{% else %}...{% endfor %}")
119 |     //        let result = try template.render([:])
120 |     //        XCTAssertEqual(result, "...")
121 |     //    }
122 | 
123 |     func testForLoopElseScopingItem() throws {
124 |         let template = try Template("{% for item in [] %}{% else %}{{ item }}{% endfor %}")
125 |         let result = try template.render(["item": 42])
126 |         XCTAssertEqual(result, "42")
127 |     }
128 | 
129 |     // TODO: Make this test pass
130 |     //    func testEmptyBlocks() throws {
131 |     //        let template = try Template("<{% for item in seq %}{% else %}{% endfor %}>")
132 |     //        let result = try template.render([:])
133 |     //        XCTAssertEqual(result, "<>")
134 |     //    }
135 | 
136 |     func testContextVars() throws {
137 |         let template = try Template(
138 |             """
139 |             {% for item in seq -%}
140 |             {{ loop.index }}|{{ loop.index0 }}|{{ loop.revindex }}|{{
141 |                 loop.revindex0 }}|{{ loop.first }}|{{ loop.last }}|{{
142 |                loop.length }}###{% endfor %}
143 |             """
144 |         )
145 | 
146 |         let result = try template.render(["seq": [42, 24]])
147 |         let parts = result.split(separator: "###")
148 |         XCTAssertEqual(parts.count, 2)
149 | 
150 |         let one = String(parts[0]).split(separator: "|")
151 |         let two = String(parts[1]).split(separator: "|")
152 | 
153 |         // First iteration checks
154 |         XCTAssertEqual(one[0], "1")  // index
155 |         XCTAssertEqual(one[1], "0")  // index0
156 |         XCTAssertEqual(one[2], "2")  // revindex
157 |         XCTAssertEqual(one[3], "1")  // revindex0
158 |         XCTAssertEqual(one[4], "true")  // first
159 |         XCTAssertEqual(one[5], "false")  // last
160 |         XCTAssertEqual(one[6], "2")  // length
161 | 
162 |         // Second iteration checks
163 |         XCTAssertEqual(two[0], "2")  // index
164 |         XCTAssertEqual(two[1], "1")  // index0
165 |         XCTAssertEqual(two[2], "1")  // revindex
166 |         XCTAssertEqual(two[3], "0")  // revindex0
167 |         XCTAssertEqual(two[4], "false")  // first
168 |         XCTAssertEqual(two[5], "true")  // last
169 |         XCTAssertEqual(two[6], "2")  // length
170 |     }
171 | 
172 |     // TODO: Make this test pass
173 |     //    func testCycling() throws {
174 |     //        let template = try Template(
175 |     //            """
176 |     //            {% for item in seq %}{{ loop.cycle('<1>', '<2>') }}{% endfor %}\
177 |     //            {% for item in seq %}{{ loop.cycle(*through) }}{% endfor %}
178 |     //            """
179 |     //        )
180 |     //        let result = try template.render([
181 |     //            "seq": Array(0 ... 3),
182 |     //            "through": ["<1>", "<2>"],
183 |     //        ])
184 |     //        XCTAssertEqual(result, "<1><2><1><2><1><2><1><2>")
185 |     //    }
186 | 
187 |     func testLookaround() throws {
188 |         let template = try Template(
189 |             """
190 |             {% for item in seq -%}
191 |             {{ loop.previtem|default('x') }}-{{ item }}-{{ loop.nextitem|default('x') }}|
192 |             {%- endfor %}
193 |             """
194 |         )
195 |         let result = try template.render(["seq": Array(0 ... 3)])
196 |         XCTAssertEqual(result, "x-0-1|0-1-2|1-2-3|2-3-x|")
197 |     }
198 | 
199 |     func testScope() throws {
200 |         let template = try Template("{% for item in seq %}{% endfor %}{{ item }}")
201 |         let result = try template.render(["seq": Array(0 ... 9)])
202 |         XCTAssertEqual(result, "")
203 |     }
204 | 
205 |     func testVarlen() throws {
206 |         let template = try Template("{% for item in iter %}{{ item }}{% endfor %}")
207 |         let result = try template.render(["iter": Array(0 ... 4)])
208 |         XCTAssertEqual(result, "01234")
209 |     }
210 | 
211 |     func testNoniter() throws {
212 |         let template = try Template("{% for item in none %}...{% endfor %}")
213 |         XCTAssertThrowsError(try template.render(["none": nil]))
214 |     }
215 | 
216 |     // TODO: Make this test pass
217 |     //    func testRecursive() throws {
218 |     //        let template = try Template(
219 |     //            """
220 |     //            {% for item in seq recursive -%}
221 |     //            [{{ item.a }}{% if item.b %}<{{ loop(item.b) }}>{% endif %}]
222 |     //            {%- endfor %}
223 |     //            """
224 |     //        )
225 |     //
226 |     //        let data: [String: Any] = [
227 |     //            "seq": [
228 |     //                ["a": 1, "b": [["a": 1], ["a": 2]]],
229 |     //                ["a": 2, "b": [["a": 1], ["a": 2]]],
230 |     //                ["a": 3, "b": [["a": "a"]]],
231 |     //            ]
232 |     //        ]
233 |     //
234 |     //        let result = try template.render(data)
235 |     //        XCTAssertEqual(result, "[1<[1][2]>][2<[1][2]>][3<[a]>]")
236 |     //    }
237 | 
238 |     func testLooploop() throws {
239 |         let template = try Template(
240 |             """
241 |             {% for row in table %}
242 |             {%- set rowloop = loop -%}
243 |             {% for cell in row -%}
244 |                 [{{ rowloop.index }}|{{ loop.index }}]
245 |             {%- endfor %}
246 |             {%- endfor %}
247 |             """
248 |         )
249 | 
250 |         let result = try template.render(["table": ["ab", "cd"]])
251 |         XCTAssertEqual(result, "[1|1][1|2][2|1][2|2]")
252 |     }
253 | 
254 |     func testLoopFilter() throws {
255 |         let template = try Template(
256 |             "{% for item in range(10) if item is even %}[{{ item }}]{% endfor %}"
257 |         )
258 |         let result = try template.render([:])
259 |         XCTAssertEqual(result, "[0][2][4][6][8]")
260 | 
261 |         let template2 = try Template(
262 |             """
263 |             {%- for item in range(10) if item is even %}[{{ loop.index }}:{{ item }}]{% endfor %}
264 |             """
265 |         )
266 |         let result2 = try template2.render([:])
267 |         XCTAssertEqual(result2, "[1:0][2:2][3:4][4:6][5:8]")
268 |     }
269 | 
270 |     func testUnpacking() throws {
271 |         let template = try Template(
272 |             "{% for a, b, c in [[1, 2, 3]] %}{{ a }}|{{ b }}|{{ c }}{% endfor %}"
273 |         )
274 |         let result = try template.render([:])
275 |         XCTAssertEqual(result, "1|2|3")
276 |     }
277 | 
278 |     // TODO: Make this test pass
279 |     //    func testRecursiveLookaround() throws {
280 |     //        let template = try Template(
281 |     //            """
282 |     //            {% for item in seq recursive -%}
283 |     //            [{{ loop.previtem.a if loop.previtem is defined else 'x' }}.\
284 |     //            {{ item.a }}.\
285 |     //            {{ loop.nextitem.a if loop.nextitem is defined else 'x' }}\
286 |     //            {% if item.b %}<{{ loop(item.b) }}>{% endif %}]
287 |     //            {%- endfor %}
288 |     //            """
289 |     //        )
290 |     //
291 |     //        let data: [String: Any] = [
292 |     //            "seq": [
293 |     //                ["a": 1, "b": [["a": 1], ["a": 2]]],
294 |     //                ["a": 2, "b": [["a": 1], ["a": 2]]],
295 |     //                ["a": 3, "b": [["a": "a"]]],
296 |     //            ]
297 |     //        ]
298 |     //
299 |     //        let result = try template.render(data)
300 |     //        XCTAssertEqual(result, "[x.1.2<[x.1.2][1.2.x]>][1.2.3<[x.1.2][1.2.x]>][2.3.x<[x.a.x]>]")
301 |     //    }
302 | 
303 |     // TODO: Make this test pass
304 |     //    func testRecursiveDepth0() throws {
305 |     //        let template = try Template(
306 |     //            """
307 |     //            {% for item in seq recursive -%}
308 |     //            [{{ loop.depth0 }}:{{ item.a }}\
309 |     //            {% if item.b %}<{{ loop(item.b) }}>{% endif %}]
310 |     //            {%- endfor %}
311 |     //            """
312 |     //        )
313 |     //
314 |     //        let data: [String: Any] = [
315 |     //            "seq": [
316 |     //                ["a": 1, "b": [["a": 1], ["a": 2]]],
317 |     //                ["a": 2, "b": [["a": 1], ["a": 2]]],
318 |     //                ["a": 3, "b": [["a": "a"]]],
319 |     //            ]
320 |     //        ]
321 |     //
322 |     //        let result = try template.render(data)
323 |     //        XCTAssertEqual(result, "[0:1<[1:1][1:2]>][0:2<[1:1][1:2]>][0:3<[1:a]>]")
324 |     //    }
325 | 
326 |     // TODO: Make this test pass
327 |     //    func testRecursiveDepth() throws {
328 |     //        let template = try Template(
329 |     //            """
330 |     //            {% for item in seq recursive -%}
331 |     //            [{{ loop.depth }}:{{ item.a }}\
332 |     //            {% if item.b %}<{{ loop(item.b) }}>{% endif %}]
333 |     //            {%- endfor %}
334 |     //            """
335 |     //        )
336 |     //
337 |     //        let data: [String: Any] = [
338 |     //            "seq": [
339 |     //                ["a": 1, "b": [["a": 1], ["a": 2]]],
340 |     //                ["a": 2, "b": [["a": 1], ["a": 2]]],
341 |     //                ["a": 3, "b": [["a": "a"]]],
342 |     //            ]
343 |     //        ]
344 |     //
345 |     //        let result = try template.render(data)
346 |     //        XCTAssertEqual(result, "[1:1<[2:1][2:2]>][1:2<[2:1][2:2]>][1:3<[2:a]>]")
347 |     //    }
348 | 
349 |     // TODO: Make this test pass
350 |     //    func testReversedBug() throws {
351 |     //        let template = try Template(
352 |     //            """
353 |     //            {% for i in items %}{{ i }}\
354 |     //            {% if not loop.last %},{% endif %}\
355 |     //            {% endfor %}
356 |     //            """
357 |     //        )
358 |     //        let result = try template.render(["items": [3, 2, 1].reversed()])
359 |     //        XCTAssertEqual(result.trimmingCharacters(in: .whitespaces), "1,2,3")
360 |     //    }
361 | 
362 |     // TODO: Make this test pass
363 |     //    func testLoopErrors() throws {
364 |     //        // Test accessing loop variable before loop starts
365 |     //        let template1 = try Template(
366 |     //            """
367 |     //            {% for item in [1] if loop.index == 0 %}...{% endfor %}
368 |     //            """
369 |     //        )
370 |     //        XCTAssertThrowsError(try template1.render([:]))
371 |     //
372 |     //        // Test accessing loop in else block
373 |     //        let template2 = try Template(
374 |     //            """
375 |     //            {% for item in [] %}...{% else %}{{ loop }}{% endfor %}
376 |     //            """
377 |     //        )
378 |     //        let result = try template2.render([:])
379 |     //        XCTAssertEqual(result, "")
380 |     //    }
381 | 
382 |     func testScopedSpecialVar() throws {
383 |         let template = try Template(
384 |             """
385 |             {% for s in seq %}[{{ loop.first }}\
386 |             {% for c in s %}|{{ loop.first }}{% endfor %}]\
387 |             {% endfor %}
388 |             """
389 |         )
390 |         let result = try template.render(["seq": ["ab", "cd"]])
391 |         XCTAssertEqual(result, "[true|true|false][false|true|false]")
392 |     }
393 | 
394 |     func testScopedLoopVar() throws {
395 |         let template1 = try Template(
396 |             """
397 |             {% for x in seq %}{{ loop.first }}\
398 |             {% for y in seq %}{% endfor %}\
399 |             {% endfor %}
400 |             """
401 |         )
402 |         let result1 = try template1.render(["seq": "ab"])
403 |         XCTAssertEqual(result1, "truefalse")
404 | 
405 |         let template2 = try Template(
406 |             """
407 |             {% for x in seq %}\
408 |             {% for y in seq %}{{ loop.first }}\
409 |             {% endfor %}\
410 |             {% endfor %}
411 |             """
412 |         )
413 |         let result2 = try template2.render(["seq": "ab"])
414 |         XCTAssertEqual(result2, "truefalsetruefalse")
415 |     }
416 | 
417 |     // TODO: Make this test pass
418 |     //    func testRecursiveEmptyLoopIter() throws {
419 |     //        let template = try Template(
420 |     //            """
421 |     //            {%- for item in foo recursive -%}\
422 |     //            {%- endfor -%}
423 |     //            """
424 |     //        )
425 |     //        let result = try template.render(["foo": []])
426 |     //        XCTAssertEqual(result, "")
427 |     //    }
428 | 
429 |     // TODO: Make this test pass
430 |     //    func testCallInLoop() throws {
431 |     //        let template = try Template(
432 |     //            """
433 |     //            {%- macro do_something() -%}
434 |     //                [{{ caller() }}]
435 |     //            {%- endmacro %}
436 |     //
437 |     //            {%- for i in [1, 2, 3] %}
438 |     //                {%- call do_something() -%}
439 |     //                    {{ i }}
440 |     //                {%- endcall %}
441 |     //            {%- endfor -%}
442 |     //            """
443 |     //        )
444 |     //        let result = try template.render([:])
445 |     //        XCTAssertEqual(result, "[1][2][3]")
446 |     //    }
447 | }
448 | 
449 | final class MacroTests: XCTestCase {
450 |     func testSimpleMacro() throws {
451 |         let template = try Template(
452 |             """
453 |             {% macro say_hello(name) %}Hello {{ name }}!{% endmacro %}
454 |             {{ say_hello('Peter') }}
455 |             """
456 |         )
457 |         let result = try template.render([:])
458 |         XCTAssertEqual(result.trimmingCharacters(in: .whitespaces), "Hello Peter!")
459 |     }
460 | 
461 |     func testMacroScoping() throws {
462 |         let template = try Template(
463 |             """
464 |             {% macro level1(data1) %}
465 |             {% macro level2(data2) %}{{ data1 }}|{{ data2 }}{% endmacro %}
466 |             {{ level2('bar') }}{% endmacro %}
467 |             {{ level1('foo') }}
468 |             """
469 |         )
470 |         let result = try template.render([:])
471 |         XCTAssertEqual(result.trimmingCharacters(in: .whitespaces), "foo|bar")
472 |     }
473 | 
474 |     // TODO: Make this test pass
475 |     //    func testMacroArguments() throws {
476 |     //        let template = try Template(
477 |     //            """
478 |     //            {% macro m(a, b, c='c', d='d') %}{{ a }}|{{ b }}|{{ c }}|{{ d }}{% endmacro %}
479 |     //            {{ m() }}|{{ m('a') }}|{{ m('a', 'b') }}|{{ m(1, 2, 3) }}
480 |     //            """
481 |     //        )
482 |     //        let result = try template.render([:])
483 |     //        XCTAssertEqual(result, "||c|d|a||c|d|a|b|c|d|1|2|3|d")
484 |     //    }
485 | 
486 |     func testCallself() throws {
487 |         let template = try Template(
488 |             """
489 |             {% macro foo(x) %}{{ x }}{% if x > 1 %}|{{ foo(x - 1) }}{% endif %}{% endmacro %}
490 |             {{ foo(5) }}
491 |             """
492 |         )
493 |         let result = try template.render([:])
494 |         XCTAssertEqual(result.trimmingCharacters(in: .whitespaces), "5|4|3|2|1")
495 |     }
496 | 
497 |     // TODO: Make this test pass
498 |     //    func testArgumentsDefaultsNonsense() throws {
499 |     //        // Test that macro with invalid argument defaults throws error
500 |     //        let template = try Template(
501 |     //            """
502 |     //            {% macro m(a, b=1, c) %}a={{ a }}, b={{ b }}, c={{ c }}{% endmacro %}
503 |     //            """
504 |     //        )
505 |     //        XCTAssertThrowsError(try template.render([:]))
506 |     //    }
507 | 
508 |     // TODO: Make this test pass
509 |     //    func testCallerDefaultsNonsense() throws {
510 |     //        let template = try Template(
511 |     //            """
512 |     //            {% macro a() %}{{ caller() }}{% endmacro %}
513 |     //            {% call(x, y=1, z) a() %}{% endcall %}
514 |     //            """
515 |     //        )
516 |     //        XCTAssertThrowsError(try template.render([:]))
517 |     //    }
518 | 
519 |     // TODO: Make this test pass
520 |     //    func testVarargs() throws {
521 |     //        let template = try Template(
522 |     //            """
523 |     //            {% macro test() %}{{ varargs|join('|') }}{% endmacro %}\
524 |     //            {{ test(1, 2, 3) }}
525 |     //            """
526 |     //        )
527 |     //        let result = try template.render([:])
528 |     //        XCTAssertEqual(result, "1|2|3")
529 |     //    }
530 | 
531 |     // TODO: Make this test pass
532 |     //    func testSimpleCall() throws {
533 |     //        let template = try Template(
534 |     //            """
535 |     //            {% macro test() %}[[{{ caller() }}]]{% endmacro %}\
536 |     //            {% call test() %}data{% endcall %}
537 |     //            """
538 |     //        )
539 |     //        let result = try template.render([:])
540 |     //        XCTAssertEqual(result, "[[data]]")
541 |     //    }
542 | 
543 |     // TODO: Make this test pass
544 |     //    func testComplexCall() throws {
545 |     //        let template = try Template(
546 |     //            """
547 |     //            {% macro test() %}[[{{ caller('data') }}]]{% endmacro %}\
548 |     //            {% call(data) test() %}{{ data }}{% endcall %}
549 |     //            """
550 |     //        )
551 |     //        let result = try template.render([:])
552 |     //        XCTAssertEqual(result, "[[data]]")
553 |     //    }
554 | 
555 |     // TODO: Make this test pass
556 |     //    func testCallerUndefined() throws {
557 |     //        let template = try Template(
558 |     //            """
559 |     //            {% set caller = 42 %}\
560 |     //            {% macro test() %}{{ caller is not defined }}{% endmacro %}\
561 |     //            {{ test() }}
562 |     //            """
563 |     //        )
564 |     //        let result = try template.render([:])
565 |     //        XCTAssertEqual(result, "true")
566 |     //    }
567 | }
568 | 
569 | final class SetTests: XCTestCase {
570 |     // MARK: - Set Tests
571 | 
572 |     func testNormalSet() throws {
573 |         let template = try Template("{% set foo = 1 %}{{ foo }}")
574 |         let result = try template.render([:])
575 |         XCTAssertEqual(result, "1")
576 |     }
577 | 
578 |     // TODO: Make this test pass
579 |     //    func testBlockSet() throws {
580 |     //        let template = try Template("{% set foo %}42{% endset %}{{ foo }}")
581 |     //        let result = try template.render([:])
582 |     //        XCTAssertEqual(result, "42")
583 |     //    }
584 | 
585 |     func testNamespace() throws {
586 |         let template = try Template(
587 |             """
588 |             {% set ns = namespace() %}{% set ns.bar = '42' %}{{ ns.bar }}
589 |             """
590 |         )
591 |         let result = try template.render([:])
592 |         XCTAssertEqual(result, "42")
593 |     }
594 | 
595 |     // TODO: Make this test pass
596 |     //    func testNamespaceLoop() throws {
597 |     //        let template = try Template(
598 |     //            """
599 |     //            {% set ns = namespace(found=false) %}\
600 |     //            {% for x in range(4) %}\
601 |     //            {% if x == v %}\
602 |     //            {% set ns.found = true %}\
603 |     //            {% endif %}\
604 |     //            {% endfor %}\
605 |     //            {{ ns.found }}
606 |     //            """
607 |     //        )
608 |     //
609 |     //        let result1 = try template.render(["v": 3])
610 |     //        XCTAssertEqual(result1, "true")
611 |     //
612 |     //        let result2 = try template.render(["v": 4])
613 |     //        XCTAssertEqual(result2, "false")
614 |     //    }
615 | 
616 |     // TODO: Make this test pass
617 |     //    func testNamespaceBlock() throws {
618 |     //        let template = try Template(
619 |     //            """
620 |     //            {% set ns = namespace() %}{% set ns.bar %}42{% endset %}{{ ns.bar }}
621 |     //            """
622 |     //        )
623 |     //        let result = try template.render([:])
624 |     //        XCTAssertEqual(result, "42")
625 |     //    }
626 | 
627 |     // TODO: Make this test pass
628 |     //    func testInitNamespace() throws {
629 |     //        let template = try Template(
630 |     //            """
631 |     //            {% set ns = namespace(d, self=37) %}
632 |     //            {% set ns.b = 42 %}
633 |     //            {{ ns.a }}|{{ ns.self }}|{{ ns.b }}
634 |     //            """
635 |     //        )
636 |     //        let result = try template.render(["d": ["a": 13]])
637 |     //        XCTAssertEqual(result.trimmingCharacters(in: .whitespaces), "13|37|42")
638 |     //    }
639 | 
640 |     // TODO: Make this test pass
641 |     //    func testNamespaceMacro() throws {
642 |     //        let template = try Template(
643 |     //            """
644 |     //            {% set ns = namespace() %}
645 |     //            {% set ns.a = 13 %}
646 |     //            {% macro magic(x) %}
647 |     //            {% set x.b = 37 %}
648 |     //            {% endmacro %}
649 |     //            {{ magic(ns) }}
650 |     //            {{ ns.a }}|{{ ns.b }}
651 |     //            """
652 |     //        )
653 |     //        let result = try template.render([:])
654 |     //        XCTAssertEqual(result.trimmingCharacters(in: .whitespaces), "13|37")
655 |     //    }
656 | 
657 |     // TODO: Make this test pass
658 |     //    func testNamespaceSetTuple() throws {
659 |     //        let template = try Template(
660 |     //            """
661 |     //            {% set ns = namespace(a=12, b=36) %}
662 |     //            {% set ns.a, ns.b = ns.a + 1, ns.b + 1 %}
663 |     //            {{ ns.a }}|{{ ns.b }}
664 |     //            """
665 |     //        )
666 |     //        let result = try template.render([:])
667 |     //        XCTAssertEqual(result.trimmingCharacters(in: .whitespaces), "13|37")
668 |     //    }
669 | 
670 |     // TODO: Make this test pass
671 |     //    func testBlockEscaping() throws {
672 |     //        let template = try Template(
673 |     //            """
674 |     //            {% set foo %}<em>{{ test }}</em>{% endset %}\
675 |     //            foo: {{ foo }}
676 |     //            """
677 |     //        )
678 |     //        let result = try template.render(["test": "<unsafe>"])
679 |     //        XCTAssertEqual(
680 |     //            result.trimmingCharacters(in: .whitespaces),
681 |     //            "foo: <em>&lt;unsafe&gt;</em>"
682 |     //        )
683 |     //    }
684 | 
685 |     // TODO: Make this test pass
686 |     //    func testBlockEscapingFiltered() throws {
687 |     //        let template = try Template(
688 |     //            """
689 |     //            {% set foo | trim %}<em>{{ test }}</em>    {% endset %}\
690 |     //            foo: {{ foo }}
691 |     //            """
692 |     //        )
693 |     //        let result = try template.render(["test": "<unsafe>"])
694 |     //        XCTAssertEqual(
695 |     //            result.trimmingCharacters(in: .whitespaces),
696 |     //            "foo: <em>&lt;unsafe&gt;</em>"
697 |     //        )
698 |     //    }
699 | 
700 |     // TODO: Make this test pass
701 |     //    func testBlockFiltered() throws {
702 |     //        let template = try Template(
703 |     //            """
704 |     //            {% set foo | trim | length | string %} 42    {% endset %}\
705 |     //            {{ foo }}
706 |     //            """
707 |     //        )
708 |     //        let result = try template.render([:])
709 |     //        XCTAssertEqual(result.trimmingCharacters(in: .whitespaces), "2")
710 |     //    }
711 | 
712 |     // TODO: Make this test pass
713 |     //    func testSetInvalid() throws {
714 |     //        // Test invalid set syntax
715 |     //        let template1 = try Template("{% set foo['bar'] = 1 %}")
716 |     //        XCTAssertThrowsError(try template1.render([:]))
717 |     //
718 |     //        // Test setting attribute on non-namespace
719 |     //        let template2 = try Template("{% set foo.bar = 1 %}")
720 |     //        XCTAssertThrowsError(try template2.render(["foo": [:]]))
721 |     //    }
722 | 
723 |     func testNamespaceRedefined() throws {
724 |         let template = try Template(
725 |             """
726 |             {% set ns = namespace() %}\
727 |             {% set ns.bar = 'hi' %}
728 |             """
729 |         )
730 |         XCTAssertThrowsError(try template.render(["namespace": [String: Any].self]))
731 |     }
732 | }
733 | 
734 | // TODO: Make these tests pass
735 | //final class WithTests: XCTestCase {
736 | //    func testWith() throws {
737 | //        let template = try Template(
738 | //            """
739 | //            {% with a=42, b=23 -%}
740 | //                {{ a }} = {{ b }}
741 | //            {% endwith -%}
742 | //                {{ a }} = {{ b }}
743 | //            """
744 | //        )
745 | //        let result = try template.render(["a": 1, "b": 2])
746 | //        let lines = result.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces) }
747 | //        XCTAssertEqual(lines, ["42 = 23", "1 = 2"])
748 | //    }
749 | //
750 | //    func testWithArgumentScoping() throws {
751 | //        let template = try Template(
752 | //            """
753 | //            {%- with a=1, b=2, c=b, d=e, e=5 -%}
754 | //                {{ a }}|{{ b }}|{{ c }}|{{ d }}|{{ e }}
755 | //            {%- endwith -%}
756 | //            """
757 | //        )
758 | //        let result = try template.render(["b": 3, "e": 4])
759 | //        XCTAssertEqual(result, "1|2|3|4|5")
760 | //    }
761 | //}
762 | 


--------------------------------------------------------------------------------
/Tests/FilterTests.swift:
--------------------------------------------------------------------------------
   1 | //
   2 | //  FilterTests.swift
   3 | //  Jinja
   4 | //
   5 | //  Created by Anthony DePasquale on 07.01.2025.
   6 | //
   7 | 
   8 | // Adapted from https://github.com/pallets/jinja/blob/main/tests/test_filters.py
   9 | 
  10 | import XCTest
  11 | import OrderedCollections
  12 | 
  13 | @testable import Jinja
  14 | 
  15 | final class FilterTests: XCTestCase {
  16 |     func testFilters() throws {
  17 |         // Helper function to run tests for a filter
  18 |         func runTest(
  19 |             filterName: String,
  20 |             input: Any,
  21 |             args: [Any?] = [],
  22 |             expected: Any,
  23 |             file: StaticString = #file,
  24 |             line: UInt = #line
  25 |         ) throws {
  26 |             let env = Environment()
  27 | 
  28 |             // Convert input to RuntimeValue
  29 |             guard let input = try? env.convertToRuntimeValues(input: input) else {
  30 |                 XCTFail(
  31 |                     "Failed to convert input \(input) to RuntimeValue in test for \(filterName)",
  32 |                     file: file,
  33 |                     line: line
  34 |                 )
  35 |                 return
  36 |             }
  37 | 
  38 |             // Set the input value in the environment
  39 |             try env.set(name: "input", value: input)
  40 | 
  41 |             // Set filter arguments in the environment
  42 |             for (index, arg) in args.enumerated() {
  43 |                 if let arg {
  44 |                     try env.set(name: "arg\(index)", value: arg)
  45 |                 }
  46 |             }
  47 | 
  48 |             // Construct the filter arguments for direct call
  49 |             var filterArgs: [any RuntimeValue] = [input]
  50 |             for (index, _) in args.enumerated() {
  51 |                 filterArgs.append(env.lookupVariable(name: "arg\(index)"))
  52 |             }
  53 | 
  54 |             // Get the filter function from the environment
  55 |             guard let filter = env.filters[filterName] else {
  56 |                 XCTFail("Filter not found: \(filterName)", file: file, line: line)
  57 |                 return
  58 |             }
  59 | 
  60 |             // Call the filter function directly with the input and arguments
  61 |             let result = try filter(filterArgs, env)
  62 | 
  63 |             // Perform assertions based on the expected type
  64 |             if let expectedString = expected as? String {
  65 |                 XCTAssertEqual(
  66 |                     (result as? StringValue)?.value,
  67 |                     expectedString,
  68 |                     "\(filterName) filter failed",
  69 |                     file: file,
  70 |                     line: line
  71 |                 )
  72 |             } else if let expectedInt = expected as? Int {
  73 |                 XCTAssertEqual(
  74 |                     (result as? NumericValue)?.value as? Int,
  75 |                     expectedInt,
  76 |                     "\(filterName) filter failed",
  77 |                     file: file,
  78 |                     line: line
  79 |                 )
  80 |             } else if let expectedDouble = expected as? Double {
  81 |                 XCTAssertEqual(
  82 |                     (result as? NumericValue)?.value as? Double,
  83 |                     expectedDouble,
  84 |                     "\(filterName) filter failed",
  85 |                     file: file,
  86 |                     line: line
  87 |                 )
  88 |             } else if let expectedBool = expected as? Bool {
  89 |                 XCTAssertEqual(
  90 |                     (result as? BooleanValue)?.value,
  91 |                     expectedBool,
  92 |                     "\(filterName) filter failed",
  93 |                     file: file,
  94 |                     line: line
  95 |                 )
  96 |             } else if expected is UndefinedValue {
  97 |                 XCTAssertTrue(
  98 |                     result is UndefinedValue,
  99 |                     "\(filterName) filter failed",
 100 |                     file: file,
 101 |                     line: line
 102 |                 )
 103 |             } else if let expectedArray = expected as? [String] {
 104 |                 guard let resultArray = (result as? ArrayValue)?.value else {
 105 |                     XCTFail(
 106 |                         "\(filterName) filter failed: Expected [String], got \(type(of: result)), value: \(result)",
 107 |                         file: file,
 108 |                         line: line
 109 |                     )
 110 |                     return
 111 |                 }
 112 |                 let resultStrings = resultArray.compactMap { value -> String? in
 113 |                     if let stringValue = value as? StringValue {
 114 |                         return stringValue.value
 115 |                     } else if value is NullValue {
 116 |                         return "None"
 117 |                     }
 118 |                     return nil
 119 |                 }
 120 |                 XCTAssertEqual(
 121 |                     resultStrings,
 122 |                     expectedArray,
 123 |                     "\(filterName) filter failed",
 124 |                     file: file,
 125 |                     line: line
 126 |                 )
 127 |             } else if let expectedArray = expected as? [Int] {
 128 |                 guard let resultArray = (result as? ArrayValue)?.value else {
 129 |                     XCTFail(
 130 |                         "\(filterName) filter failed: Expected [Int], got \(type(of: result))",
 131 |                         file: file,
 132 |                         line: line
 133 |                     )
 134 |                     return
 135 |                 }
 136 |                 let resultInts = resultArray.compactMap { ($0 as? NumericValue)?.value as? Int }
 137 |                 XCTAssertEqual(
 138 |                     resultInts,
 139 |                     expectedArray,
 140 |                     "\(filterName) filter failed",
 141 |                     file: file,
 142 |                     line: line
 143 |                 )
 144 |             } else if let expectedArray = expected as? [[String]] {
 145 |                 guard let resultArray = (result as? ArrayValue)?.value else {
 146 |                     XCTFail(
 147 |                         "\(filterName) filter failed: Expected [[String]], got \(type(of: result))",
 148 |                         file: file,
 149 |                         line: line
 150 |                     )
 151 |                     return
 152 |                 }
 153 |                 let resultArrays = resultArray.compactMap { value -> [String]? in
 154 |                     if let arrayValue = value as? ArrayValue {
 155 |                         return arrayValue.value.compactMap { ($0 as? StringValue)?.value }
 156 |                     } else if let stringValue = value as? StringValue {
 157 |                         return [stringValue.value]
 158 |                     }
 159 |                     return nil
 160 |                 }
 161 |                 XCTAssertEqual(
 162 |                     resultArrays,
 163 |                     expectedArray,
 164 |                     "\(filterName) filter failed",
 165 |                     file: file,
 166 |                     line: line
 167 |                 )
 168 |             } else if let expectedArray = expected as? [[Int]] {
 169 |                 guard let resultArray = (result as? ArrayValue)?.value as? [ArrayValue] else {
 170 |                     XCTFail(
 171 |                         "\(filterName) filter failed: Expected [[Int]], got \(type(of: result))",
 172 |                         file: file,
 173 |                         line: line
 174 |                     )
 175 |                     return
 176 |                 }
 177 |                 let resultInts = resultArray.map { $0.value.compactMap { ($0 as? NumericValue)?.value as? Int } }
 178 |                 XCTAssertEqual(
 179 |                     resultInts,
 180 |                     expectedArray,
 181 |                     "\(filterName) filter failed",
 182 |                     file: file,
 183 |                     line: line
 184 |                 )
 185 |             } else if let expectedDict = expected as? [String: Any] {
 186 |                 guard let resultDict = (result as? ObjectValue)?.value else {
 187 |                     XCTFail(
 188 |                         "\(filterName) filter failed: Expected [String: Any], got \(type(of: result))",
 189 |                         file: file,
 190 |                         line: line
 191 |                     )
 192 |                     return
 193 |                 }
 194 |                 XCTAssertEqual(
 195 |                     resultDict.count,
 196 |                     expectedDict.count,
 197 |                     "\(filterName) filter failed: Dictionary count mismatch",
 198 |                     file: file,
 199 |                     line: line
 200 |                 )
 201 |                 for (key, expectedValue) in expectedDict {
 202 |                     guard let resultValue = resultDict[key] else {
 203 |                         XCTFail(
 204 |                             "\(filterName) filter failed: Missing key '\(key)' in result",
 205 |                             file: file,
 206 |                             line: line
 207 |                         )
 208 |                         return
 209 |                     }
 210 |                     if let expectedString = expectedValue as? String {
 211 |                         XCTAssertEqual(
 212 |                             (resultValue as? StringValue)?.value,
 213 |                             expectedString,
 214 |                             "\(filterName) filter failed for key '\(key)'",
 215 |                             file: file,
 216 |                             line: line
 217 |                         )
 218 |                     } else if let expectedInt = expectedValue as? Int {
 219 |                         XCTAssertEqual(
 220 |                             ((resultValue as? NumericValue)?.value as? Int),
 221 |                             expectedInt,
 222 |                             "\(filterName) filter failed for key '\(key)'",
 223 |                             file: file,
 224 |                             line: line
 225 |                         )
 226 |                     } else if let expectedDouble = expectedValue as? Double {
 227 |                         XCTAssertEqual(
 228 |                             ((resultValue as? NumericValue)?.value as? Double),
 229 |                             expectedDouble,
 230 |                             "\(filterName) filter failed for key '\(key)'",
 231 |                             file: file,
 232 |                             line: line
 233 |                         )
 234 |                     } else if let expectedBool = expectedValue as? Bool {
 235 |                         XCTAssertEqual(
 236 |                             (resultValue as? BooleanValue)?.value,
 237 |                             expectedBool,
 238 |                             "\(filterName) filter failed for key '\(key)'",
 239 |                             file: file,
 240 |                             line: line
 241 |                         )
 242 |                     } else if expectedValue is UndefinedValue {
 243 |                         XCTAssertTrue(
 244 |                             resultValue is UndefinedValue,
 245 |                             "\(filterName) filter failed for key '\(key)'",
 246 |                             file: file,
 247 |                             line: line
 248 |                         )
 249 |                     } else {
 250 |                         XCTFail(
 251 |                             "\(filterName) filter failed: Unsupported type for key '\(key)'",
 252 |                             file: file,
 253 |                             line: line
 254 |                         )
 255 |                     }
 256 |                 }
 257 |             } else if let expectedArray = expected as? [(String, Any)] {
 258 |                 guard let resultArray = (result as? ArrayValue)?.value as? [ArrayValue] else {
 259 |                     XCTFail(
 260 |                         "\(filterName) filter failed: Expected [(String, Any)], got \(type(of: result))",
 261 |                         file: file,
 262 |                         line: line
 263 |                     )
 264 |                     return
 265 |                 }
 266 | 
 267 |                 XCTAssertEqual(
 268 |                     resultArray.count,
 269 |                     expectedArray.count,
 270 |                     "\(filterName) filter failed",
 271 |                     file: file,
 272 |                     line: line
 273 |                 )
 274 | 
 275 |                 for (index, expectedTuple) in expectedArray.enumerated() {
 276 |                     let resultTuple = resultArray[index].value
 277 | 
 278 |                     guard resultTuple.count == 2 else {
 279 |                         XCTFail(
 280 |                             "\(filterName) filter failed at index \(index): Result tuple does not have 2 elements",
 281 |                             file: file,
 282 |                             line: line
 283 |                         )
 284 |                         return
 285 |                     }
 286 | 
 287 |                     XCTAssertEqual(
 288 |                         (resultTuple[0] as? StringValue)?.value,
 289 |                         expectedTuple.0,
 290 |                         "\(filterName) filter failed at index \(index)",
 291 |                         file: file,
 292 |                         line: line
 293 |                     )
 294 | 
 295 |                     if let expectedInt = expectedTuple.1 as? Int {
 296 |                         XCTAssertEqual(
 297 |                             ((resultTuple[1] as? NumericValue)?.value as? Int),
 298 |                             expectedInt,
 299 |                             "\(filterName) filter failed at index \(index)",
 300 |                             file: file,
 301 |                             line: line
 302 |                         )
 303 |                     } else if let expectedString = expectedTuple.1 as? String {
 304 |                         XCTAssertEqual(
 305 |                             (resultTuple[1] as? StringValue)?.value,
 306 |                             expectedString,
 307 |                             "\(filterName) filter failed at index \(index)",
 308 |                             file: file,
 309 |                             line: line
 310 |                         )
 311 |                     } else {
 312 |                         XCTFail(
 313 |                             "\(filterName) filter failed: Unsupported type for tuple element at index \(index)",
 314 |                             file: file,
 315 |                             line: line
 316 |                         )
 317 |                     }
 318 |                 }
 319 |             } else if let expectedMixedArray = expected as? [Any] {
 320 |                 guard let resultArray = (result as? ArrayValue)?.value else {
 321 |                     XCTFail(
 322 |                         "\(filterName) filter failed: Expected [Any], got \(type(of: result))",
 323 |                         file: file,
 324 |                         line: line
 325 |                     )
 326 |                     return
 327 |                 }
 328 | 
 329 |                 // Convert both arrays to strings for comparison since they may contain mixed types
 330 |                 let resultStrings = resultArray.map { value -> String in
 331 |                     if let arrayValue = value as? ArrayValue {
 332 |                         return "["
 333 |                             + arrayValue.value.map {
 334 |                                 if let strValue = $0 as? StringValue {
 335 |                                     return strValue.value
 336 |                                 }
 337 |                                 return String(describing: $0)
 338 |                             }.joined(separator: ", ") + "]"
 339 |                     } else if let stringValue = value as? StringValue {
 340 |                         return stringValue.value
 341 |                     } else {
 342 |                         return String(describing: value)
 343 |                     }
 344 |                 }
 345 | 
 346 |                 let expectedStrings = expectedMixedArray.map { value -> String in
 347 |                     if let array = value as? [String] {
 348 |                         return "[" + array.joined(separator: ", ") + "]"
 349 |                     } else {
 350 |                         return String(describing: value)
 351 |                     }
 352 |                 }
 353 | 
 354 |                 XCTAssertEqual(
 355 |                     resultStrings,
 356 |                     expectedStrings,
 357 |                     "\(filterName) filter failed",
 358 |                     file: file,
 359 |                     line: line
 360 |                 )
 361 |             } else if let expectedGroups = expected as? [[String: Any]] {
 362 |                 // For "groupby" filter
 363 |                 // Convert both expected and actual results to JSON strings for comparison
 364 |                 let expectedJSON = try toJSON(try env.convertToRuntimeValues(input: expectedGroups))
 365 |                 let actualJSON = try toJSON(result)
 366 | 
 367 |                 XCTAssertEqual(
 368 |                     expectedJSON,
 369 |                     actualJSON,
 370 |                     "\(filterName) filter failed: Expected \(expectedJSON) but got \(actualJSON)",
 371 |                     file: file,
 372 |                     line: line
 373 |                 )
 374 |             } else {
 375 |                 XCTFail(
 376 |                     "\(filterName) filter failed: Unsupported expected type \(type(of: expected))",
 377 |                     file: file,
 378 |                     line: line
 379 |                 )
 380 |             }
 381 |         }
 382 | 
 383 |         // Test abs
 384 |         try runTest(filterName: "abs", input: -1, expected: 1)
 385 |         try runTest(filterName: "abs", input: 1, expected: 1)
 386 |         try runTest(filterName: "abs", input: -3.14, expected: 3.14)
 387 |         try runTest(filterName: "abs", input: 3.14, expected: 3.14)
 388 | 
 389 |         // Test attr
 390 |         try runTest(
 391 |             filterName: "attr",
 392 |             input: ["name": "John"],
 393 |             args: ["name"],
 394 |             expected: "John"
 395 |         )
 396 |         try runTest(
 397 |             filterName: "attr",
 398 |             input: ["age": 30],
 399 |             args: ["age"],
 400 |             expected: 30
 401 |         )
 402 |         try runTest(
 403 |             filterName: "attr",
 404 |             input: ["name": "John"],
 405 |             args: ["age"],
 406 |             expected: UndefinedValue()
 407 |         )
 408 | 
 409 |         // Test batch
 410 |         try runTest(
 411 |             filterName: "batch",
 412 |             input: [1, 2, 3, 4, 5, 6, 7, 8, 9],
 413 |             args: [3],
 414 |             expected: [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
 415 |         )
 416 |         try runTest(
 417 |             filterName: "batch",
 418 |             input: [1, 2, 3, 4, 5, 6, 7, 8, 9],
 419 |             args: [3, 0],
 420 |             expected: [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
 421 |         )
 422 |         try runTest(
 423 |             filterName: "batch",
 424 |             input: [1, 2, 3, 4, 5, 6, 7, 8],
 425 |             args: [3, 0],
 426 |             expected: [[1, 2, 3], [4, 5, 6], [7, 8, 0]]
 427 |         )
 428 | 
 429 |         // Test capitalize
 430 |         try runTest(filterName: "capitalize", input: "foo bar", expected: "Foo bar")
 431 |         try runTest(filterName: "capitalize", input: "FOO BAR", expected: "Foo bar")
 432 | 
 433 |         // Test center
 434 |         try runTest(
 435 |             filterName: "center",
 436 |             input: "foo",
 437 |             expected: String(repeating: " ", count: 38) + "foo" + String(repeating: " ", count: 39)
 438 |         )  // Default width 80
 439 |         try runTest(filterName: "center", input: "foo", args: [NumericValue(value: 11)], expected: "    foo    ")
 440 |         try runTest(filterName: "center", input: "foo", args: [NumericValue(value: 5)], expected: " foo ")
 441 |         try runTest(filterName: "center", input: "foo", args: [NumericValue(value: 4)], expected: "foo ")
 442 |         try runTest(filterName: "center", input: "foo", args: [NumericValue(value: 3)], expected: "foo")
 443 |         try runTest(filterName: "center", input: "foo", args: [NumericValue(value: 2)], expected: "foo")
 444 | 
 445 |         // Test count
 446 |         try runTest(filterName: "count", input: "Hello", expected: 5)
 447 |         try runTest(filterName: "count", input: [1, 2, 3].map { NumericValue(value: $0) }, expected: 3)
 448 |         try runTest(
 449 |             filterName: "count",
 450 |             input: ObjectValue(value: ["name": StringValue(value: "John"), "age": NumericValue(value: 30)]),
 451 |             expected: 2
 452 |         )
 453 | 
 454 |         // Test default
 455 |         try runTest(filterName: "default", input: UndefinedValue(), expected: "")
 456 |         try runTest(filterName: "default", input: UndefinedValue(), args: ["foo"], expected: "foo")
 457 |         try runTest(filterName: "default", input: false, args: ["foo", true], expected: "foo")
 458 |         try runTest(filterName: "default", input: true, args: ["foo", true], expected: "true")
 459 |         try runTest(filterName: "default", input: "bar", args: ["foo"], expected: "bar")
 460 | 
 461 |         // Test dictsort
 462 |         try runTest(
 463 |             filterName: "dictsort",
 464 |             input: OrderedDictionary<String, Any>(dictionaryLiteral: ("f", 5), ("b", 4), ("c", 3), ("d", 2), ("a", 1)),
 465 |             expected: [("a", 1), ("b", 4), ("c", 3), ("d", 2), ("f", 5)]
 466 |         )
 467 |         try runTest(
 468 |             filterName: "dictsort",
 469 |             input: OrderedDictionary<String, Any>(dictionaryLiteral: ("f", 5), ("b", 4), ("c", 3), ("d", 2), ("a", 1)),
 470 |             args: [true],
 471 |             expected: [("a", 1), ("b", 4), ("c", 3), ("d", 2), ("f", 5)]
 472 |         )
 473 |         try runTest(
 474 |             filterName: "dictsort",
 475 |             input: OrderedDictionary<String, Any>(dictionaryLiteral: ("f", 5), ("b", 4), ("c", 3), ("d", 2), ("a", 1)),
 476 |             args: [false, "value"],
 477 |             expected: [("a", 1), ("d", 2), ("c", 3), ("b", 4), ("f", 5)]
 478 |         )
 479 |         try runTest(
 480 |             filterName: "dictsort",
 481 |             input: OrderedDictionary<String, Any>(dictionaryLiteral: ("f", 5), ("b", 4), ("c", 3), ("d", 2), ("a", 1)),
 482 |             args: [false, "key", true],
 483 |             expected: [("f", 5), ("d", 2), ("c", 3), ("b", 4), ("a", 1)]
 484 |         )
 485 |         try runTest(
 486 |             filterName: "dictsort",
 487 |             input: OrderedDictionary<String, Any>(dictionaryLiteral: ("f", 5), ("b", 4), ("c", 3), ("d", 2), ("a", 1)),
 488 |             args: [false, "value", true],
 489 |             expected: [("f", 5), ("b", 4), ("c", 3), ("d", 2), ("a", 1)]
 490 |         )
 491 | 
 492 |         // Test escape
 493 |         try runTest(filterName: "escape", input: "<foo>", expected: "&lt;foo&gt;")
 494 |         try runTest(filterName: "escape", input: "foo & bar", expected: "foo &amp; bar")
 495 | 
 496 |         // Test filesizeformat
 497 |         try runTest(filterName: "filesizeformat", input: 100, expected: "100 Bytes")
 498 |         try runTest(filterName: "filesizeformat", input: 1000, expected: "1.0 kB")
 499 |         try runTest(filterName: "filesizeformat", input: 1_000_000, expected: "1.0 MB")
 500 |         try runTest(filterName: "filesizeformat", input: 1_000_000_000, expected: "1.0 GB")
 501 |         try runTest(
 502 |             filterName: "filesizeformat",
 503 |             input: 1_000_000_000_000,
 504 |             expected: "1.0 TB"
 505 |         )
 506 |         try runTest(filterName: "filesizeformat", input: 300, expected: "300 Bytes")
 507 |         try runTest(filterName: "filesizeformat", input: 3000, expected: "3.0 kB")
 508 |         try runTest(filterName: "filesizeformat", input: 3_000_000, expected: "3.0 MB")
 509 |         try runTest(filterName: "filesizeformat", input: 3_000_000_000, expected: "3.0 GB")
 510 |         try runTest(
 511 |             filterName: "filesizeformat",
 512 |             input: 3_000_000_000_000,
 513 |             expected: "3.0 TB"
 514 |         )
 515 |         try runTest(
 516 |             filterName: "filesizeformat",
 517 |             input: 100,
 518 |             args: [true],
 519 |             expected: "100 Bytes"
 520 |         )
 521 |         try runTest(
 522 |             filterName: "filesizeformat",
 523 |             input: 1000,
 524 |             args: [true],
 525 |             expected: "1000 Bytes"
 526 |         )
 527 |         try runTest(
 528 |             filterName: "filesizeformat",
 529 |             input: 1_000_000,
 530 |             args: [true],
 531 |             expected: "976.6 KiB"
 532 |         )
 533 |         try runTest(
 534 |             filterName: "filesizeformat",
 535 |             input: 1_000_000_000,
 536 |             args: [true],
 537 |             expected: "953.7 MiB"
 538 |         )
 539 |         try runTest(
 540 |             filterName: "filesizeformat",
 541 |             input: 1_000_000_000_000,
 542 |             args: [true],
 543 |             expected: "931.3 GiB"
 544 |         )
 545 |         try runTest(
 546 |             filterName: "filesizeformat",
 547 |             input: 300,
 548 |             args: [true],
 549 |             expected: "300 Bytes"
 550 |         )
 551 |         try runTest(
 552 |             filterName: "filesizeformat",
 553 |             input: 3000,
 554 |             args: [true],
 555 |             expected: "2.9 KiB"
 556 |         )
 557 |         try runTest(
 558 |             filterName: "filesizeformat",
 559 |             input: 3_000_000,
 560 |             args: [true],
 561 |             expected: "2.9 MiB"
 562 |         )
 563 | 
 564 |         // Test first
 565 |         try runTest(filterName: "first", input: [1, 2, 3], expected: 1)
 566 |         try runTest(filterName: "first", input: ["a", "b", "c"], expected: "a")
 567 |         try runTest(filterName: "first", input: [], expected: UndefinedValue())
 568 | 
 569 |         // Test float
 570 |         try runTest(filterName: "float", input: 42, expected: 42.0)
 571 |         try runTest(filterName: "float", input: 42.5, expected: 42.5)
 572 |         try runTest(filterName: "float", input: "42", expected: 0.0)
 573 |         try runTest(filterName: "float", input: "42.5", expected: 0.0)
 574 | 
 575 |         // Test forceescape
 576 |         try runTest(filterName: "forceescape", input: "<foo>", expected: "&lt;foo&gt;")
 577 |         try runTest(filterName: "forceescape", input: "foo & bar", expected: "foo &amp; bar")
 578 | 
 579 |         // Test format
 580 |         try runTest(filterName: "format", input: "%s %s", args: ["Hello", "World"], expected: "Hello World")
 581 |         try runTest(filterName: "format", input: "%d", args: [123], expected: "123")
 582 | 
 583 |         // TODO: Test groupby
 584 | 
 585 |         // Test indent
 586 |         try runTest(
 587 |             filterName: "indent",
 588 |             input: "Hello\nWorld",
 589 |             expected: "Hello\n    World"
 590 |         )  // Default: width=4, first=false, blank=false
 591 |         try runTest(
 592 |             filterName: "indent",
 593 |             input: "Hello\nWorld",
 594 |             args: [2],
 595 |             expected: "Hello\n  World"
 596 |         )  // width=2
 597 |         try runTest(
 598 |             filterName: "indent",
 599 |             input: "Hello\nWorld",
 600 |             args: [4, true],
 601 |             expected: "    Hello\n    World"
 602 |         )  // first=true
 603 |         try runTest(
 604 |             filterName: "indent",
 605 |             input: "\nfoo bar\n\"baz\"\n",
 606 |             args: [2, false, false],
 607 |             expected: "\n  foo bar\n  \"baz\"\n"
 608 |         )  // blank=false
 609 |         try runTest(
 610 |             filterName: "indent",
 611 |             input: "\nfoo bar\n\"baz\"\n",
 612 |             args: [2, false, true],
 613 |             expected: "\n  foo bar\n  \"baz\"\n  "
 614 |         )  // blank=true
 615 |         try runTest(
 616 |             filterName: "indent",
 617 |             input: "\nfoo bar\n\"baz\"\n",
 618 |             args: [2, true, false],
 619 |             expected: "  \n  foo bar\n  \"baz\"\n"
 620 |         )  // first=true, blank=false
 621 |         try runTest(
 622 |             filterName: "indent",
 623 |             input: "\nfoo bar\n\"baz\"\n",
 624 |             args: [2, true, true],
 625 |             expected: "  \n  foo bar\n  \"baz\"\n  "
 626 |         )  // first=true, blank=true
 627 |         try runTest(
 628 |             filterName: "indent",
 629 |             input: "jinja",
 630 |             expected: "jinja"
 631 |         )  // Single line, no indent
 632 |         try runTest(
 633 |             filterName: "indent",
 634 |             input: "jinja",
 635 |             args: [4, true],
 636 |             expected: "    jinja"
 637 |         )  // Single line, first=true
 638 |         try runTest(
 639 |             filterName: "indent",
 640 |             input: "jinja",
 641 |             args: [4, false, true],
 642 |             expected: "jinja"
 643 |         )  // Single line, blank=true (no effect)
 644 |         try runTest(
 645 |             filterName: "indent",
 646 |             input: "jinja\nflask",
 647 |             args: [">>> ", true],
 648 |             expected: ">>> jinja\n>>> flask"
 649 |         )  // String width, first=true
 650 | 
 651 |         // Test int
 652 |         try runTest(filterName: "int", input: 42.0, expected: 42)
 653 |         try runTest(filterName: "int", input: 42.5, expected: 42)
 654 |         try runTest(filterName: "int", input: "42", expected: 42)
 655 |         try runTest(filterName: "int", input: "42.5", expected: 42)
 656 | 
 657 |         // Test items
 658 |         // Test with dictionary
 659 |         try runTest(
 660 |             filterName: "items",
 661 |             input: OrderedDictionary<String, Any>(
 662 |                 dictionaryLiteral: ("0", "a"),
 663 |                 ("1", "b"),
 664 |                 ("2", "c")
 665 |             ),
 666 |             expected: [
 667 |                 ("0", "a"),
 668 |                 ("1", "b"),
 669 |                 ("2", "c"),
 670 |             ]
 671 |         )
 672 |         // Test with undefined value
 673 |         try runTest(
 674 |             filterName: "items",
 675 |             input: UndefinedValue(),
 676 |             expected: []
 677 |         )
 678 |         // Test with invalid input (should throw error)
 679 |         XCTAssertThrowsError(
 680 |             try runTest(
 681 |                 filterName: "items",
 682 |                 input: [1, 2, 3],  // Array instead of mapping
 683 |                 expected: []
 684 |             )
 685 |         ) { error in
 686 |             XCTAssertEqual(
 687 |                 error as? JinjaError,
 688 |                 .runtime("Can only get item pairs from a mapping.")
 689 |             )
 690 |         }
 691 | 
 692 |         // Test join
 693 |         try runTest(filterName: "join", input: [1, 2, 3], expected: "123")
 694 |         try runTest(filterName: "join", input: [1, 2, 3], args: [","], expected: "1,2,3")
 695 |         try runTest(filterName: "join", input: ["a", "b", "c"], args: ["-"], expected: "a-b-c")
 696 | 
 697 |         // Test last
 698 |         try runTest(filterName: "last", input: [1, 2, 3], expected: 3)
 699 |         try runTest(filterName: "last", input: ["a", "b", "c"], expected: "c")
 700 |         try runTest(filterName: "last", input: [], expected: UndefinedValue())
 701 | 
 702 |         // Test length
 703 |         try runTest(filterName: "length", input: "Hello", expected: 5)
 704 |         try runTest(filterName: "length", input: [1, 2, 3], expected: 3)
 705 |         try runTest(filterName: "length", input: ["name": "John", "age": 30], expected: 2)
 706 | 
 707 |         // Test list
 708 |         try runTest(filterName: "list", input: [1, 2, 3], expected: [1, 2, 3])
 709 |         try runTest(filterName: "list", input: ["a", "b", "c"], expected: ["a", "b", "c"])
 710 | 
 711 |         // Test lower
 712 |         try runTest(filterName: "lower", input: "FOO", expected: "foo")
 713 |         try runTest(filterName: "lower", input: "Foo", expected: "foo")
 714 | 
 715 |         // Test map
 716 |         // Test simple map with int conversion
 717 |         try runTest(
 718 |             filterName: "map",
 719 |             input: ["1", "2", "3"],
 720 |             args: [StringValue(value: "int")],
 721 |             expected: [1, 2, 3]
 722 |         )
 723 | 
 724 |         // TODO: Test `map` with `sum` (currently failing, may require changes to `map` or `sum`)
 725 |         //      try runFilterTest(
 726 |         //        filterName: "map",
 727 |         //        input: [[1, 2], [3], [4, 5, 6]],
 728 |         //        args: [StringValue(value: "sum")],
 729 |         //        expected: [3, 3, 15]
 730 |         //      )
 731 | 
 732 |         // Test attribute map
 733 |         try runTest(
 734 |             filterName: "map",
 735 |             input: [
 736 |                 ["username": "john"],
 737 |                 ["username": "jane"],
 738 |                 ["username": "mike"],
 739 |             ],
 740 |             args: [
 741 |                 ObjectValue(value: [
 742 |                     "attribute": StringValue(value: "username")
 743 |                 ])
 744 |             ],
 745 |             expected: ["john", "jane", "mike"]
 746 |         )
 747 | 
 748 |         // Test map with default value
 749 |         try runTest(
 750 |             filterName: "map",
 751 |             input: [
 752 |                 ["firstname": "john", "lastname": "lennon"],
 753 |                 ["firstname": "jane", "lastname": "edwards"],
 754 |                 ["firstname": "jon", "lastname": UndefinedValue()],
 755 |                 ["firstname": "mike"],
 756 |             ],
 757 |             args: [
 758 |                 ObjectValue(value: [
 759 |                     "attribute": StringValue(value: "lastname"),
 760 |                     "default": StringValue(value: "smith"),
 761 |                 ])
 762 |             ],
 763 |             expected: ["lennon", "edwards", "None", "smith"]
 764 |         )
 765 | 
 766 |         // Test map with list default value
 767 |         try runTest(
 768 |             filterName: "map",
 769 |             input: [
 770 |                 ["firstname": "john", "lastname": "lennon"],
 771 |                 ["firstname": "jane", "lastname": "edwards"],
 772 |                 ["firstname": "jon", "lastname": UndefinedValue()],
 773 |                 ["firstname": "mike"],
 774 |             ],
 775 |             args: [
 776 |                 ObjectValue(value: [
 777 |                     "attribute": StringValue(value: "lastname"),
 778 |                     "default": ArrayValue(value: [
 779 |                         StringValue(value: "smith"),
 780 |                         StringValue(value: "x"),
 781 |                     ]),
 782 |                 ])
 783 |             ],
 784 |             expected: ["lennon", "edwards", "None", ["smith", "x"]]
 785 |         )
 786 | 
 787 |         // Test map with empty string default value
 788 |         try runTest(
 789 |             filterName: "map",
 790 |             input: [
 791 |                 ["firstname": "john", "lastname": "lennon"],
 792 |                 ["firstname": "jane", "lastname": "edwards"],
 793 |                 ["firstname": "jon", "lastname": UndefinedValue()],
 794 |                 ["firstname": "mike"],
 795 |             ],
 796 |             args: [
 797 |                 ObjectValue(value: [
 798 |                     "attribute": StringValue(value: "lastname"),
 799 |                     "default": StringValue(value: ""),
 800 |                 ])
 801 |             ],
 802 |             expected: ["lennon", "edwards", "None", ""]
 803 |         )
 804 | 
 805 |         // Test min
 806 |         try runTest(filterName: "min", input: [3, 1, 4, 2], expected: 1)
 807 |         try runTest(filterName: "min", input: ["b", "a", "d", "c"], expected: "a")
 808 |         try runTest(filterName: "min", input: [], expected: UndefinedValue())
 809 | 
 810 |         // Test max
 811 |         try runTest(filterName: "max", input: [3, 1, 4, 2], expected: 4)
 812 |         try runTest(filterName: "max", input: ["b", "a", "d", "c"], expected: "d")
 813 |         try runTest(filterName: "max", input: [], expected: UndefinedValue())
 814 | 
 815 |         // TODO: Figure out how to test "pprint", given that Swift 5.10 doesn't preserve the key order in dictionaries
 816 | 
 817 |         // TODO: Figure out how to test "random" filter
 818 | 
 819 |         // Test reject
 820 |         try runTest(
 821 |             filterName: "reject",
 822 |             input: [1, 2, 3, 4, 5],
 823 |             args: ["even"],
 824 |             expected: [1, 3, 5]
 825 |         )
 826 | 
 827 |         // TODO: Test rejectattr
 828 |         //        try runFilterTest(
 829 |         //            filterName: "rejectattr",
 830 |         //            input: [
 831 |         //                ["name": "John", "admin": true],
 832 |         //                ["name": "Jane", "admin": false],
 833 |         //            ],
 834 |         //            args: ["admin"],
 835 |         //            expected: [
 836 |         //                ["admin": false, "name": "Jane"]
 837 |         //            ]
 838 |         //        )
 839 | 
 840 |         // Test replace
 841 |         try runTest(
 842 |             filterName: "replace",
 843 |             input: "Hello World",
 844 |             args: ["World", "Jinja"],
 845 |             expected: "Hello Jinja"
 846 |         )
 847 |         try runTest(
 848 |             filterName: "replace",
 849 |             input: "aaaa",
 850 |             args: ["a", "b", 2],
 851 |             expected: "bbbb"
 852 |         )
 853 | 
 854 |         // Test reverse
 855 |         try runTest(filterName: "reverse", input: [1, 2, 3], expected: [3, 2, 1])
 856 |         try runTest(filterName: "reverse", input: ["a", "b", "c"], expected: ["c", "b", "a"])
 857 | 
 858 |         // Test round
 859 |         try runTest(filterName: "round", input: 42.55, expected: 43.0)
 860 |         try runTest(filterName: "round", input: 42.55, args: [1], expected: 42.6)
 861 |         try runTest(filterName: "round", input: 42.55, args: [1, "floor"], expected: 42.5)
 862 |         try runTest(filterName: "round", input: 42.55, args: [1, "ceil"], expected: 42.6)
 863 | 
 864 |         // Test safe
 865 |         try runTest(filterName: "safe", input: "<foo>", expected: "<foo>")
 866 |         try runTest(filterName: "safe", input: "foo & bar", expected: "foo & bar")
 867 | 
 868 |         // Test select
 869 |         try runTest(
 870 |             filterName: "select",
 871 |             input: [1, 2, 3, 4, 5],
 872 |             args: ["even"],
 873 |             expected: [2, 4]
 874 |         )
 875 |         // TODO: Make this test pass
 876 |         //        try runFilterTest(
 877 |         //            filterName: "select",
 878 |         //            input: [
 879 |         //                ["name": "John", "age": 30],
 880 |         //                ["name": "Jane", "age": 25],
 881 |         //            ],
 882 |         //            args: ["even"],
 883 |         //            expected: [["name": "John", "age": 30]]
 884 |         //        )
 885 | 
 886 |         // TODO: Test selectattr
 887 |         //        try runFilterTest(
 888 |         //            filterName: "selectattr",
 889 |         //            input: [
 890 |         //                ["name": "John", "admin": true],
 891 |         //                ["name": "Jane", "admin": false],
 892 |         //            ],
 893 |         //            args: ["admin"],
 894 |         //            expected: [["name": "John", "admin": true]]
 895 |         //        )
 896 |         //        try runFilterTest(
 897 |         //            filterName: "selectattr",
 898 |         //            input: [
 899 |         //                ["name": "John", "age": 30],
 900 |         //                ["name": "Jane", "age": 25],
 901 |         //            ],
 902 |         //            args: ["age", "equalto", 25],
 903 |         //            expected: [["name": "Jane", "age": 25]]
 904 |         //        )
 905 | 
 906 |         // Test slice
 907 |         try runTest(
 908 |             filterName: "slice",
 909 |             input: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
 910 |             args: [3],
 911 |             expected: [[1, 2, 3, 4], [5, 6, 7], [8, 9, 10]]
 912 |         )
 913 |         try runTest(
 914 |             filterName: "slice",
 915 |             input: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
 916 |             args: [3, 0],
 917 |             expected: [[1, 2, 3, 4], [5, 6, 7, 0], [8, 9, 10, 0]]
 918 |         )
 919 | 
 920 |         // Test sort
 921 |         try runTest(filterName: "sort", input: [3, 1, 4, 2], expected: [1, 2, 3, 4])
 922 |         try runTest(filterName: "sort", input: [3, 1, 4, 2], args: [true], expected: [4, 3, 2, 1])
 923 |         try runTest(
 924 |             filterName: "sort",
 925 |             input: ["b", "A", "d", "c"],
 926 |             expected: ["A", "b", "c", "d"]
 927 |         )
 928 |         try runTest(
 929 |             filterName: "sort",
 930 |             input: ["b", "A", "d", "c"],
 931 |             args: [false, true],
 932 |             expected: ["A", "b", "c", "d"]
 933 |         )
 934 |         // TODO: Make these tests pass
 935 |         //        try runFilterTest(
 936 |         //            filterName: "sort",
 937 |         //            input: [
 938 |         //                ["name": "John", "age": 30],
 939 |         //                ["name": "Jane", "age": 25],
 940 |         //            ],
 941 |         //            args: [false, false, "name"],
 942 |         //            expected: [
 943 |         //                ["name": "Jane", "age": 25],
 944 |         //                ["name": "John", "age": 30],
 945 |         //            ]
 946 |         //        )
 947 |         //        try runFilterTest(
 948 |         //            filterName: "sort",
 949 |         //            input: [
 950 |         //                ["name": "John", "age": 30],
 951 |         //                ["name": "Jane", "age": 25],
 952 |         //            ],
 953 |         //            args: [false, false, "age"],
 954 |         //            expected: [
 955 |         //                ["name": "Jane", "age": 25],
 956 |         //                ["name": "John", "age": 30],
 957 |         //            ]
 958 |         //        )
 959 | 
 960 |         // Test string
 961 |         try runTest(filterName: "string", input: 123, expected: "123")
 962 |         try runTest(filterName: "string", input: true, expected: "true")
 963 |         try runTest(filterName: "string", input: [1, 2, 3], expected: "[1, 2, 3]")
 964 |         try runTest(
 965 |             filterName: "string",
 966 |             input: OrderedDictionary<String, Any>(dictionaryLiteral: ("a", 1), ("b", 2)),
 967 |             expected: "{\"a\": 1, \"b\": 2}"
 968 |         )
 969 | 
 970 |         // Test striptags
 971 |         try runTest(
 972 |             filterName: "striptags",
 973 |             input: "<p>Hello, <b>World</b>!</p>",
 974 |             expected: "Hello, World!"
 975 |         )
 976 |         try runTest(
 977 |             filterName: "striptags",
 978 |             input: "<a href=\"#\">Link</a>",
 979 |             expected: "Link"
 980 |         )
 981 | 
 982 |         // Test sum
 983 |         try runTest(filterName: "sum", input: [1, 2, 3, 4, 5], expected: 15)
 984 |         try runTest(
 985 |             filterName: "sum",
 986 |             input: [
 987 |                 ["value": 1],
 988 |                 ["value": 2],
 989 |                 ["value": 3],
 990 |             ],
 991 |             args: ["value"],
 992 |             expected: 6
 993 |         )
 994 |         try runTest(filterName: "sum", input: [1, 2, 3, 4, 5], args: [], expected: 15)
 995 |         // TODO: Make this test pass
 996 |         //        try runFilterTest(filterName: "sum", input: [1, 2, 3, 4, 5], args: ["", 10], expected: 25)
 997 | 
 998 |         // Test title
 999 |         try runTest(filterName: "title", input: "hello world", expected: "Hello World")
1000 |         try runTest(filterName: "title", input: "HELLO WORLD", expected: "Hello World")
1001 | 
1002 |         // Test trim
1003 |         try runTest(filterName: "trim", input: "  hello   ", expected: "hello")
1004 |         try runTest(filterName: "trim", input: "\t  hello \n  ", expected: "hello")
1005 | 
1006 |         // Test truncate
1007 |         try runTest(filterName: "truncate", input: "Hello World", expected: "Hello World")
1008 |         try runTest(filterName: "truncate", input: "Hello World", args: [5], expected: "He...")
1009 |         try runTest(filterName: "truncate", input: "Hello World", args: [5, true], expected: "He...")
1010 |         try runTest(filterName: "truncate", input: "Hello World", args: [5, false], expected: "He...")
1011 |         try runTest(filterName: "truncate", input: "Hello World", args: [5, false, "---"], expected: "He---")
1012 |         try runTest(filterName: "truncate", input: "Hello Big World", args: [10, false], expected: "Hello...")
1013 | 
1014 |         // Test unique
1015 |         try runTest(filterName: "unique", input: [2, 1, 2, 3, 4, 4], expected: [2, 1, 3, 4])
1016 |         try runTest(filterName: "unique", input: ["Foo", "foo", "bar"], expected: ["Foo", "bar"])
1017 |         try runTest(
1018 |             filterName: "unique",
1019 |             input: ["Foo", "foo", "bar"],
1020 |             args: [true],
1021 |             expected: ["Foo", "foo", "bar"]
1022 |         )
1023 |         // TODO: Make these tests pass
1024 |         //        try runFilterTest(
1025 |         //            filterName: "unique",
1026 |         //            input: [
1027 |         //                ["name": "foo", "id": 1],
1028 |         //                ["name": "foo", "id": 2],
1029 |         //                ["name": "bar", "id": 3],
1030 |         //            ],
1031 |         //            args: [false, "name"],
1032 |         //            expected: [["name": "foo", "id": 1], ["name": "bar", "id": 3]]
1033 |         //        )
1034 |         //        try runFilterTest(
1035 |         //            filterName: "unique",
1036 |         //            input: [
1037 |         //                ["name": "foo", "id": 1],
1038 |         //                ["name": "foo", "id": 2],
1039 |         //                ["name": "bar", "id": 3],
1040 |         //            ],
1041 |         //            args: [false, "id"],
1042 |         //            expected: [["name": "foo", "id": 1], ["name": "bar", "id": 3]]
1043 |         //        )
1044 |         try runTest(
1045 |             filterName: "unique",
1046 |             input: "abcba",
1047 |             expected: ["a", "b", "c"]
1048 |         )
1049 |         try runTest(  //XCTAssertEqual failed: ("["a"]") is not equal to ("["a", "b", "c"]") - unique filter failed
1050 |             filterName: "unique",
1051 |             input: "abcba",
1052 |             args: [false, 0],
1053 |             expected: ["a", "b", "c"]
1054 |         )
1055 | 
1056 |         // Test upper
1057 |         try runTest(filterName: "upper", input: "foo", expected: "FOO")
1058 |         try runTest(filterName: "upper", input: "Foo", expected: "FOO")
1059 | 
1060 |         // TODO: Test urlencode
1061 | 
1062 |         // Test urlize
1063 |         try runTest(
1064 |             filterName: "urlize",
1065 |             input: "http://www.example.com/",
1066 |             expected: "<a href=\"http://www.example.com/\">http://www.example.com/</a>"
1067 |         )
1068 |         try runTest(
1069 |             filterName: "urlize",
1070 |             input: "www.example.com",
1071 |             expected: "<a href=\"www.example.com\">www.example.com</a>"
1072 |         )
1073 |         try runTest(
1074 |             filterName: "urlize",
1075 |             input: "http://www.example.com/",
1076 |             args: [10],
1077 |             expected: "<a href=\"http://www.example.com/\">http://www...</a>"
1078 |         )
1079 |         try runTest(
1080 |             filterName: "urlize",
1081 |             input: "http://www.example.com/",
1082 |             args: [10, true],
1083 |             expected: "<a href=\"http://www.example.com/\" rel=\"nofollow\">http://www...</a>"
1084 |         )
1085 |         // TODO: Make this test pass
1086 |         //        try runFilterTest(
1087 |         //            filterName: "urlize",
1088 |         //            input: "http://www.example.com/",
1089 |         //            args: [10, true, "_blank"],
1090 |         //            expected: "<a href=\"http://www.example.com/\" target=\"_blank\" rel=\"nofollow\">http://www...</a>"
1091 |         //        )
1092 | 
1093 |         // Test wordcount
1094 |         try runTest(filterName: "wordcount", input: "foo bar baz", expected: 3)
1095 |         try runTest(filterName: "wordcount", input: "foo  bar baz", expected: 3)
1096 | 
1097 |         // TODO: Test wordwrap
1098 | 
1099 |         // TODO: Test xmlattr
1100 | 
1101 |         // TODO: Fix key order in results using OrderedDictionary as input
1102 |         // Test tojson
1103 |         //        try runFilterTest(
1104 |         //            filterName: "tojson",
1105 |         //            input: ["foo": 42, "bar": 23],
1106 |         //            expected: "{\n  \"foo\": 42,\n  \"bar\": 23\n}"
1107 |         //        )
1108 |         //        try runFilterTest(
1109 |         //            filterName: "tojson",
1110 |         //            input: ["foo": 42, "bar": 23],
1111 |         //            args: [["indent": 4]],
1112 |         //            expected: "{\n    \"foo\": 42,\n    \"bar\": 23\n}"
1113 |         //        )
1114 |     }
1115 | }
1116 | 


--------------------------------------------------------------------------------
/Tests/InterpreterTests.swift:
--------------------------------------------------------------------------------
  1 | //
  2 | //  InterpreterTests.swift
  3 | //
  4 | //
  5 | //  Created by John Mai on 2024/3/23.
  6 | //
  7 | 
  8 | import XCTest
  9 | 
 10 | @testable import Jinja
 11 | 
 12 | let exampleIfTemplate = "<div>\n    {% if True %}\n        yay\n    {% endif %}\n</div>"
 13 | 
 14 | let exampleForTemplate = "{% for item in seq %}\n    {{ item }}\n{% endfor %}"
 15 | let exampleForTemplate2 = "{% for item in seq -%}\n    {{ item }}\n{% endfor %}"
 16 | let exampleForTemplate3 = "{% for item in seq %}\n    {{ item }}\n{%- endfor %}"
 17 | let exampleForTemplate4 = "{% for item in seq -%}\n    {{ item }}\n{%- endfor %}"
 18 | 
 19 | let exampleCommentTemplate = "    {# comment #}\n  {# {% if true %} {% endif %} #}\n"
 20 | 
 21 | let seq = [1, 2, 3, 4, 5, 6, 7, 8, 9]
 22 | 
 23 | final class InterpreterTests: XCTestCase {
 24 |     struct Test {
 25 |         let template: String
 26 |         let data: [String: Any]
 27 |         var options: PreprocessOptions = .init()
 28 |         let target: String
 29 |     }
 30 | 
 31 |     let tests: [Test] = [
 32 |         Test(
 33 |             template: exampleIfTemplate,
 34 |             data: [:],
 35 |             target: "<div>\n    \n        yay\n    \n</div>"
 36 |         ),
 37 |         Test(
 38 |             template: exampleIfTemplate,
 39 |             data: [:],
 40 |             options: .init(lstripBlocks: true),
 41 |             target: "<div>\n\n        yay\n\n</div>"
 42 |         ),
 43 |         Test(
 44 |             template: exampleIfTemplate,
 45 |             data: [:],
 46 |             options: .init(trimBlocks: true),
 47 |             target: "<div>\n            yay\n    </div>"
 48 |         ),
 49 |         Test(
 50 |             template: exampleIfTemplate,
 51 |             data: [:],
 52 |             options: .init(trimBlocks: true, lstripBlocks: true),
 53 |             target: "<div>\n        yay\n</div>"
 54 |         ),
 55 |         Test(
 56 |             template: exampleForTemplate,
 57 |             data: [
 58 |                 "seq": seq
 59 |             ],
 60 |             target: "\n    1\n\n    2\n\n    3\n\n    4\n\n    5\n\n    6\n\n    7\n\n    8\n\n    9\n"
 61 |         ),
 62 |         Test(
 63 |             template: exampleForTemplate,
 64 |             data: [
 65 |                 "seq": seq
 66 |             ],
 67 |             options: .init(lstripBlocks: true),
 68 |             target: "\n    1\n\n    2\n\n    3\n\n    4\n\n    5\n\n    6\n\n    7\n\n    8\n\n    9\n"
 69 |         ),
 70 |         Test(
 71 |             template: exampleForTemplate,
 72 |             data: [
 73 |                 "seq": seq
 74 |             ],
 75 |             options: .init(trimBlocks: true),
 76 |             target: "    1\n    2\n    3\n    4\n    5\n    6\n    7\n    8\n    9\n"
 77 |         ),
 78 |         Test(
 79 |             template: exampleForTemplate,
 80 |             data: [
 81 |                 "seq": seq
 82 |             ],
 83 |             options: .init(trimBlocks: true, lstripBlocks: true),
 84 |             target: "    1\n    2\n    3\n    4\n    5\n    6\n    7\n    8\n    9\n"
 85 |         ),
 86 |         Test(
 87 |             template: exampleForTemplate2,
 88 |             data: [
 89 |                 "seq": seq
 90 |             ],
 91 |             target: "1\n2\n3\n4\n5\n6\n7\n8\n9\n"
 92 |         ),
 93 |         Test(
 94 |             template: exampleForTemplate3,
 95 |             data: [
 96 |                 "seq": seq
 97 |             ],
 98 |             target: "\n    1\n    2\n    3\n    4\n    5\n    6\n    7\n    8\n    9"
 99 |         ),
100 |         Test(
101 |             template: exampleForTemplate3,
102 |             data: [
103 |                 "seq": seq
104 |             ],
105 |             options: .init(trimBlocks: true),
106 |             target: "    1    2    3    4    5    6    7    8    9"
107 |         ),
108 |         Test(
109 |             template: exampleForTemplate4,
110 |             data: [
111 |                 "seq": seq
112 |             ],
113 |             target: "123456789"
114 |         ),
115 |         Test(
116 |             template: exampleCommentTemplate,
117 |             data: [:],
118 |             target: "    \n  "
119 |         ),
120 |         Test(
121 |             template: exampleCommentTemplate,
122 |             data: [:],
123 |             options: .init(lstripBlocks: true),
124 |             target: "\n"
125 |         ),
126 |         Test(
127 |             template: exampleCommentTemplate,
128 |             data: [:],
129 |             options: .init(trimBlocks: true),
130 |             target: "      "
131 |         ),
132 |         Test(
133 |             template: exampleCommentTemplate,
134 |             data: [:],
135 |             options: .init(trimBlocks: true, lstripBlocks: true),
136 |             target: ""
137 |         ),
138 |     ]
139 | 
140 |     func testRender() throws {
141 |         for test in tests {
142 |             let env = Environment()
143 |             try env.set(name: "True", value: true)
144 |             for (key, value) in test.data {
145 |                 try env.set(name: key, value: value)
146 |             }
147 |             let tokens = try tokenize(test.template, options: test.options)
148 |             let parsed = try parse(tokens: tokens)
149 |             let interpreter = Interpreter(env: env)
150 |             let result = try interpreter.run(program: parsed)
151 |             if let stringResult = result as? StringValue {
152 |                 XCTAssertEqual(stringResult.value.debugDescription, test.target.debugDescription)
153 |             } else {
154 |                 XCTFail("Expected a StringValue, but got \(type(of: result))")
155 |             }
156 |         }
157 |     }
158 | }
159 | 


--------------------------------------------------------------------------------
/Tests/LexerTests.swift:
--------------------------------------------------------------------------------
   1 | //
   2 | //  LexerTests.swift
   3 | //
   4 | //
   5 | //  Created by John Mai on 2024/3/20.
   6 | //
   7 | 
   8 | import XCTest
   9 | 
  10 | @testable import Jinja
  11 | 
  12 | final class LexerTests: XCTestCase {
  13 |     let testStrings: [String: String] = [
  14 |         // Text nodes
  15 |         "NO_TEMPLATE": "Hello world!",
  16 |         "TEXT_NODES": "0{{ 'A' }}1{{ 'B' }}{{ 'C' }}2{{ 'D' }}3",
  17 | 
  18 |         // Logical operators
  19 |         "LOGICAL_AND": "{{ true and true }}{{ true and false }}{{ false and true }}{{ false and false }}",
  20 |         "LOGICAL_OR": "{{ true or true }}{{ true or false }}{{ false or true }}{{ false or false }}",
  21 |         "LOGICAL_NOT": "{{ not true }}{{ not false }}",
  22 |         "LOGICAL_NOT_NOT": "{{ not not true }}{{ not not false }}",
  23 |         "LOGICAL_AND_OR":
  24 |             "{{ true and true or false }}{{ true and false or true }}{{ false and true or true }}{{ false and false or true }}{{ false and false or false }}",
  25 |         "LOGICAL_AND_NOT":
  26 |             "{{ true and not true }}{{ true and not false }}{{ false and not true }}{{ false and not false }}",
  27 |         "LOGICAL_OR_NOT":
  28 |             "{{ true or not true }}{{ true or not false }}{{ false or not true }}{{ false or not false }}",
  29 |         "LOGICAL_COMBINED": "{{ 1 == 2 and 2 == 2 }}{{ 1 == 2 or 2 == 2}}",
  30 | 
  31 |         // If statements
  32 |         "IF_ONLY": "{% if 1 == 1 %}{{ 'A' }}{% endif %}{{ 'B' }}",
  33 |         "IF_ELSE_ONLY": "{% if 1 == 2 %}{{ 'A' }}{% else %}{{ 'B' }}{% endif %}{{ 'C' }}",
  34 |         "IF_ELIF_ELSE":
  35 |             "{% if 1 == 2 %}{{ 'A' }}{{ 'B' }}{{ 'C' }}{% elif 1 == 2 %}{{ 'D' }}{% elif 1 == 3 %}{{ 'E' }}{{ 'F' }}{% else %}{{ 'G' }}{{ 'H' }}{{ 'I' }}{% endif %}{{ 'J' }}",
  36 |         "NESTED_STATEMENTS":
  37 |             "{% set a = 0 %}{% set b = 0 %}{% set c = 0 %}{% set d = 0 %}{% if 1 == 1 %}{% set a = 2 %}{% set b = 3 %}{% elif 1 == 2 %}{% set c = 4 %}{% else %}{% set d = 5 %}{% endif %}{{ a }}{{ b }}{{ c }}{{ d }}",
  38 | 
  39 |         // For loops
  40 |         "FOR_LOOP": "{% for message in messages %}{{ message['content'] }}{% endfor %}",
  41 |         "FOR_LOOP_UNPACKING": "|{% for x, y in [ [1, 2], [3, 4] ] %}|{{ x + ' ' + y }}|{% endfor %}|",
  42 | 
  43 |         // Set variables
  44 |         "VARIABLES": "{% set x = 'Hello' %}{% set y = 'World' %}{{ x + ' ' + y }}",
  45 | 
  46 |         // Numbers
  47 |         "NUMBERS": "|{{ 5 }}|{{ -5 }}|{{ add(3, -1) }}|{{ (3 - 1) + (a - 5) - (a + 5)}}|",
  48 | 
  49 |         // Binary expressions
  50 |         "BINOP_EXPR": "{{ 1 % 2 }}{{ 1 < 2 }}{{ 1 > 2 }}{{ 1 >= 2 }}{{ 2 <= 2 }}{{ 2 == 2 }}{{ 2 != 3 }}{{ 2 + 3 }}",
  51 | 
  52 |         // Strings
  53 |         "STRINGS": "{{ 'Bye' }}{{ bos_token + '[INST] ' }}",
  54 |         "STRINGS_1": "|{{ \"test\" }}|{{ \"a\" + 'b' + \"c\" }}|{{ '\"' + \"'\" }}|{{ '\\'' }}|{{ \"\\\"\" }}|",
  55 |         "STRINGS_2": "|{{ \"\" | length }}|{{ \"a\" | length }}|{{ '' | length }}|{{ 'a' | length }}|",
  56 | 
  57 |         // Function calls
  58 |         "FUNCTIONS": "{{ func() }}{{ func(apple) }}{{ func(x, 'test', 2, false) }}",
  59 | 
  60 |         // Object properties
  61 |         "PROPERTIES": "{{ obj.x + obj.y }}{{ obj['x'] + obj.y }}",
  62 | 
  63 |         // Object methods
  64 |         "OBJ_METHODS": "{{ obj.x(x, y) }}{{ ' ' + obj.x() + ' ' }}{{ obj.z[x](x, y) }}",
  65 |         "STRING_METHODS":
  66 |             "{{ '  A  '.strip() }}{% set x = '  B  ' %}{{ x.strip() }}{% set y = ' aBcD ' %}{{ y.upper() }}{{ y.lower() }}",
  67 |         "STRING_METHODS_2": "{{ 'test test'.title() }}",
  68 | 
  69 |         // String indexing and slicing
  70 |         "STRING_SLICING": "|{{ x[0] }}|{{ x[:] }}|{{ x[:3] }}|{{ x[1:4] }}|{{ x[1:-1] }}|{{ x[1::2] }}|{{ x[5::-1] }}|",
  71 | 
  72 |         // Array indexing and slicing
  73 |         "ARRAY_SLICING":
  74 |             "|{{ strings[0] }}|{% for s in strings[:] %}{{ s }}{% endfor %}|{% for s in strings[:3] %}{{ s }}{% endfor %}|{% for s in strings[1:4] %}{{ s }}{% endfor %}|{% for s in strings[1:-1] %}{{ s }}{% endfor %}|{% for s in strings[1::2] %}{{ s }}{% endfor %}|{% for s in strings[5::-1] %}{{ s }}{% endfor %}|",
  75 | 
  76 |         // Membership operators
  77 |         "MEMBERSHIP":
  78 |             "|{{ 0 in arr }}|{{ 1 in arr }}|{{ true in arr }}|{{ false in arr }}|{{ 'a' in arr }}|{{ 'b' in arr }}|",
  79 |         "MEMBERSHIP_NEGATION_1":
  80 |             "|{{ not 0 in arr }}|{{ not 1 in arr }}|{{ not true in arr }}|{{ not false in arr }}|{{ not 'a' in arr }}|{{ not 'b' in arr }}|",
  81 |         "MEMBERSHIP_NEGATION_2":
  82 |             "|{{ 0 not in arr }}|{{ 1 not in arr }}|{{ true not in arr }}|{{ false not in arr }}|{{ 'a' not in arr }}|{{ 'b' not in arr }}|",
  83 | 
  84 |         // Escaped characters
  85 |         "ESCAPED_CHARS": "{{ '\\n' }}{{ '\\t' }}{{ '\\'' }}{{ '\\\"' }}{{ '\\\\' }}{{ '|\\n|\\t|\\'|\\\"|\\\\|' }}",
  86 | 
  87 |         // Substring inclusion
  88 |         "SUBSTRING_INCLUSION":
  89 |             "|{{ '' in 'abc' }}|{{ 'a' in 'abc' }}|{{ 'd' in 'abc' }}|{{ 'ab' in 'abc' }}|{{ 'ac' in 'abc' }}|{{ 'abc' in 'abc' }}|{{ 'abcd' in 'abc' }}|",
  90 | 
  91 |         // Filter operator
  92 |         "FILTER_OPERATOR": "{{ arr | length }}{{ 1 + arr | length }}{{ 2 + arr | sort | length }}{{ (arr | sort)[0] }}",
  93 |         "FILTER_OPERATOR_2":
  94 |             "|{{ 'abc' | length }}|{{ 'aBcD' | upper }}|{{ 'aBcD' | lower }}|{{ 'test test' | capitalize}}|{{ 'test test' | title }}|{{ ' a b ' | trim }}|{{ '  A  B  ' | trim | lower | length }}|",
  95 |         "FILTER_OPERATOR_3": "|{{ -1 | abs }}|{{ 1 | abs }}|",
  96 |         "FILTER_OPERATOR_4": "{{ items | selectattr('key') | length }}",
  97 |         "FILTER_OPERATOR_5": "{{ messages | selectattr('role', 'equalto', 'system') | length }}",
  98 |         "FILTER_OPERATOR_6": "|{{ obj | length }}|{{ (obj | items)[1:] | length }}|",
  99 | 
 100 |         // Logical operators between non-Booleans
 101 |         "BOOLEAN_NUMERICAL":
 102 |             "|{{ 1 and 2 }}|{{ 1 and 0 }}|{{ 0 and 1 }}|{{ 0 and 0 }}|{{ 1 or 2 }}|{{ 1 or 0 }}|{{ 0 or 1 }}|{{ 0 or 0 }}|{{ not 1 }}|{{ not 0 }}|",
 103 |         "BOOLEAN_STRINGS":
 104 |             "|{{ 'a' and 'b' }}|{{ 'a' and '' }}|{{ '' and 'a' }}|{{ '' and '' }}|{{ 'a' or 'b' }}|{{ 'a' or '' }}|{{ '' or 'a' }}|{{ '' or '' }}|{{ not 'a' }}|{{ not '' }}|",
 105 |         "BOOLEAN_MIXED":
 106 |             "|{{ true and 1 }}|{{ true and 0 }}|{{ false and 1 }}|{{ false and 0 }}|{{ true or 1 }}|{{ true or 0 }}|{{ false or 1 }}|{{ false or 0 }}|",
 107 |         "BOOLEAN_MIXED_2":
 108 |             "|{{ true and '' }}|{{ true and 'a' }}|{{ false or '' }}|{{ false or 'a' }}|{{ '' and true }}|{{ 'a' and true }}|{{ '' or false }}|{{ 'a' or false }}|",
 109 |         "BOOLEAN_MIXED_IF":
 110 |             "{% if '' %}{{ 'A' }}{% endif %}{% if 'a' %}{{ 'B' }}{% endif %}{% if true and '' %}{{ 'C' }}{% endif %}{% if true and 'a' %}{{ 'D' }}{% endif %}",
 111 | 
 112 |         // Tests (is operator)
 113 |         "IS_OPERATOR":
 114 |             "|{{ unknown_var is defined }}|{{ unknown_var is not defined }}|{{ known_var is defined }}|{{ known_var is not defined }}|",
 115 |         "IS_OPERATOR_2":
 116 |             "|{{ true is true }}|{{ true is not true }}|{{ true is false }}|{{ true is not false }}|{{ true is boolean }}|{{ 1 is boolean }}|",
 117 |         "IS_OPERATOR_3":
 118 |             "|{{ 1 is odd }}|{{ 2 is odd }}|{{ 1 is even }}|{{ 2 is even }}|{{ 2 is number }}|{{ '2' is number }}|{{ 2 is integer }}|{{ '2' is integer }}|",
 119 |         "IS_OPERATOR_4": "|{{ func is callable }}|{{ 2 is callable }}|{{ 1 is iterable }}|{{ 'hello' is iterable }}|",
 120 |         "IS_OPERATOR_5": "|{{ 'a' is lower }}|{{ 'A' is lower }}|{{ 'a' is upper }}|{{ 'A' is upper }}|",
 121 | 
 122 |         // Short-circuit evaluation
 123 |         "SHORT_CIRCUIT": "{{ false and raise_exception('This should not be printed') }}",
 124 |         "SHORT_CIRCUIT_1": "{{ true or raise_exception('This should not be printed') }}",
 125 | 
 126 |         // Namespaces
 127 |         "NAMESPACE": "{% set ns = namespace() %}{% set ns.foo = 'bar' %}{{ ns.foo }}",
 128 |         "NAMESPACE_1": "{% set ns = namespace(default=false) %}{{ ns.default }}",
 129 |         "NAMESPACE_2": "{% set ns = namespace(default=false, number=1+1) %}|{{ ns.default }}|{{ ns.number }}|",
 130 | 
 131 |         // Object operators
 132 |         "OBJECT_OPERATORS":
 133 |             "|{{ 'known' in obj }}|{{ 'known' not in obj }}|{{ 'unknown' in obj }}|{{ 'unknown' not in obj }}|",
 134 |         "OBJECT_OPERATORS_1":
 135 |             "|{{ obj.get('known') }}|{{ obj.get('unknown') is none }}|{{ obj.get('unknown') is defined }}|",
 136 |         "OBJECT_OPERATORS_2": "|{% for x, y in obj.items() %}|{{ x + ' ' + y }}|{% endfor %}|",
 137 | 
 138 |         // Scope
 139 |         "SCOPE":
 140 |             "{% set ns = namespace(found=false) %}{% for num in nums %}{% if num == 1 %}{{ 'found=' }}{% set ns.found = true %}{% endif %}{% endfor %}{{ ns.found }}",
 141 |         "SCOPE_1":
 142 |             "{% set found = false %}{% for num in nums %}{% if num == 1 %}{{ 'found=' }}{% set found = true %}{% endif %}{% endfor %}{{ found }}",
 143 | 
 144 |         // Undefined
 145 |         "UNDEFINED_VARIABLES": "{{ undefined_variable }}",
 146 |         "UNDEFINED_ACCESS": "{{ object.undefined_attribute }}",
 147 | 
 148 |         // Null
 149 |         "NULL_VARIABLE":
 150 |             "{% if not null_val is defined %}{% set null_val = none %}{% endif %}{% if null_val is not none %}{{ 'fail' }}{% else %}{{ 'pass' }}{% endif %}",
 151 | 
 152 |         // Ternary operator
 153 |         "TERNARY_OPERATOR":
 154 |             "|{{ 'a' if true else 'b' }}|{{ 'a' if false else 'b' }}|{{ 'a' if 1 + 1 == 2 else 'b' }}|{{ 'a' if 1 + 1 == 3 or 1 * 2 == 3 else 'b' }}|",
 155 | 
 156 |         // Array literals
 157 |         "ARRAY_LITERALS": "{{ [1, true, 'hello', [1, 2, 3, 4], var] | length }}",
 158 | 
 159 |         // Tuple literals
 160 |         "TUPLE_LITERALS": "{{ (1, (1, 2)) | length }}",
 161 | 
 162 |         // Object literals
 163 |         "OBJECT_LITERALS": "{{ { 'key': 'value', key: 'value2', \"key3\": [1, {'foo': 'bar'} ] }['key'] }}",
 164 | 
 165 |         // Array operators
 166 |         "ARRAY_OPERATORS": "{{ ([1, 2, 3] + [4, 5, 6]) | length }}",
 167 |     ]
 168 | 
 169 |     let testParsed: [String: [Token]] = [
 170 |         "NO_TEMPLATE": [Token(value: "Hello world!", type: .text)],
 171 |         "TEXT_NODES": [
 172 |             Token(value: "0", type: .text),
 173 |             Token(value: "{{", type: .openExpression),
 174 |             Token(value: "A", type: .stringLiteral),
 175 |             Token(value: "}}", type: .closeExpression),
 176 |             Token(value: "1", type: .text),
 177 |             Token(value: "{{", type: .openExpression),
 178 |             Token(value: "B", type: .stringLiteral),
 179 |             Token(value: "}}", type: .closeExpression),
 180 |             Token(value: "{{", type: .openExpression),
 181 |             Token(value: "C", type: .stringLiteral),
 182 |             Token(value: "}}", type: .closeExpression),
 183 |             Token(value: "2", type: .text),
 184 |             Token(value: "{{", type: .openExpression),
 185 |             Token(value: "D", type: .stringLiteral),
 186 |             Token(value: "}}", type: .closeExpression),
 187 |             Token(value: "3", type: .text),
 188 |         ],
 189 | 
 190 |         // Logical operators
 191 |         "LOGICAL_AND": [
 192 |             Token(value: "{{", type: .openExpression),
 193 |             Token(value: "true", type: .booleanLiteral),
 194 |             Token(value: "and", type: .and),
 195 |             Token(value: "true", type: .booleanLiteral),
 196 |             Token(value: "}}", type: .closeExpression),
 197 |             Token(value: "{{", type: .openExpression),
 198 |             Token(value: "true", type: .booleanLiteral),
 199 |             Token(value: "and", type: .and),
 200 |             Token(value: "false", type: .booleanLiteral),
 201 |             Token(value: "}}", type: .closeExpression),
 202 |             Token(value: "{{", type: .openExpression),
 203 |             Token(value: "false", type: .booleanLiteral),
 204 |             Token(value: "and", type: .and),
 205 |             Token(value: "true", type: .booleanLiteral),
 206 |             Token(value: "}}", type: .closeExpression),
 207 |             Token(value: "{{", type: .openExpression),
 208 |             Token(value: "false", type: .booleanLiteral),
 209 |             Token(value: "and", type: .and),
 210 |             Token(value: "false", type: .booleanLiteral),
 211 |             Token(value: "}}", type: .closeExpression),
 212 |         ],
 213 |         "LOGICAL_OR": [
 214 |             Token(value: "{{", type: .openExpression),
 215 |             Token(value: "true", type: .booleanLiteral),
 216 |             Token(value: "or", type: .or),
 217 |             Token(value: "true", type: .booleanLiteral),
 218 |             Token(value: "}}", type: .closeExpression),
 219 |             Token(value: "{{", type: .openExpression),
 220 |             Token(value: "true", type: .booleanLiteral),
 221 |             Token(value: "or", type: .or),
 222 |             Token(value: "false", type: .booleanLiteral),
 223 |             Token(value: "}}", type: .closeExpression),
 224 |             Token(value: "{{", type: .openExpression),
 225 |             Token(value: "false", type: .booleanLiteral),
 226 |             Token(value: "or", type: .or),
 227 |             Token(value: "true", type: .booleanLiteral),
 228 |             Token(value: "}}", type: .closeExpression),
 229 |             Token(value: "{{", type: .openExpression),
 230 |             Token(value: "false", type: .booleanLiteral),
 231 |             Token(value: "or", type: .or),
 232 |             Token(value: "false", type: .booleanLiteral),
 233 |             Token(value: "}}", type: .closeExpression),
 234 |         ],
 235 |         "LOGICAL_NOT": [
 236 |             Token(value: "{{", type: .openExpression),
 237 |             Token(value: "not", type: .not),
 238 |             Token(value: "true", type: .booleanLiteral),
 239 |             Token(value: "}}", type: .closeExpression),
 240 |             Token(value: "{{", type: .openExpression),
 241 |             Token(value: "not", type: .not),
 242 |             Token(value: "false", type: .booleanLiteral),
 243 |             Token(value: "}}", type: .closeExpression),
 244 |         ],
 245 |         "LOGICAL_NOT_NOT": [
 246 |             Token(value: "{{", type: .openExpression),
 247 |             Token(value: "not", type: .not),
 248 |             Token(value: "not", type: .not),
 249 |             Token(value: "true", type: .booleanLiteral),
 250 |             Token(value: "}}", type: .closeExpression),
 251 |             Token(value: "{{", type: .openExpression),
 252 |             Token(value: "not", type: .not),
 253 |             Token(value: "not", type: .not),
 254 |             Token(value: "false", type: .booleanLiteral),
 255 |             Token(value: "}}", type: .closeExpression),
 256 |         ],
 257 |         "LOGICAL_AND_OR": [
 258 |             Token(value: "{{", type: .openExpression),
 259 |             Token(value: "true", type: .booleanLiteral),
 260 |             Token(value: "and", type: .and),
 261 |             Token(value: "true", type: .booleanLiteral),
 262 |             Token(value: "or", type: .or),
 263 |             Token(value: "false", type: .booleanLiteral),
 264 |             Token(value: "}}", type: .closeExpression),
 265 |             Token(value: "{{", type: .openExpression),
 266 |             Token(value: "true", type: .booleanLiteral),
 267 |             Token(value: "and", type: .and),
 268 |             Token(value: "false", type: .booleanLiteral),
 269 |             Token(value: "or", type: .or),
 270 |             Token(value: "true", type: .booleanLiteral),
 271 |             Token(value: "}}", type: .closeExpression),
 272 |             Token(value: "{{", type: .openExpression),
 273 |             Token(value: "false", type: .booleanLiteral),
 274 |             Token(value: "and", type: .and),
 275 |             Token(value: "true", type: .booleanLiteral),
 276 |             Token(value: "or", type: .or),
 277 |             Token(value: "true", type: .booleanLiteral),
 278 |             Token(value: "}}", type: .closeExpression),
 279 |             Token(value: "{{", type: .openExpression),
 280 |             Token(value: "false", type: .booleanLiteral),
 281 |             Token(value: "and", type: .and),
 282 |             Token(value: "false", type: .booleanLiteral),
 283 |             Token(value: "or", type: .or),
 284 |             Token(value: "true", type: .booleanLiteral),
 285 |             Token(value: "}}", type: .closeExpression),
 286 |             Token(value: "{{", type: .openExpression),
 287 |             Token(value: "false", type: .booleanLiteral),
 288 |             Token(value: "and", type: .and),
 289 |             Token(value: "false", type: .booleanLiteral),
 290 |             Token(value: "or", type: .or),
 291 |             Token(value: "false", type: .booleanLiteral),
 292 |             Token(value: "}}", type: .closeExpression),
 293 |         ],
 294 |         "LOGICAL_AND_NOT": [
 295 |             Token(value: "{{", type: .openExpression),
 296 |             Token(value: "true", type: .booleanLiteral),
 297 |             Token(value: "and", type: .and),
 298 |             Token(value: "not", type: .not),
 299 |             Token(value: "true", type: .booleanLiteral),
 300 |             Token(value: "}}", type: .closeExpression),
 301 |             Token(value: "{{", type: .openExpression),
 302 |             Token(value: "true", type: .booleanLiteral),
 303 |             Token(value: "and", type: .and),
 304 |             Token(value: "not", type: .not),
 305 |             Token(value: "false", type: .booleanLiteral),
 306 |             Token(value: "}}", type: .closeExpression),
 307 |             Token(value: "{{", type: .openExpression),
 308 |             Token(value: "false", type: .booleanLiteral),
 309 |             Token(value: "and", type: .and),
 310 |             Token(value: "not", type: .not),
 311 |             Token(value: "true", type: .booleanLiteral),
 312 |             Token(value: "}}", type: .closeExpression),
 313 |             Token(value: "{{", type: .openExpression),
 314 |             Token(value: "false", type: .booleanLiteral),
 315 |             Token(value: "and", type: .and),
 316 |             Token(value: "not", type: .not),
 317 |             Token(value: "false", type: .booleanLiteral),
 318 |             Token(value: "}}", type: .closeExpression),
 319 |         ],
 320 |         "LOGICAL_OR_NOT": [
 321 |             Token(value: "{{", type: .openExpression),
 322 |             Token(value: "true", type: .booleanLiteral),
 323 |             Token(value: "or", type: .or),
 324 |             Token(value: "not", type: .not),
 325 |             Token(value: "true", type: .booleanLiteral),
 326 |             Token(value: "}}", type: .closeExpression),
 327 |             Token(value: "{{", type: .openExpression),
 328 |             Token(value: "true", type: .booleanLiteral),
 329 |             Token(value: "or", type: .or),
 330 |             Token(value: "not", type: .not),
 331 |             Token(value: "false", type: .booleanLiteral),
 332 |             Token(value: "}}", type: .closeExpression),
 333 |             Token(value: "{{", type: .openExpression),
 334 |             Token(value: "false", type: .booleanLiteral),
 335 |             Token(value: "or", type: .or),
 336 |             Token(value: "not", type: .not),
 337 |             Token(value: "true", type: .booleanLiteral),
 338 |             Token(value: "}}", type: .closeExpression),
 339 |             Token(value: "{{", type: .openExpression),
 340 |             Token(value: "false", type: .booleanLiteral),
 341 |             Token(value: "or", type: .or),
 342 |             Token(value: "not", type: .not),
 343 |             Token(value: "false", type: .booleanLiteral),
 344 |             Token(value: "}}", type: .closeExpression),
 345 |         ],
 346 |         "LOGICAL_COMBINED": [
 347 |             Token(value: "{{", type: .openExpression),
 348 |             Token(value: "1", type: .numericLiteral),
 349 |             Token(value: "==", type: .comparisonBinaryOperator),
 350 |             Token(value: "2", type: .numericLiteral),
 351 |             Token(value: "and", type: .and),
 352 |             Token(value: "2", type: .numericLiteral),
 353 |             Token(value: "==", type: .comparisonBinaryOperator),
 354 |             Token(value: "2", type: .numericLiteral),
 355 |             Token(value: "}}", type: .closeExpression),
 356 |             Token(value: "{{", type: .openExpression),
 357 |             Token(value: "1", type: .numericLiteral),
 358 |             Token(value: "==", type: .comparisonBinaryOperator),
 359 |             Token(value: "2", type: .numericLiteral),
 360 |             Token(value: "or", type: .or),
 361 |             Token(value: "2", type: .numericLiteral),
 362 |             Token(value: "==", type: .comparisonBinaryOperator),
 363 |             Token(value: "2", type: .numericLiteral),
 364 |             Token(value: "}}", type: .closeExpression),
 365 |         ],
 366 | 
 367 |         // If statements
 368 |         "IF_ONLY": [
 369 |             Token(value: "{%", type: .openStatement),
 370 |             Token(value: "if", type: .if),
 371 |             Token(value: "1", type: .numericLiteral),
 372 |             Token(value: "==", type: .comparisonBinaryOperator),
 373 |             Token(value: "1", type: .numericLiteral),
 374 |             Token(value: "%}", type: .closeStatement),
 375 |             Token(value: "{{", type: .openExpression),
 376 |             Token(value: "A", type: .stringLiteral),
 377 |             Token(value: "}}", type: .closeExpression),
 378 |             Token(value: "{%", type: .openStatement),
 379 |             Token(value: "endif", type: .endIf),
 380 |             Token(value: "%}", type: .closeStatement),
 381 |             Token(value: "{{", type: .openExpression),
 382 |             Token(value: "B", type: .stringLiteral),
 383 |             Token(value: "}}", type: .closeExpression),
 384 |         ],
 385 |         "IF_ELSE_ONLY": [
 386 |             Token(value: "{%", type: .openStatement),
 387 |             Token(value: "if", type: .if),
 388 |             Token(value: "1", type: .numericLiteral),
 389 |             Token(value: "==", type: .comparisonBinaryOperator),
 390 |             Token(value: "2", type: .numericLiteral),
 391 |             Token(value: "%}", type: .closeStatement),
 392 |             Token(value: "{{", type: .openExpression),
 393 |             Token(value: "A", type: .stringLiteral),
 394 |             Token(value: "}}", type: .closeExpression),
 395 |             Token(value: "{%", type: .openStatement),
 396 |             Token(value: "else", type: .else),
 397 |             Token(value: "%}", type: .closeStatement),
 398 |             Token(value: "{{", type: .openExpression),
 399 |             Token(value: "B", type: .stringLiteral),
 400 |             Token(value: "}}", type: .closeExpression),
 401 |             Token(value: "{%", type: .openStatement),
 402 |             Token(value: "endif", type: .endIf),
 403 |             Token(value: "%}", type: .closeStatement),
 404 |             Token(value: "{{", type: .openExpression),
 405 |             Token(value: "C", type: .stringLiteral),
 406 |             Token(value: "}}", type: .closeExpression),
 407 |         ],
 408 |         "IF_ELIF_ELSE": [
 409 |             Token(value: "{%", type: .openStatement),
 410 |             Token(value: "if", type: .if),
 411 |             Token(value: "1", type: .numericLiteral),
 412 |             Token(value: "==", type: .comparisonBinaryOperator),
 413 |             Token(value: "2", type: .numericLiteral),
 414 |             Token(value: "%}", type: .closeStatement),
 415 |             Token(value: "{{", type: .openExpression),
 416 |             Token(value: "A", type: .stringLiteral),
 417 |             Token(value: "}}", type: .closeExpression),
 418 |             Token(value: "{{", type: .openExpression),
 419 |             Token(value: "B", type: .stringLiteral),
 420 |             Token(value: "}}", type: .closeExpression),
 421 |             Token(value: "{{", type: .openExpression),
 422 |             Token(value: "C", type: .stringLiteral),
 423 |             Token(value: "}}", type: .closeExpression),
 424 |             Token(value: "{%", type: .openStatement),
 425 |             Token(value: "elif", type: .elseIf),
 426 |             Token(value: "1", type: .numericLiteral),
 427 |             Token(value: "==", type: .comparisonBinaryOperator),
 428 |             Token(value: "2", type: .numericLiteral),
 429 |             Token(value: "%}", type: .closeStatement),
 430 |             Token(value: "{{", type: .openExpression),
 431 |             Token(value: "D", type: .stringLiteral),
 432 |             Token(value: "}}", type: .closeExpression),
 433 |             Token(value: "{%", type: .openStatement),
 434 |             Token(value: "elif", type: .elseIf),
 435 |             Token(value: "1", type: .numericLiteral),
 436 |             Token(value: "==", type: .comparisonBinaryOperator),
 437 |             Token(value: "3", type: .numericLiteral),
 438 |             Token(value: "%}", type: .closeStatement),
 439 |             Token(value: "{{", type: .openExpression),
 440 |             Token(value: "E", type: .stringLiteral),
 441 |             Token(value: "}}", type: .closeExpression),
 442 |             Token(value: "{{", type: .openExpression),
 443 |             Token(value: "F", type: .stringLiteral),
 444 |             Token(value: "}}", type: .closeExpression),
 445 |             Token(value: "{%", type: .openStatement),
 446 |             Token(value: "else", type: .else),
 447 |             Token(value: "%}", type: .closeStatement),
 448 |             Token(value: "{{", type: .openExpression),
 449 |             Token(value: "G", type: .stringLiteral),
 450 |             Token(value: "}}", type: .closeExpression),
 451 |             Token(value: "{{", type: .openExpression),
 452 |             Token(value: "H", type: .stringLiteral),
 453 |             Token(value: "}}", type: .closeExpression),
 454 |             Token(value: "{{", type: .openExpression),
 455 |             Token(value: "I", type: .stringLiteral),
 456 |             Token(value: "}}", type: .closeExpression),
 457 |             Token(value: "{%", type: .openStatement),
 458 |             Token(value: "endif", type: .endIf),
 459 |             Token(value: "%}", type: .closeStatement),
 460 |             Token(value: "{{", type: .openExpression),
 461 |             Token(value: "J", type: .stringLiteral),
 462 |             Token(value: "}}", type: .closeExpression),
 463 |         ],
 464 |         "NESTED_STATEMENTS": [
 465 |             Token(value: "{%", type: .openStatement),
 466 |             Token(value: "set", type: .set),
 467 |             Token(value: "a", type: .identifier),
 468 |             Token(value: "=", type: .equals),
 469 |             Token(value: "0", type: .numericLiteral),
 470 |             Token(value: "%}", type: .closeStatement),
 471 |             Token(value: "{%", type: .openStatement),
 472 |             Token(value: "set", type: .set),
 473 |             Token(value: "b", type: .identifier),
 474 |             Token(value: "=", type: .equals),
 475 |             Token(value: "0", type: .numericLiteral),
 476 |             Token(value: "%}", type: .closeStatement),
 477 |             Token(value: "{%", type: .openStatement),
 478 |             Token(value: "set", type: .set),
 479 |             Token(value: "c", type: .identifier),
 480 |             Token(value: "=", type: .equals),
 481 |             Token(value: "0", type: .numericLiteral),
 482 |             Token(value: "%}", type: .closeStatement),
 483 |             Token(value: "{%", type: .openStatement),
 484 |             Token(value: "set", type: .set),
 485 |             Token(value: "d", type: .identifier),
 486 |             Token(value: "=", type: .equals),
 487 |             Token(value: "0", type: .numericLiteral),
 488 |             Token(value: "%}", type: .closeStatement),
 489 |             Token(value: "{%", type: .openStatement),
 490 |             Token(value: "if", type: .if),
 491 |             Token(value: "1", type: .numericLiteral),
 492 |             Token(value: "==", type: .comparisonBinaryOperator),
 493 |             Token(value: "1", type: .numericLiteral),
 494 |             Token(value: "%}", type: .closeStatement),
 495 |             Token(value: "{%", type: .openStatement),
 496 |             Token(value: "set", type: .set),
 497 |             Token(value: "a", type: .identifier),
 498 |             Token(value: "=", type: .equals),
 499 |             Token(value: "2", type: .numericLiteral),
 500 |             Token(value: "%}", type: .closeStatement),
 501 |             Token(value: "{%", type: .openStatement),
 502 |             Token(value: "set", type: .set),
 503 |             Token(value: "b", type: .identifier),
 504 |             Token(value: "=", type: .equals),
 505 |             Token(value: "3", type: .numericLiteral),
 506 |             Token(value: "%}", type: .closeStatement),
 507 |             Token(value: "{%", type: .openStatement),
 508 |             Token(value: "elif", type: .elseIf),
 509 |             Token(value: "1", type: .numericLiteral),
 510 |             Token(value: "==", type: .comparisonBinaryOperator),
 511 |             Token(value: "2", type: .numericLiteral),
 512 |             Token(value: "%}", type: .closeStatement),
 513 |             Token(value: "{%", type: .openStatement),
 514 |             Token(value: "set", type: .set),
 515 |             Token(value: "c", type: .identifier),
 516 |             Token(value: "=", type: .equals),
 517 |             Token(value: "4", type: .numericLiteral),
 518 |             Token(value: "%}", type: .closeStatement),
 519 |             Token(value: "{%", type: .openStatement),
 520 |             Token(value: "else", type: .else),
 521 |             Token(value: "%}", type: .closeStatement),
 522 |             Token(value: "{%", type: .openStatement),
 523 |             Token(value: "set", type: .set),
 524 |             Token(value: "d", type: .identifier),
 525 |             Token(value: "=", type: .equals),
 526 |             Token(value: "5", type: .numericLiteral),
 527 |             Token(value: "%}", type: .closeStatement),
 528 |             Token(value: "{%", type: .openStatement),
 529 |             Token(value: "endif", type: .endIf),
 530 |             Token(value: "%}", type: .closeStatement),
 531 |             Token(value: "{{", type: .openExpression),
 532 |             Token(value: "a", type: .identifier),
 533 |             Token(value: "}}", type: .closeExpression),
 534 |             Token(value: "{{", type: .openExpression),
 535 |             Token(value: "b", type: .identifier),
 536 |             Token(value: "}}", type: .closeExpression),
 537 |             Token(value: "{{", type: .openExpression),
 538 |             Token(value: "c", type: .identifier),
 539 |             Token(value: "}}", type: .closeExpression),
 540 |             Token(value: "{{", type: .openExpression),
 541 |             Token(value: "d", type: .identifier),
 542 |             Token(value: "}}", type: .closeExpression),
 543 |         ],
 544 | 
 545 |         // For loops
 546 |         "FOR_LOOP": [
 547 |             Token(value: "{%", type: .openStatement),
 548 |             Token(value: "for", type: .for),
 549 |             Token(value: "message", type: .identifier),
 550 |             Token(value: "in", type: .in),
 551 |             Token(value: "messages", type: .identifier),
 552 |             Token(value: "%}", type: .closeStatement),
 553 |             Token(value: "{{", type: .openExpression),
 554 |             Token(value: "message", type: .identifier),
 555 |             Token(value: "[", type: .openSquareBracket),
 556 |             Token(value: "content", type: .stringLiteral),
 557 |             Token(value: "]", type: .closeSquareBracket),
 558 |             Token(value: "}}", type: .closeExpression),
 559 |             Token(value: "{%", type: .openStatement),
 560 |             Token(value: "endfor", type: .endFor),
 561 |             Token(value: "%}", type: .closeStatement),
 562 |         ],
 563 |         "FOR_LOOP_UNPACKING": [
 564 |             Token(value: "|", type: .text),
 565 |             Token(value: "{%", type: .openStatement),
 566 |             Token(value: "for", type: .for),
 567 |             Token(value: "x", type: .identifier),
 568 |             Token(value: ",", type: .comma),
 569 |             Token(value: "y", type: .identifier),
 570 |             Token(value: "in", type: .in),
 571 |             Token(value: "[", type: .openSquareBracket),
 572 |             Token(value: "[", type: .openSquareBracket),
 573 |             Token(value: "1", type: .numericLiteral),
 574 |             Token(value: ",", type: .comma),
 575 |             Token(value: "2", type: .numericLiteral),
 576 |             Token(value: "]", type: .closeSquareBracket),
 577 |             Token(value: ",", type: .comma),
 578 |             Token(value: "[", type: .openSquareBracket),
 579 |             Token(value: "3", type: .numericLiteral),
 580 |             Token(value: ",", type: .comma),
 581 |             Token(value: "4", type: .numericLiteral),
 582 |             Token(value: "]", type: .closeSquareBracket),
 583 |             Token(value: "]", type: .closeSquareBracket),
 584 |             Token(value: "%}", type: .closeStatement),
 585 |             Token(value: "|", type: .text),
 586 |             Token(value: "{{", type: .openExpression),
 587 |             Token(value: "x", type: .identifier),
 588 |             Token(value: "+", type: .additiveBinaryOperator),
 589 |             Token(value: " ", type: .stringLiteral),
 590 |             Token(value: "+", type: .additiveBinaryOperator),
 591 |             Token(value: "y", type: .identifier),
 592 |             Token(value: "}}", type: .closeExpression),
 593 |             Token(value: "|", type: .text),
 594 |             Token(value: "{%", type: .openStatement),
 595 |             Token(value: "endfor", type: .endFor),
 596 |             Token(value: "%}", type: .closeStatement),
 597 |             Token(value: "|", type: .text),
 598 |         ],
 599 | 
 600 |         // Set variables
 601 |         "VARIABLES": [
 602 |             Token(value: "{%", type: .openStatement),
 603 |             Token(value: "set", type: .set),
 604 |             Token(value: "x", type: .identifier),
 605 |             Token(value: "=", type: .equals),
 606 |             Token(value: "Hello", type: .stringLiteral),
 607 |             Token(value: "%}", type: .closeStatement),
 608 |             Token(value: "{%", type: .openStatement),
 609 |             Token(value: "set", type: .set),
 610 |             Token(value: "y", type: .identifier),
 611 |             Token(value: "=", type: .equals),
 612 |             Token(value: "World", type: .stringLiteral),
 613 |             Token(value: "%}", type: .closeStatement),
 614 |             Token(value: "{{", type: .openExpression),
 615 |             Token(value: "x", type: .identifier),
 616 |             Token(value: "+", type: .additiveBinaryOperator),
 617 |             Token(value: " ", type: .stringLiteral),
 618 |             Token(value: "+", type: .additiveBinaryOperator),
 619 |             Token(value: "y", type: .identifier),
 620 |             Token(value: "}}", type: .closeExpression),
 621 |         ],
 622 | 
 623 |         // Numbers
 624 |         "NUMBERS": [
 625 |             Token(value: "|", type: .text),
 626 |             Token(value: "{{", type: .openExpression),
 627 |             Token(value: "5", type: .numericLiteral),
 628 |             Token(value: "}}", type: .closeExpression),
 629 |             Token(value: "|", type: .text),
 630 |             Token(value: "{{", type: .openExpression),
 631 |             Token(value: "-5", type: .numericLiteral),
 632 |             Token(value: "}}", type: .closeExpression),
 633 |             Token(value: "|", type: .text),
 634 |             Token(value: "{{", type: .openExpression),
 635 |             Token(value: "add", type: .identifier),
 636 |             Token(value: "(", type: .openParen),
 637 |             Token(value: "3", type: .numericLiteral),
 638 |             Token(value: ",", type: .comma),
 639 |             Token(value: "-1", type: .numericLiteral),
 640 |             Token(value: ")", type: .closeParen),
 641 |             Token(value: "}}", type: .closeExpression),
 642 |             Token(value: "|", type: .text),
 643 |             Token(value: "{{", type: .openExpression),
 644 |             Token(value: "(", type: .openParen),
 645 |             Token(value: "3", type: .numericLiteral),
 646 |             Token(value: "-", type: .additiveBinaryOperator),
 647 |             Token(value: "1", type: .numericLiteral),
 648 |             Token(value: ")", type: .closeParen),
 649 |             Token(value: "+", type: .additiveBinaryOperator),
 650 |             Token(value: "(", type: .openParen),
 651 |             Token(value: "a", type: .identifier),
 652 |             Token(value: "-", type: .additiveBinaryOperator),
 653 |             Token(value: "5", type: .numericLiteral),
 654 |             Token(value: ")", type: .closeParen),
 655 |             Token(value: "-", type: .additiveBinaryOperator),
 656 |             Token(value: "(", type: .openParen),
 657 |             Token(value: "a", type: .identifier),
 658 |             Token(value: "+", type: .additiveBinaryOperator),
 659 |             Token(value: "5", type: .numericLiteral),
 660 |             Token(value: ")", type: .closeParen),
 661 |             Token(value: "}}", type: .closeExpression),
 662 |             Token(value: "|", type: .text),
 663 |         ],
 664 | 
 665 |         // Binary expressions
 666 |         "BINOP_EXPR": [
 667 |             Token(value: "{{", type: .openExpression),
 668 |             Token(value: "1", type: .numericLiteral),
 669 |             Token(value: "%", type: .multiplicativeBinaryOperator),
 670 |             Token(value: "2", type: .numericLiteral),
 671 |             Token(value: "}}", type: .closeExpression),
 672 |             Token(value: "{{", type: .openExpression),
 673 |             Token(value: "1", type: .numericLiteral),
 674 |             Token(value: "<", type: .comparisonBinaryOperator),
 675 |             Token(value: "2", type: .numericLiteral),
 676 |             Token(value: "}}", type: .closeExpression),
 677 |             Token(value: "{{", type: .openExpression),
 678 |             Token(value: "1", type: .numericLiteral),
 679 |             Token(value: ">", type: .comparisonBinaryOperator),
 680 |             Token(value: "2", type: .numericLiteral),
 681 |             Token(value: "}}", type: .closeExpression),
 682 |             Token(value: "{{", type: .openExpression),
 683 |             Token(value: "1", type: .numericLiteral),
 684 |             Token(value: ">=", type: .comparisonBinaryOperator),
 685 |             Token(value: "2", type: .numericLiteral),
 686 |             Token(value: "}}", type: .closeExpression),
 687 |             Token(value: "{{", type: .openExpression),
 688 |             Token(value: "2", type: .numericLiteral),
 689 |             Token(value: "<=", type: .comparisonBinaryOperator),
 690 |             Token(value: "2", type: .numericLiteral),
 691 |             Token(value: "}}", type: .closeExpression),
 692 |             Token(value: "{{", type: .openExpression),
 693 |             Token(value: "2", type: .numericLiteral),
 694 |             Token(value: "==", type: .comparisonBinaryOperator),
 695 |             Token(value: "2", type: .numericLiteral),
 696 |             Token(value: "}}", type: .closeExpression),
 697 |             Token(value: "{{", type: .openExpression),
 698 |             Token(value: "2", type: .numericLiteral),
 699 |             Token(value: "!=", type: .comparisonBinaryOperator),
 700 |             Token(value: "3", type: .numericLiteral),
 701 |             Token(value: "}}", type: .closeExpression),
 702 |             Token(value: "{{", type: .openExpression),
 703 |             Token(value: "2", type: .numericLiteral),
 704 |             Token(value: "+", type: .additiveBinaryOperator),
 705 |             Token(value: "3", type: .numericLiteral),
 706 |             Token(value: "}}", type: .closeExpression),
 707 |         ],
 708 | 
 709 |         // Strings
 710 |         "STRINGS": [
 711 |             Token(value: "{{", type: .openExpression),
 712 |             Token(value: "Bye", type: .stringLiteral),
 713 |             Token(value: "}}", type: .closeExpression),
 714 |             Token(value: "{{", type: .openExpression),
 715 |             Token(value: "bos_token", type: .identifier),
 716 |             Token(value: "+", type: .additiveBinaryOperator),
 717 |             Token(value: "[INST] ", type: .stringLiteral),
 718 |             Token(value: "}}", type: .closeExpression),
 719 |         ],
 720 |         "STRINGS_1": [
 721 |             Token(value: "|", type: .text),
 722 |             Token(value: "{{", type: .openExpression),
 723 |             Token(value: "test", type: .stringLiteral),
 724 |             Token(value: "}}", type: .closeExpression),
 725 |             Token(value: "|", type: .text),
 726 |             Token(value: "{{", type: .openExpression),
 727 |             Token(value: "a", type: .stringLiteral),
 728 |             Token(value: "+", type: .additiveBinaryOperator),
 729 |             Token(value: "b", type: .stringLiteral),
 730 |             Token(value: "+", type: .additiveBinaryOperator),
 731 |             Token(value: "c", type: .stringLiteral),
 732 |             Token(value: "}}", type: .closeExpression),
 733 |             Token(value: "|", type: .text),
 734 |             Token(value: "{{", type: .openExpression),
 735 |             Token(value: "\"", type: .stringLiteral),
 736 |             Token(value: "+", type: .additiveBinaryOperator),
 737 |             Token(value: "'", type: .stringLiteral),
 738 |             Token(value: "}}", type: .closeExpression),
 739 |             Token(value: "|", type: .text),
 740 |             Token(value: "{{", type: .openExpression),
 741 |             Token(value: "'", type: .stringLiteral),
 742 |             Token(value: "}}", type: .closeExpression),
 743 |             Token(value: "|", type: .text),
 744 |             Token(value: "{{", type: .openExpression),
 745 |             Token(value: "\"", type: .stringLiteral),
 746 |             Token(value: "}}", type: .closeExpression),
 747 |             Token(value: "|", type: .text),
 748 |         ],
 749 |         "STRINGS_2": [
 750 |             Token(value: "|", type: .text),
 751 |             Token(value: "{{", type: .openExpression),
 752 |             Token(value: "", type: .stringLiteral),
 753 |             Token(value: "|", type: .pipe),
 754 |             Token(value: "length", type: .identifier),
 755 |             Token(value: "}}", type: .closeExpression),
 756 |             Token(value: "|", type: .text),
 757 |             Token(value: "{{", type: .openExpression),
 758 |             Token(value: "a", type: .stringLiteral),
 759 |             Token(value: "|", type: .pipe),
 760 |             Token(value: "length", type: .identifier),
 761 |             Token(value: "}}", type: .closeExpression),
 762 |             Token(value: "|", type: .text),
 763 |             Token(value: "{{", type: .openExpression),
 764 |             Token(value: "", type: .stringLiteral),
 765 |             Token(value: "|", type: .pipe),
 766 |             Token(value: "length", type: .identifier),
 767 |             Token(value: "}}", type: .closeExpression),
 768 |             Token(value: "|", type: .text),
 769 |             Token(value: "{{", type: .openExpression),
 770 |             Token(value: "a", type: .stringLiteral),
 771 |             Token(value: "|", type: .pipe),
 772 |             Token(value: "length", type: .identifier),
 773 |             Token(value: "}}", type: .closeExpression),
 774 |             Token(value: "|", type: .text),
 775 |         ],
 776 | 
 777 |         // Function calls
 778 |         "FUNCTIONS": [
 779 |             Token(value: "{{", type: .openExpression),
 780 |             Token(value: "func", type: .identifier),
 781 |             Token(value: "(", type: .openParen),
 782 |             Token(value: ")", type: .closeParen),
 783 |             Token(value: "}}", type: .closeExpression),
 784 |             Token(value: "{{", type: .openExpression),
 785 |             Token(value: "func", type: .identifier),
 786 |             Token(value: "(", type: .openParen),
 787 |             Token(value: "apple", type: .identifier),
 788 |             Token(value: ")", type: .closeParen),
 789 |             Token(value: "}}", type: .closeExpression),
 790 |             Token(value: "{{", type: .openExpression),
 791 |             Token(value: "func", type: .identifier),
 792 |             Token(value: "(", type: .openParen),
 793 |             Token(value: "x", type: .identifier),
 794 |             Token(value: ",", type: .comma),
 795 |             Token(value: "test", type: .stringLiteral),
 796 |             Token(value: ",", type: .comma),
 797 |             Token(value: "2", type: .numericLiteral),
 798 |             Token(value: ",", type: .comma),
 799 |             Token(value: "false", type: .booleanLiteral),
 800 |             Token(value: ")", type: .closeParen),
 801 |             Token(value: "}}", type: .closeExpression),
 802 |         ],
 803 | 
 804 |         // Object properties
 805 |         "PROPERTIES": [
 806 |             Token(value: "{{", type: .openExpression),
 807 |             Token(value: "obj", type: .identifier),
 808 |             Token(value: ".", type: .dot),
 809 |             Token(value: "x", type: .identifier),
 810 |             Token(value: "+", type: .additiveBinaryOperator),
 811 |             Token(value: "obj", type: .identifier),
 812 |             Token(value: ".", type: .dot),
 813 |             Token(value: "y", type: .identifier),
 814 |             Token(value: "}}", type: .closeExpression),
 815 |             Token(value: "{{", type: .openExpression),
 816 |             Token(value: "obj", type: .identifier),
 817 |             Token(value: "[", type: .openSquareBracket),
 818 |             Token(value: "x", type: .stringLiteral),
 819 |             Token(value: "]", type: .closeSquareBracket),
 820 |             Token(value: "+", type: .additiveBinaryOperator),
 821 |             Token(value: "obj", type: .identifier),
 822 |             Token(value: ".", type: .dot),
 823 |             Token(value: "y", type: .identifier),
 824 |             Token(value: "}}", type: .closeExpression),
 825 |         ],
 826 | 
 827 |         // Object methods
 828 |         "OBJ_METHODS": [
 829 |             Token(value: "{{", type: .openExpression),
 830 |             Token(value: "obj", type: .identifier),
 831 |             Token(value: ".", type: .dot),
 832 |             Token(value: "x", type: .identifier),
 833 |             Token(value: "(", type: .openParen),
 834 |             Token(value: "x", type: .identifier),
 835 |             Token(value: ",", type: .comma),
 836 |             Token(value: "y", type: .identifier),
 837 |             Token(value: ")", type: .closeParen),
 838 |             Token(value: "}}", type: .closeExpression),
 839 |             Token(value: "{{", type: .openExpression),
 840 |             Token(value: " ", type: .stringLiteral),
 841 |             Token(value: "+", type: .additiveBinaryOperator),
 842 |             Token(value: "obj", type: .identifier),
 843 |             Token(value: ".", type: .dot),
 844 |             Token(value: "x", type: .identifier),
 845 |             Token(value: "(", type: .openParen),
 846 |             Token(value: ")", type: .closeParen),
 847 |             Token(value: "+", type: .additiveBinaryOperator),
 848 |             Token(value: " ", type: .stringLiteral),
 849 |             Token(value: "}}", type: .closeExpression),
 850 |             Token(value: "{{", type: .openExpression),
 851 |             Token(value: "obj", type: .identifier),
 852 |             Token(value: ".", type: .dot),
 853 |             Token(value: "z", type: .identifier),
 854 |             Token(value: "[", type: .openSquareBracket),
 855 |             Token(value: "x", type: .identifier),
 856 |             Token(value: "]", type: .closeSquareBracket),
 857 |             Token(value: "(", type: .openParen),
 858 |             Token(value: "x", type: .identifier),
 859 |             Token(value: ",", type: .comma),
 860 |             Token(value: "y", type: .identifier),
 861 |             Token(value: ")", type: .closeParen),
 862 |             Token(value: "}}", type: .closeExpression),
 863 |         ],
 864 | 
 865 |         // String methods
 866 |         "STRING_METHODS": [
 867 |             Token(value: "{{", type: .openExpression),
 868 |             Token(value: "  A  ", type: .stringLiteral),
 869 |             Token(value: ".", type: .dot),
 870 |             Token(value: "strip", type: .identifier),
 871 |             Token(value: "(", type: .openParen),
 872 |             Token(value: ")", type: .closeParen),
 873 |             Token(value: "}}", type: .closeExpression),
 874 |             Token(value: "{%", type: .openStatement),
 875 |             Token(value: "set", type: .set),
 876 |             Token(value: "x", type: .identifier),
 877 |             Token(value: "=", type: .equals),
 878 |             Token(value: "  B  ", type: .stringLiteral),
 879 |             Token(value: "%}", type: .closeStatement),
 880 |             Token(value: "{{", type: .openExpression),
 881 |             Token(value: "x", type: .identifier),
 882 |             Token(value: ".", type: .dot),
 883 |             Token(value: "strip", type: .identifier),
 884 |             Token(value: "(", type: .openParen),
 885 |             Token(value: ")", type: .closeParen),
 886 |             Token(value: "}}", type: .closeExpression),
 887 |             Token(value: "{%", type: .openStatement),
 888 |             Token(value: "set", type: .set),
 889 |             Token(value: "y", type: .identifier),
 890 |             Token(value: "=", type: .equals),
 891 |             Token(value: " aBcD ", type: .stringLiteral),
 892 |             Token(value: "%}", type: .closeStatement),
 893 |             Token(value: "{{", type: .openExpression),
 894 |             Token(value: "y", type: .identifier),
 895 |             Token(value: ".", type: .dot),
 896 |             Token(value: "upper", type: .identifier),
 897 |             Token(value: "(", type: .openParen),
 898 |             Token(value: ")", type: .closeParen),
 899 |             Token(value: "}}", type: .closeExpression),
 900 |             Token(value: "{{", type: .openExpression),
 901 |             Token(value: "y", type: .identifier),
 902 |             Token(value: ".", type: .dot),
 903 |             Token(value: "lower", type: .identifier),
 904 |             Token(value: "(", type: .openParen),
 905 |             Token(value: ")", type: .closeParen),
 906 |             Token(value: "}}", type: .closeExpression),
 907 |         ],
 908 |         "STRING_METHODS_2": [
 909 |             Token(value: "{{", type: .openExpression),
 910 |             Token(value: "test test", type: .stringLiteral),
 911 |             Token(value: ".", type: .dot),
 912 |             Token(value: "title", type: .identifier),
 913 |             Token(value: "(", type: .openParen),
 914 |             Token(value: ")", type: .closeParen),
 915 |             Token(value: "}}", type: .closeExpression),
 916 |         ],
 917 | 
 918 |         // String indexing and slicing
 919 |         "STRING_SLICING": [
 920 |             Token(value: "|", type: .text),
 921 |             Token(value: "{{", type: .openExpression),
 922 |             Token(value: "x", type: .identifier),
 923 |             Token(value: "[", type: .openSquareBracket),
 924 |             Token(value: "0", type: .numericLiteral),
 925 |             Token(value: "]", type: .closeSquareBracket),
 926 |             Token(value: "}}", type: .closeExpression),
 927 |             Token(value: "|", type: .text),
 928 |             Token(value: "{{", type: .openExpression),
 929 |             Token(value: "x", type: .identifier),
 930 |             Token(value: "[", type: .openSquareBracket),
 931 |             Token(value: ":", type: .colon),
 932 |             Token(value: "]", type: .closeSquareBracket),
 933 |             Token(value: "}}", type: .closeExpression),
 934 |             Token(value: "|", type: .text),
 935 |             Token(value: "{{", type: .openExpression),
 936 |             Token(value: "x", type: .identifier),
 937 |             Token(value: "[", type: .openSquareBracket),
 938 |             Token(value: ":", type: .colon),
 939 |             Token(value: "3", type: .numericLiteral),
 940 |             Token(value: "]", type: .closeSquareBracket),
 941 |             Token(value: "}}", type: .closeExpression),
 942 |             Token(value: "|", type: .text),
 943 |             Token(value: "{{", type: .openExpression),
 944 |             Token(value: "x", type: .identifier),
 945 |             Token(value: "[", type: .openSquareBracket),
 946 |             Token(value: "1", type: .numericLiteral),
 947 |             Token(value: ":", type: .colon),
 948 |             Token(value: "4", type: .numericLiteral),
 949 |             Token(value: "]", type: .closeSquareBracket),
 950 |             Token(value: "}}", type: .closeExpression),
 951 |             Token(value: "|", type: .text),
 952 |             Token(value: "{{", type: .openExpression),
 953 |             Token(value: "x", type: .identifier),
 954 |             Token(value: "[", type: .openSquareBracket),
 955 |             Token(value: "1", type: .numericLiteral),
 956 |             Token(value: ":", type: .colon),
 957 |             Token(value: "-1", type: .numericLiteral),
 958 |             Token(value: "]", type: .closeSquareBracket),
 959 |             Token(value: "}}", type: .closeExpression),
 960 |             Token(value: "|", type: .text),
 961 |             Token(value: "{{", type: .openExpression),
 962 |             Token(value: "x", type: .identifier),
 963 |             Token(value: "[", type: .openSquareBracket),
 964 |             Token(value: "1", type: .numericLiteral),
 965 |             Token(value: ":", type: .colon),
 966 |             Token(value: ":", type: .colon),
 967 |             Token(value: "2", type: .numericLiteral),
 968 |             Token(value: "]", type: .closeSquareBracket),
 969 |             Token(value: "}}", type: .closeExpression),
 970 |             Token(value: "|", type: .text),
 971 |             Token(value: "{{", type: .openExpression),
 972 |             Token(value: "x", type: .identifier),
 973 |             Token(value: "[", type: .openSquareBracket),
 974 |             Token(value: "5", type: .numericLiteral),
 975 |             Token(value: ":", type: .colon),
 976 |             Token(value: ":", type: .colon),
 977 |             Token(value: "-1", type: .numericLiteral),
 978 |             Token(value: "]", type: .closeSquareBracket),
 979 |             Token(value: "}}", type: .closeExpression),
 980 |             Token(value: "|", type: .text),
 981 |         ],
 982 | 
 983 |         // Array indexing and slicing
 984 |         "ARRAY_SLICING": [
 985 |             Token(value: "|", type: .text),
 986 |             Token(value: "{{", type: .openExpression),
 987 |             Token(value: "strings", type: .identifier),
 988 |             Token(value: "[", type: .openSquareBracket),
 989 |             Token(value: "0", type: .numericLiteral),
 990 |             Token(value: "]", type: .closeSquareBracket),
 991 |             Token(value: "}}", type: .closeExpression),
 992 |             Token(value: "|", type: .text),
 993 |             Token(value: "{%", type: .openStatement),
 994 |             Token(value: "for", type: .for),
 995 |             Token(value: "s", type: .identifier),
 996 |             Token(value: "in", type: .in),
 997 |             Token(value: "strings", type: .identifier),
 998 |             Token(value: "[", type: .openSquareBracket),
 999 |             Token(value: ":", type: .colon),
1000 |             Token(value: "]", type: .closeSquareBracket),
1001 |             Token(value: "%}", type: .closeStatement),
1002 |             Token(value: "{{", type: .openExpression),
1003 |             Token(value: "s", type: .identifier),
1004 |             Token(value: "}}", type: .closeExpression),
1005 |             Token(value: "{%", type: .openStatement),
1006 |             Token(value: "endfor", type: .endFor),
1007 |             Token(value: "%}", type: .closeStatement),
1008 |             Token(value: "|", type: .text),
1009 |             Token(value: "{%", type: .openStatement),
1010 |             Token(value: "for", type: .for),
1011 |             Token(value: "s", type: .identifier),
1012 |             Token(value: "in", type: .in),
1013 |             Token(value: "strings", type: .identifier),
1014 |             Token(value: "[", type: .openSquareBracket),
1015 |             Token(value: ":", type: .colon),
1016 |             Token(value: "3", type: .numericLiteral),
1017 |             Token(value: "]", type: .closeSquareBracket),
1018 |             Token(value: "%}", type: .closeStatement),
1019 |             Token(value: "{{", type: .openExpression),
1020 |             Token(value: "s", type: .identifier),
1021 |             Token(value: "}}", type: .closeExpression),
1022 |             Token(value: "{%", type: .openStatement),
1023 |             Token(value: "endfor", type: .endFor),
1024 |             Token(value: "%}", type: .closeStatement),
1025 |             Token(value: "|", type: .text),
1026 |             Token(value: "{%", type: .openStatement),
1027 |             Token(value: "for", type: .for),
1028 |             Token(value: "s", type: .identifier),
1029 |             Token(value: "in", type: .in),
1030 |             Token(value: "strings", type: .identifier),
1031 |             Token(value: "[", type: .openSquareBracket),
1032 |             Token(value: "1", type: .numericLiteral),
1033 |             Token(value: ":", type: .colon),
1034 |             Token(value: "4", type: .numericLiteral),
1035 |             Token(value: "]", type: .closeSquareBracket),
1036 |             Token(value: "%}", type: .closeStatement),
1037 |             Token(value: "{{", type: .openExpression),
1038 |             Token(value: "s", type: .identifier),
1039 |             Token(value: "}}", type: .closeExpression),
1040 |             Token(value: "{%", type: .openStatement),
1041 |             Token(value: "endfor", type: .endFor),
1042 |             Token(value: "%}", type: .closeStatement),
1043 |             Token(value: "|", type: .text),
1044 |             Token(value: "{%", type: .openStatement),
1045 |             Token(value: "for", type: .for),
1046 |             Token(value: "s", type: .identifier),
1047 |             Token(value: "in", type: .in),
1048 |             Token(value: "strings", type: .identifier),
1049 |             Token(value: "[", type: .openSquareBracket),
1050 |             Token(value: "1", type: .numericLiteral),
1051 |             Token(value: ":", type: .colon),
1052 |             Token(value: "-1", type: .numericLiteral),
1053 |             Token(value: "]", type: .closeSquareBracket),
1054 |             Token(value: "%}", type: .closeStatement),
1055 |             Token(value: "{{", type: .openExpression),
1056 |             Token(value: "s", type: .identifier),
1057 |             Token(value: "}}", type: .closeExpression),
1058 |             Token(value: "{%", type: .openStatement),
1059 |             Token(value: "endfor", type: .endFor),
1060 |             Token(value: "%}", type: .closeStatement),
1061 |             Token(value: "|", type: .text),
1062 |             Token(value: "{%", type: .openStatement),
1063 |             Token(value: "for", type: .for),
1064 |             Token(value: "s", type: .identifier),
1065 |             Token(value: "in", type: .in),
1066 |             Token(value: "strings", type: .identifier),
1067 |             Token(value: "[", type: .openSquareBracket),
1068 |             Token(value: "1", type: .numericLiteral),
1069 |             Token(value: ":", type: .colon),
1070 |             Token(value: ":", type: .colon),
1071 |             Token(value: "2", type: .numericLiteral),
1072 |             Token(value: "]", type: .closeSquareBracket),
1073 |             Token(value: "%}", type: .closeStatement),
1074 |             Token(value: "{{", type: .openExpression),
1075 |             Token(value: "s", type: .identifier),
1076 |             Token(value: "}}", type: .closeExpression),
1077 |             Token(value: "{%", type: .openStatement),
1078 |             Token(value: "endfor", type: .endFor),
1079 |             Token(value: "%}", type: .closeStatement),
1080 |             Token(value: "|", type: .text),
1081 |             Token(value: "{%", type: .openStatement),
1082 |             Token(value: "for", type: .for),
1083 |             Token(value: "s", type: .identifier),
1084 |             Token(value: "in", type: .in),
1085 |             Token(value: "strings", type: .identifier),
1086 |             Token(value: "[", type: .openSquareBracket),
1087 |             Token(value: "5", type: .numericLiteral),
1088 |             Token(value: ":", type: .colon),
1089 |             Token(value: ":", type: .colon),
1090 |             Token(value: "-1", type: .numericLiteral),
1091 |             Token(value: "]", type: .closeSquareBracket),
1092 |             Token(value: "%}", type: .closeStatement),
1093 |             Token(value: "{{", type: .openExpression),
1094 |             Token(value: "s", type: .identifier),
1095 |             Token(value: "}}", type: .closeExpression),
1096 |             Token(value: "{%", type: .openStatement),
1097 |             Token(value: "endfor", type: .endFor),
1098 |             Token(value: "%}", type: .closeStatement),
1099 |             Token(value: "|", type: .text),
1100 |         ],
1101 | 
1102 |         // Membership operators
1103 |         "MEMBERSHIP": [
1104 |             Token(value: "|", type: .text),
1105 |             Token(value: "{{", type: .openExpression),
1106 |             Token(value: "0", type: .numericLiteral),
1107 |             Token(value: "in", type: .in),
1108 |             Token(value: "arr", type: .identifier),
1109 |             Token(value: "}}", type: .closeExpression),
1110 |             Token(value: "|", type: .text),
1111 |             Token(value: "{{", type: .openExpression),
1112 |             Token(value: "1", type: .numericLiteral),
1113 |             Token(value: "in", type: .in),
1114 |             Token(value: "arr", type: .identifier),
1115 |             Token(value: "}}", type: .closeExpression),
1116 |             Token(value: "|", type: .text),
1117 |             Token(value: "{{", type: .openExpression),
1118 |             Token(value: "true", type: .booleanLiteral),
1119 |             Token(value: "in", type: .in),
1120 |             Token(value: "arr", type: .identifier),
1121 |             Token(value: "}}", type: .closeExpression),
1122 |             Token(value: "|", type: .text),
1123 |             Token(value: "{{", type: .openExpression),
1124 |             Token(value: "false", type: .booleanLiteral),
1125 |             Token(value: "in", type: .in),
1126 |             Token(value: "arr", type: .identifier),
1127 |             Token(value: "}}", type: .closeExpression),
1128 |             Token(value: "|", type: .text),
1129 |             Token(value: "{{", type: .openExpression),
1130 |             Token(value: "a", type: .stringLiteral),
1131 |             Token(value: "in", type: .in),
1132 |             Token(value: "arr", type: .identifier),
1133 |             Token(value: "}}", type: .closeExpression),
1134 |             Token(value: "|", type: .text),
1135 |             Token(value: "{{", type: .openExpression),
1136 |             Token(value: "b", type: .stringLiteral),
1137 |             Token(value: "in", type: .in),
1138 |             Token(value: "arr", type: .identifier),
1139 |             Token(value: "}}", type: .closeExpression),
1140 |             Token(value: "|", type: .text),
1141 |         ],
1142 |         "MEMBERSHIP_NEGATION_1": [
1143 |             Token(value: "|", type: .text),
1144 |             Token(value: "{{", type: .openExpression),
1145 |             Token(value: "not", type: .not),
1146 |             Token(value: "0", type: .numericLiteral),
1147 |             Token(value: "in", type: .in),
1148 |             Token(value: "arr", type: .identifier),
1149 |             Token(value: "}}", type: .closeExpression),
1150 |             Token(value: "|", type: .text),
1151 |             Token(value: "{{", type: .openExpression),
1152 |             Token(value: "not", type: .not),
1153 |             Token(value: "1", type: .numericLiteral),
1154 |             Token(value: "in", type: .in),
1155 |             Token(value: "arr", type: .identifier),
1156 |             Token(value: "}}", type: .closeExpression),
1157 |             Token(value: "|", type: .text),
1158 |             Token(value: "{{", type: .openExpression),
1159 |             Token(value: "not", type: .not),
1160 |             Token(value: "true", type: .booleanLiteral),
1161 |             Token(value: "in", type: .in),
1162 |             Token(value: "arr", type: .identifier),
1163 |             Token(value: "}}", type: .closeExpression),
1164 |             Token(value: "|", type: .text),
1165 |             Token(value: "{{", type: .openExpression),
1166 |             Token(value: "not", type: .not),
1167 |             Token(value: "false", type: .booleanLiteral),
1168 |             Token(value: "in", type: .in),
1169 |             Token(value: "arr", type: .identifier),
1170 |             Token(value: "}}", type: .closeExpression),
1171 |             Token(value: "|", type: .text),
1172 |             Token(value: "{{", type: .openExpression),
1173 |             Token(value: "not", type: .not),
1174 |             Token(value: "a", type: .stringLiteral),
1175 |             Token(value: "in", type: .in),
1176 |             Token(value: "arr", type: .identifier),
1177 |             Token(value: "}}", type: .closeExpression),
1178 |             Token(value: "|", type: .text),
1179 |             Token(value: "{{", type: .openExpression),
1180 |             Token(value: "not", type: .not),
1181 |             Token(value: "b", type: .stringLiteral),
1182 |             Token(value: "in", type: .in),
1183 |             Token(value: "arr", type: .identifier),
1184 |             Token(value: "}}", type: .closeExpression),
1185 |             Token(value: "|", type: .text),
1186 |         ],
1187 |         "MEMBERSHIP_NEGATION_2": [
1188 |             Token(value: "|", type: .text),
1189 |             Token(value: "{{", type: .openExpression),
1190 |             Token(value: "0", type: .numericLiteral),
1191 |             Token(value: "not in", type: .notIn),
1192 |             Token(value: "arr", type: .identifier),
1193 |             Token(value: "}}", type: .closeExpression),
1194 |             Token(value: "|", type: .text),
1195 |             Token(value: "{{", type: .openExpression),
1196 |             Token(value: "1", type: .numericLiteral),
1197 |             Token(value: "not in", type: .notIn),
1198 |             Token(value: "arr", type: .identifier),
1199 |             Token(value: "}}", type: .closeExpression),
1200 |             Token(value: "|", type: .text),
1201 |             Token(value: "{{", type: .openExpression),
1202 |             Token(value: "true", type: .booleanLiteral),
1203 |             Token(value: "not in", type: .notIn),
1204 |             Token(value: "arr", type: .identifier),
1205 |             Token(value: "}}", type: .closeExpression),
1206 |             Token(value: "|", type: .text),
1207 |             Token(value: "{{", type: .openExpression),
1208 |             Token(value: "false", type: .booleanLiteral),
1209 |             Token(value: "not in", type: .notIn),
1210 |             Token(value: "arr", type: .identifier),
1211 |             Token(value: "}}", type: .closeExpression),
1212 |             Token(value: "|", type: .text),
1213 |             Token(value: "{{", type: .openExpression),
1214 |             Token(value: "a", type: .stringLiteral),
1215 |             Token(value: "not in", type: .notIn),
1216 |             Token(value: "arr", type: .identifier),
1217 |             Token(value: "}}", type: .closeExpression),
1218 |             Token(value: "|", type: .text),
1219 |             Token(value: "{{", type: .openExpression),
1220 |             Token(value: "b", type: .stringLiteral),
1221 |             Token(value: "not in", type: .notIn),
1222 |             Token(value: "arr", type: .identifier),
1223 |             Token(value: "}}", type: .closeExpression),
1224 |             Token(value: "|", type: .text),
1225 |         ],
1226 | 
1227 |         // Escaped characters
1228 |         "ESCAPED_CHARS": [
1229 |             Token(value: "{{", type: .openExpression),
1230 |             Token(value: "\n", type: .stringLiteral),
1231 |             Token(value: "}}", type: .closeExpression),
1232 |             Token(value: "{{", type: .openExpression),
1233 |             Token(value: "\t", type: .stringLiteral),
1234 |             Token(value: "}}", type: .closeExpression),
1235 |             Token(value: "{{", type: .openExpression),
1236 |             Token(value: "'", type: .stringLiteral),
1237 |             Token(value: "}}", type: .closeExpression),
1238 |             Token(value: "{{", type: .openExpression),
1239 |             Token(value: "\"", type: .stringLiteral),
1240 |             Token(value: "}}", type: .closeExpression),
1241 |             Token(value: "{{", type: .openExpression),
1242 |             Token(value: "\\", type: .stringLiteral),
1243 |             Token(value: "}}", type: .closeExpression),
1244 |             Token(value: "{{", type: .openExpression),
1245 |             Token(value: "|\n|\t|'|\"|\\|", type: .stringLiteral),
1246 |             Token(value: "}}", type: .closeExpression),
1247 |         ],
1248 | 
1249 |         // Substring inclusion
1250 |         "SUBSTRING_INCLUSION": [
1251 |             Token(value: "|", type: .text),
1252 |             Token(value: "{{", type: .openExpression),
1253 |             Token(value: "", type: .stringLiteral),
1254 |             Token(value: "in", type: .in),
1255 |             Token(value: "abc", type: .stringLiteral),
1256 |             Token(value: "}}", type: .closeExpression),
1257 |             Token(value: "|", type: .text),
1258 |             Token(value: "{{", type: .openExpression),
1259 |             Token(value: "a", type: .stringLiteral),
1260 |             Token(value: "in", type: .in),
1261 |             Token(value: "abc", type: .stringLiteral),
1262 |             Token(value: "}}", type: .closeExpression),
1263 |             Token(value: "|", type: .text),
1264 |             Token(value: "{{", type: .openExpression),
1265 |             Token(value: "d", type: .stringLiteral),
1266 |             Token(value: "in", type: .in),
1267 |             Token(value: "abc", type: .stringLiteral),
1268 |             Token(value: "}}", type: .closeExpression),
1269 |             Token(value: "|", type: .text),
1270 |             Token(value: "{{", type: .openExpression),
1271 |             Token(value: "ab", type: .stringLiteral),
1272 |             Token(value: "in", type: .in),
1273 |             Token(value: "abc", type: .stringLiteral),
1274 |             Token(value: "}}", type: .closeExpression),
1275 |             Token(value: "|", type: .text),
1276 |             Token(value: "{{", type: .openExpression),
1277 |             Token(value: "ac", type: .stringLiteral),
1278 |             Token(value: "in", type: .in),
1279 |             Token(value: "abc", type: .stringLiteral),
1280 |             Token(value: "}}", type: .closeExpression),
1281 |             Token(value: "|", type: .text),
1282 |             Token(value: "{{", type: .openExpression),
1283 |             Token(value: "abc", type: .stringLiteral),
1284 |             Token(value: "in", type: .in),
1285 |             Token(value: "abc", type: .stringLiteral),
1286 |             Token(value: "}}", type: .closeExpression),
1287 |             Token(value: "|", type: .text),
1288 |             Token(value: "{{", type: .openExpression),
1289 |             Token(value: "abcd", type: .stringLiteral),
1290 |             Token(value: "in", type: .in),
1291 |             Token(value: "abc", type: .stringLiteral),
1292 |             Token(value: "}}", type: .closeExpression),
1293 |             Token(value: "|", type: .text),
1294 |         ],
1295 | 
1296 |         // Filter operator
1297 |         "FILTER_OPERATOR": [
1298 |             Token(value: "{{", type: .openExpression),
1299 |             Token(value: "arr", type: .identifier),
1300 |             Token(value: "|", type: .pipe),
1301 |             Token(value: "length", type: .identifier),
1302 |             Token(value: "}}", type: .closeExpression),
1303 |             Token(value: "{{", type: .openExpression),
1304 |             Token(value: "1", type: .numericLiteral),
1305 |             Token(value: "+", type: .additiveBinaryOperator),
1306 |             Token(value: "arr", type: .identifier),
1307 |             Token(value: "|", type: .pipe),
1308 |             Token(value: "length", type: .identifier),
1309 |             Token(value: "}}", type: .closeExpression),
1310 |             Token(value: "{{", type: .openExpression),
1311 |             Token(value: "2", type: .numericLiteral),
1312 |             Token(value: "+", type: .additiveBinaryOperator),
1313 |             Token(value: "arr", type: .identifier),
1314 |             Token(value: "|", type: .pipe),
1315 |             Token(value: "sort", type: .identifier),
1316 |             Token(value: "|", type: .pipe),
1317 |             Token(value: "length", type: .identifier),
1318 |             Token(value: "}}", type: .closeExpression),
1319 |             Token(value: "{{", type: .openExpression),
1320 |             Token(value: "(", type: .openParen),
1321 |             Token(value: "arr", type: .identifier),
1322 |             Token(value: "|", type: .pipe),
1323 |             Token(value: "sort", type: .identifier),
1324 |             Token(value: ")", type: .closeParen),
1325 |             Token(value: "[", type: .openSquareBracket),
1326 |             Token(value: "0", type: .numericLiteral),
1327 |             Token(value: "]", type: .closeSquareBracket),
1328 |             Token(value: "}}", type: .closeExpression),
1329 |         ],
1330 |         "FILTER_OPERATOR_2": [
1331 |             Token(value: "|", type: .text),
1332 |             Token(value: "{{", type: .openExpression),
1333 |             Token(value: "abc", type: .stringLiteral),
1334 |             Token(value: "|", type: .pipe),
1335 |             Token(value: "length", type: .identifier),
1336 |             Token(value: "}}", type: .closeExpression),
1337 |             Token(value: "|", type: .text),
1338 |             Token(value: "{{", type: .openExpression),
1339 |             Token(value: "aBcD", type: .stringLiteral),
1340 |             Token(value: "|", type: .pipe),
1341 |             Token(value: "upper", type: .identifier),
1342 |             Token(value: "}}", type: .closeExpression),
1343 |             Token(value: "|", type: .text),
1344 |             Token(value: "{{", type: .openExpression),
1345 |             Token(value: "aBcD", type: .stringLiteral),
1346 |             Token(value: "|", type: .pipe),
1347 |             Token(value: "lower", type: .identifier),
1348 |             Token(value: "}}", type: .closeExpression),
1349 |             Token(value: "|", type: .text),
1350 |             Token(value: "{{", type: .openExpression),
1351 |             Token(value: "test test", type: .stringLiteral),
1352 |             Token(value: "|", type: .pipe),
1353 |             Token(value: "capitalize", type: .identifier),
1354 |             Token(value: "}}", type: .closeExpression),
1355 |             Token(value: "|", type: .text),
1356 |             Token(value: "{{", type: .openExpression),
1357 |             Token(value: "test test", type: .stringLiteral),
1358 |             Token(value: "|", type: .pipe),
1359 |             Token(value: "title", type: .identifier),
1360 |             Token(value: "}}", type: .closeExpression),
1361 |             Token(value: "|", type: .text),
1362 |             Token(value: "{{", type: .openExpression),
1363 |             Token(value: " a b ", type: .stringLiteral),
1364 |             Token(value: "|", type: .pipe),
1365 |             Token(value: "trim", type: .identifier),
1366 |             Token(value: "}}", type: .closeExpression),
1367 |             Token(value: "|", type: .text),
1368 |             Token(value: "{{", type: .openExpression),
1369 |             Token(value: "  A  B  ", type: .stringLiteral),
1370 |             Token(value: "|", type: .pipe),
1371 |             Token(value: "trim", type: .identifier),
1372 |             Token(value: "|", type: .pipe),
1373 |             Token(value: "lower", type: .identifier),
1374 |             Token(value: "|", type: .pipe),
1375 |             Token(value: "length", type: .identifier),
1376 |             Token(value: "}}", type: .closeExpression),
1377 |             Token(value: "|", type: .text),
1378 |         ],
1379 |         "FILTER_OPERATOR_3": [
1380 |             Token(value: "|", type: .text),
1381 |             Token(value: "{{", type: .openExpression),
1382 |             Token(value: "-1", type: .numericLiteral),
1383 |             Token(value: "|", type: .pipe),
1384 |             Token(value: "abs", type: .identifier),
1385 |             Token(value: "}}", type: .closeExpression),
1386 |             Token(value: "|", type: .text),
1387 |             Token(value: "{{", type: .openExpression),
1388 |             Token(value: "1", type: .numericLiteral),
1389 |             Token(value: "|", type: .pipe),
1390 |             Token(value: "abs", type: .identifier),
1391 |             Token(value: "}}", type: .closeExpression),
1392 |             Token(value: "|", type: .text),
1393 |         ],
1394 |         "FILTER_OPERATOR_4": [
1395 |             Token(value: "{{", type: .openExpression),
1396 |             Token(value: "items", type: .identifier),
1397 |             Token(value: "|", type: .pipe),
1398 |             Token(value: "selectattr", type: .identifier),
1399 |             Token(value: "(", type: .openParen),
1400 |             Token(value: "key", type: .stringLiteral),
1401 |             Token(value: ")", type: .closeParen),
1402 |             Token(value: "|", type: .pipe),
1403 |             Token(value: "length", type: .identifier),
1404 |             Token(value: "}}", type: .closeExpression),
1405 |         ],
1406 |         "FILTER_OPERATOR_5": [
1407 |             Token(value: "{{", type: .openExpression),
1408 |             Token(value: "messages", type: .identifier),
1409 |             Token(value: "|", type: .pipe),
1410 |             Token(value: "selectattr", type: .identifier),
1411 |             Token(value: "(", type: .openParen),
1412 |             Token(value: "role", type: .stringLiteral),
1413 |             Token(value: ",", type: .comma),
1414 |             Token(value: "equalto", type: .stringLiteral),
1415 |             Token(value: ",", type: .comma),
1416 |             Token(value: "system", type: .stringLiteral),
1417 |             Token(value: ")", type: .closeParen),
1418 |             Token(value: "|", type: .pipe),
1419 |             Token(value: "length", type: .identifier),
1420 |             Token(value: "}}", type: .closeExpression),
1421 |         ],
1422 |         "FILTER_OPERATOR_6": [
1423 |             Token(value: "|", type: .text),
1424 |             Token(value: "{{", type: .openExpression),
1425 |             Token(value: "obj", type: .identifier),
1426 |             Token(value: "|", type: .pipe),
1427 |             Token(value: "length", type: .identifier),
1428 |             Token(value: "}}", type: .closeExpression),
1429 |             Token(value: "|", type: .text),
1430 |             Token(value: "{{", type: .openExpression),
1431 |             Token(value: "(", type: .openParen),
1432 |             Token(value: "obj", type: .identifier),
1433 |             Token(value: "|", type: .pipe),
1434 |             Token(value: "items", type: .identifier),
1435 |             Token(value: ")", type: .closeParen),
1436 |             Token(value: "[", type: .openSquareBracket),
1437 |             Token(value: "1", type: .numericLiteral),
1438 |             Token(value: ":", type: .colon),
1439 |             Token(value: "]", type: .closeSquareBracket),
1440 |             Token(value: "|", type: .pipe),
1441 |             Token(value: "length", type: .identifier),
1442 |             Token(value: "}}", type: .closeExpression),
1443 |             Token(value: "|", type: .text),
1444 |         ],
1445 | 
1446 |         // Logical operators between non-Booleans
1447 |         "BOOLEAN_NUMERICAL": [
1448 |             Token(value: "|", type: .text),
1449 |             Token(value: "{{", type: .openExpression),
1450 |             Token(value: "1", type: .numericLiteral),
1451 |             Token(value: "and", type: .and),
1452 |             Token(value: "2", type: .numericLiteral),
1453 |             Token(value: "}}", type: .closeExpression),
1454 |             Token(value: "|", type: .text),
1455 |             Token(value: "{{", type: .openExpression),
1456 |             Token(value: "1", type: .numericLiteral),
1457 |             Token(value: "and", type: .and),
1458 |             Token(value: "0", type: .numericLiteral),
1459 |             Token(value: "}}", type: .closeExpression),
1460 |             Token(value: "|", type: .text),
1461 |             Token(value: "{{", type: .openExpression),
1462 |             Token(value: "0", type: .numericLiteral),
1463 |             Token(value: "and", type: .and),
1464 |             Token(value: "1", type: .numericLiteral),
1465 |             Token(value: "}}", type: .closeExpression),
1466 |             Token(value: "|", type: .text),
1467 |             Token(value: "{{", type: .openExpression),
1468 |             Token(value: "0", type: .numericLiteral),
1469 |             Token(value: "and", type: .and),
1470 |             Token(value: "0", type: .numericLiteral),
1471 |             Token(value: "}}", type: .closeExpression),
1472 |             Token(value: "|", type: .text),
1473 |             Token(value: "{{", type: .openExpression),
1474 |             Token(value: "1", type: .numericLiteral),
1475 |             Token(value: "or", type: .or),
1476 |             Token(value: "2", type: .numericLiteral),
1477 |             Token(value: "}}", type: .closeExpression),
1478 |             Token(value: "|", type: .text),
1479 |             Token(value: "{{", type: .openExpression),
1480 |             Token(value: "1", type: .numericLiteral),
1481 |             Token(value: "or", type: .or),
1482 |             Token(value: "0", type: .numericLiteral),
1483 |             Token(value: "}}", type: .closeExpression),
1484 |             Token(value: "|", type: .text),
1485 |             Token(value: "{{", type: .openExpression),
1486 |             Token(value: "0", type: .numericLiteral),
1487 |             Token(value: "or", type: .or),
1488 |             Token(value: "1", type: .numericLiteral),
1489 |             Token(value: "}}", type: .closeExpression),
1490 |             Token(value: "|", type: .text),
1491 |             Token(value: "{{", type: .openExpression),
1492 |             Token(value: "0", type: .numericLiteral),
1493 |             Token(value: "or", type: .or),
1494 |             Token(value: "0", type: .numericLiteral),
1495 |             Token(value: "}}", type: .closeExpression),
1496 |             Token(value: "|", type: .text),
1497 |             Token(value: "{{", type: .openExpression),
1498 |             Token(value: "not", type: .not),
1499 |             Token(value: "1", type: .numericLiteral),
1500 |             Token(value: "}}", type: .closeExpression),
1501 |             Token(value: "|", type: .text),
1502 |             Token(value: "{{", type: .openExpression),
1503 |             Token(value: "not", type: .not),
1504 |             Token(value: "0", type: .numericLiteral),
1505 |             Token(value: "}}", type: .closeExpression),
1506 |             Token(value: "|", type: .text),
1507 |         ],
1508 |         "BOOLEAN_STRINGS": [
1509 |             Token(value: "|", type: .text),
1510 |             Token(value: "{{", type: .openExpression),
1511 |             Token(value: "a", type: .stringLiteral),
1512 |             Token(value: "and", type: .and),
1513 |             Token(value: "b", type: .stringLiteral),
1514 |             Token(value: "}}", type: .closeExpression),
1515 |             Token(value: "|", type: .text),
1516 |             Token(value: "{{", type: .openExpression),
1517 |             Token(value: "a", type: .stringLiteral),
1518 |             Token(value: "and", type: .and),
1519 |             Token(value: "", type: .stringLiteral),
1520 |             Token(value: "}}", type: .closeExpression),
1521 |             Token(value: "|", type: .text),
1522 |             Token(value: "{{", type: .openExpression),
1523 |             Token(value: "", type: .stringLiteral),
1524 |             Token(value: "and", type: .and),
1525 |             Token(value: "a", type: .stringLiteral),
1526 |             Token(value: "}}", type: .closeExpression),
1527 |             Token(value: "|", type: .text),
1528 |             Token(value: "{{", type: .openExpression),
1529 |             Token(value: "", type: .stringLiteral),
1530 |             Token(value: "and", type: .and),
1531 |             Token(value: "", type: .stringLiteral),
1532 |             Token(value: "}}", type: .closeExpression),
1533 |             Token(value: "|", type: .text),
1534 |             Token(value: "{{", type: .openExpression),
1535 |             Token(value: "a", type: .stringLiteral),
1536 |             Token(value: "or", type: .or),
1537 |             Token(value: "b", type: .stringLiteral),
1538 |             Token(value: "}}", type: .closeExpression),
1539 |             Token(value: "|", type: .text),
1540 |             Token(value: "{{", type: .openExpression),
1541 |             Token(value: "a", type: .stringLiteral),
1542 |             Token(value: "or", type: .or),
1543 |             Token(value: "", type: .stringLiteral),
1544 |             Token(value: "}}", type: .closeExpression),
1545 |             Token(value: "|", type: .text),
1546 |             Token(value: "{{", type: .openExpression),
1547 |             Token(value: "", type: .stringLiteral),
1548 |             Token(value: "or", type: .or),
1549 |             Token(value: "a", type: .stringLiteral),
1550 |             Token(value: "}}", type: .closeExpression),
1551 |             Token(value: "|", type: .text),
1552 |             Token(value: "{{", type: .openExpression),
1553 |             Token(value: "", type: .stringLiteral),
1554 |             Token(value: "or", type: .or),
1555 |             Token(value: "", type: .stringLiteral),
1556 |             Token(value: "}}", type: .closeExpression),
1557 |             Token(value: "|", type: .text),
1558 |             Token(value: "{{", type: .openExpression),
1559 |             Token(value: "not", type: .not),
1560 |             Token(value: "a", type: .stringLiteral),
1561 |             Token(value: "}}", type: .closeExpression),
1562 |             Token(value: "|", type: .text),
1563 |             Token(value: "{{", type: .openExpression),
1564 |             Token(value: "not", type: .not),
1565 |             Token(value: "", type: .stringLiteral),
1566 |             Token(value: "}}", type: .closeExpression),
1567 |             Token(value: "|", type: .text),
1568 |         ],
1569 |         "BOOLEAN_MIXED": [
1570 |             Token(value: "|", type: .text),
1571 |             Token(value: "{{", type: .openExpression),
1572 |             Token(value: "true", type: .booleanLiteral),
1573 |             Token(value: "and", type: .and),
1574 |             Token(value: "1", type: .numericLiteral),
1575 |             Token(value: "}}", type: .closeExpression),
1576 |             Token(value: "|", type: .text),
1577 |             Token(value: "{{", type: .openExpression),
1578 |             Token(value: "true", type: .booleanLiteral),
1579 |             Token(value: "and", type: .and),
1580 |             Token(value: "0", type: .numericLiteral),
1581 |             Token(value: "}}", type: .closeExpression),
1582 |             Token(value: "|", type: .text),
1583 |             Token(value: "{{", type: .openExpression),
1584 |             Token(value: "false", type: .booleanLiteral),
1585 |             Token(value: "and", type: .and),
1586 |             Token(value: "1", type: .numericLiteral),
1587 |             Token(value: "}}", type: .closeExpression),
1588 |             Token(value: "|", type: .text),
1589 |             Token(value: "{{", type: .openExpression),
1590 |             Token(value: "false", type: .booleanLiteral),
1591 |             Token(value: "and", type: .and),
1592 |             Token(value: "0", type: .numericLiteral),
1593 |             Token(value: "}}", type: .closeExpression),
1594 |             Token(value: "|", type: .text),
1595 |             Token(value: "{{", type: .openExpression),
1596 |             Token(value: "true", type: .booleanLiteral),
1597 |             Token(value: "or", type: .or),
1598 |             Token(value: "1", type: .numericLiteral),
1599 |             Token(value: "}}", type: .closeExpression),
1600 |             Token(value: "|", type: .text),
1601 |             Token(value: "{{", type: .openExpression),
1602 |             Token(value: "true", type: .booleanLiteral),
1603 |             Token(value: "or", type: .or),
1604 |             Token(value: "0", type: .numericLiteral),
1605 |             Token(value: "}}", type: .closeExpression),
1606 |             Token(value: "|", type: .text),
1607 |             Token(value: "{{", type: .openExpression),
1608 |             Token(value: "false", type: .booleanLiteral),
1609 |             Token(value: "or", type: .or),
1610 |             Token(value: "1", type: .numericLiteral),
1611 |             Token(value: "}}", type: .closeExpression),
1612 |             Token(value: "|", type: .text),
1613 |             Token(value: "{{", type: .openExpression),
1614 |             Token(value: "false", type: .booleanLiteral),
1615 |             Token(value: "or", type: .or),
1616 |             Token(value: "0", type: .numericLiteral),
1617 |             Token(value: "}}", type: .closeExpression),
1618 |             Token(value: "|", type: .text),
1619 |         ],
1620 |         "BOOLEAN_MIXED_2": [
1621 |             Token(value: "|", type: .text),
1622 |             Token(value: "{{", type: .openExpression),
1623 |             Token(value: "true", type: .booleanLiteral),
1624 |             Token(value: "and", type: .and),
1625 |             Token(value: "", type: .stringLiteral),
1626 |             Token(value: "}}", type: .closeExpression),
1627 |             Token(value: "|", type: .text),
1628 |             Token(value: "{{", type: .openExpression),
1629 |             Token(value: "true", type: .booleanLiteral),
1630 |             Token(value: "and", type: .and),
1631 |             Token(value: "a", type: .stringLiteral),
1632 |             Token(value: "}}", type: .closeExpression),
1633 |             Token(value: "|", type: .text),
1634 |             Token(value: "{{", type: .openExpression),
1635 |             Token(value: "false", type: .booleanLiteral),
1636 |             Token(value: "or", type: .or),
1637 |             Token(value: "", type: .stringLiteral),
1638 |             Token(value: "}}", type: .closeExpression),
1639 |             Token(value: "|", type: .text),
1640 |             Token(value: "{{", type: .openExpression),
1641 |             Token(value: "false", type: .booleanLiteral),
1642 |             Token(value: "or", type: .or),
1643 |             Token(value: "a", type: .stringLiteral),
1644 |             Token(value: "}}", type: .closeExpression),
1645 |             Token(value: "|", type: .text),
1646 |             Token(value: "{{", type: .openExpression),
1647 |             Token(value: "", type: .stringLiteral),
1648 |             Token(value: "and", type: .and),
1649 |             Token(value: "true", type: .booleanLiteral),
1650 |             Token(value: "}}", type: .closeExpression),
1651 |             Token(value: "|", type: .text),
1652 |             Token(value: "{{", type: .openExpression),
1653 |             Token(value: "a", type: .stringLiteral),
1654 |             Token(value: "and", type: .and),
1655 |             Token(value: "true", type: .booleanLiteral),
1656 |             Token(value: "}}", type: .closeExpression),
1657 |             Token(value: "|", type: .text),
1658 |             Token(value: "{{", type: .openExpression),
1659 |             Token(value: "", type: .stringLiteral),
1660 |             Token(value: "or", type: .or),
1661 |             Token(value: "false", type: .booleanLiteral),
1662 |             Token(value: "}}", type: .closeExpression),
1663 |             Token(value: "|", type: .text),
1664 |             Token(value: "{{", type: .openExpression),
1665 |             Token(value: "a", type: .stringLiteral),
1666 |             Token(value: "or", type: .or),
1667 |             Token(value: "false", type: .booleanLiteral),
1668 |             Token(value: "}}", type: .closeExpression),
1669 |             Token(value: "|", type: .text),
1670 |         ],
1671 |         "BOOLEAN_MIXED_IF": [
1672 |             Token(value: "{%", type: .openStatement),
1673 |             Token(value: "if", type: .if),
1674 |             Token(value: "", type: .stringLiteral),
1675 |             Token(value: "%}", type: .closeStatement),
1676 |             Token(value: "{{", type: .openExpression),
1677 |             Token(value: "A", type: .stringLiteral),
1678 |             Token(value: "}}", type: .closeExpression),
1679 |             Token(value: "{%", type: .openStatement),
1680 |             Token(value: "endif", type: .endIf),
1681 |             Token(value: "%}", type: .closeStatement),
1682 |             Token(value: "{%", type: .openStatement),
1683 |             Token(value: "if", type: .if),
1684 |             Token(value: "a", type: .stringLiteral),
1685 |             Token(value: "%}", type: .closeStatement),
1686 |             Token(value: "{{", type: .openExpression),
1687 |             Token(value: "B", type: .stringLiteral),
1688 |             Token(value: "}}", type: .closeExpression),
1689 |             Token(value: "{%", type: .openStatement),
1690 |             Token(value: "endif", type: .endIf),
1691 |             Token(value: "%}", type: .closeStatement),
1692 |             Token(value: "{%", type: .openStatement),
1693 |             Token(value: "if", type: .if),
1694 |             Token(value: "true", type: .booleanLiteral),
1695 |             Token(value: "and", type: .and),
1696 |             Token(value: "", type: .stringLiteral),
1697 |             Token(value: "%}", type: .closeStatement),
1698 |             Token(value: "{{", type: .openExpression),
1699 |             Token(value: "C", type: .stringLiteral),
1700 |             Token(value: "}}", type: .closeExpression),
1701 |             Token(value: "{%", type: .openStatement),
1702 |             Token(value: "endif", type: .endIf),
1703 |             Token(value: "%}", type: .closeStatement),
1704 |             Token(value: "{%", type: .openStatement),
1705 |             Token(value: "if", type: .if),
1706 |             Token(value: "true", type: .booleanLiteral),
1707 |             Token(value: "and", type: .and),
1708 |             Token(value: "a", type: .stringLiteral),
1709 |             Token(value: "%}", type: .closeStatement),
1710 |             Token(value: "{{", type: .openExpression),
1711 |             Token(value: "D", type: .stringLiteral),
1712 |             Token(value: "}}", type: .closeExpression),
1713 |             Token(value: "{%", type: .openStatement),
1714 |             Token(value: "endif", type: .endIf),
1715 |             Token(value: "%}", type: .closeStatement),
1716 |         ],
1717 | 
1718 |         // Tests (is operator)
1719 |         "IS_OPERATOR": [
1720 |             Token(value: "|", type: .text),
1721 |             Token(value: "{{", type: .openExpression),
1722 |             Token(value: "unknown_var", type: .identifier),
1723 |             Token(value: "is", type: .is),
1724 |             Token(value: "defined", type: .identifier),
1725 |             Token(value: "}}", type: .closeExpression),
1726 |             Token(value: "|", type: .text),
1727 |             Token(value: "{{", type: .openExpression),
1728 |             Token(value: "unknown_var", type: .identifier),
1729 |             Token(value: "is", type: .is),
1730 |             Token(value: "not", type: .not),
1731 |             Token(value: "defined", type: .identifier),
1732 |             Token(value: "}}", type: .closeExpression),
1733 |             Token(value: "|", type: .text),
1734 |             Token(value: "{{", type: .openExpression),
1735 |             Token(value: "known_var", type: .identifier),
1736 |             Token(value: "is", type: .is),
1737 |             Token(value: "defined", type: .identifier),
1738 |             Token(value: "}}", type: .closeExpression),
1739 |             Token(value: "|", type: .text),
1740 |             Token(value: "{{", type: .openExpression),
1741 |             Token(value: "known_var", type: .identifier),
1742 |             Token(value: "is", type: .is),
1743 |             Token(value: "not", type: .not),
1744 |             Token(value: "defined", type: .identifier),
1745 |             Token(value: "}}", type: .closeExpression),
1746 |             Token(value: "|", type: .text),
1747 |         ],
1748 |         "IS_OPERATOR_2": [
1749 |             Token(value: "|", type: .text),
1750 |             Token(value: "{{", type: .openExpression),
1751 |             Token(value: "true", type: .booleanLiteral),
1752 |             Token(value: "is", type: .is),
1753 |             Token(value: "true", type: .booleanLiteral),
1754 |             Token(value: "}}", type: .closeExpression),
1755 |             Token(value: "|", type: .text),
1756 |             Token(value: "{{", type: .openExpression),
1757 |             Token(value: "true", type: .booleanLiteral),
1758 |             Token(value: "is", type: .is),
1759 |             Token(value: "not", type: .not),
1760 |             Token(value: "true", type: .booleanLiteral),
1761 |             Token(value: "}}", type: .closeExpression),
1762 |             Token(value: "|", type: .text),
1763 |             Token(value: "{{", type: .openExpression),
1764 |             Token(value: "true", type: .booleanLiteral),
1765 |             Token(value: "is", type: .is),
1766 |             Token(value: "false", type: .booleanLiteral),
1767 |             Token(value: "}}", type: .closeExpression),
1768 |             Token(value: "|", type: .text),
1769 |             Token(value: "{{", type: .openExpression),
1770 |             Token(value: "true", type: .booleanLiteral),
1771 |             Token(value: "is", type: .is),
1772 |             Token(value: "not", type: .not),
1773 |             Token(value: "false", type: .booleanLiteral),
1774 |             Token(value: "}}", type: .closeExpression),
1775 |             Token(value: "|", type: .text),
1776 |             Token(value: "{{", type: .openExpression),
1777 |             Token(value: "true", type: .booleanLiteral),
1778 |             Token(value: "is", type: .is),
1779 |             Token(value: "boolean", type: .identifier),
1780 |             Token(value: "}}", type: .closeExpression),
1781 |             Token(value: "|", type: .text),
1782 |             Token(value: "{{", type: .openExpression),
1783 |             Token(value: "1", type: .numericLiteral),
1784 |             Token(value: "is", type: .is),
1785 |             Token(value: "boolean", type: .identifier),
1786 |             Token(value: "}}", type: .closeExpression),
1787 |             Token(value: "|", type: .text),
1788 |         ],
1789 |         "IS_OPERATOR_3": [
1790 |             Token(value: "|", type: .text),
1791 |             Token(value: "{{", type: .openExpression),
1792 |             Token(value: "1", type: .numericLiteral),
1793 |             Token(value: "is", type: .is),
1794 |             Token(value: "odd", type: .identifier),
1795 |             Token(value: "}}", type: .closeExpression),
1796 |             Token(value: "|", type: .text),
1797 |             Token(value: "{{", type: .openExpression),
1798 |             Token(value: "2", type: .numericLiteral),
1799 |             Token(value: "is", type: .is),
1800 |             Token(value: "odd", type: .identifier),
1801 |             Token(value: "}}", type: .closeExpression),
1802 |             Token(value: "|", type: .text),
1803 |             Token(value: "{{", type: .openExpression),
1804 |             Token(value: "1", type: .numericLiteral),
1805 |             Token(value: "is", type: .is),
1806 |             Token(value: "even", type: .identifier),
1807 |             Token(value: "}}", type: .closeExpression),
1808 |             Token(value: "|", type: .text),
1809 |             Token(value: "{{", type: .openExpression),
1810 |             Token(value: "2", type: .numericLiteral),
1811 |             Token(value: "is", type: .is),
1812 |             Token(value: "even", type: .identifier),
1813 |             Token(value: "}}", type: .closeExpression),
1814 |             Token(value: "|", type: .text),
1815 |             Token(value: "{{", type: .openExpression),
1816 |             Token(value: "2", type: .numericLiteral),
1817 |             Token(value: "is", type: .is),
1818 |             Token(value: "number", type: .identifier),
1819 |             Token(value: "}}", type: .closeExpression),
1820 |             Token(value: "|", type: .text),
1821 |             Token(value: "{{", type: .openExpression),
1822 |             Token(value: "2", type: .stringLiteral),
1823 |             Token(value: "is", type: .is),
1824 |             Token(value: "number", type: .identifier),
1825 |             Token(value: "}}", type: .closeExpression),
1826 |             Token(value: "|", type: .text),
1827 |             Token(value: "{{", type: .openExpression),
1828 |             Token(value: "2", type: .numericLiteral),
1829 |             Token(value: "is", type: .is),
1830 |             Token(value: "integer", type: .identifier),
1831 |             Token(value: "}}", type: .closeExpression),
1832 |             Token(value: "|", type: .text),
1833 |             Token(value: "{{", type: .openExpression),
1834 |             Token(value: "2", type: .stringLiteral),
1835 |             Token(value: "is", type: .is),
1836 |             Token(value: "integer", type: .identifier),
1837 |             Token(value: "}}", type: .closeExpression),
1838 |             Token(value: "|", type: .text),
1839 |         ],
1840 |         "IS_OPERATOR_4": [
1841 |             Token(value: "|", type: .text),
1842 |             Token(value: "{{", type: .openExpression),
1843 |             Token(value: "func", type: .identifier),
1844 |             Token(value: "is", type: .is),
1845 |             Token(value: "callable", type: .identifier),
1846 |             Token(value: "}}", type: .closeExpression),
1847 |             Token(value: "|", type: .text),
1848 |             Token(value: "{{", type: .openExpression),
1849 |             Token(value: "2", type: .numericLiteral),
1850 |             Token(value: "is", type: .is),
1851 |             Token(value: "callable", type: .identifier),
1852 |             Token(value: "}}", type: .closeExpression),
1853 |             Token(value: "|", type: .text),
1854 |             Token(value: "{{", type: .openExpression),
1855 |             Token(value: "1", type: .numericLiteral),
1856 |             Token(value: "is", type: .is),
1857 |             Token(value: "iterable", type: .identifier),
1858 |             Token(value: "}}", type: .closeExpression),
1859 |             Token(value: "|", type: .text),
1860 |             Token(value: "{{", type: .openExpression),
1861 |             Token(value: "hello", type: .stringLiteral),
1862 |             Token(value: "is", type: .is),
1863 |             Token(value: "iterable", type: .identifier),
1864 |             Token(value: "}}", type: .closeExpression),
1865 |             Token(value: "|", type: .text),
1866 |         ],
1867 |         "IS_OPERATOR_5": [
1868 |             Token(value: "|", type: .text),
1869 |             Token(value: "{{", type: .openExpression),
1870 |             Token(value: "a", type: .stringLiteral),
1871 |             Token(value: "is", type: .is),
1872 |             Token(value: "lower", type: .identifier),
1873 |             Token(value: "}}", type: .closeExpression),
1874 |             Token(value: "|", type: .text),
1875 |             Token(value: "{{", type: .openExpression),
1876 |             Token(value: "A", type: .stringLiteral),
1877 |             Token(value: "is", type: .is),
1878 |             Token(value: "lower", type: .identifier),
1879 |             Token(value: "}}", type: .closeExpression),
1880 |             Token(value: "|", type: .text),
1881 |             Token(value: "{{", type: .openExpression),
1882 |             Token(value: "a", type: .stringLiteral),
1883 |             Token(value: "is", type: .is),
1884 |             Token(value: "upper", type: .identifier),
1885 |             Token(value: "}}", type: .closeExpression),
1886 |             Token(value: "|", type: .text),
1887 |             Token(value: "{{", type: .openExpression),
1888 |             Token(value: "A", type: .stringLiteral),
1889 |             Token(value: "is", type: .is),
1890 |             Token(value: "upper", type: .identifier),
1891 |             Token(value: "}}", type: .closeExpression),
1892 |             Token(value: "|", type: .text),
1893 |         ],
1894 | 
1895 |         // Short-circuit evaluation
1896 |         "SHORT_CIRCUIT": [
1897 |             Token(value: "{{", type: .openExpression),
1898 |             Token(value: "false", type: .booleanLiteral),
1899 |             Token(value: "and", type: .and),
1900 |             Token(value: "raise_exception", type: .identifier),
1901 |             Token(value: "(", type: .openParen),
1902 |             Token(value: "This should not be printed", type: .stringLiteral),
1903 |             Token(value: ")", type: .closeParen),
1904 |             Token(value: "}}", type: .closeExpression),
1905 |         ],
1906 |         "SHORT_CIRCUIT_1": [
1907 |             Token(value: "{{", type: .openExpression),
1908 |             Token(value: "true", type: .booleanLiteral),
1909 |             Token(value: "or", type: .or),
1910 |             Token(value: "raise_exception", type: .identifier),
1911 |             Token(value: "(", type: .openParen),
1912 |             Token(value: "This should not be printed", type: .stringLiteral),
1913 |             Token(value: ")", type: .closeParen),
1914 |             Token(value: "}}", type: .closeExpression),
1915 |         ],
1916 | 
1917 |         // Namespaces
1918 |         "NAMESPACE": [
1919 |             Token(value: "{%", type: .openStatement),
1920 |             Token(value: "set", type: .set),
1921 |             Token(value: "ns", type: .identifier),
1922 |             Token(value: "=", type: .equals),
1923 |             Token(value: "namespace", type: .identifier),
1924 |             Token(value: "(", type: .openParen),
1925 |             Token(value: ")", type: .closeParen),
1926 |             Token(value: "%}", type: .closeStatement),
1927 |             Token(value: "{%", type: .openStatement),
1928 |             Token(value: "set", type: .set),
1929 |             Token(value: "ns", type: .identifier),
1930 |             Token(value: ".", type: .dot),
1931 |             Token(value: "foo", type: .identifier),
1932 |             Token(value: "=", type: .equals),
1933 |             Token(value: "bar", type: .stringLiteral),
1934 |             Token(value: "%}", type: .closeStatement),
1935 |             Token(value: "{{", type: .openExpression),
1936 |             Token(value: "ns", type: .identifier),
1937 |             Token(value: ".", type: .dot),
1938 |             Token(value: "foo", type: .identifier),
1939 |             Token(value: "}}", type: .closeExpression),
1940 |         ],
1941 |         "NAMESPACE_1": [
1942 |             Token(value: "{%", type: .openStatement),
1943 |             Token(value: "set", type: .set),
1944 |             Token(value: "ns", type: .identifier),
1945 |             Token(value: "=", type: .equals),
1946 |             Token(value: "namespace", type: .identifier),
1947 |             Token(value: "(", type: .openParen),
1948 |             Token(value: "default", type: .identifier),
1949 |             Token(value: "=", type: .equals),
1950 |             Token(value: "false", type: .booleanLiteral),
1951 |             Token(value: ")", type: .closeParen),
1952 |             Token(value: "%}", type: .closeStatement),
1953 |             Token(value: "{{", type: .openExpression),
1954 |             Token(value: "ns", type: .identifier),
1955 |             Token(value: ".", type: .dot),
1956 |             Token(value: "default", type: .identifier),
1957 |             Token(value: "}}", type: .closeExpression),
1958 |         ],
1959 |         "NAMESPACE_2": [
1960 |             Token(value: "{%", type: .openStatement),
1961 |             Token(value: "set", type: .set),
1962 |             Token(value: "ns", type: .identifier),
1963 |             Token(value: "=", type: .equals),
1964 |             Token(value: "namespace", type: .identifier),
1965 |             Token(value: "(", type: .openParen),
1966 |             Token(value: "default", type: .identifier),
1967 |             Token(value: "=", type: .equals),
1968 |             Token(value: "false", type: .booleanLiteral),
1969 |             Token(value: ",", type: .comma),
1970 |             Token(value: "number", type: .identifier),
1971 |             Token(value: "=", type: .equals),
1972 |             Token(value: "1", type: .numericLiteral),
1973 |             Token(value: "+", type: .additiveBinaryOperator),
1974 |             Token(value: "1", type: .numericLiteral),
1975 |             Token(value: ")", type: .closeParen),
1976 |             Token(value: "%}", type: .closeStatement),
1977 |             Token(value: "|", type: .text),
1978 |             Token(value: "{{", type: .openExpression),
1979 |             Token(value: "ns", type: .identifier),
1980 |             Token(value: ".", type: .dot),
1981 |             Token(value: "default", type: .identifier),
1982 |             Token(value: "}}", type: .closeExpression),
1983 |             Token(value: "|", type: .text),
1984 |             Token(value: "{{", type: .openExpression),
1985 |             Token(value: "ns", type: .identifier),
1986 |             Token(value: ".", type: .dot),
1987 |             Token(value: "number", type: .identifier),
1988 |             Token(value: "}}", type: .closeExpression),
1989 |             Token(value: "|", type: .text),
1990 |         ],
1991 | 
1992 |         // Object operators
1993 |         "OBJECT_OPERATORS": [
1994 |             Token(value: "|", type: .text),
1995 |             Token(value: "{{", type: .openExpression),
1996 |             Token(value: "known", type: .stringLiteral),
1997 |             Token(value: "in", type: .in),
1998 |             Token(value: "obj", type: .identifier),
1999 |             Token(value: "}}", type: .closeExpression),
2000 |             Token(value: "|", type: .text),
2001 |             Token(value: "{{", type: .openExpression),
2002 |             Token(value: "known", type: .stringLiteral),
2003 |             Token(value: "not in", type: .notIn),
2004 |             Token(value: "obj", type: .identifier),
2005 |             Token(value: "}}", type: .closeExpression),
2006 |             Token(value: "|", type: .text),
2007 |             Token(value: "{{", type: .openExpression),
2008 |             Token(value: "unknown", type: .stringLiteral),
2009 |             Token(value: "in", type: .in),
2010 |             Token(value: "obj", type: .identifier),
2011 |             Token(value: "}}", type: .closeExpression),
2012 |             Token(value: "|", type: .text),
2013 |             Token(value: "{{", type: .openExpression),
2014 |             Token(value: "unknown", type: .stringLiteral),
2015 |             Token(value: "not in", type: .notIn),
2016 |             Token(value: "obj", type: .identifier),
2017 |             Token(value: "}}", type: .closeExpression),
2018 |             Token(value: "|", type: .text),
2019 |         ],
2020 |         "OBJECT_OPERATORS_1": [
2021 |             Token(value: "|", type: .text),
2022 |             Token(value: "{{", type: .openExpression),
2023 |             Token(value: "obj", type: .identifier),
2024 |             Token(value: ".", type: .dot),
2025 |             Token(value: "get", type: .identifier),
2026 |             Token(value: "(", type: .openParen),
2027 |             Token(value: "known", type: .stringLiteral),
2028 |             Token(value: ")", type: .closeParen),
2029 |             Token(value: "}}", type: .closeExpression),
2030 |             Token(value: "|", type: .text),
2031 |             Token(value: "{{", type: .openExpression),
2032 |             Token(value: "obj", type: .identifier),
2033 |             Token(value: ".", type: .dot),
2034 |             Token(value: "get", type: .identifier),
2035 |             Token(value: "(", type: .openParen),
2036 |             Token(value: "unknown", type: .stringLiteral),
2037 |             Token(value: ")", type: .closeParen),
2038 |             Token(value: "is", type: .is),
2039 |             Token(value: "none", type: .nullLiteral),
2040 |             Token(value: "}}", type: .closeExpression),
2041 |             Token(value: "|", type: .text),
2042 |             Token(value: "{{", type: .openExpression),
2043 |             Token(value: "obj", type: .identifier),
2044 |             Token(value: ".", type: .dot),
2045 |             Token(value: "get", type: .identifier),
2046 |             Token(value: "(", type: .openParen),
2047 |             Token(value: "unknown", type: .stringLiteral),
2048 |             Token(value: ")", type: .closeParen),
2049 |             Token(value: "is", type: .is),
2050 |             Token(value: "defined", type: .identifier),
2051 |             Token(value: "}}", type: .closeExpression),
2052 |             Token(value: "|", type: .text),
2053 |         ],
2054 |         "OBJECT_OPERATORS_2": [
2055 |             Token(value: "|", type: .text),
2056 |             Token(value: "{%", type: .openStatement),
2057 |             Token(value: "for", type: .for),
2058 |             Token(value: "x", type: .identifier),
2059 |             Token(value: ",", type: .comma),
2060 |             Token(value: "y", type: .identifier),
2061 |             Token(value: "in", type: .in),
2062 |             Token(value: "obj", type: .identifier),
2063 |             Token(value: ".", type: .dot),
2064 |             Token(value: "items", type: .identifier),
2065 |             Token(value: "(", type: .openParen),
2066 |             Token(value: ")", type: .closeParen),
2067 |             Token(value: "%}", type: .closeStatement),
2068 |             Token(value: "|", type: .text),
2069 |             Token(value: "{{", type: .openExpression),
2070 |             Token(value: "x", type: .identifier),
2071 |             Token(value: "+", type: .additiveBinaryOperator),
2072 |             Token(value: " ", type: .stringLiteral),
2073 |             Token(value: "+", type: .additiveBinaryOperator),
2074 |             Token(value: "y", type: .identifier),
2075 |             Token(value: "}}", type: .closeExpression),
2076 |             Token(value: "|", type: .text),
2077 |             Token(value: "{%", type: .openStatement),
2078 |             Token(value: "endfor", type: .endFor),
2079 |             Token(value: "%}", type: .closeStatement),
2080 |             Token(value: "|", type: .text),
2081 |         ],
2082 | 
2083 |         // Scope
2084 |         "SCOPE": [
2085 |             Token(value: "{%", type: .openStatement),
2086 |             Token(value: "set", type: .set),
2087 |             Token(value: "ns", type: .identifier),
2088 |             Token(value: "=", type: .equals),
2089 |             Token(value: "namespace", type: .identifier),
2090 |             Token(value: "(", type: .openParen),
2091 |             Token(value: "found", type: .identifier),
2092 |             Token(value: "=", type: .equals),
2093 |             Token(value: "false", type: .booleanLiteral),
2094 |             Token(value: ")", type: .closeParen),
2095 |             Token(value: "%}", type: .closeStatement),
2096 |             Token(value: "{%", type: .openStatement),
2097 |             Token(value: "for", type: .for),
2098 |             Token(value: "num", type: .identifier),
2099 |             Token(value: "in", type: .in),
2100 |             Token(value: "nums", type: .identifier),
2101 |             Token(value: "%}", type: .closeStatement),
2102 |             Token(value: "{%", type: .openStatement),
2103 |             Token(value: "if", type: .if),
2104 |             Token(value: "num", type: .identifier),
2105 |             Token(value: "==", type: .comparisonBinaryOperator),
2106 |             Token(value: "1", type: .numericLiteral),
2107 |             Token(value: "%}", type: .closeStatement),
2108 |             Token(value: "{{", type: .openExpression),
2109 |             Token(value: "found=", type: .stringLiteral),
2110 |             Token(value: "}}", type: .closeExpression),
2111 |             Token(value: "{%", type: .openStatement),
2112 |             Token(value: "set", type: .set),
2113 |             Token(value: "ns", type: .identifier),
2114 |             Token(value: ".", type: .dot),
2115 |             Token(value: "found", type: .identifier),
2116 |             Token(value: "=", type: .equals),
2117 |             Token(value: "true", type: .booleanLiteral),
2118 |             Token(value: "%}", type: .closeStatement),
2119 |             Token(value: "{%", type: .openStatement),
2120 |             Token(value: "endif", type: .endIf),
2121 |             Token(value: "%}", type: .closeStatement),
2122 |             Token(value: "{%", type: .openStatement),
2123 |             Token(value: "endfor", type: .endFor),
2124 |             Token(value: "%}", type: .closeStatement),
2125 |             Token(value: "{{", type: .openExpression),
2126 |             Token(value: "ns", type: .identifier),
2127 |             Token(value: ".", type: .dot),
2128 |             Token(value: "found", type: .identifier),
2129 |             Token(value: "}}", type: .closeExpression),
2130 |         ],
2131 |         "SCOPE_1": [
2132 |             Token(value: "{%", type: .openStatement),
2133 |             Token(value: "set", type: .set),
2134 |             Token(value: "found", type: .identifier),
2135 |             Token(value: "=", type: .equals),
2136 |             Token(value: "false", type: .booleanLiteral),
2137 |             Token(value: "%}", type: .closeStatement),
2138 |             Token(value: "{%", type: .openStatement),
2139 |             Token(value: "for", type: .for),
2140 |             Token(value: "num", type: .identifier),
2141 |             Token(value: "in", type: .in),
2142 |             Token(value: "nums", type: .identifier),
2143 |             Token(value: "%}", type: .closeStatement),
2144 |             Token(value: "{%", type: .openStatement),
2145 |             Token(value: "if", type: .if),
2146 |             Token(value: "num", type: .identifier),
2147 |             Token(value: "==", type: .comparisonBinaryOperator),
2148 |             Token(value: "1", type: .numericLiteral),
2149 |             Token(value: "%}", type: .closeStatement),
2150 |             Token(value: "{{", type: .openExpression),
2151 |             Token(value: "found=", type: .stringLiteral),
2152 |             Token(value: "}}", type: .closeExpression),
2153 |             Token(value: "{%", type: .openStatement),
2154 |             Token(value: "set", type: .set),
2155 |             Token(value: "found", type: .identifier),
2156 |             Token(value: "=", type: .equals),
2157 |             Token(value: "true", type: .booleanLiteral),
2158 |             Token(value: "%}", type: .closeStatement),
2159 |             Token(value: "{%", type: .openStatement),
2160 |             Token(value: "endif", type: .endIf),
2161 |             Token(value: "%}", type: .closeStatement),
2162 |             Token(value: "{%", type: .openStatement),
2163 |             Token(value: "endfor", type: .endFor),
2164 |             Token(value: "%}", type: .closeStatement),
2165 |             Token(value: "{{", type: .openExpression),
2166 |             Token(value: "found", type: .identifier),
2167 |             Token(value: "}}", type: .closeExpression),
2168 |         ],
2169 | 
2170 |         // Undefined
2171 |         "UNDEFINED_VARIABLES": [
2172 |             Token(value: "{{", type: .openExpression),
2173 |             Token(value: "undefined_variable", type: .identifier),
2174 |             Token(value: "}}", type: .closeExpression),
2175 |         ],
2176 |         "UNDEFINED_ACCESS": [
2177 |             Token(value: "{{", type: .openExpression),
2178 |             Token(value: "object", type: .identifier),
2179 |             Token(value: ".", type: .dot),
2180 |             Token(value: "undefined_attribute", type: .identifier),
2181 |             Token(value: "}}", type: .closeExpression),
2182 |         ],
2183 | 
2184 |         // Null
2185 |         "NULL_VARIABLE": [
2186 |             Token(value: "{%", type: .openStatement),
2187 |             Token(value: "if", type: .if),
2188 |             Token(value: "not", type: .not),
2189 |             Token(value: "null_val", type: .identifier),
2190 |             Token(value: "is", type: .is),
2191 |             Token(value: "defined", type: .identifier),
2192 |             Token(value: "%}", type: .closeStatement),
2193 |             Token(value: "{%", type: .openStatement),
2194 |             Token(value: "set", type: .set),
2195 |             Token(value: "null_val", type: .identifier),
2196 |             Token(value: "=", type: .equals),
2197 |             Token(value: "none", type: .nullLiteral),
2198 |             Token(value: "%}", type: .closeStatement),
2199 |             Token(value: "{%", type: .openStatement),
2200 |             Token(value: "endif", type: .endIf),
2201 |             Token(value: "%}", type: .closeStatement),
2202 |             Token(value: "{%", type: .openStatement),
2203 |             Token(value: "if", type: .if),
2204 |             Token(value: "null_val", type: .identifier),
2205 |             Token(value: "is", type: .is),
2206 |             Token(value: "not", type: .not),
2207 |             Token(value: "none", type: .nullLiteral),
2208 |             Token(value: "%}", type: .closeStatement),
2209 |             Token(value: "{{", type: .openExpression),
2210 |             Token(value: "fail", type: .stringLiteral),
2211 |             Token(value: "}}", type: .closeExpression),
2212 |             Token(value: "{%", type: .openStatement),
2213 |             Token(value: "else", type: .else),
2214 |             Token(value: "%}", type: .closeStatement),
2215 |             Token(value: "{{", type: .openExpression),
2216 |             Token(value: "pass", type: .stringLiteral),
2217 |             Token(value: "}}", type: .closeExpression),
2218 |             Token(value: "{%", type: .openStatement),
2219 |             Token(value: "endif", type: .endIf),
2220 |             Token(value: "%}", type: .closeStatement),
2221 |         ],
2222 | 
2223 |         // Ternary operator
2224 |         "TERNARY_OPERATOR": [
2225 |             Token(value: "|", type: .text),
2226 |             Token(value: "{{", type: .openExpression),
2227 |             Token(value: "a", type: .stringLiteral),
2228 |             Token(value: "if", type: .if),
2229 |             Token(value: "true", type: .booleanLiteral),
2230 |             Token(value: "else", type: .else),
2231 |             Token(value: "b", type: .stringLiteral),
2232 |             Token(value: "}}", type: .closeExpression),
2233 |             Token(value: "|", type: .text),
2234 |             Token(value: "{{", type: .openExpression),
2235 |             Token(value: "a", type: .stringLiteral),
2236 |             Token(value: "if", type: .if),
2237 |             Token(value: "false", type: .booleanLiteral),
2238 |             Token(value: "else", type: .else),
2239 |             Token(value: "b", type: .stringLiteral),
2240 |             Token(value: "}}", type: .closeExpression),
2241 |             Token(value: "|", type: .text),
2242 |             Token(value: "{{", type: .openExpression),
2243 |             Token(value: "a", type: .stringLiteral),
2244 |             Token(value: "if", type: .if),
2245 |             Token(value: "1", type: .numericLiteral),
2246 |             Token(value: "+", type: .additiveBinaryOperator),
2247 |             Token(value: "1", type: .numericLiteral),
2248 |             Token(value: "==", type: .comparisonBinaryOperator),
2249 |             Token(value: "2", type: .numericLiteral),
2250 |             Token(value: "else", type: .else),
2251 |             Token(value: "b", type: .stringLiteral),
2252 |             Token(value: "}}", type: .closeExpression),
2253 |             Token(value: "|", type: .text),
2254 |             Token(value: "{{", type: .openExpression),
2255 |             Token(value: "a", type: .stringLiteral),
2256 |             Token(value: "if", type: .if),
2257 |             Token(value: "1", type: .numericLiteral),
2258 |             Token(value: "+", type: .additiveBinaryOperator),
2259 |             Token(value: "1", type: .numericLiteral),
2260 |             Token(value: "==", type: .comparisonBinaryOperator),
2261 |             Token(value: "3", type: .numericLiteral),
2262 |             Token(value: "or", type: .or),
2263 |             Token(value: "1", type: .numericLiteral),
2264 |             Token(value: "*", type: .multiplicativeBinaryOperator),
2265 |             Token(value: "2", type: .numericLiteral),
2266 |             Token(value: "==", type: .comparisonBinaryOperator),
2267 |             Token(value: "3", type: .numericLiteral),
2268 |             Token(value: "else", type: .else),
2269 |             Token(value: "b", type: .stringLiteral),
2270 |             Token(value: "}}", type: .closeExpression),
2271 |             Token(value: "|", type: .text),
2272 |         ],
2273 | 
2274 |         // Array literals
2275 |         "ARRAY_LITERALS": [
2276 |             Token(value: "{{", type: .openExpression),
2277 |             Token(value: "[", type: .openSquareBracket),
2278 |             Token(value: "1", type: .numericLiteral),
2279 |             Token(value: ",", type: .comma),
2280 |             Token(value: "true", type: .booleanLiteral),
2281 |             Token(value: ",", type: .comma),
2282 |             Token(value: "hello", type: .stringLiteral),
2283 |             Token(value: ",", type: .comma),
2284 |             Token(value: "[", type: .openSquareBracket),
2285 |             Token(value: "1", type: .numericLiteral),
2286 |             Token(value: ",", type: .comma),
2287 |             Token(value: "2", type: .numericLiteral),
2288 |             Token(value: ",", type: .comma),
2289 |             Token(value: "3", type: .numericLiteral),
2290 |             Token(value: ",", type: .comma),
2291 |             Token(value: "4", type: .numericLiteral),
2292 |             Token(value: "]", type: .closeSquareBracket),
2293 |             Token(value: ",", type: .comma),
2294 |             Token(value: "var", type: .identifier),
2295 |             Token(value: "]", type: .closeSquareBracket),
2296 |             Token(value: "|", type: .pipe),
2297 |             Token(value: "length", type: .identifier),
2298 |             Token(value: "}}", type: .closeExpression),
2299 |         ],
2300 | 
2301 |         // Tuple literals
2302 |         "TUPLE_LITERALS": [
2303 |             Token(value: "{{", type: .openExpression),
2304 |             Token(value: "(", type: .openParen),
2305 |             Token(value: "1", type: .numericLiteral),
2306 |             Token(value: ",", type: .comma),
2307 |             Token(value: "(", type: .openParen),
2308 |             Token(value: "1", type: .numericLiteral),
2309 |             Token(value: ",", type: .comma),
2310 |             Token(value: "2", type: .numericLiteral),
2311 |             Token(value: ")", type: .closeParen),
2312 |             Token(value: ")", type: .closeParen),
2313 |             Token(value: "|", type: .pipe),
2314 |             Token(value: "length", type: .identifier),
2315 |             Token(value: "}}", type: .closeExpression),
2316 |         ],
2317 | 
2318 |         // Object literals
2319 |         "OBJECT_LITERALS": [
2320 |             Token(value: "{{", type: .openExpression),
2321 |             Token(value: "{", type: .openCurlyBracket),
2322 |             Token(value: "key", type: .stringLiteral),
2323 |             Token(value: ":", type: .colon),
2324 |             Token(value: "value", type: .stringLiteral),
2325 |             Token(value: ",", type: .comma),
2326 |             Token(value: "key", type: .identifier),
2327 |             Token(value: ":", type: .colon),
2328 |             Token(value: "value2", type: .stringLiteral),
2329 |             Token(value: ",", type: .comma),
2330 |             Token(value: "key3", type: .stringLiteral),
2331 |             Token(value: ":", type: .colon),
2332 |             Token(value: "[", type: .openSquareBracket),
2333 |             Token(value: "1", type: .numericLiteral),
2334 |             Token(value: ",", type: .comma),
2335 |             Token(value: "{", type: .openCurlyBracket),
2336 |             Token(value: "foo", type: .stringLiteral),
2337 |             Token(value: ":", type: .colon),
2338 |             Token(value: "bar", type: .stringLiteral),
2339 |             Token(value: "}", type: .closeCurlyBracket),
2340 |             Token(value: "]", type: .closeSquareBracket),
2341 |             Token(value: "}", type: .closeCurlyBracket),
2342 |             Token(value: "[", type: .openSquareBracket),
2343 |             Token(value: "key", type: .stringLiteral),
2344 |             Token(value: "]", type: .closeSquareBracket),
2345 |             Token(value: "}}", type: .closeExpression),
2346 |         ],
2347 | 
2348 |         // Array operators
2349 |         "ARRAY_OPERATORS": [
2350 |             Token(value: "{{", type: .openExpression),
2351 |             Token(value: "(", type: .openParen),
2352 |             Token(value: "[", type: .openSquareBracket),
2353 |             Token(value: "1", type: .numericLiteral),
2354 |             Token(value: ",", type: .comma),
2355 |             Token(value: "2", type: .numericLiteral),
2356 |             Token(value: ",", type: .comma),
2357 |             Token(value: "3", type: .numericLiteral),
2358 |             Token(value: "]", type: .closeSquareBracket),
2359 |             Token(value: "+", type: .additiveBinaryOperator),
2360 |             Token(value: "[", type: .openSquareBracket),
2361 |             Token(value: "4", type: .numericLiteral),
2362 |             Token(value: ",", type: .comma),
2363 |             Token(value: "5", type: .numericLiteral),
2364 |             Token(value: ",", type: .comma),
2365 |             Token(value: "6", type: .numericLiteral),
2366 |             Token(value: "]", type: .closeSquareBracket),
2367 |             Token(value: ")", type: .closeParen),
2368 |             Token(value: "|", type: .pipe),
2369 |             Token(value: "length", type: .identifier),
2370 |             Token(value: "}}", type: .closeExpression),
2371 |         ],
2372 |     ]
2373 | 
2374 |     func testTokenize() throws {
2375 |         for (name, text) in testStrings {
2376 |             let tokens = try tokenize(text)
2377 |             XCTAssertNotNil(testParsed[name], "Test case \(name) not found")
2378 |             XCTAssertEqual(tokens, testParsed[name], "Test case \(name) failed")
2379 |         }
2380 |     }
2381 | }
2382 | 


--------------------------------------------------------------------------------
/Tests/ParseTests.swift:
--------------------------------------------------------------------------------
 1 | //
 2 | //  ParseTests.swift
 3 | //
 4 | //
 5 | //  Created by John Mai on 2024/3/21.
 6 | //
 7 | 
 8 | import XCTest
 9 | 
10 | @testable import Jinja
11 | 
12 | final class ParseTests: XCTestCase {
13 |     func testParse() throws {
14 |         let tokens = try tokenize("Hello world!")
15 |         let parsed = try parse(tokens: tokens)
16 |         XCTAssertEqual((parsed.body.first! as! StringLiteral).value, "Hello world!")
17 |     }
18 | }
19 | 


--------------------------------------------------------------------------------
/Tests/Templates/ChatTemplateTests.swift:
--------------------------------------------------------------------------------
  1 | //
  2 | //  ChatTemplateTests.swift
  3 | //
  4 | //
  5 | //  Created by John Mai on 2024/3/24.
  6 | //
  7 | 
  8 | import XCTest
  9 | 
 10 | @testable import Jinja
 11 | 
 12 | final class ChatTemplateTests: XCTestCase {
 13 |     let messages: [[String: String]] = [
 14 |         [
 15 |             "role": "user",
 16 |             "content": "Hello, how are you?",
 17 |         ],
 18 |         [
 19 |             "role": "assistant",
 20 |             "content": "I'm doing great. How can I help you today?",
 21 |         ],
 22 |         [
 23 |             "role": "user",
 24 |             "content": "I'd like to show off how chat templating works!",
 25 |         ],
 26 |     ]
 27 | 
 28 |     let systemPromptMessage: [String: String] = [
 29 |         "role": "system",
 30 |         "content": "You are a friendly chatbot who always responds in the style of a pirate",
 31 |     ]
 32 | 
 33 |     lazy var messagesWithSystemPrompt: [[String: String]] = [systemPromptMessage] + messages
 34 | 
 35 |     func testGenericChatTemplate() throws {
 36 |         let chatTemplate =
 37 |             "{% for message in messages %}{{'<|im_start|>' + message['role'] + '\n' + message['content'] + '<|im_end|>' + '\n'}}{% endfor %}{% if add_generation_prompt %}{{ '<|im_start|>assistant\n' }}{% endif %}"
 38 |         let template = try Template(chatTemplate)
 39 |         let result = try template.render([
 40 |             "messages": messages,
 41 |             "add_generation_prompt": false,
 42 |         ])
 43 |         let target =
 44 |             "<|im_start|>user\nHello, how are you?<|im_end|>\n<|im_start|>assistant\nI'm doing great. How can I help you today?<|im_end|>\n<|im_start|>user\nI'd like to show off how chat templating works!<|im_end|>\n"
 45 |         XCTAssertEqual(result, target)
 46 |     }
 47 | 
 48 |     func testFacebookBlenderbot400MDistill() throws {
 49 |         let chatTemplate =
 50 |             "{% for message in messages %}{% if message['role'] == 'user' %}{{ ' ' }}{% endif %}{{ message['content'] }}{% if not loop.last %}{{ '  ' }}{% endif %}{% endfor %}{{ eos_token }}"
 51 |         let template = try Template(chatTemplate)
 52 |         let result = try template.render([
 53 |             "messages": messages,
 54 |             "eos_token": "</s>",
 55 |         ])
 56 |         let target =
 57 |             " Hello, how are you?  I'm doing great. How can I help you today?   I'd like to show off how chat templating works!</s>"
 58 |         XCTAssertEqual(result, target)
 59 |     }
 60 | 
 61 |     func testFacebookBlenderbotSmall90M() throws {
 62 |         let chatTemplate =
 63 |             "{% for message in messages %}{% if message['role'] == 'user' %}{{ ' ' }}{% endif %}{{ message['content'] }}{% if not loop.last %}{{ '  ' }}{% endif %}{% endfor %}{{ eos_token }}"
 64 |         let template = try Template(chatTemplate)
 65 |         let result = try template.render([
 66 |             "messages": messages,
 67 |             "eos_token": "</s>",
 68 |         ])
 69 |         let target =
 70 |             " Hello, how are you?  I'm doing great. How can I help you today?   I'd like to show off how chat templating works!</s>"
 71 |         XCTAssertEqual(result, target)
 72 |     }
 73 | 
 74 |     func testBigscienceBloom() throws {
 75 |         let chatTemplate = "{% for message in messages %}{{ message.content }}{{ eos_token }}{% endfor %}"
 76 |         let template = try Template(chatTemplate)
 77 |         let result = try template.render([
 78 |             "messages": messages,
 79 |             "eos_token": "</s>",
 80 |         ])
 81 |         let target =
 82 |             "Hello, how are you?</s>I'm doing great. How can I help you today?</s>I'd like to show off how chat templating works!</s>"
 83 |         XCTAssertEqual(result, target)
 84 |     }
 85 | 
 86 |     func testEleutherAIGptNeox20b() throws {
 87 |         let chatTemplate = "{% for message in messages %}{{ message.content }}{{ eos_token }}{% endfor %}"
 88 |         let template = try Template(chatTemplate)
 89 |         let result = try template.render([
 90 |             "messages": messages,
 91 |             "eos_token": "<|endoftext|>",
 92 |         ])
 93 |         let target =
 94 |             "Hello, how are you?<|endoftext|>I'm doing great. How can I help you today?<|endoftext|>I'd like to show off how chat templating works!<|endoftext|>"
 95 |         XCTAssertEqual(result, target)
 96 |     }
 97 | 
 98 |     func testGPT2() throws {
 99 |         let chatTemplate = "{% for message in messages %}{{ message.content }}{{ eos_token }}{% endfor %}"
100 |         let template = try Template(chatTemplate)
101 |         let result = try template.render([
102 |             "messages": messages,
103 |             "eos_token": "<|endoftext|>",
104 |         ])
105 |         let target =
106 |             "Hello, how are you?<|endoftext|>I'm doing great. How can I help you today?<|endoftext|>I'd like to show off how chat templating works!<|endoftext|>"
107 |         XCTAssertEqual(result, target)
108 |     }
109 | 
110 |     func testHfInternalTestingLlamaTokenizer1() throws {
111 |         let chatTemplate =
112 |             "{% if messages[0]['role'] == 'system' %}{% set loop_messages = messages[1:] %}{% set system_message = messages[0]['content'] %}{% elif USE_DEFAULT_PROMPT == true and not '<<SYS>>' in messages[0]['content'] %}{% set loop_messages = messages %}{% set system_message = 'DEFAULT_SYSTEM_MESSAGE' %}{% else %}{% set loop_messages = messages %}{% set system_message = false %}{% endif %}{% for message in loop_messages %}{% if (message['role'] == 'user') != (loop.index0 % 2 == 0) %}{{ raise_exception('Conversation roles must alternate user/assistant/user/assistant/...') }}{% endif %}{% if loop.index0 == 0 and system_message != false %}{% set content = '<<SYS>>\\n' + system_message + '\\n<</SYS>>\\n\\n' + message['content'] %}{% else %}{% set content = message['content'] %}{% endif %}{% if message['role'] == 'user' %}{{ bos_token + '[INST] ' + content.strip() + ' [/INST]' }}{% elif message['role'] == 'system' %}{{ '<<SYS>>\\n' + content.strip() + '\\n<</SYS>>\\n\\n' }}{% elif message['role'] == 'assistant' %}{{ ' ' + content.strip() + ' ' + eos_token }}{% endif %}{% endfor %}"
113 |         let template = try Template(chatTemplate)
114 |         let result = try template.render([
115 |             "messages": messagesWithSystemPrompt,
116 |             "bos_token": "<s>",
117 |             "eos_token": "</s>",
118 |             "USE_DEFAULT_PROMPT": true,
119 |         ])
120 |         let target =
121 |             "<s>[INST] <<SYS>>\nYou are a friendly chatbot who always responds in the style of a pirate\n<</SYS>>\n\nHello, how are you? [/INST] I'm doing great. How can I help you today? </s><s>[INST] I'd like to show off how chat templating works! [/INST]"
122 |         XCTAssertEqual(result, target)
123 |     }
124 | 
125 |     func testHfInternalTestingLlamaTokenizer2() throws {
126 |         let chatTemplate =
127 |             "{% if messages[0]['role'] == 'system' %}{% set loop_messages = messages[1:] %}{% set system_message = messages[0]['content'] %}{% elif USE_DEFAULT_PROMPT == true and not '<<SYS>>' in messages[0]['content'] %}{% set loop_messages = messages %}{% set system_message = 'DEFAULT_SYSTEM_MESSAGE' %}{% else %}{% set loop_messages = messages %}{% set system_message = false %}{% endif %}{% for message in loop_messages %}{% if (message['role'] == 'user') != (loop.index0 % 2 == 0) %}{{ raise_exception('Conversation roles must alternate user/assistant/user/assistant/...') }}{% endif %}{% if loop.index0 == 0 and system_message != false %}{% set content = '<<SYS>>\\n' + system_message + '\\n<</SYS>>\\n\\n' + message['content'] %}{% else %}{% set content = message['content'] %}{% endif %}{% if message['role'] == 'user' %}{{ bos_token + '[INST] ' + content.strip() + ' [/INST]' }}{% elif message['role'] == 'system' %}{{ '<<SYS>>\\n' + content.strip() + '\\n<</SYS>>\\n\\n' }}{% elif message['role'] == 'assistant' %}{{ ' ' + content.strip() + ' ' + eos_token }}{% endif %}{% endfor %}"
128 |         let template = try Template(chatTemplate)
129 |         let result = try template.render([
130 |             "messages": messages,
131 |             "bos_token": "<s>",
132 |             "eos_token": "</s>",
133 |             "USE_DEFAULT_PROMPT": true,
134 |         ])
135 |         let target =
136 |             "<s>[INST] <<SYS>>\nDEFAULT_SYSTEM_MESSAGE\n<</SYS>>\n\nHello, how are you? [/INST] I'm doing great. How can I help you today? </s><s>[INST] I'd like to show off how chat templating works! [/INST]"
137 |         XCTAssertEqual(result, target)
138 |     }
139 | 
140 |     func testHfInternalTestingLlamaTokenizer3() throws {
141 |         let chatTemplate =
142 |             "{% if messages[0]['role'] == 'system' %}{% set loop_messages = messages[1:] %}{% set system_message = messages[0]['content'] %}{% elif USE_DEFAULT_PROMPT == true and not '<<SYS>>' in messages[0]['content'] %}{% set loop_messages = messages %}{% set system_message = 'DEFAULT_SYSTEM_MESSAGE' %}{% else %}{% set loop_messages = messages %}{% set system_message = false %}{% endif %}{% for message in loop_messages %}{% if (message['role'] == 'user') != (loop.index0 % 2 == 0) %}{{ raise_exception('Conversation roles must alternate user/assistant/user/assistant/...') }}{% endif %}{% if loop.index0 == 0 and system_message != false %}{% set content = '<<SYS>>\\n' + system_message + '\\n<</SYS>>\\n\\n' + message['content'] %}{% else %}{% set content = message['content'] %}{% endif %}{% if message['role'] == 'user' %}{{ bos_token + '[INST] ' + content.strip() + ' [/INST]' }}{% elif message['role'] == 'system' %}{{ '<<SYS>>\\n' + content.strip() + '\\n<</SYS>>\\n\\n' }}{% elif message['role'] == 'assistant' %}{{ ' ' + content.strip() + ' ' + eos_token }}{% endif %}{% endfor %}"
143 |         let template = try Template(chatTemplate)
144 |         let result = try template.render([
145 |             "messages": [
146 |                 [
147 |                     "role": "user",
148 |                     "content": "<<SYS>>\nYou are a helpful assistant\n<</SYS>> Hello, how are you?",
149 |                 ],
150 |                 [
151 |                     "role": "assistant",
152 |                     "content": "I'm doing great. How can I help you today?",
153 |                 ],
154 |                 [
155 |                     "role": "user",
156 |                     "content": "I'd like to show off how chat templating works!",
157 |                 ],
158 |             ],
159 |             "bos_token": "<s>",
160 |             "eos_token": "</s>",
161 |             "USE_DEFAULT_PROMPT": true,
162 |         ])
163 |         let target =
164 |             "<s>[INST] <<SYS>>\nYou are a helpful assistant\n<</SYS>> Hello, how are you? [/INST] I'm doing great. How can I help you today? </s><s>[INST] I'd like to show off how chat templating works! [/INST]"
165 |         XCTAssertEqual(result, target)
166 |     }
167 | 
168 |     func testOpenaiWhisperLargeV3() throws {
169 |         let chatTemplate = "{% for message in messages %}{{ message.content }}{{ eos_token }}{% endfor %}"
170 |         let template = try Template(chatTemplate)
171 |         let result = try template.render([
172 |             "messages": messages,
173 |             "eos_token": "<|endoftext|>",
174 |         ])
175 |         let target =
176 |             "Hello, how are you?<|endoftext|>I'm doing great. How can I help you today?<|endoftext|>I'd like to show off how chat templating works!<|endoftext|>"
177 |         XCTAssertEqual(result, target)
178 |     }
179 | 
180 |     func testQwenQwen1_5_1_8BChat1() throws {
181 |         let chatTemplate =
182 |             "{% for message in messages %}{% if loop.first and messages[0]['role'] != 'system' %}{{ '<|im_start|>system\nYou are a helpful assistant<|im_end|>\n' }}{% endif %}{{'<|im_start|>' + message['role'] + '\n' + message['content']}}{% if (loop.last and add_generation_prompt) or not loop.last %}{{ '<|im_end|>' + '\n'}}{% endif %}{% endfor %}{% if add_generation_prompt and messages[-1]['role'] != 'assistant' %}{{ '<|im_start|>assistant\n' }}{% endif %}"
183 |         let template = try Template(chatTemplate)
184 |         let result = try template.render([
185 |             "messages": messages,
186 |             "add_generation_prompt": true,
187 |         ])
188 |         let target =
189 |             "<|im_start|>system\nYou are a helpful assistant<|im_end|>\n<|im_start|>user\nHello, how are you?<|im_end|>\n<|im_start|>assistant\nI\'m doing great. How can I help you today?<|im_end|>\n<|im_start|>user\nI\'d like to show off how chat templating works!<|im_end|>\n<|im_start|>assistant\n"
190 |         XCTAssertEqual(result, target)
191 |     }
192 | 
193 |     func testQwenQwen1_5_1_8BChat2() throws {
194 |         let chatTemplate =
195 |             "{% for message in messages %}{% if loop.first and messages[0]['role'] != 'system' %}{{ '<|im_start|>system\nYou are a helpful assistant<|im_end|>\n' }}{% endif %}{{'<|im_start|>' + message['role'] + '\n' + message['content']}}{% if (loop.last and add_generation_prompt) or not loop.last %}{{ '<|im_end|>' + '\n'}}{% endif %}{% endfor %}{% if add_generation_prompt and messages[-1]['role'] != 'assistant' %}{{ '<|im_start|>assistant\n' }}{% endif %}"
196 |         let template = try Template(chatTemplate)
197 |         let result = try template.render([
198 |             "messages": messagesWithSystemPrompt,
199 |             "add_generation_prompt": true,
200 |         ])
201 |         let target =
202 |             "<|im_start|>system\nYou are a friendly chatbot who always responds in the style of a pirate<|im_end|>\n<|im_start|>user\nHello, how are you?<|im_end|>\n<|im_start|>assistant\nI\'m doing great. How can I help you today?<|im_end|>\n<|im_start|>user\nI\'d like to show off how chat templating works!<|im_end|>\n<|im_start|>assistant\n"
203 |         XCTAssertEqual(result, target)
204 |     }
205 | 
206 |     func testQwenQwen1_5_1_8BChat3() throws {
207 |         let chatTemplate =
208 |             "{% for message in messages %}{% if loop.first and messages[0]['role'] != 'system' %}{{ '<|im_start|>system\nYou are a helpful assistant<|im_end|>\n' }}{% endif %}{{'<|im_start|>' + message['role'] + '\n' + message['content']}}{% if (loop.last and add_generation_prompt) or not loop.last %}{{ '<|im_end|>' + '\n'}}{% endif %}{% endfor %}{% if add_generation_prompt and messages[-1]['role'] != 'assistant' %}{{ '<|im_start|>assistant\n' }}{% endif %}"
209 |         let template = try Template(chatTemplate)
210 |         let result = try template.render([
211 |             "messages": messagesWithSystemPrompt
212 |         ])
213 |         let target =
214 |             "<|im_start|>system\nYou are a friendly chatbot who always responds in the style of a pirate<|im_end|>\n<|im_start|>user\nHello, how are you?<|im_end|>\n<|im_start|>assistant\nI\'m doing great. How can I help you today?<|im_end|>\n<|im_start|>user\nI\'d like to show off how chat templating works!"
215 |         XCTAssertEqual(result, target)
216 |     }
217 | 
218 |     func testTHUDMChatglm36b() throws {
219 |         let chatTemplate =
220 |             "{% for message in messages %}{% if loop.first %}[gMASK]sop<|{{ message['role'] }}|>\n {{ message['content'] }}{% else %}<|{{ message['role'] }}|>\n {{ message['content'] }}{% endif %}{% endfor %}{% if add_generation_prompt %}<|assistant|>{% endif %}"
221 |         let template = try Template(chatTemplate)
222 |         let result = try template.render([
223 |             "messages": messagesWithSystemPrompt
224 |         ])
225 |         let target =
226 |             "[gMASK]sop<|system|>\n You are a friendly chatbot who always responds in the style of a pirate<|user|>\n Hello, how are you?<|assistant|>\n I\'m doing great. How can I help you today?<|user|>\n I\'d like to show off how chat templating works!"
227 |         XCTAssertEqual(result, target)
228 |     }
229 | 
230 |     func testGoogleGemma2bIt() throws {
231 |         let chatTemplate =
232 |             "{{ bos_token }}{% if messages[0]['role'] == 'system' %}{{ raise_exception('System role not supported') }}{% endif %}{% for message in messages %}{% if (message['role'] == 'user') != (loop.index0 % 2 == 0) %}{{ raise_exception('Conversation roles must alternate user/assistant/user/assistant/...') }}{% endif %}{% if (message['role'] == 'assistant') %}{% set role = 'model' %}{% else %}{% set role = message['role'] %}{% endif %}{{ '<start_of_turn>' + role + '\n' + message['content'] | trim + '<end_of_turn>\n' }}{% endfor %}{% if add_generation_prompt %}{{'<start_of_turn>model\n'}}{% endif %}"
233 |         let template = try Template(chatTemplate)
234 |         let result = try template.render([
235 |             "messages": messages
236 |         ])
237 |         let target =
238 |             "<start_of_turn>user\nHello, how are you?<end_of_turn>\n<start_of_turn>model\nI\'m doing great. How can I help you today?<end_of_turn>\n<start_of_turn>user\nI\'d like to show off how chat templating works!<end_of_turn>\n"
239 |         XCTAssertEqual(result, target)
240 |     }
241 | 
242 |     func testQwenQwen2_5_0_5BInstruct() throws {
243 |         let chatTemplate =
244 |             "{%- if tools %}\n    {{- '<|im_start|>system\\n' }}\n    {%- if messages[0]['role'] == 'system' %}\n        {{- messages[0]['content'] }}\n    {%- else %}\n        {{- 'You are Qwen, created by Alibaba Cloud. You are a helpful assistant.' }}\n    {%- endif %}\n    {{- \"\\n\\n# Tools\\n\\nYou may call one or more functions to assist with the user query.\\n\\nYou are provided with function signatures within <tools></tools> XML tags:\\n<tools>\" }}\n    {%- for tool in tools %}\n        {{- \"\\n\" }}\n        {{- tool | tojson }}\n    {%- endfor %}\n    {{- \"\\n</tools>\\n\\nFor each function call, return a json object with function name and arguments within <tool_call></tool_call> XML tags:\\n<tool_call>\\n{\\\"name\\\": <function-name>, \\\"arguments\\\": <args-json-object>}\\n</tool_call><|im_end|>\\n\" }}\n{%- else %}\n    {%- if messages[0]['role'] == 'system' %}\n        {{- '<|im_start|>system\\n' + messages[0]['content'] + '<|im_end|>\\n' }}\n    {%- else %}\n        {{- '<|im_start|>system\\nYou are Qwen, created by Alibaba Cloud. You are a helpful assistant.<|im_end|>\\n' }}\n    {%- endif %}\n{%- endif %}\n{%- for message in messages %}\n    {%- if (message.role == \"user\") or (message.role == \"system\" and not loop.first) or (message.role == \"assistant\" and not message.tool_calls) %}\n        {{- '<|im_start|>' + message.role + '\\n' + message.content + '<|im_end|>' + '\\n' }}\n    {%- elif message.role == \"assistant\" %}\n        {{- '<|im_start|>' + message.role }}\n        {%- if message.content %}\n            {{- '\\n' + message.content }}\n        {%- endif %}\n        {%- for tool_call in message.tool_calls %}\n            {%- if tool_call.function is defined %}\n                {%- set tool_call = tool_call.function %}\n            {%- endif %}\n            {{- '\\n<tool_call>\\n{\"name\": \"' }}\n            {{- tool_call.name }}\n            {{- '\", \"arguments\": ' }}\n            {{- tool_call.arguments | tojson }}\n            {{- '}\\n</tool_call>' }}\n        {%- endfor %}\n        {{- '<|im_end|>\\n' }}\n    {%- elif message.role == \"tool\" %}\n        {%- if (loop.index0 == 0) or (messages[loop.index0 - 1].role != \"tool\") %}\n            {{- '<|im_start|>user' }}\n        {%- endif %}\n        {{- '\\n<tool_response>\\n' }}\n        {{- message.content }}\n        {{- '\\n</tool_response>' }}\n        {%- if loop.last or (messages[loop.index0 + 1].role != \"tool\") %}\n            {{- '<|im_end|>\\n' }}\n        {%- endif %}\n    {%- endif %}\n{%- endfor %}\n{%- if add_generation_prompt %}\n    {{- '<|im_start|>assistant\\n' }}\n{%- endif %}\n"
245 |         let template = try Template(chatTemplate)
246 |         let result = try template.render([
247 |             "messages": messages
248 |         ])
249 |         let target =
250 |             "<|im_start|>system\nYou are Qwen, created by Alibaba Cloud. You are a helpful assistant.<|im_end|>\n<|im_start|>user\nHello, how are you?<|im_end|>\n<|im_start|>assistant\nI\'m doing great. How can I help you today?<|im_end|>\n<|im_start|>user\nI\'d like to show off how chat templating works!<|im_end|>\n"
251 |         XCTAssertEqual(result, target)
252 |     }
253 | 
254 |     func testHuggingFaceH4Zephyr7bBetaAddGenerationPromptFalse() throws {
255 |         let chatTemplate =
256 |             "{% for message in messages %}\n{% if message['role'] == 'user' %}\n{{ '<|user|>\n' + message['content'] + eos_token }}\n{% elif message['role'] == 'system' %}\n{{ '<|system|>\n' + message['content'] + eos_token }}\n{% elif message['role'] == 'assistant' %}\n{{ '<|assistant|>\n'  + message['content'] + eos_token }}\n{% endif %}\n{% if loop.last and add_generation_prompt %}\n{{ '<|assistant|>' }}\n{% endif %}\n{% endfor %}"
257 |         let template = try Template(chatTemplate)
258 |         let result = try template.render(
259 |             [
260 |                 "messages": messagesWithSystemPrompt, "eos_token": "</s>",
261 |                 "add_generation_prompt": false,
262 |             ] as [String: Any]
263 |         )
264 |         let target =
265 |             "<|system|>\nYou are a friendly chatbot who always responds in the style of a pirate</s>\n<|user|>\nHello, how are you?</s>\n<|assistant|>\nI'm doing great. How can I help you today?</s>\n<|user|>\nI'd like to show off how chat templating works!</s>\n"
266 |         XCTAssertEqual(result, target)
267 |     }
268 | 
269 |     func testHuggingFaceH4Zephyr7bBetaAddGenerationPromptTrue() throws {
270 |         let chatTemplate =
271 |             "{% for message in messages %}\n{% if message['role'] == 'user' %}\n{{ '<|user|>\n' + message['content'] + eos_token }}\n{% elif message['role'] == 'system' %}\n{{ '<|system|>\n' + message['content'] + eos_token }}\n{% elif message['role'] == 'assistant' %}\n{{ '<|assistant|>\n'  + message['content'] + eos_token }}\n{% endif %}\n{% if loop.last and add_generation_prompt %}\n{{ '<|assistant|>' }}\n{% endif %}\n{% endfor %}"
272 |         let template = try Template(chatTemplate)
273 |         let result = try template.render(
274 |             [
275 |                 "messages": [
276 |                     [
277 |                         "role": "system",
278 |                         "content": "You are a friendly chatbot who always responds in the style of a pirate",
279 |                     ],
280 |                     ["role": "user", "content": "How many helicopters can a human eat in one sitting?"],
281 |                 ], "eos_token": "</s>", "add_generation_prompt": true,
282 |             ] as [String: Any]
283 |         )
284 |         let target =
285 |             "<|system|>\nYou are a friendly chatbot who always responds in the style of a pirate</s>\n<|user|>\nHow many helicopters can a human eat in one sitting?</s>\n<|assistant|>\n"
286 |         XCTAssertEqual(result, target)
287 |     }
288 | 
289 |     func testHuggingFaceH4Zephyr7bGemmaV0_1() throws {
290 |         let chatTemplate =
291 |             "{% if messages[0]['role'] == 'user' or messages[0]['role'] == 'system' %}{{ bos_token }}{% endif %}{% for message in messages %}{{ '<|im_start|>' + message['role'] + '\n' + message['content'] + '<|im_end|>' + '\n' }}{% endfor %}{% if add_generation_prompt %}{{ '<|im_start|>assistant\n' }}{% elif messages[-1]['role'] == 'assistant' %}{{ eos_token }}{% endif %}"
292 |         let template = try Template(chatTemplate)
293 |         let result = try template.render(
294 |             [
295 |                 "messages": messages, "bos_token": "<bos>", "eos_token": "<eos>",
296 |                 "add_generation_prompt": false,
297 |             ] as [String: Any]
298 |         )
299 |         let target =
300 |             "<bos><|im_start|>user\nHello, how are you?<|im_end|>\n<|im_start|>assistant\nI'm doing great. How can I help you today?<|im_end|>\n<|im_start|>user\nI'd like to show off how chat templating works!<|im_end|>\n"
301 |         XCTAssertEqual(result, target)
302 |     }
303 | 
304 |     func testTheBlokeMistral7BInstructV0_1GPTQ() throws {
305 |         let chatTemplate =
306 |             "{{ bos_token }}{% for message in messages %}{% if (message['role'] == 'user') != (loop.index0 % 2 == 0) %}{{ raise_exception('Conversation roles must alternate user/assistant/user/assistant/...') }}{% endif %}{% if message['role'] == 'user' %}{{ '[INST] ' + message['content'] + ' [/INST]' }}{% elif message['role'] == 'assistant' %}{{ message['content'] + eos_token + ' ' }}{% else %}{{ raise_exception('Only user and assistant roles are supported!') }}{% endif %}{% endfor %}"
307 |         let template = try Template(chatTemplate)
308 |         let result = try template.render(
309 |             [
310 |                 "messages": messages, "bos_token": "<s>", "eos_token": "</s>",
311 |             ] as [String: Any]
312 |         )
313 |         let target =
314 |             "<s>[INST] Hello, how are you? [/INST]I'm doing great. How can I help you today?</s> [INST] I'd like to show off how chat templating works! [/INST]"
315 |         XCTAssertEqual(result, target)
316 |     }
317 | 
318 |     func testMistralaiMixtral8x7BInstructV0_1() throws {
319 |         let chatTemplate =
320 |             "{{ bos_token }}{% for message in messages %}{% if (message['role'] == 'user') != (loop.index0 % 2 == 0) %}{{ raise_exception('Conversation roles must alternate user/assistant/user/assistant/...') }}{% endif %}{% if message['role'] == 'user' %}{{ '[INST] ' + message['content'] + ' [/INST]' }}{% elif message['role'] == 'assistant' %}{{ message['content'] + eos_token}}{% else %}{{ raise_exception('Only user and assistant roles are supported!') }}{% endif %}{% endfor %}"
321 |         let template = try Template(chatTemplate)
322 |         let result = try template.render(
323 |             [
324 |                 "messages": messages, "bos_token": "<s>", "eos_token": "</s>",
325 |             ] as [String: Any]
326 |         )
327 |         let target =
328 |             "<s>[INST] Hello, how are you? [/INST]I'm doing great. How can I help you today?</s>[INST] I'd like to show off how chat templating works! [/INST]"
329 |         XCTAssertEqual(result, target)
330 |     }
331 | 
332 |     func testCognitivecomputationsDolphin2_5Mixtral8x7b() throws {
333 |         let chatTemplate =
334 |             "{% if not add_generation_prompt is defined %}{% set add_generation_prompt = false %}{% endif %}{% for message in messages %}{{'<|im_start|>' + message['role'] + '\n' + message['content'] + '<|im_end|>' + '\n'}}{% endfor %}{% if add_generation_prompt %}{{ '<|im_start|>assistant\n' }}{% endif %}"
335 |         let template = try Template(chatTemplate)
336 |         let result = try template.render(
337 |             [
338 |                 "messages": messages
339 |             ] as [String: Any]
340 |         )
341 |         let target =
342 |             "<|im_start|>user\nHello, how are you?<|im_end|>\n<|im_start|>assistant\nI'm doing great. How can I help you today?<|im_end|>\n<|im_start|>user\nI'd like to show off how chat templating works!<|im_end|>\n"
343 |         XCTAssertEqual(result, target)
344 |     }
345 | 
346 |     func testOpenchatOpenchat3_5_0106() throws {
347 |         let chatTemplate =
348 |             "{{ bos_token }}{% for message in messages %}{{ 'GPT4 Correct ' + message['role'].title() + ': ' + message['content'] + '<|end_of_turn|>'}}{% endfor %}{% if add_generation_prompt %}{{ 'GPT4 Correct Assistant:' }}{% endif %}"
349 |         let template = try Template(chatTemplate)
350 |         let result = try template.render(
351 |             [
352 |                 "messages": messages, "bos_token": "<s>", "eos_token": "</s>",
353 |                 "add_generation_prompt": false,
354 |             ] as [String: Any]
355 |         )
356 |         let target =
357 |             "<s>GPT4 Correct User: Hello, how are you?<|end_of_turn|>GPT4 Correct Assistant: I'm doing great. How can I help you today?<|end_of_turn|>GPT4 Correct User: I'd like to show off how chat templating works!<|end_of_turn|>"
358 |         XCTAssertEqual(result, target)
359 |     }
360 | 
361 |     func testUpstageSOLAR10_7BInstructV1_0() throws {
362 |         let chatTemplate =
363 |             "{% for message in messages %}{% if message['role'] == 'system' %}{% if message['content']%}{{'### System:\n' + message['content']+'\n\n'}}{% endif %}{% elif message['role'] == 'user' %}{{'### User:\n' + message['content']+'\n\n'}}{% elif message['role'] == 'assistant' %}{{'### Assistant:\n'  + message['content']}}{% endif %}{% if loop.last and add_generation_prompt %}{{ '### Assistant:\n' }}{% endif %}{% endfor %}"
364 |         let template = try Template(chatTemplate)
365 |         let result = try template.render(
366 |             [
367 |                 "messages": messages
368 |             ] as [String: Any]
369 |         )
370 |         let target =
371 |             "### User:\nHello, how are you?\n\n### Assistant:\nI'm doing great. How can I help you today?### User:\nI'd like to show off how chat templating works!\n\n"
372 |         XCTAssertEqual(result, target)
373 |     }
374 | 
375 |     func testCodellamaCodeLlama70bInstructHf() throws {
376 |         let chatTemplate =
377 |             "{% if messages[0]['role'] == 'system' %}{% set user_index = 1 %}{% else %}{% set user_index = 0 %}{% endif %}{% for message in messages %}{% if (message['role'] == 'user') != ((loop.index0 + user_index) % 2 == 0) %}{{ raise_exception('Conversation roles must alternate user/assistant/user/assistant/...') }}{% endif %}{% if loop.index0 == 0 %}{{ '<s>' }}{% endif %}{% set content = 'Source: ' + message['role'] + '\n\n ' + message['content'] | trim %}{{ content + ' <step> ' }}{% endfor %}{{'Source: assistant\nDestination: user\n\n '}}";
378 |         let template = try Template(chatTemplate)
379 |         let result = try template.render(
380 |             [
381 |                 "messages": messages
382 |             ] as [String: Any]
383 |         )
384 |         let target =
385 |             "<s>Source: user\n\n Hello, how are you? <step> Source: assistant\n\n I'm doing great. How can I help you today? <step> Source: user\n\n I'd like to show off how chat templating works! <step> Source: assistant\nDestination: user\n\n "
386 |         XCTAssertEqual(result, target)
387 |     }
388 | 
389 |     func testDeciDeciLM7BInstruct() throws {
390 |         let chatTemplate =
391 |             "{% for message in messages %}\n{% if message['role'] == 'user' %}\n{{ '### User:\n' + message['content'] }}\n{% elif message['role'] == 'system' %}\n{{ '### System:\n' + message['content'] }}\n{% elif message['role'] == 'assistant' %}\n{{ '### Assistant:\n'  + message['content'] }}\n{% endif %}\n{% if loop.last and add_generation_prompt %}\n{{ '### Assistant:' }}\n{% endif %}\n{% endfor %}"
392 |         let template = try Template(chatTemplate)
393 |         let result = try template.render(
394 |             [
395 |                 "messages": messages
396 |             ] as [String: Any]
397 |         )
398 |         let target =
399 |             "### User:\nHello, how are you?\n### Assistant:\nI'm doing great. How can I help you today?\n### User:\nI'd like to show off how chat templating works!\n"
400 |         XCTAssertEqual(result, target)
401 |     }
402 | 
403 |     func testQwenQwen1_5_72BChat() throws {
404 |         let chatTemplate =
405 |             "{% for message in messages %}{% if loop.first and messages[0]['role'] != 'system' %}{{ '<|im_start|>system\nYou are a helpful assistant.<|im_end|>\n' }}{% endif %}{{'<|im_start|>' + message['role'] + '\n' + message['content'] + '<|im_end|>' + '\n'}}{% endfor %}{% if add_generation_prompt %}{{ '<|im_start|>assistant\n' }}{% endif %}"
406 |         let template = try Template(chatTemplate)
407 |         let result = try template.render(
408 |             [
409 |                 "messages": messages
410 |             ] as [String: Any]
411 |         )
412 |         let target =
413 |             "<|im_start|>system\nYou are a helpful assistant.<|im_end|>\n<|im_start|>user\nHello, how are you?<|im_end|>\n<|im_start|>assistant\nI'm doing great. How can I help you today?<|im_end|>\n<|im_start|>user\nI'd like to show off how chat templating works!<|im_end|>\n"
414 |         XCTAssertEqual(result, target)
415 |     }
416 | 
417 |     func testDeepseekAiDeepseekLlm7bChat() throws {
418 |         let chatTemplate =
419 |             "{% if not add_generation_prompt is defined %}{% set add_generation_prompt = false %}{% endif %}{{ bos_token }}{% for message in messages %}{% if message['role'] == 'user' %}{{ 'User: ' + message['content'] + '\n\n' }}{% elif message['role'] == 'assistant' %}{{ 'Assistant: ' + message['content'] + eos_token }}{% elif message['role'] == 'system' %}{{ message['content'] + '\n\n' }}{% endif %}{% endfor %}{% if add_generation_prompt %}{{ 'Assistant:' }}{% endif %}"
420 |         let template = try Template(chatTemplate)
421 |         let result = try template.render(
422 |             [
423 |                 "messages": messages, "bos_token": "<｜begin of sentence｜>",
424 |                 "eos_token": "<｜end of sentence｜>",
425 |             ] as [String: Any]
426 |         )
427 |         let target =
428 |             "<｜begin of sentence｜>User: Hello, how are you?\n\nAssistant: I'm doing great. How can I help you today?<｜end of sentence｜>User: I'd like to show off how chat templating works!\n\n"
429 |         XCTAssertEqual(result, target)
430 |     }
431 | 
432 |     func testH2oaiH2oDanube1_8bChat() throws {
433 |         let chatTemplate =
434 |             "{% for message in messages %}{% if message['role'] == 'user' %}{{ '<|prompt|>' + message['content'] + eos_token }}{% elif message['role'] == 'system' %}{{ '<|system|>' + message['content'] + eos_token }}{% elif message['role'] == 'assistant' %}{{ '<|answer|>'  + message['content'] + eos_token }}{% endif %}{% if loop.last and add_generation_prompt %}{{ '<|answer|>' }}{% endif %}{% endfor %}"
435 |         let template = try Template(chatTemplate)
436 |         let result = try template.render(
437 |             [
438 |                 "messages": messages, "eos_token": "</s>",
439 |             ] as [String: Any]
440 |         )
441 |         let target =
442 |             "<|prompt|>Hello, how are you?</s><|answer|>I'm doing great. How can I help you today?</s><|prompt|>I'd like to show off how chat templating works!</s>"
443 |         XCTAssertEqual(result, target)
444 |     }
445 | 
446 |     func testInternlmInternlm2Chat7b() throws {
447 |         let chatTemplate =
448 |             "{% if messages[0]['role'] == 'user' or messages[0]['role'] == 'system' %}{{ bos_token }}{% endif %}{% for message in messages %}{{ '<|im_start|>' + message['role'] + '\n' + message['content'] + '<|im_end|>' + '\n' }}{% endfor %}{% if add_generation_prompt %}{{ '<|im_start|>assistant\n' }}{% elif messages[-1]['role'] == 'assistant' %}{{ eos_token }}{% endif %}"
449 |         let template = try Template(chatTemplate)
450 |         let result = try template.render(
451 |             [
452 |                 "messages": messages, "bos_token": "<s>", "eos_token": "</s>",
453 |             ] as [String: Any]
454 |         )
455 |         let target =
456 |             "<s><|im_start|>user\nHello, how are you?<|im_end|>\n<|im_start|>assistant\nI'm doing great. How can I help you today?<|im_end|>\n<|im_start|>user\nI'd like to show off how chat templating works!<|im_end|>\n"
457 |         XCTAssertEqual(result, target)
458 |     }
459 | 
460 |     func testTheBlokedeepseekCoder33BInstructAWQ() throws {
461 |         let chatTemplate =
462 |             "{%- set found_item = false -%}\n{%- for message in messages -%}\n    {%- if message['role'] == 'system' -%}\n        {%- set found_item = true -%}\n    {%- endif -%}\n{%- endfor -%}\n{%- if not found_item -%}\n{{'You are an AI programming assistant, utilizing the Deepseek Coder model, developed by Deepseek Company, and you only answer questions related to computer science. For politically sensitive questions, security and privacy issues, and other non-computer science questions, you will refuse to answer.\\n'}}\n{%- endif %}\n{%- for message in messages %}\n    {%- if message['role'] == 'system' %}\n{{ message['content'] }}\n    {%- else %}\n        {%- if message['role'] == 'user' %}\n{{'### Instruction:\\n' + message['content'] + '\\n'}}\n        {%- else %}\n{{'### Response:\\n' + message['content'] + '\\n<|EOT|>\\n'}}\n        {%- endif %}\n    {%- endif %}\n{%- endfor %}\n{{'### Response:\\n'}}\n"
463 |         let template = try Template(chatTemplate)
464 |         let result = try template.render(
465 |             [
466 |                 "messages": messages
467 |             ] as [String: Any]
468 |         )
469 |         let target =
470 |             "You are an AI programming assistant, utilizing the Deepseek Coder model, developed by Deepseek Company, and you only answer questions related to computer science. For politically sensitive questions, security and privacy issues, and other non-computer science questions, you will refuse to answer.\n### Instruction:\nHello, how are you?\n### Response:\nI'm doing great. How can I help you today?\n<|EOT|>\n### Instruction:\nI'd like to show off how chat templating works!\n### Response:\n"
471 |         XCTAssertEqual(result, target)
472 |     }
473 | 
474 |     func testEriczzzFalconRw1bChat() throws {
475 |         let chatTemplate =
476 |             "{% for message in messages %}{% if loop.index > 1 and loop.previtem['role'] != 'assistant' %}{{ ' ' }}{% endif %}{% if message['role'] == 'system' %}{{ '[SYS] ' + message['content'].strip() }}{% elif message['role'] == 'user' %}{{ '[INST] ' + message['content'].strip() }}{% elif message['role'] == 'assistant' %}{{ '[RESP] '  + message['content'] + eos_token }}{% endif %}{% endfor %}{% if add_generation_prompt %}{{ ' [RESP] ' }}{% endif %}"
477 |         let template = try Template(chatTemplate)
478 |         let result = try template.render(
479 |             [
480 |                 "messages": messages, "eos_token": "<|endoftext|>",
481 |             ] as [String: Any]
482 |         )
483 |         let target =
484 |             "[INST] Hello, how are you? [RESP] I'm doing great. How can I help you today?<|endoftext|>[INST] I'd like to show off how chat templating works!"
485 |         XCTAssertEqual(result, target)
486 |     }
487 | 
488 |     func testAbacusaiSmaug34BV0_1() throws {
489 |         let chatTemplate =
490 |             "{%- for idx in range(0, messages|length) -%}\n{%- if messages[idx]['role'] == 'user' -%}\n{%- if idx > 1 -%}\n{{- bos_token + '[INST] ' + messages[idx]['content'] + ' [/INST]' -}}\n{%- else -%}\n{{- messages[idx]['content'] + ' [/INST]' -}}\n{%- endif -%}\n{% elif messages[idx]['role'] == 'system' %}\n{{- '[INST] <<SYS>>\\n' + messages[idx]['content'] + '\\n<</SYS>>\\n\\n' -}}\n{%- elif messages[idx]['role'] == 'assistant' -%}\n{{- ' '  + messages[idx]['content'] + ' ' + eos_token -}}\n{% endif %}\n{% endfor %}"
491 |         let template = try Template(chatTemplate)
492 |         let result = try template.render(
493 |             [
494 |                 "messages": messages, "bos_token": "<s>", "eos_token": "</s>",
495 |             ] as [String: Any]
496 |         )
497 |         let target =
498 |             "Hello, how are you? [/INST] I'm doing great. How can I help you today? </s><s>[INST] I'd like to show off how chat templating works! [/INST]"
499 |         XCTAssertEqual(result, target)
500 |     }
501 | 
502 |     func testMaywellSynatraMixtral8x7B() throws {
503 |         let chatTemplate =
504 |             "Below is an instruction that describes a task. Write a response that appropriately completes the request.\n\n{% for message in messages %}{% if message['role'] == 'user' %}### Instruction:\n{{ message['content']|trim -}}{% if not loop.last %}{% endif %}\n{% elif message['role'] == 'assistant' %}### Response:\n{{ message['content']|trim -}}{% if not loop.last %}{% endif %}\n{% elif message['role'] == 'system' %}{{ message['content']|trim -}}{% if not loop.last %}{% endif %}\n{% endif %}\n{% endfor %}\n{% if add_generation_prompt and messages[-1]['role'] != 'assistant' %}\n### Response:\n{% endif %}"
505 |         let template = try Template(chatTemplate)
506 |         let result = try template.render(
507 |             [
508 |                 "messages": messages
509 |             ] as [String: Any]
510 |         )
511 |         let target =
512 |             "Below is an instruction that describes a task. Write a response that appropriately completes the request.\n\n### Instruction:\nHello, how are you?### Response:\nI'm doing great. How can I help you today?### Instruction:\nI'd like to show off how chat templating works!"
513 |         XCTAssertEqual(result, target)
514 |     }
515 | 
516 |     func testDeepseekAiDeepseekCoder33bInstruct() throws {
517 |         let chatTemplate =
518 |             "{% if not add_generation_prompt is defined %}\n{% set add_generation_prompt = false %}\n{% endif %}\n{%- set ns = namespace(found=false) -%}\n{%- for message in messages -%}\n    {%- if message['role'] == 'system' -%}\n        {%- set ns.found = true -%}\n    {%- endif -%}\n{%- endfor -%}\n{{bos_token}}{%- if not ns.found -%}\n{{'You are an AI programming assistant, utilizing the Deepseek Coder model, developed by Deepseek Company, and you only answer questions related to computer science. For politically sensitive questions, security and privacy issues, and other non-computer science questions, you will refuse to answer\\n'}}\n{%- endif %}\n{%- for message in messages %}\n    {%- if message['role'] == 'system' %}\n{{ message['content'] }}\n    {%- else %}\n        {%- if message['role'] == 'user' %}\n{{'### Instruction:\\n' + message['content'] + '\\n'}}\n        {%- else %}\n{{'### Response:\\n' + message['content'] + '\\n<|EOT|>\\n'}}\n        {%- endif %}\n    {%- endif %}\n{%- endfor %}\n{% if add_generation_prompt %}\n{{'### Response:'}}\n{% endif %}"
519 |         let template = try Template(chatTemplate)
520 |         let result = try template.render(
521 |             [
522 |                 "messages": messages, "bos_token": "<｜begin of sentence｜>", "eos_token": "<|EOT|>",
523 |             ] as [String: Any]
524 |         )
525 |         let target =
526 |             "<｜begin of sentence｜>You are an AI programming assistant, utilizing the Deepseek Coder model, developed by Deepseek Company, and you only answer questions related to computer science. For politically sensitive questions, security and privacy issues, and other non-computer science questions, you will refuse to answer\n### Instruction:\nHello, how are you?\n### Response:\nI'm doing great. How can I help you today?\n<|EOT|>\n### Instruction:\nI'd like to show off how chat templating works!\n"
527 |         XCTAssertEqual(result, target)
528 |     }
529 | 
530 |     func testMaywellSynatraMixtral8x7B_2() throws {
531 |         let chatTemplate =
532 |             "Below is an instruction that describes a task. Write a response that appropriately completes the request.\n\n{% for message in messages %}{% if message['role'] == 'user' %}### Instruction:\n{{ message['content']|trim -}}{% if not loop.last %}{% endif %}\n{% elif message['role'] == 'assistant' %}### Response:\n{{ message['content']|trim -}}{% if not loop.last %}{% endif %}\n{% elif message['role'] == 'system' %}{{ message['content']|trim -}}{% if not loop.last %}{% endif %}\n{% endif %}\n{% endfor %}\n{% if add_generation_prompt and messages[-1]['role'] != 'assistant' %}\n### Response:\n{% endif %}"
533 |         let template = try Template(chatTemplate)
534 |         let result = try template.render(
535 |             [
536 |                 "messages": messagesWithSystemPrompt
537 |             ] as [String: Any]
538 |         )
539 |         let target =
540 |             "Below is an instruction that describes a task. Write a response that appropriately completes the request.\n\nYou are a friendly chatbot who always responds in the style of a pirate### Instruction:\nHello, how are you?### Response:\nI'm doing great. How can I help you today?### Instruction:\nI'd like to show off how chat templating works!"
541 |         XCTAssertEqual(result, target)
542 |     }
543 | 
544 |     func testMistralNemoInstruct2407() throws {
545 |         let chatTemplate =
546 |             "{%- if messages[0][\"role\"] == \"system\" %}\n    {%- set system_message = messages[0][\"content\"] %}\n    {%- set loop_messages = messages[1:] %}\n{%- else %}\n    {%- set loop_messages = messages %}\n{%- endif %}\n{%- if not tools is defined %}\n    {%- set tools = none %}\n{%- endif %}\n{%- set user_messages = loop_messages | selectattr(\"role\", \"equalto\", \"user\") | list %}\n\n{%- for message in loop_messages | rejectattr(\"role\", \"equalto\", \"tool\") | rejectattr(\"role\", \"equalto\", \"tool_results\") | selectattr(\"tool_calls\", \"undefined\") %}\n    {%- if (message[\"role\"] == \"user\") != (loop.index0 % 2 == 0) %}\n        {{- raise_exception(\"After the optional system message, conversation roles must alternate user/assistant/user/assistant/...\") }}\n    {%- endif %}\n{%- endfor %}\n\n{{- bos_token }}\n{%- for message in loop_messages %}\n    {%- if message[\"role\"] == \"user\" %}\n        {%- if tools is not none and (message == user_messages[-1]) %}\n            {{- \"[AVAILABLE_TOOLS][\" }}\n            {%- for tool in tools %}\n        {%- set tool = tool.function %}\n        {{- '{\"type\": \"function\", \"function\": {' }}\n        {%- for key, val in tool.items() if key != \"return\" %}\n            {%- if val is string %}\n            {{- '\"' + key + '\": \"' + val + '\"' }}\n            {%- else %}\n            {{- '\"' + key + '\": ' + val|tojson }}\n            {%- endif %}\n            {%- if not loop.last %}\n            {{- \", \" }}\n            {%- endif %}\n        {%- endfor %}\n        {{- \"}}\" }}\n                {%- if not loop.last %}\n                    {{- \", \" }}\n                {%- else %}\n                    {{- \"]\" }}\n                {%- endif %}\n            {%- endfor %}\n            {{- \"[/AVAILABLE_TOOLS]\" }}\n            {%- endif %}\n        {%- if loop.last and system_message is defined %}\n            {{- \"[INST]\" + system_message + \"\\n\\n\" + message[\"content\"] + \"[/INST]\" }}\n        {%- else %}\n            {{- \"[INST]\" + message[\"content\"] + \"[/INST]\" }}\n        {%- endif %}\n    {%- elif message[\"role\"] == \"tool_calls\" or message.tool_calls is defined %}\n        {%- if message.tool_calls is defined %}\n            {%- set tool_calls = message.tool_calls %}\n        {%- else %}\n            {%- set tool_calls = message.content %}\n        {%- endif %}\n        {{- \"[TOOL_CALLS][\" }}\n        {%- for tool_call in tool_calls %}\n            {%- set out = tool_call.function|tojson %}\n            {{- out[:-1] }}\n            {%- if not tool_call.id is defined or tool_call.id|length != 9 %}\n                {{- raise_exception(\"Tool call IDs should be alphanumeric strings with length 9!\") }}\n            {%- endif %}\n            {{- ', \"id\": \"' + tool_call.id + '\"}' }}\n            {%- if not loop.last %}\n                {{- \", \" }}\n            {%- else %}\n                {{- \"]\" + eos_token }}\n            {%- endif %}\n        {%- endfor %}\n    {%- elif message[\"role\"] == \"assistant\" %}\n        {{- message[\"content\"] + eos_token}}\n    {%- elif message[\"role\"] == \"tool_results\" or message[\"role\"] == \"tool\" %}\n        {%- if message.content is defined and message.content.content is defined %}\n            {%- set content = message.content.content %}\n        {%- else %}\n            {%- set content = message.content %}\n        {%- endif %}\n        {{- '[TOOL_RESULTS]{\"content\": ' + content|string + \", \" }}\n        {%- if not message.tool_call_id is defined or message.tool_call_id|length != 9 %}\n            {{- raise_exception(\"Tool call IDs should be alphanumeric strings with length 9!\") }}\n        {%- endif %}\n        {{- '\"call_id\": \"' + message.tool_call_id + '\"}[/TOOL_RESULTS]' }}\n    {%- else %}\n        {{- raise_exception(\"Only user and assistant roles are supported, with the exception of an initial optional system message!\") }}\n    {%- endif %}\n{%- endfor %}\n"
547 |         let template = try Template(chatTemplate)
548 |         let result = try template.render([
549 |             "messages": messages,
550 |             "bos_token": "<s>",
551 |             "eos_token": "</s>",
552 |         ])
553 |         let target =
554 |             "<s>[INST]Hello, how are you?[/INST]I'm doing great. How can I help you today?</s>[INST]I'd like to show off how chat templating works![/INST]"
555 | 
556 |         XCTAssertEqual(result, target)
557 |     }
558 | 
559 |     func testQwen2VLTextOnly() throws {
560 |         let qwen2VLChatTemplate =
561 |             "{% set image_count = namespace(value=0) %}{% set video_count = namespace(value=0) %}{% for message in messages %}{% if loop.first and message['role'] != 'system' %}<|im_start|>system\nYou are a helpful assistant.<|im_end|>\n{% endif %}<|im_start|>{{ message['role'] }}\n{% if message['content'] is string %}{{ message['content'] }}<|im_end|>\n{% else %}{% for content in message['content'] %}{% if content['type'] == 'image' or 'image' in content or 'image_url' in content %}{% set image_count.value = image_count.value + 1 %}{% if add_vision_id %}Picture {{ image_count.value }}: {% endif %}<|vision_start|><|image_pad|><|vision_end|>{% elif content['type'] == 'video' or 'video' in content %}{% set video_count.value = video_count.value + 1 %}{% if add_vision_id %}Video {{ video_count.value }}: {% endif %}<|vision_start|><|video_pad|><|vision_end|>{% elif 'text' in content %}{{ content['text'] }}{% endif %}{% endfor %}<|im_end|>\n{% endif %}{% endfor %}{% if add_generation_prompt %}<|im_start|>assistant\n{% endif %}"
562 |         let template = try Template(qwen2VLChatTemplate)
563 |         let result = try template.render([
564 |             "messages": messages,
565 |             "add_generation_prompt": true,
566 |         ])
567 |         let target = """
568 |             <|im_start|>system
569 |             You are a helpful assistant.<|im_end|>
570 |             <|im_start|>user
571 |             Hello, how are you?<|im_end|>
572 |             <|im_start|>assistant
573 |             I'm doing great. How can I help you today?<|im_end|>
574 |             <|im_start|>user
575 |             I'd like to show off how chat templating works!<|im_end|>
576 |             <|im_start|>assistant
577 | 
578 |             """
579 |         XCTAssertEqual(result, target)
580 |     }
581 | 
582 |     func testPhi4() throws {
583 |         let userMessage = [
584 |             "role": "user",
585 |             "content": "What is the weather in Paris today?",
586 |         ]
587 |         let chatTemplate = """
588 |             {% for message in messages %}{% if (message['role'] == 'system') %}{{'<|im_start|>system<|im_sep|>' + message['content'] + '<|im_end|>'}}{% elif (message['role'] == 'user') %}{{'<|im_start|>user<|im_sep|>' + message['content'] + '<|im_end|><|im_start|>assistant<|im_sep|>'}}{% elif (message['role'] == 'assistant') %}{{message['content'] + '<|im_end|>'}}{% endif %}{% endfor %}
589 |             """
590 |         let template = try Template(chatTemplate)
591 |         let result = try template.render([
592 |             "messages": [userMessage],
593 |             "bos_token": "<|begin_of_text|>",
594 |             "add_generation_prompt": true,
595 |         ])
596 |         let target = """
597 |             <|im_start|>user<|im_sep|>What is the weather in Paris today?<|im_end|><|im_start|>assistant<|im_sep|>
598 |             """
599 |         XCTAssertEqual(result, target)
600 |     }
601 | 
602 |     let deepSeekR1chatTemplate = """
603 |         {% if not add_generation_prompt is defined %}{% set add_generation_prompt = false %}{% endif %}{% set ns = namespace(is_first=false, is_tool=false, is_output_first=true, system_prompt='') %}{%- for message in messages %}{%- if message['role'] == 'system' %}{% set ns.system_prompt = message['content'] %}{%- endif %}{%- endfor %}{{bos_token}}{{ns.system_prompt}}{%- for message in messages %}{%- if message['role'] == 'user' %}{%- set ns.is_tool = false -%}{{'<｜User｜>' + message['content']}}{%- endif %}{%- if message['role'] == 'assistant' and message['content'] is none %}{%- set ns.is_tool = false -%}{%- for tool in message['tool_calls']%}{%- if not ns.is_first %}{{'<｜Assistant｜><｜tool▁calls▁begin｜><｜tool▁call▁begin｜>' + tool['type'] + '<｜tool▁sep｜>' + tool['function']['name'] + '\\n' + '```json' + '\\n' + tool['function']['arguments'] + '\\n' + '```' + '<｜tool▁call▁end｜>'}}{%- set ns.is_first = true -%}{%- else %}{{'\\n' + '<｜tool▁call▁begin｜>' + tool['type'] + '<｜tool▁sep｜>' + tool['function']['name'] + '\\n' + '```json' + '\\n' + tool['function']['arguments'] + '\\n' + '```' + '<｜tool▁call▁end｜>'}}{{'<｜tool▁calls▁end｜><｜end▁of▁sentence｜>'}}{%- endif %}{%- endfor %}{%- endif %}{%- if message['role'] == 'assistant' and message['content'] is not none %}{%- if ns.is_tool %}{{'<｜tool▁outputs▁end｜>' + message['content'] + '<｜end▁of▁sentence｜>'}}{%- set ns.is_tool = false -%}{%- else %}{% set content = message['content'] %}{% if '</think>' in content %}{% set content = content.split('</think>')[-1] %}{% endif %}{{'<｜Assistant｜>' + content + '<｜end▁of▁sentence｜>'}}{%- endif %}{%- endif %}{%- if message['role'] == 'tool' %}{%- set ns.is_tool = true -%}{%- if ns.is_output_first %}{{'<｜tool▁outputs▁begin｜><｜tool▁output▁begin｜>' + message['content'] + '<｜tool▁output▁end｜>'}}{%- set ns.is_output_first = false %}{%- else %}{{'\\n<｜tool▁output▁begin｜>' + message['content'] + '<｜tool▁output▁end｜>'}}{%- endif %}{%- endif %}{%- endfor -%}{% if ns.is_tool %}{{'<｜tool▁outputs▁end｜>'}}{% endif %}{% if add_generation_prompt and not ns.is_tool %}{{'<｜Assistant｜>'}}{% endif %}
604 |         """
605 | 
606 |     func testDeepSeekR1() throws {
607 |         let userMessage = [
608 |             "role": "user",
609 |             "content": "What is the weather in Paris today?",
610 |         ]
611 |         let template = try Template(deepSeekR1chatTemplate)
612 |         let result = try template.render([
613 |             "messages": [userMessage],
614 |             "bos_token": "<|begin_of_text|>",
615 |             "add_generation_prompt": true,
616 |         ])
617 |         let target = """
618 |             <|begin_of_text|><｜User｜>What is the weather in Paris today?<｜Assistant｜>
619 |             """
620 |         XCTAssertEqual(result, target)
621 |     }
622 | 
623 |     func testDeepSeekR1WitihSystemPrompt() throws {
624 |         let userMessage = [
625 |             "role": "user",
626 |             "content": "What is the weather in Paris today?",
627 |         ]
628 |         let template = try Template(deepSeekR1chatTemplate)
629 |         let result = try template.render([
630 |             "messages": [systemPromptMessage, userMessage],
631 |             "bos_token": "<|begin_of_text|>",
632 |             "add_generation_prompt": true,
633 |         ])
634 |         let target = """
635 |             <|begin_of_text|>You are a friendly chatbot who always responds in the style of a pirate<｜User｜>What is the weather in Paris today?<｜Assistant｜>
636 |             """
637 |         XCTAssertEqual(result, target)
638 |     }
639 | 
640 |     func testQwen3() throws {
641 |         let chatTemplate = """
642 |             {%- if tools %}\n    {{- '<|im_start|>system\\n' }}\n    {%- if messages[0].role == 'system' %}\n        {{- messages[0].content + '\\n\\n' }}\n    {%- endif %}\n    {{- \"# Tools\\n\\nYou may call one or more functions to assist with the user query.\\n\\nYou are provided with function signatures within <tools></tools> XML tags:\\n<tools>\" }}\n    {%- for tool in tools %}\n        {{- \"\\n\" }}\n        {{- tool | tojson }}\n    {%- endfor %}\n    {{- \"\\n</tools>\\n\\nFor each function call, return a json object with function name and arguments within <tool_call></tool_call> XML tags:\\n<tool_call>\\n{\\\"name\\\": <function-name>, \\\"arguments\\\": <args-json-object>}\\n</tool_call><|im_end|>\\n\" }}\n{%- else %}\n    {%- if messages[0].role == 'system' %}\n        {{- '<|im_start|>system\\n' + messages[0].content + '<|im_end|>\\n' }}\n    {%- endif %}\n{%- endif %}\n{%- set ns = namespace(multi_step_tool=true, last_query_index=messages|length - 1) %}\n{%- for message in messages[::-1] %}\n    {%- set index = (messages|length - 1) - loop.index0 %}\n    {%- if ns.multi_step_tool and message.role == \"user\" and not(message.content.startswith('<tool_response>') and message.content.endswith('</tool_response>')) %}\n        {%- set ns.multi_step_tool = false %}\n        {%- set ns.last_query_index = index %}\n    {%- endif %}\n{%- endfor %}\n{%- for message in messages %}\n    {%- if (message.role == \"user\") or (message.role == \"system\" and not loop.first) %}\n        {{- '<|im_start|>' + message.role + '\\n' + message.content + '<|im_end|>' + '\\n' }}\n    {%- elif message.role == \"assistant\" %}\n        {%- set content = message.content %}\n        {%- set reasoning_content = '' %}\n        {%- if message.reasoning_content is defined and message.reasoning_content is not none %}\n            {%- set reasoning_content = message.reasoning_content %}\n        {%- else %}\n            {%- if '</think>' in message.content %}\n                {%- set content = message.content.split('</think>')[-1].lstrip('\\n') %}\n                {%- set reasoning_content = message.content.split('</think>')[0].rstrip('\\n').split('<think>')[-1].lstrip('\\n') %}\n            {%- endif %}\n        {%- endif %}\n        {%- if loop.index0 > ns.last_query_index %}\n            {%- if loop.last or (not loop.last and reasoning_content) %}\n                {{- '<|im_start|>' + message.role + '\\n<think>\\n' + reasoning_content.strip('\\n') + '\\n</think>\\n\\n' + content.lstrip('\\n') }}\n            {%- else %}\n                {{- '<|im_start|>' + message.role + '\\n' + content }}\n            {%- endif %}\n        {%- else %}\n            {{- '<|im_start|>' + message.role + '\\n' + content }}\n        {%- endif %}\n        {%- if message.tool_calls %}\n            {%- for tool_call in message.tool_calls %}\n                {%- if (loop.first and content) or (not loop.first) %}\n                    {{- '\\n' }}\n                {%- endif %}\n                {%- if tool_call.function %}\n                    {%- set tool_call = tool_call.function %}\n                {%- endif %}\n                {{- '<tool_call>\\n{\"name\": \"' }}\n                {{- tool_call.name }}\n                {{- '\", \"arguments\": ' }}\n                {%- if tool_call.arguments is string %}\n                    {{- tool_call.arguments }}\n                {%- else %}\n                    {{- tool_call.arguments | tojson }}\n                {%- endif %}\n                {{- '}\\n</tool_call>' }}\n            {%- endfor %}\n        {%- endif %}\n        {{- '<|im_end|>\\n' }}\n    {%- elif message.role == \"tool\" %}\n        {%- if loop.first or (messages[loop.index0 - 1].role != \"tool\") %}\n            {{- '<|im_start|>user' }}\n        {%- endif %}\n        {{- '\\n<tool_response>\\n' }}\n        {{- message.content }}\n        {{- '\\n</tool_response>' }}\n        {%- if loop.last or (messages[loop.index0 + 1].role != \"tool\") %}\n            {{- '<|im_end|>\\n' }}\n        {%- endif %}\n    {%- endif %}\n{%- endfor %}\n{%- if add_generation_prompt %}\n    {{- '<|im_start|>assistant\\n' }}\n    {%- if enable_thinking is defined and enable_thinking is false %}\n        {{- '<think>\\n\\n</think>\\n\\n' }}\n    {%- endif %}\n{%- endif %}
643 |             """
644 |         let userMessage = [
645 |             "role": "user",
646 |             "content": "Why is the sky blue?",
647 |         ]
648 |         let template = try Template(chatTemplate)
649 |         let result = try template.render([
650 |             "messages": [userMessage],
651 |             "bos_token": "<|begin_of_text|>",
652 |             "add_generation_prompt": true,
653 |         ])
654 |         let target = """
655 |             <|im_start|>user
656 |             Why is the sky blue?<|im_end|>
657 |             <|im_start|>assistant
658 | 
659 |             """
660 |         XCTAssertEqual(result, target)
661 |     }
662 | 
663 |     func testGraniteWithoutThinking() throws {
664 |         let userMessage = [
665 |             "role": "user",
666 |             "content": "What is 1+1?",
667 |         ]
668 |         let template = try Template(ChatTemplate.granite3_3)
669 |         let result = try template.render([
670 |             "messages": [userMessage],
671 |             "bos_token": "<|begin_of_text|>",
672 |             "add_generation_prompt": true,
673 |         ])
674 |         let target = """
675 |             <|start_of_role|>system<|end_of_role|>Knowledge Cutoff Date: April 2024.
676 |             Today's Date: \(Environment.formatDate(Date(), withFormat: "%B %d, %Y")).
677 |             You are Granite, developed by IBM. You are a helpful AI assistant.<|end_of_text|>
678 |             <|start_of_role|>user<|end_of_role|>What is 1+1?<|end_of_text|>
679 |             <|start_of_role|>assistant<|end_of_role|>
680 |             """
681 |         XCTAssertEqual(result, target)
682 |     }
683 | 
684 |     func testGraniteWithThinking() throws {
685 |         let userMessage = [
686 |             "role": "user",
687 |             "content": "What is 1+1?",
688 |         ]
689 |         let template = try Template(ChatTemplate.granite3_3)
690 |         let result = try template.render([
691 |             "messages": [userMessage],
692 |             "bos_token": "<|begin_of_text|>",
693 |             "add_generation_prompt": true,
694 |             "thinking": true,
695 |         ])
696 |         let target = """
697 |             <|start_of_role|>system<|end_of_role|>Knowledge Cutoff Date: April 2024.
698 |             Today's Date: \(Environment.formatDate(Date(), withFormat: "%B %d, %Y")).
699 |             You are Granite, developed by IBM. You are a helpful AI assistant.
700 |             Respond to every user query in a comprehensive and detailed way. You can write down your thoughts and reasoning process before responding. In the thought process, engage in a comprehensive cycle of analysis, summarization, exploration, reassessment, reflection, backtracing, and iteration to develop well-considered thinking process. In the response section, based on various attempts, explorations, and reflections from the thoughts section, systematically present the final solution that you deem correct. The response should summarize the thought process. Write your thoughts between <think></think> and write your response between <response></response> for each user query.<|end_of_text|>
701 |             <|start_of_role|>user<|end_of_role|>What is 1+1?<|end_of_text|>
702 |             <|start_of_role|>assistant<|end_of_role|>
703 |             """
704 |         XCTAssertEqual(result, target)
705 |     }
706 | }
707 | 


--------------------------------------------------------------------------------
/Tests/Templates/ChatTemplates.swift:
--------------------------------------------------------------------------------
 1 | //
 2 | //  ChatTemplates.swift
 3 | //  Jinja
 4 | //
 5 | //  Created by Anthony DePasquale on 02.01.2025.
 6 | //
 7 | 
 8 | struct ChatTemplate {
 9 |     static let llama3_1 = """
10 |         {{- bos_token }}\n{%- if custom_tools is defined %}\n    {%- set tools = custom_tools %}\n{%- endif %}\n{%- if not tools_in_user_message is defined %}\n    {%- set tools_in_user_message = true %}\n{%- endif %}\n{%- if not date_string is defined %}\n    {%- set date_string = \"26 Jul 2024\" %}\n{%- endif %}\n{%- if not tools is defined %}\n    {%- set tools = none %}\n{%- endif %}\n\n{#- This block extracts the system message, so we can slot it into the right place. #}\n{%- if messages[0]['role'] == 'system' %}\n    {%- set system_message = messages[0]['content']|trim %}\n    {%- set messages = messages[1:] %}\n{%- else %}\n    {%- set system_message = \"\" %}\n{%- endif %}\n\n{#- System message + builtin tools #}\n{{- \"<|start_header_id|>system<|end_header_id|>\\n\\n\" }}\n{%- if builtin_tools is defined or tools is not none %}\n    {{- \"Environment: ipython\\n\" }}\n{%- endif %}\n{%- if builtin_tools is defined %}\n    {{- \"Tools: \" + builtin_tools | reject('equalto', 'code_interpreter') | join(\", \") + \"\\n\\n\"}}\n{%- endif %}\n{{- \"Cutting Knowledge Date: December 2023\\n\" }}\n{{- \"Today Date: \" + date_string + \"\\n\\n\" }}\n{%- if tools is not none and not tools_in_user_message %}\n    {{- \"You have access to the following functions. To call a function, please respond with JSON for a function call.\" }}\n    {{- 'Respond in the format {\"name\": function name, \"parameters\": dictionary of argument name and its value}.' }}\n    {{- \"Do not use variables.\\n\\n\" }}\n    {%- for t in tools %}\n        {{- t | tojson(indent=4) }}\n        {{- \"\\n\\n\" }}\n    {%- endfor %}\n{%- endif %}\n{{- system_message }}\n{{- \"<|eot_id|>\" }}\n\n{#- Custom tools are passed in a user message with some extra guidance #}\n{%- if tools_in_user_message and not tools is none %}\n    {#- Extract the first user message so we can plug it in here #}\n    {%- if messages | length != 0 %}\n        {%- set first_user_message = messages[0]['content']|trim %}\n        {%- set messages = messages[1:] %}\n    {%- else %}\n        {{- raise_exception(\"Cannot put tools in the first user message when there's no first user message!\") }}\n{%- endif %}\n    {{- '<|start_header_id|>user<|end_header_id|>\\n\\n' -}}\n    {{- \"Given the following functions, please respond with a JSON for a function call \" }}\n    {{- \"with its proper arguments that best answers the given prompt.\\n\\n\" }}\n    {{- 'Respond in the format {\"name\": function name, \"parameters\": dictionary of argument name and its value}.' }}\n    {{- \"Do not use variables.\\n\\n\" }}\n    {%- for t in tools %}\n        {{- t | tojson(indent=4) }}\n        {{- \"\\n\\n\" }}\n    {%- endfor %}\n    {{- first_user_message + \"<|eot_id|>\"}}\n{%- endif %}\n\n{%- for message in messages %}\n    {%- if not (message.role == 'ipython' or message.role == 'tool' or 'tool_calls' in message) %}\n        {{- '<|start_header_id|>' + message['role'] + '<|end_header_id|>\\n\\n'+ message['content'] | trim + '<|eot_id|>' }}\n    {%- elif 'tool_calls' in message %}\n        {%- if not message.tool_calls|length == 1 %}\n            {{- raise_exception(\"This model only supports single tool-calls at once!\") }}\n        {%- endif %}\n        {%- set tool_call = message.tool_calls[0].function %}\n        {%- if builtin_tools is defined and tool_call.name in builtin_tools %}\n            {{- '<|start_header_id|>assistant<|end_header_id|>\\n\\n' -}}\n            {{- \"<|python_tag|>\" + tool_call.name + \".call(\" }}\n            {%- for arg_name, arg_val in tool_call.arguments | items %}\n                {{- arg_name + '=\"' + arg_val + '\"' }}\n                {%- if not loop.last %}\n                    {{- \", \" }}\n                {%- endif %}\n                {%- endfor %}\n            {{- \")\" }}\n        {%- else  %}\n            {{- '<|start_header_id|>assistant<|end_header_id|>\\n\\n' -}}\n            {{- '{\"name\": \"' + tool_call.name + '\", ' }}\n            {{- '\"parameters\": ' }}\n            {{- tool_call.arguments | tojson }}\n            {{- \"}\" }}\n        {%- endif %}\n        {%- if builtin_tools is defined %}\n            {#- This means we're in ipython mode #}\n            {{- \"<|eom_id|>\" }}\n        {%- else %}\n            {{- \"<|eot_id|>\" }}\n        {%- endif %}\n    {%- elif message.role == \"tool\" or message.role == \"ipython\" %}\n        {{- \"<|start_header_id|>ipython<|end_header_id|>\\n\\n\" }}\n        {%- if message.content is mapping or message.content is iterable %}\n            {{- message.content | tojson }}\n        {%- else %}\n            {{- message.content }}\n        {%- endif %}\n        {{- \"<|eot_id|>\" }}\n    {%- endif %}\n{%- endfor %}\n{%- if add_generation_prompt %}\n    {{- '<|start_header_id|>assistant<|end_header_id|>\\n\\n' }}\n{%- endif %}\n
11 |         """
12 |     static let llama3_2 = """
13 |         {{- bos_token }}\n{%- if custom_tools is defined %}\n    {%- set tools = custom_tools %}\n{%- endif %}\n{%- if not tools_in_user_message is defined %}\n    {%- set tools_in_user_message = true %}\n{%- endif %}\n{%- if not date_string is defined %}\n    {%- if strftime_now is defined %}\n        {%- set date_string = strftime_now(\"%d %b %Y\") %}\n    {%- else %}\n        {%- set date_string = \"26 Jul 2024\" %}\n    {%- endif %}\n{%- endif %}\n{%- if not tools is defined %}\n    {%- set tools = none %}\n{%- endif %}\n\n{#- This block extracts the system message, so we can slot it into the right place. #}\n{%- if messages[0]['role'] == 'system' %}\n    {%- set system_message = messages[0]['content']|trim %}\n    {%- set messages = messages[1:] %}\n{%- else %}\n    {%- set system_message = \"\" %}\n{%- endif %}\n\n{#- System message #}\n{{- \"<|start_header_id|>system<|end_header_id|>\\n\\n\" }}\n{%- if tools is not none %}\n    {{- \"Environment: ipython\\n\" }}\n{%- endif %}\n{{- \"Cutting Knowledge Date: December 2023\\n\" }}\n{{- \"Today Date: \" + date_string + \"\\n\\n\" }}\n{%- if tools is not none and not tools_in_user_message %}\n    {{- \"You have access to the following functions. To call a function, please respond with JSON for a function call.\" }}\n    {{- 'Respond in the format {\"name\": function name, \"parameters\": dictionary of argument name and its value}.' }}\n    {{- \"Do not use variables.\\n\\n\" }}\n    {%- for t in tools %}\n        {{- t | tojson(indent=4) }}\n        {{- \"\\n\\n\" }}\n    {%- endfor %}\n{%- endif %}\n{{- system_message }}\n{{- \"<|eot_id|>\" }}\n\n{#- Custom tools are passed in a user message with some extra guidance #}\n{%- if tools_in_user_message and not tools is none %}\n    {#- Extract the first user message so we can plug it in here #}\n    {%- if messages | length != 0 %}\n        {%- set first_user_message = messages[0]['content']|trim %}\n        {%- set messages = messages[1:] %}\n    {%- else %}\n        {{- raise_exception(\"Cannot put tools in the first user message when there's no first user message!\") }}\n{%- endif %}\n    {{- '<|start_header_id|>user<|end_header_id|>\\n\\n' -}}\n    {{- \"Given the following functions, please respond with a JSON for a function call \" }}\n    {{- \"with its proper arguments that best answers the given prompt.\\n\\n\" }}\n    {{- 'Respond in the format {\"name\": function name, \"parameters\": dictionary of argument name and its value}.' }}\n    {{- \"Do not use variables.\\n\\n\" }}\n    {%- for t in tools %}\n        {{- t | tojson(indent=4) }}\n        {{- \"\\n\\n\" }}\n    {%- endfor %}\n    {{- first_user_message + \"<|eot_id|>\"}}\n{%- endif %}\n\n{%- for message in messages %}\n    {%- if not (message.role == 'ipython' or message.role == 'tool' or 'tool_calls' in message) %}\n        {{- '<|start_header_id|>' + message['role'] + '<|end_header_id|>\\n\\n'+ message['content'] | trim + '<|eot_id|>' }}\n    {%- elif 'tool_calls' in message %}\n        {%- if not message.tool_calls|length == 1 %}\n            {{- raise_exception(\"This model only supports single tool-calls at once!\") }}\n        {%- endif %}\n        {%- set tool_call = message.tool_calls[0].function %}\n        {{- '<|start_header_id|>assistant<|end_header_id|>\\n\\n' -}}\n        {{- '{\"name\": \"' + tool_call.name + '\", ' }}\n        {{- '\"parameters\": ' }}\n        {{- tool_call.arguments | tojson }}\n        {{- \"}\" }}\n        {{- \"<|eot_id|>\" }}\n    {%- elif message.role == \"tool\" or message.role == \"ipython\" %}\n        {{- \"<|start_header_id|>ipython<|end_header_id|>\\n\\n\" }}\n        {%- if message.content is mapping or message.content is iterable %}\n            {{- message.content | tojson }}\n        {%- else %}\n            {{- message.content }}\n        {%- endif %}\n        {{- \"<|eot_id|>\" }}\n    {%- endif %}\n{%- endfor %}\n{%- if add_generation_prompt %}\n    {{- '<|start_header_id|>assistant<|end_header_id|>\\n\\n' }}\n{%- endif %}\n
14 |         """
15 |     static let qwen2_5 = """
16 |         {%- if tools %}\n    {{- '<|im_start|>system\\n' }}\n    {%- if messages[0]['role'] == 'system' %}\n        {{- messages[0]['content'] }}\n    {%- else %}\n        {{- 'You are Qwen, created by Alibaba Cloud. You are a helpful assistant.' }}\n    {%- endif %}\n    {{- \"\\n\\n# Tools\\n\\nYou may call one or more functions to assist with the user query.\\n\\nYou are provided with function signatures within <tools></tools> XML tags:\\n<tools>\" }}\n    {%- for tool in tools %}\n        {{- \"\\n\" }}\n        {{- tool | tojson }}\n    {%- endfor %}\n    {{- \"\\n</tools>\\n\\nFor each function call, return a json object with function name and arguments within <tool_call></tool_call> XML tags:\\n<tool_call>\\n{\\\"name\\\": <function-name>, \\\"arguments\\\": <args-json-object>}\\n</tool_call><|im_end|>\\n\" }}\n{%- else %}\n    {%- if messages[0]['role'] == 'system' %}\n        {{- '<|im_start|>system\\n' + messages[0]['content'] + '<|im_end|>\\n' }}\n    {%- else %}\n        {{- '<|im_start|>system\\nYou are Qwen, created by Alibaba Cloud. You are a helpful assistant.<|im_end|>\\n' }}\n    {%- endif %}\n{%- endif %}\n{%- for message in messages %}\n    {%- if (message.role == \"user\") or (message.role == \"system\" and not loop.first) or (message.role == \"assistant\" and not message.tool_calls) %}\n        {{- '<|im_start|>' + message.role + '\\n' + message.content + '<|im_end|>' + '\\n' }}\n    {%- elif message.role == \"assistant\" %}\n        {{- '<|im_start|>' + message.role }}\n        {%- if message.content %}\n            {{- '\\n' + message.content }}\n        {%- endif %}\n        {%- for tool_call in message.tool_calls %}\n            {%- if tool_call.function is defined %}\n                {%- set tool_call = tool_call.function %}\n            {%- endif %}\n            {{- '\\n<tool_call>\\n{\"name\": \"' }}\n            {{- tool_call.name }}\n            {{- '\", \"arguments\": ' }}\n            {{- tool_call.arguments | tojson }}\n            {{- '}\\n</tool_call>' }}\n        {%- endfor %}\n        {{- '<|im_end|>\\n' }}\n    {%- elif message.role == \"tool\" %}\n        {%- if (loop.index0 == 0) or (messages[loop.index0 - 1].role != \"tool\") %}\n            {{- '<|im_start|>user' }}\n        {%- endif %}\n        {{- '\\n<tool_response>\\n' }}\n        {{- message.content }}\n        {{- '\\n</tool_response>' }}\n        {%- if loop.last or (messages[loop.index0 + 1].role != \"tool\") %}\n            {{- '<|im_end|>\\n' }}\n        {%- endif %}\n    {%- endif %}\n{%- endfor %}\n{%- if add_generation_prompt %}\n    {{- '<|im_start|>assistant\\n' }}\n{%- endif %}\n
17 |         """
18 |     static let mistral7b = """
19 |         {{bos_token}}{% set user_messages = messages | selectattr('role', 'equalto', 'user') | list %}{% for message in messages %}{% if message['role'] == 'user' %}{% if message == user_messages[-1] %}{% if tools %}{{'[AVAILABLE_TOOLS]'+ tools|string + '[/AVAILABLE_TOOLS]'}}{% endif %}{{ '[INST]' + message['content'] + '[/INST]' }}{% else %}{{ '[INST]' + message['content'] + '[/INST]' }}{% endif %}{% elif message['role'] == 'assistant' %}{{ ' ' + message['content'] + ' ' + eos_token}}{% elif message['role'] == 'tool_results' %}{{'[TOOL_RESULTS]' + message['content']|string + '[/TOOL_RESULTS]'}}{% elif message['role'] == 'tool_calls' %}{{'[TOOL_CALLS]' + message['content']|string + eos_token}}{% endif %}{% endfor %}
20 |         """
21 | 
22 |     static let granite3_3 = """
23 |         {# Alias tools -> available_tools #}\n{%- if tools and not available_tools -%}\n    {%- set available_tools = tools -%}\n{%- endif -%}\n{%- if messages[0]['role'] == 'system' %}\n     {%- set system_message = messages[0]['content'] %}\n     {%- set loop_messages = messages[1:] %}\n {%- else %}\n     {%- set system_message = \"Knowledge Cutoff Date: April 2024.\\nToday's Date: \" + strftime_now('%B %d, %Y') + \".\\nYou are Granite, developed by IBM.\" %}\n     {%- if available_tools and documents %}\n         {%- set system_message = system_message + \" You are a helpful assistant with access to the following tools. When a tool is required to answer the user's query, respond only with <|tool_call|> followed by a JSON list of tools used. If a tool does not exist in the provided list of tools, notify the user that you do not have the ability to fulfill the request.\\nWrite the response to the user's input by strictly aligning with the facts in the provided documents. If the information needed to answer the question is not available in the documents, inform the user that the question cannot be answered based on the available data.\" %}\n     {%- elif available_tools %}\n         {%- set system_message = system_message + \" You are a helpful assistant with access to the following tools. When a tool is required to answer the user's query, respond only with <|tool_call|> followed by a JSON list of tools used. If a tool does not exist in the provided list of tools, notify the user that you do not have the ability to fulfill the request.\" %}\n     {%- elif documents %}\n         {%- set system_message = system_message + \" Write the response to the user's input by strictly aligning with the facts in the provided documents. If the information needed to answer the question is not available in the documents, inform the user that the question cannot be answered based on the available data.\" %}\n    {%- elif thinking %}\n    {%- set system_message = system_message + \" You are a helpful AI assistant.\\nRespond to every user query in a comprehensive and detailed way. You can write down your thoughts and reasoning process before responding. In the thought process, engage in a comprehensive cycle of analysis, summarization, exploration, reassessment, reflection, backtracing, and iteration to develop well-considered thinking process. In the response section, based on various attempts, explorations, and reflections from the thoughts section, systematically present the final solution that you deem correct. The response should summarize the thought process. Write your thoughts between <think></think> and write your response between <response></response> for each user query.\" %}\n     {%- else %}\n         {%- set system_message = system_message + \" You are a helpful AI assistant.\" %}\n     {%- endif %}\n     {%- if 'citations' in controls and documents %}\n         {%- set system_message = system_message + '\\nUse the symbols <|start_of_cite|> and <|end_of_cite|> to indicate when a fact comes from a document in the search result, e.g <|start_of_cite|> {document_id: 1}my fact <|end_of_cite|> for a fact from document 1. Afterwards, list all the citations with their corresponding documents in an ordered list.' %}\n     {%- endif %}\n     {%- if 'hallucinations' in controls and documents %}\n         {%- set system_message = system_message + '\\nFinally, after the response is written, include a numbered list of sentences from the response with a corresponding risk value that are hallucinated and not based in the documents.' %}\n     {%- endif %}\n     {%- set loop_messages = messages %}\n {%- endif %}\n {{- '<|start_of_role|>system<|end_of_role|>' + system_message + '<|end_of_text|>\\n' }}\n {%- if available_tools %}\n     {{- '<|start_of_role|>available_tools<|end_of_role|>' }}\n     {{- available_tools | tojson(indent=4) }}\n     {{- '<|end_of_text|>\\n' }}\n {%- endif %}\n {%- if documents %}\n     {%- for document in documents %}\n         {{- '<|start_of_role|>document {\"document_id\": \"' + document['doc_id'] | string + '\"}<|end_of_role|>\\n' }}\n         {{- document['text'] }}\n         {{- '<|end_of_text|>\\n' }}\n              {%- endfor %}\n {%- endif %}\n {%- for message in loop_messages %}\n     {{- '<|start_of_role|>' + message['role'] + '<|end_of_role|>' + message['content'] + '<|end_of_text|>\\n' }}\n     {%- if loop.last and add_generation_prompt %}\n         {{- '<|start_of_role|>assistant' }}\n             {%- if controls %}\n                 {{- ' ' + controls | tojson()}}\n             {%- endif %}\n         {{- '<|end_of_role|>' }}\n     {%- endif %}\n {%- endfor %}
24 |         """
25 | }
26 | 


--------------------------------------------------------------------------------
/Tests/Templates/DateFormatTests.swift:
--------------------------------------------------------------------------------
  1 | //
  2 | //  DateFormatTests.swift
  3 | //  Jinja
  4 | //
  5 | //  Created by Sachin Desai on 5/13/25.
  6 | //
  7 | 
  8 | import XCTest
  9 | import OrderedCollections
 10 | 
 11 | @testable import Jinja
 12 | 
 13 | final class DateFormatTests: XCTestCase {
 14 | 
 15 |     // Fixed test date to ensure consistent results
 16 |     let testDate: Date = {
 17 |         var components = DateComponents()
 18 |         components.year = 2025
 19 |         components.month = 3
 20 |         components.day = 15
 21 |         components.hour = 14
 22 |         components.minute = 30
 23 |         components.second = 45
 24 |         components.nanosecond = 123456000
 25 | 
 26 |         let calendar = Calendar(identifier: .gregorian)
 27 |         return calendar.date(from: components)!
 28 |     }()
 29 | 
 30 |     // MARK: - Basic Format Tests
 31 | 
 32 |     func testBasicFormats() {
 33 |         // Test basic date components
 34 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%B %d, %Y"), "March 15, 2025")
 35 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%Y-%m-%d"), "2025-03-15")
 36 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%H:%M:%S"), "14:30:45")
 37 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%Y-%m-%d %H:%M:%S"), "2025-03-15 14:30:45")
 38 |     }
 39 | 
 40 |     // MARK: - Individual Format Specifier Tests
 41 | 
 42 |     func testWeekdayFormats() {
 43 |         // Test abbreviated weekday name
 44 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%a"), "Sat")
 45 |         // Test full weekday name
 46 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%A"), "Saturday")
 47 |         // Test weekday as a number (0-6, Sunday=0)
 48 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%w"), "6")
 49 |     }
 50 | 
 51 |     func testMonthFormats() {
 52 |         // Test month as zero-padded number
 53 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%m"), "03")
 54 |         // Test month as non-padded number
 55 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%-m"), "3")
 56 |         // Test abbreviated month name
 57 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%b"), "Mar")
 58 |         // Test full month name
 59 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%B"), "March")
 60 |     }
 61 | 
 62 |     func testDayFormats() {
 63 |         // Test day of month as zero-padded number
 64 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%d"), "15")
 65 |         // Test day of month as non-padded number
 66 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%-d"), "15")
 67 |         // Test day of year (001-366)
 68 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%j"), "074")
 69 |         // Test day of year without padding
 70 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%-j"), "74")
 71 |     }
 72 | 
 73 |     func testYearFormats() {
 74 |         // Test year with century
 75 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%Y"), "2025")
 76 |         // Test year without century (00-99)
 77 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%y"), "25")
 78 |         // Test year without century and without padding
 79 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%-y"), "25")
 80 |     }
 81 | 
 82 |     func testTimeFormats() {
 83 |         // Test hour in 24-hour format (00-23)
 84 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%H"), "14")
 85 |         // Test hour without padding in 24-hour format
 86 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%-H"), "14")
 87 |         // Test hour in 12-hour format (01-12)
 88 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%I"), "02")
 89 |         // Test hour without padding in 12-hour format
 90 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%-I"), "2")
 91 |         // Test AM/PM
 92 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%p"), "PM")
 93 |         // Test minute (00-59)
 94 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%M"), "30")
 95 |         // Test minute without padding
 96 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%-M"), "30")
 97 |         // Test second (00-59)
 98 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%S"), "45")
 99 |         // Test second without padding
100 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%-S"), "45")
101 |         // Test microseconds
102 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%f"), "123456")
103 |     }
104 | 
105 |     func testTimeZoneFormats() {
106 |         // Note: These tests may need adjustment based on your test environment
107 |         // Test timezone offset (e.g., +0000)
108 |         // This is environment-dependent, so we'll just check format
109 |         let tzOffsetResult = Environment.formatDate(testDate, withFormat: "%z")
110 |         XCTAssertTrue(tzOffsetResult.hasPrefix("+") || tzOffsetResult.hasPrefix("-"))
111 |         XCTAssertEqual(tzOffsetResult.count, 5)
112 | 
113 |         // Test timezone abbreviation (e.g., UTC, EST)
114 |         // This is environment-dependent, so we'll just check it's not empty
115 |         let tzAbbrResult = Environment.formatDate(testDate, withFormat: "%Z")
116 |         XCTAssertFalse(tzAbbrResult.isEmpty)
117 |     }
118 | 
119 |     func testWeekFormats() {
120 |         // Test week number with Sunday as first day (00-53)
121 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%U"), "11")
122 |         // Test week number with Monday as first day (00-53)
123 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%W"), "11")
124 |     }
125 | 
126 |     func testCompleteFormats() {
127 |         // Test locale's appropriate date and time representation
128 |         let cFormatResult = Environment.formatDate(testDate, withFormat: "%c")
129 |         XCTAssertFalse(cFormatResult.isEmpty)
130 |         XCTAssertTrue(cFormatResult.contains("2025"))
131 | 
132 |         // Test locale's appropriate date representation
133 |         let xFormatResult = Environment.formatDate(testDate, withFormat: "%x")
134 |         XCTAssertFalse(xFormatResult.isEmpty)
135 | 
136 |         // Test locale's appropriate time representation
137 |         let XFormatResult = Environment.formatDate(testDate, withFormat: "%X")
138 |         XCTAssertFalse(XFormatResult.isEmpty)
139 |     }
140 | 
141 |     // MARK: - Edge Cases
142 | 
143 |     func testEscapedPercent() {
144 |         // Test escaped % character
145 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "100%%"), "100%")
146 |     }
147 | 
148 |     func testUnknownFormatSpecifiers() {
149 |         // Test unknown format specifiers (should pass through as-is)
150 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: "%Q"), "%Q")
151 |     }
152 | 
153 |     func testEmptyFormat() {
154 |         // Test empty format string
155 |         XCTAssertEqual(Environment.formatDate(testDate, withFormat: ""), "")
156 |     }
157 | 
158 |     func testComplexFormats() {
159 |         // Test complex combinations of format specifiers
160 |         XCTAssertEqual(
161 |             Environment.formatDate(testDate, withFormat: "Date: %Y-%m-%d (%A) Time: %I:%M:%S %p"),
162 |             "Date: 2025-03-15 (Saturday) Time: 02:30:45 PM"
163 |         )
164 |     }
165 | 
166 |     // MARK: - Special Cases
167 | 
168 |     func testSpecialDates() {
169 |         // Test with January 1st (first day of year)
170 |         var components = DateComponents()
171 |         components.year = 2025
172 |         components.month = 1
173 |         components.day = 1
174 |         components.hour = 0
175 |         components.minute = 0
176 |         components.second = 0
177 | 
178 |         let calendar = Calendar(identifier: .gregorian)
179 |         let newYearsDay = calendar.date(from: components)!
180 | 
181 |         XCTAssertEqual(Environment.formatDate(newYearsDay, withFormat: "%Y-%m-%d"), "2025-01-01")
182 |         XCTAssertEqual(Environment.formatDate(newYearsDay, withFormat: "%j"), "001")
183 |         XCTAssertEqual(Environment.formatDate(newYearsDay, withFormat: "%A"), "Wednesday")
184 |         XCTAssertEqual(Environment.formatDate(newYearsDay, withFormat: "%I:%M:%S %p"), "12:00:00 AM")
185 | 
186 |         // Test with December 31st (last day of year)
187 |         components.month = 12
188 |         components.day = 31
189 |         components.hour = 23
190 |         components.minute = 59
191 |         components.second = 59
192 | 
193 |         let newYearsEve = calendar.date(from: components)!
194 | 
195 |         XCTAssertEqual(Environment.formatDate(newYearsEve, withFormat: "%Y-%m-%d"), "2025-12-31")
196 |         XCTAssertEqual(Environment.formatDate(newYearsEve, withFormat: "%j"), "365")
197 |         XCTAssertEqual(Environment.formatDate(newYearsEve, withFormat: "%A"), "Wednesday")
198 |         XCTAssertEqual(Environment.formatDate(newYearsEve, withFormat: "%I:%M:%S %p"), "11:59:59 PM")
199 |     }
200 | 
201 |     func testLeapYearDate() {
202 |         // Test with February 29th on a leap year
203 |         var components = DateComponents()
204 |         components.year = 2024  // Leap year
205 |         components.month = 2
206 |         components.day = 29
207 | 
208 |         let calendar = Calendar(identifier: .gregorian)
209 |         let leapYearDate = calendar.date(from: components)!
210 | 
211 |         XCTAssertEqual(Environment.formatDate(leapYearDate, withFormat: "%Y-%m-%d"), "2024-02-29")
212 |         XCTAssertEqual(Environment.formatDate(leapYearDate, withFormat: "%j"), "060")  // Day of year
213 |     }
214 | }
215 | 


--------------------------------------------------------------------------------
/Tests/Templates/Messages.swift:
--------------------------------------------------------------------------------
 1 | //
 2 | //  Messages.swift
 3 | //  Jinja
 4 | //
 5 | //  Created by Anthony DePasquale on 02.01.2025.
 6 | //
 7 | 
 8 | struct Messages {
 9 |     static let weatherQuery: [[String: String]] = [
10 |         [
11 |             "role": "user",
12 |             "content": "What is the weather in Paris today?",
13 |         ]
14 |     ]
15 | }
16 | 


--------------------------------------------------------------------------------
/Tests/Templates/ToolSpecs.swift:
--------------------------------------------------------------------------------
 1 | //
 2 | //  ToolSpecs.swift
 3 | //  Jinja
 4 | //
 5 | //  Created by Anthony DePasquale on 02.01.2025.
 6 | //
 7 | 
 8 | import OrderedCollections
 9 | 
10 | struct ToolSpec {
11 |     static let getCurrentWeather = OrderedDictionary(uniqueKeysWithValues: [
12 |         ("type", "function") as (String, Any),
13 |         (
14 |             "function",
15 |             OrderedDictionary(uniqueKeysWithValues: [
16 |                 ("name", "get_current_weather") as (String, Any),
17 |                 ("description", "Get the current weather in a given location") as (String, Any),
18 |                 (
19 |                     "parameters",
20 |                     OrderedDictionary(uniqueKeysWithValues: [
21 |                         ("type", "object") as (String, Any),
22 |                         (
23 |                             "properties",
24 |                             OrderedDictionary(uniqueKeysWithValues: [
25 |                                 (
26 |                                     "location",
27 |                                     OrderedDictionary(uniqueKeysWithValues: [
28 |                                         ("type", "string") as (String, Any),
29 |                                         ("description", "The city and state, e.g. San Francisco, CA")
30 |                                             as (String, Any),
31 |                                     ])
32 |                                 ) as (String, Any),
33 |                                 (
34 |                                     "unit",
35 |                                     OrderedDictionary(uniqueKeysWithValues: [
36 |                                         ("type", "string") as (String, Any),
37 |                                         ("enum", ["celsius", "fahrenheit"]) as (String, Any),
38 |                                     ])
39 |                                 ) as (String, Any),
40 |                             ])
41 |                         ) as (String, Any),
42 |                         ("required", ["location"]) as (String, Any),
43 |                     ])
44 |                 ) as (String, Any),
45 |             ])
46 |         ) as (String, Any),
47 |     ])
48 | }
49 | 


--------------------------------------------------------------------------------
/Tests/Templates/ToolUseTests.swift:
--------------------------------------------------------------------------------
  1 | //
  2 | //  VisionTests.swift
  3 | //  Jinja
  4 | //
  5 | //  Created by Anthony DePasquale on 30.12.2024.
  6 | //
  7 | 
  8 | import XCTest
  9 | import OrderedCollections
 10 | 
 11 | /*
 12 |  Recent models that don't support tool use:
 13 |  - Gemma 2
 14 |  - Phi 3.5
 15 |  - Mistral NeMo
 16 |  */
 17 | 
 18 | @testable import Jinja
 19 | 
 20 | final class ToolUseTests: XCTestCase {
 21 |     let messagesWithFunctionCalling: [[String: Any?]] = [
 22 |         [
 23 |             "role": "assistant",
 24 |             "content": nil,
 25 |             "tool_calls": [
 26 |                 [
 27 |                     "type": "function",
 28 |                     "function": [
 29 |                         "name": "get_current_weather",
 30 |                         "arguments": "{\n  \"location\": \"Hanoi\"\n}",
 31 |                     ],
 32 |                 ]
 33 |             ],
 34 |         ],
 35 |         [
 36 |             "role": "user",
 37 |             "content": "What's the weather like in Hanoi?",
 38 |         ],
 39 |     ]
 40 | 
 41 |     // Example adapted from https://huggingface.co/fireworks-ai/firefunction-v1
 42 |     let exampleFunctionSpec: [OrderedDictionary<String, Any>] = [
 43 |         OrderedDictionary(uniqueKeysWithValues: [
 44 |             ("name", "get_stock_price") as (String, Any),
 45 |             ("description", "Get the current stock price") as (String, Any),
 46 |             (
 47 |                 "parameters",
 48 |                 OrderedDictionary(uniqueKeysWithValues: [
 49 |                     ("type", "object") as (String, Any),
 50 |                     (
 51 |                         "properties",
 52 |                         OrderedDictionary(uniqueKeysWithValues: [
 53 |                             (
 54 |                                 "symbol",
 55 |                                 OrderedDictionary(uniqueKeysWithValues: [
 56 |                                     ("type", "string") as (String, Any),
 57 |                                     ("description", "The stock symbol, e.g. AAPL, GOOG") as (String, Any),
 58 |                                 ])
 59 |                             )
 60 |                         ])
 61 |                     ) as (String, Any),
 62 |                     ("required", ["symbol"]) as (String, Any),
 63 |                 ])
 64 |             ) as (String, Any),
 65 |         ]),
 66 |         OrderedDictionary(uniqueKeysWithValues: [
 67 |             ("name", "check_word_anagram") as (String, Any),
 68 |             ("description", "Check if two words are anagrams of each other") as (String, Any),
 69 |             (
 70 |                 "parameters",
 71 |                 OrderedDictionary(uniqueKeysWithValues: [
 72 |                     ("type", "object") as (String, Any),
 73 |                     (
 74 |                         "properties",
 75 |                         OrderedDictionary(uniqueKeysWithValues: [
 76 |                             (
 77 |                                 "word1",
 78 |                                 OrderedDictionary(uniqueKeysWithValues: [
 79 |                                     ("type", "string") as (String, Any),
 80 |                                     ("description", "The first word") as (String, Any),
 81 |                                 ])
 82 |                             ) as (String, Any),
 83 |                             (
 84 |                                 "word2",
 85 |                                 OrderedDictionary(uniqueKeysWithValues: [
 86 |                                     ("type", "string") as (String, Any),
 87 |                                     ("description", "The second word") as (String, Any),
 88 |                                 ])
 89 |                             ) as (String, Any),
 90 |                         ])
 91 |                     ) as (String, Any),
 92 |                     ("required", ["word1", "word2"]) as (String, Any),
 93 |                 ])
 94 |             ) as (String, Any),
 95 |         ]),
 96 |     ]
 97 | 
 98 |     lazy var messagesWithFunctionCallingAndSystemPrompt: [OrderedDictionary<String, Any>] = [
 99 |         OrderedDictionary(uniqueKeysWithValues: [
100 |             ("role", "system") as (String, Any),
101 |             ("content", "You are a helpful assistant with access to functions. Use them if required.") as (String, Any),
102 |         ]),
103 |         OrderedDictionary(uniqueKeysWithValues: [
104 |             ("role", "functions") as (String, Any),
105 |             ("content", exampleFunctionSpec) as (String, Any),
106 |         ]),
107 |         OrderedDictionary(uniqueKeysWithValues: [
108 |             ("role", "user") as (String, Any),
109 |             ("content", "Hi, can you tell me the current stock price of AAPL?") as (String, Any),
110 |         ]),
111 |     ]
112 | 
113 |     let exampleToolJSONSchemas: OrderedDictionary<String, OrderedDictionary<String, Any>> = OrderedDictionary(
114 |         uniqueKeysWithValues: [
115 |             (
116 |                 "get_current_weather",
117 |                 OrderedDictionary(uniqueKeysWithValues: [
118 |                     ("type", "function") as (String, Any),
119 |                     (
120 |                         "function",
121 |                         OrderedDictionary(uniqueKeysWithValues: [
122 |                             ("name", "get_current_weather") as (String, Any),
123 |                             ("description", "Get the current weather in a given location") as (String, Any),
124 |                             (
125 |                                 "parameters",
126 |                                 OrderedDictionary(uniqueKeysWithValues: [
127 |                                     ("type", "object") as (String, Any),
128 |                                     (
129 |                                         "properties",
130 |                                         OrderedDictionary(uniqueKeysWithValues: [
131 |                                             (
132 |                                                 "location",
133 |                                                 OrderedDictionary(uniqueKeysWithValues: [
134 |                                                     ("type", "string") as (String, Any),
135 |                                                     ("description", "The city and state, e.g. San Francisco, CA")
136 |                                                         as (String, Any),
137 |                                                 ])
138 |                                             ) as (String, Any),
139 |                                             (
140 |                                                 "unit",
141 |                                                 OrderedDictionary(uniqueKeysWithValues: [
142 |                                                     ("type", "string") as (String, Any),
143 |                                                     ("enum", ["celsius", "fahrenheit"]) as (String, Any),
144 |                                                 ])
145 |                                             ) as (String, Any),
146 |                                         ])
147 |                                     ) as (String, Any),
148 |                                     ("required", ["location"]) as (String, Any),
149 |                                 ])
150 |                             ) as (String, Any),
151 |                         ])
152 |                     ) as (String, Any),
153 |                 ])
154 |             ),
155 |             (
156 |                 "get_current_temperature_v1",
157 |                 OrderedDictionary(uniqueKeysWithValues: [
158 |                     ("type", "function") as (String, Any),
159 |                     (
160 |                         "function",
161 |                         OrderedDictionary(uniqueKeysWithValues: [
162 |                             ("name", "get_current_temperature") as (String, Any),
163 |                             ("description", "Get the current temperature at a location.") as (String, Any),
164 |                             (
165 |                                 "parameters",
166 |                                 OrderedDictionary(uniqueKeysWithValues: [
167 |                                     ("type", "object") as (String, Any),
168 |                                     (
169 |                                         "properties",
170 |                                         OrderedDictionary(uniqueKeysWithValues: [
171 |                                             (
172 |                                                 "location",
173 |                                                 OrderedDictionary(uniqueKeysWithValues: [
174 |                                                     ("type", "string") as (String, Any),
175 |                                                     (
176 |                                                         "description",
177 |                                                         "The location to get the temperature for, in the format \"City, Country\""
178 |                                                     ) as (String, Any),
179 |                                                 ])
180 |                                             ) as (String, Any)
181 |                                         ])
182 |                                     ) as (String, Any),
183 |                                     ("required", ["location"]) as (String, Any),
184 |                                 ])
185 |                             ) as (String, Any),
186 |                             (
187 |                                 "return",
188 |                                 OrderedDictionary(uniqueKeysWithValues: [
189 |                                     ("type", "number") as (String, Any),
190 |                                     (
191 |                                         "description",
192 |                                         "The current temperature at the specified location in the specified units, as a float."
193 |                                     ) as (String, Any),
194 |                                 ])
195 |                             ) as (String, Any),
196 |                         ])
197 |                     ) as (String, Any),
198 |                 ])
199 |             ),
200 |             (
201 |                 "get_current_temperature_v2",
202 |                 OrderedDictionary(uniqueKeysWithValues: [
203 |                     ("type", "function") as (String, Any),
204 |                     (
205 |                         "function",
206 |                         OrderedDictionary(uniqueKeysWithValues: [
207 |                             ("name", "get_current_temperature") as (String, Any),
208 |                             ("description", "Get the current temperature at a location.") as (String, Any),
209 |                             (
210 |                                 "parameters",
211 |                                 OrderedDictionary(uniqueKeysWithValues: [
212 |                                     ("type", "object") as (String, Any),
213 |                                     (
214 |                                         "properties",
215 |                                         OrderedDictionary(uniqueKeysWithValues: [
216 |                                             (
217 |                                                 "location",
218 |                                                 OrderedDictionary(uniqueKeysWithValues: [
219 |                                                     ("type", "string") as (String, Any),
220 |                                                     (
221 |                                                         "description",
222 |                                                         "The location to get the temperature for, in the format \"City, Country\""
223 |                                                     ) as (String, Any),
224 |                                                 ])
225 |                                             ) as (String, Any),
226 |                                             (
227 |                                                 "unit",
228 |                                                 OrderedDictionary(uniqueKeysWithValues: [
229 |                                                     ("type", "string") as (String, Any),
230 |                                                     ("enum", ["celsius", "fahrenheit"]) as (String, Any),
231 |                                                     ("description", "The unit to return the temperature in.")
232 |                                                         as (String, Any),
233 |                                                 ])
234 |                                             ) as (String, Any),
235 |                                         ])
236 |                                     ) as (String, Any),
237 |                                     ("required", ["location", "unit"]) as (String, Any),
238 |                                 ])
239 |                             ) as (String, Any),
240 |                             (
241 |                                 "return",
242 |                                 OrderedDictionary(uniqueKeysWithValues: [
243 |                                     ("type", "number") as (String, Any),
244 |                                     (
245 |                                         "description",
246 |                                         "The current temperature at the specified location in the specified units, as a float."
247 |                                     ) as (String, Any),
248 |                                 ])
249 |                             ) as (String, Any),
250 |                         ])
251 |                     ) as (String, Any),
252 |                 ])
253 |             ),
254 |             (
255 |                 "get_current_wind_speed",
256 |                 OrderedDictionary(uniqueKeysWithValues: [
257 |                     ("type", "function") as (String, Any),
258 |                     (
259 |                         "function",
260 |                         OrderedDictionary(uniqueKeysWithValues: [
261 |                             ("name", "get_current_wind_speed") as (String, Any),
262 |                             ("description", "Get the current wind speed in km/h at a given location.") as (String, Any),
263 |                             (
264 |                                 "parameters",
265 |                                 OrderedDictionary(uniqueKeysWithValues: [
266 |                                     ("type", "object") as (String, Any),
267 |                                     (
268 |                                         "properties",
269 |                                         OrderedDictionary(uniqueKeysWithValues: [
270 |                                             (
271 |                                                 "location",
272 |                                                 OrderedDictionary(uniqueKeysWithValues: [
273 |                                                     ("type", "string") as (String, Any),
274 |                                                     (
275 |                                                         "description",
276 |                                                         "The location to get the temperature for, in the format \"City, Country\""
277 |                                                     ) as (String, Any),
278 |                                                 ])
279 |                                             ) as (String, Any)
280 |                                         ])
281 |                                     ) as (String, Any),
282 |                                     ("required", ["location"]) as (String, Any),
283 |                                 ])
284 |                             ) as (String, Any),
285 |                             (
286 |                                 "return",
287 |                                 OrderedDictionary(uniqueKeysWithValues: [
288 |                                     ("type", "number") as (String, Any),
289 |                                     ("description", "The current wind speed at the given location in km/h, as a float.")
290 |                                         as (String, Any),
291 |                                 ])
292 |                             ) as (String, Any),
293 |                         ])
294 |                     ) as (String, Any),
295 |                 ])
296 |             ),
297 |         ])
298 | 
299 |     lazy var exampleListOfTools: [OrderedDictionary<String, Any>] = [
300 |         exampleToolJSONSchemas["get_current_temperature_v2"]!,
301 |         exampleToolJSONSchemas["get_current_wind_speed"]!,
302 |     ]
303 | 
304 |     func testMeetKaiFunctionaryMediumV2_2() throws {
305 |         let chatTemplate = """
306 |             {#v2.2#}\n{% for message in messages %}\n{% if message['role'] == 'user' or message['role'] == 'system' %}\n{{ '<|from|>' + message['role'] + '\n<|recipient|>all\n<|content|>' + message['content'] + '\n' }}{% elif message['role'] == 'tool' %}\n{{ '<|from|>' + message['name'] + '\n<|recipient|>all\n<|content|>' + message['content'] + '\n' }}{% else %}\n{% set contain_content='no'%}\n{% if message['content'] is not none %}\n{{ '<|from|>assistant\n<|recipient|>all\n<|content|>' + message['content'] }}{% set contain_content='yes'%}\n{% endif %}\n{% if 'tool_calls' in message and message['tool_calls'] is not none %}\n{% for tool_call in message['tool_calls'] %}\n{% set prompt='<|from|>assistant\n<|recipient|>' + tool_call['function']['name'] + '\n<|content|>' + tool_call['function']['arguments'] %}\n{% if loop.index == 1 and contain_content == "no" %}\n{{ prompt }}{% else %}\n{{ '\n' + prompt}}{% endif %}\n{% endfor %}\n{% endif %}\n{{ '<|stop|>\n' }}{% endif %}\n{% endfor %}\n{% if add_generation_prompt %}{{ '<|from|>assistant\n<|recipient|>' }}{% endif %}
307 |             """
308 |         let template = try Template(chatTemplate)
309 |         let result = try template.render([
310 |             "messages": messagesWithFunctionCalling,
311 |             "bos_token": "<s>",
312 |             "eos_token": "</s>",
313 |             "add_generation_prompt": false,
314 |         ])
315 |         let target =
316 |             """
317 |             <|from|>assistant\n<|recipient|>get_current_weather\n<|content|>{\n  "location": "Hanoi"\n}<|stop|>\n<|from|>user\n<|recipient|>all\n<|content|>What's the weather like in Hanoi?\n
318 |             """
319 |         XCTAssertEqual(result, target)
320 |     }
321 | 
322 |     func testFireworksAIFireFunctionV1() throws {
323 |         let chatTemplate = """
324 |                 {%- set message_roles = ['SYSTEM', 'FUNCTIONS', 'USER', 'ASSISTANT', 'TOOL'] -%}\n{%- set ns = namespace(seen_non_system=false, messages=messages, content='', functions=[]) -%}\n{{ bos_token }}\n{#- Basic consistency checks -#}\n{%- if not ns.messages -%}\n  {{ raise_exception('No messages') }}\n{%- endif -%}\n{%- if ns.messages[0]['role'] | upper != 'SYSTEM' -%}\n  {%- set ns.messages = [{'role': 'SYSTEM', 'content': 'You are a helpful assistant with access to functions. Use them if required.'}] + ns.messages -%}\n{%- endif -%}\n{%- if ns.messages | length < 2 or ns.messages[0]['role'] | upper != 'SYSTEM' or ns.messages[1]['role'] | upper != 'FUNCTIONS' -%}\n  {{ raise_exception('Expected either "functions" or ["system", "functions"] as the first messages') }}\n{%- endif -%}\n{%- for message in ns.messages -%}\n  {%- set role = message['role'] | upper -%}\n  {#- Validation -#}\n  {%- if role not in message_roles -%}\n    {{ raise_exception('Invalid role ' + message['role'] + '. Only ' + message_roles + ' are supported.') }}\n  {%- endif -%}\n  {%- set ns.content = message['content'] if message.get('content') else '' -%}\n  {#- Move tool calls inside the content -#}\n  {%- if 'tool_calls' in message -%}\n    {%- for call in message['tool_calls'] -%}\n      {%- set ns.content = ns.content + '<functioncall>{"name": "' + call['function']['name'] + '", "arguments": ' + call['function']['arguments'] + '}' -%}\n    {%- endfor -%}\n  {%- endif -%}\n  {%- if role == 'ASSISTANT' and '<functioncall>' not in ns.content -%}\n    {%- set ns.content = '<plain>' + ns.content -%}\n  {%- endif -%}\n  {%- if role == 'ASSISTANT' -%}\n    {%- set ns.content = ns.content + eos_token -%}\n  {%- endif -%}\n  {{ role }}: {{ ns.content }}{{ '\\n\\n' }}\n{%- endfor -%}\nASSISTANT:{{ ' ' }}\n
325 |             """
326 |         let template = try Template(chatTemplate)
327 |         let result = try template.render([
328 |             "messages": messagesWithFunctionCallingAndSystemPrompt,
329 |             "bos_token": "<s>",
330 |             "eos_token": "</s>",
331 |             "add_generation_prompt": false,
332 |         ])
333 |         let target = """
334 |             <s>SYSTEM: You are a helpful assistant with access to functions. Use them if required.
335 | 
336 |             FUNCTIONS: [{"name": "get_stock_price", "description": "Get the current stock price", "parameters": {"type": "object", "properties": {"symbol": {"type": "string", "description": "The stock symbol, e.g. AAPL, GOOG"}}, "required": ["symbol"]}}, {"name": "check_word_anagram", "description": "Check if two words are anagrams of each other", "parameters": {"type": "object", "properties": {"word1": {"type": "string", "description": "The first word"}, "word2": {"type": "string", "description": "The second word"}}, "required": ["word1", "word2"]}}]
337 | 
338 |             USER: Hi, can you tell me the current stock price of AAPL?
339 | 
340 |             ASSISTANT: 
341 |             """
342 |         XCTAssertEqual(result, target)
343 |     }
344 | 
345 |     // Fails because tools are omitted in the output, and the result is indented.
346 |     //        func testMistral7BInstructV0_3JSONSchema() throws {
347 |     //            let chatTemplate =
348 |     //                "{{- bos_token }}\n{%- set user_messages = messages | selectattr('role', 'equalto', 'user') | list %}\n{%- for message in messages %}\n    {%- if message['role'] == 'user' %}\n        {%- if tools and (message == user_messages[-1]) %}\n            {{- ' [AVAILABLE_TOOLS] [' }}\n            {%- for tool in tools %}\n\t\t{%- set tool = tool.function %}\n\t\t{{- '{\"type\": \"function\", \"function\": {' }}\n\t\t{%- for key, val in tool|items if key != \"return\" %}\n\t\t    {%- if val is string %}\n\t\t\t{{- '\"' + key + '\": \"' + val + '\"' }}\n\t\t    {%- else %}\n\t\t\t{{- '\"' + key + '\": ' + val|tojson }}\n\t\t    {%- endif %}\n\t\t    {%- if not loop.last %}\n\t\t\t{{- \", \" }}\n\t\t    {%- endif %}\n\t\t{%- endfor %}\n\t\t{{- \"}}\" }}\n                {%- if not loop.last %}\n                    {{- \", \" }}\n                {%- else %}\n                    {{- \"]\" }}\n                {%- endif %}\n            {%- endfor %}\n            {{- ' [/AVAILABLE_TOOLS]' }}\n            {%- endif %}\n        {{- ' [INST] ' + message['content'] + ' [/INST]' }}\n    {%- elif message['role'] == 'assistant' %}\n        {%- if message.tool_calls is defined and message.tool_calls|length > 0 %}\n            {{- ' [TOOL_CALLS] [' }}\n            {%- for tool_call in message.tool_calls %}\n                {{- {\"name\": tool_call.function.name, \"arguments\": tool_call.function.arguments, \"id\": tool_call.id}|tojson }}\n                {%- if not loop.last %}\n                    {{- \", \" }}\n                {%- endif %}\n            {%- endfor %}\n            {{- '] ' }}\n            {{- eos_token }}\n    \t{%- elif message.content is defined %}\n\t    {{- ' ' + message.content + ' ' + eos_token}}\n        {%- endif %}\n    {%- elif message['role'] == 'tool' %}\n        {{- ' [TOOL_RESULTS] ' }}\n        {{- '{\"call_id\": \"' + message.tool_call_id + '\", \"content\": ' + message.content|string + '}' }}\n        {{- ' [/TOOL_RESULTS] ' }}\n    {%- endif %}\n{%- endfor %}\n"
349 |     //            let template = try Template(chatTemplate)
350 |     //
351 |     //            let result = try template.render([
352 |     //                "messages": [
353 |     //                    [
354 |     //                        "role": "system",
355 |     //                        "content":
356 |     //                            "You are a bot that responds to weather queries. You should reply with the unit used in the queried location.",
357 |     //                    ],
358 |     //                    ["role": "user", "content": "Hey, what's the temperature in Paris right now?"],
359 |     //                    [
360 |     //                        "role": "assistant",
361 |     //                        "tool_calls": [
362 |     //                            [
363 |     //                                "id": "abcdef123",
364 |     //                                "type": "function",
365 |     //                                "function": [
366 |     //                                    "name": "get_current_temperature",
367 |     //                                    "arguments": ["location": "Paris, France", "unit": "celsius"],
368 |     //                                ],
369 |     //                            ]
370 |     //                        ],
371 |     //                    ],
372 |     //                    ["role": "tool", "tool_call_id": "abcdef123", "name": "get_current_temperature", "content": "22.0"],
373 |     //                ],
374 |     //                "tools": exampleListOfTools,
375 |     //                // "tools_json": "", // TODO: Figure out how to convert the array of OrderedDictionaries to JSON
376 |     //                "bos_token": "<s>",
377 |     //                "eos_token": "</s>",
378 |     //            ])
379 |     //            let target = """
380 |     //                <s> [AVAILABLE_TOOLS] [{"type": "function", "function": {"name": "get_current_temperature", "description": "Get the current temperature at a location.", "parameters": {"type": "object", "properties": {"location": {"type": "string", "description": "The location to get the temperature for, in the format \\"City, Country\\""}, "unit": {"type": "string", "enum": ["celsius", "fahrenheit"], "description": "The unit to return the temperature in."}}, "required": ["location", "unit"]}}}, {"type": "function", "function": {"name": "get_current_wind_speed", "description": "Get the current wind speed in km/h at a given location.", "parameters": {"type": "object", "properties": {"location": {"type": "string", "description": "The location to get the temperature for, in the format \\"City, Country\\""}}, "required": ["location"]}}}] [/AVAILABLE_TOOLS] [INST] Hey, what\'s the temperature in Paris right now? [/INST] [TOOL_CALLS] [{"name": "get_current_temperature", "arguments": {"location": "Paris, France", "unit": "celsius"}, "id": "abcdef123"}] </s> [TOOL_RESULTS] {"call_id": "abcdef123", "content": 22.0} [/TOOL_RESULTS]
381 |     //                """
382 |     //
383 |     //            XCTAssertEqual(result, target)
384 |     //        }
385 | 
386 |     // Previously failed because tools are omitted in the output, now fails because of error with `map`: runtime("map filter requires either an attribute name or a function")
387 |     //    func testCISCaiMistral7BInstructV0_3SOTAGGUF() throws {
388 |     //        let chatTemplate = """
389 |     //              {{ bos_token }}{% set ns = namespace(lastuser=-1, system=false, functions=false) %}{% if tools %}{% for message in messages %}{% if message['role'] == 'user' %}{% set ns.lastuser = loop.index0 %}{% elif message['role'] == 'system' %}{% set ns.system = message['content'] %}{% endif %}{% endfor %}{% set ns.functions = tools|selectattr('type','eq','function')|map(attribute='function')|list|tojson %}{% endif %}{% for message in messages %}{% if message['role'] == 'user' %}{% if loop.index0 == ns.lastuser and ns.functions %}{{ '[AVAILABLE_TOOLS] ' }}{{ ns.functions }}{{ '[/AVAILABLE_TOOLS]' }}{% endif %}{{ '[INST] ' }}{% if loop.index0 == ns.lastuser and ns.system %}{{ ns.system + ' ' }}{% endif %}{{ message['content'] }}{{ '[/INST]' }}{% elif message['role'] == 'tool' %}{{ '[TOOL_RESULTS] ' }}{{ dict(call_id=message['tool_call_id'], content=message['content'])|tojson }}{{ '[/TOOL_RESULTS]' }}{% elif message['role'] == 'assistant' %}{% if message['tool_calls'] %}{{ '[TOOL_CALLS] [' }}{% for call in message['tool_calls'] %}{% if call['type'] == 'function' %}{{ dict(id=call['id'], name=call['function']['name'], arguments=call['function']['arguments'])|tojson }}{% endif %}{% if not loop.last %}{{ ', ' }}{% endif %}{% endfor %}{{ ']' }}{% else %}{{ message['content'] }}{% endif %}{{ eos_token }}{% endif %}{% endfor %}
390 |     //            """
391 |     //        let template = try Template(chatTemplate)
392 |     //
393 |     //        let result = try template.render([
394 |     //            "messages": [
395 |     //                [
396 |     //                    "role": "user",
397 |     //                    "content": "What's the weather like in Oslo and Stockholm?",
398 |     //                ]
399 |     //            ],
400 |     //            "tools": [exampleToolJSONSchemas["get_current_temperature_v2"]!],
401 |     //            "bos_token": "<s>",
402 |     //            "eos_token": "</s>",
403 |     //        ])
404 |     //        let target =
405 |     //            """
406 |     //            <s>[AVAILABLE_TOOLS] [{"name": "get_current_weather", "description": "Get the current weather in a given location", "parameters": {"type": "object", "properties": {"location": {"type": "string", "description": "The city and state, e.g. San Francisco, CA"}, "unit": {"type": "string", "enum": ["celsius", "fahrenheit"]}}, "required": ["location"]}}][/AVAILABLE_TOOLS][INST] What's the weather like in Oslo and Stockholm?[/INST]
407 |     //            """
408 |     //
409 |     //        XCTAssertEqual(result, target)
410 |     //    }
411 | 
412 |     func testNousResearchHermes2ProLlama38BJSONSchema() throws {
413 |         let chatTemplate = """
414 |             {%- macro json_to_python_type(json_spec) %}\n{%- set basic_type_map = {\n    "string": "str",\n    "number": "float",\n    "integer": "int",\n    "boolean": "bool"\n} %}\n\n{%- if basic_type_map[json_spec.type] is defined %}\n    {{- basic_type_map[json_spec.type] }}\n{%- elif json_spec.type == "array" %}\n    {{- "list[" +  json_to_python_type(json_spec|items) + "]"}}\n{%- elif json_spec.type == "object" %}\n    {%- if json_spec.additionalProperties is defined %}\n        {{- "dict[str, " + json_to_python_type(json_spec.additionalProperties) + ']'}}\n    {%- else %}\n        {{- "dict" }}\n    {%- endif %}\n{%- elif json_spec.type is iterable %}\n    {{- "Union[" }}\n    {%- for t in json_spec.type %}\n      {{- json_to_python_type({"type": t}) }}\n      {%- if not loop.last %}\n        {{- "," }} \n    {%- endif %}\n    {%- endfor %}\n    {{- "]" }}\n{%- else %}\n    {{- "Any" }}\n{%- endif %}\n{%- endmacro %}\n\n\n{{- bos_token }}\n{{- "You are a function calling AI model. You are provided with function signatures within <tools></tools> XML tags. You may call one or more functions to assist with the user query. Don't make assumptions about what values to plug into functions. Here are the available tools: <tools> " }}\n{%- for tool in tools %}\n    {%- if tool.function is defined %}\n        {%- set tool = tool.function %}\n    {%- endif %}\n    {{- '{"type": "function", "function": ' }}\n    {{- '{"name": ' + tool.name + '", ' }}\n    {{- '"description": "' + tool.name + '(' }}\n    {%- for param_name, param_fields in tool.parameters.properties|items %}\n        {{- param_name + ": " + json_to_python_type(param_fields) }}\n        {%- if not loop.last %}\n            {{- ", " }}\n        {%- endif %}\n    {%- endfor %}\n    {{- ")" }}\n    {%- if tool.return is defined %}\n        {{- " -> " + json_to_python_type(tool.return) }}\n    {%- endif %}\n    {{- " - " + tool.description + "\\n\\n" }}\n    {%- for param_name, param_fields in tool.parameters.properties|items %}\n        {%- if loop.first %}\n            {{- "    Args:\\n" }}\n        {%- endif %}\n        {{- "        " + param_name + "(" + json_to_python_type(param_fields) + "): " + param_fields.description|trim }}\n    {%- endfor %}\n    {%- if tool.return is defined and tool.return.description is defined %}\n        {{- "\\n    Returns:\\n        " + tool.return.description }}\n    {%- endif %}\n    {{- '"' }}\n    {{- ', "parameters": ' }}\n    {%- if tool.parameters.properties | length == 0 %}\n        {{- "{}" }}\n    {%- else %}\n        {{- tool.parameters | tojson}}\n    {%- endif %}\n    {{- "}" }}\n    {%- if not loop.last %}\n        {{- "\\n" }}\n    {%- endif %}\n{%- endfor %}\n{{- " </tools>" }}\n{{- 'Use the following pydantic model json schema for each tool call you will make: {"properties": {"arguments": {"title": "Arguments", "type": "object"}, "name": {"title": "Name", "type": "string"}}, "required": ["arguments", "name"], "title": "FunctionCall", "type": "object"}\n' }}\n{{- "For each function call return a json object with function name and arguments within <tool_call></tool_call> XML tags as follows:\n" }}\n{{- "<tool_call>\n" }}\n{{- '{"arguments": <args-dict>, "name": <function-name>}\n' }}\n{{- '</tool_call><|im_end|>' }}\n{%- for message in messages %}\n    {%- if message.role == "user" or message.role == "system" or (message.role == "assistant" and message.tool_calls is not defined) %}\n        {{- '<|im_start|>' + message.role + '\\n' + message.content + '<|im_end|>' + '\\n' }}\n    {%- elif message.role == "assistant" %}\n        {{- '<|im_start|>' + message.role + '\\n<tool_call>\\n' }}\n        {%- for tool_call in message.tool_calls %}\n            {%- if tool_call.function is defined %}\n                {%- set tool_call = tool_call.function %}\n            {%- endif %}\n            {{- '{ ' }}\n            {%- if tool_call.arguments is defined %}\n                {{- '"arguments": ' }}\n                {{- tool_call.arguments|tojson }}\n                {{- ', '}}\n            {%- endif %}\n            {{- '"name": "' }}\n            {{- tool_call.name }}\n            {{- '"}' }}\n            {{- '\\n</tool_call> ' }}\n        {%- endfor %}\n        {{- '<|im_end|>\\n' }}\n    {%- elif message.role == "tool" %}\n        {%- if not message.name is defined %}\n            {{- raise_exception("Tool response dicts require a 'name' key indicating the name of the called function!") }}\n        {%- endif %}\n        {{- '<|im_start|>' + message.role + '\\n<tool_response>\\n' }}\n        {{- '{"name": "' }}\n        {{- message.name }}\n        {{- '", "content": ' }}\n        {{- message.content|tojson + '}' }}\n        {{- '\\n</tool_response> <|im_end|>\\n' }} \n    {%- endif %}\n{%- endfor %}\n{%- if add_generation_prompt %}\n    {{- '<|im_start|>assistant\\n' }}\n{%- endif %}\n
415 |             """
416 |         let template = try Template(chatTemplate)
417 |         let result = try template.render([
418 |             "messages": [
419 |                 OrderedDictionary(uniqueKeysWithValues: [
420 |                     ("role", "user") as (String, Any),
421 |                     ("content", "Fetch the stock fundamentals data for Tesla (TSLA)") as (String, Any),
422 |                 ])
423 |             ],
424 |             "tools": [
425 |                 OrderedDictionary(uniqueKeysWithValues: [
426 |                     ("type", "function") as (String, Any),
427 |                     (
428 |                         "function",
429 |                         OrderedDictionary(uniqueKeysWithValues: [
430 |                             ("name", "get_stock_fundamentals") as (String, Any),
431 |                             ("description", "Get fundamental data for a given stock symbol using yfinance API.")
432 |                                 as (String, Any),
433 |                             (
434 |                                 "parameters",
435 |                                 OrderedDictionary(uniqueKeysWithValues: [
436 |                                     ("type", "object") as (String, Any),
437 |                                     (
438 |                                         "properties",
439 |                                         OrderedDictionary(uniqueKeysWithValues: [
440 |                                             (
441 |                                                 "symbol",
442 |                                                 OrderedDictionary(uniqueKeysWithValues: [
443 |                                                     ("type", "string") as (String, Any),
444 |                                                     ("description", "The stock symbol.") as (String, Any),
445 |                                                 ])
446 |                                             ) as (String, Any)
447 |                                         ])
448 |                                     ) as (String, Any),
449 |                                     ("required", ["symbol"]) as (String, Any),
450 |                                 ])
451 |                             ) as (String, Any),
452 |                             (
453 |                                 "return",
454 |                                 OrderedDictionary(uniqueKeysWithValues: [
455 |                                     ("type", "object") as (String, Any),
456 |                                     (
457 |                                         "description",
458 |                                         """
459 |                                         A dictionary containing fundamental data.
460 | 
461 |                                         Keys:
462 |                                             - 'symbol': The stock symbol.
463 |                                             - 'company_name': The long name of the company.
464 |                                             - 'sector': The sector to which the company belongs.
465 |                                             - 'industry': The industry to which the company belongs.
466 |                                             - 'market_cap': The market capitalization of the company.
467 |                                             - 'pe_ratio': The forward price-to-earnings ratio.
468 |                                             - 'pb_ratio': The price-to-book ratio.
469 |                                             - 'dividend_yield': The dividend yield.
470 |                                             - 'eps': The trailing earnings per share.
471 |                                             - 'beta': The beta value of the stock.
472 |                                             - '52_week_high': The 52-week high price of the stock.
473 |                                             - '52_week_low': The 52-week low price of the stock.
474 |                                         """
475 |                                     ) as (String, Any),
476 |                                 ])
477 |                             ) as (String, Any),
478 |                         ])
479 |                     ) as (String, Any),
480 |                 ])
481 |             ],
482 |             "bos_token": "<|begin_of_text|>",
483 |             "eos_token": "<|im_end|>",
484 |             "add_generation_prompt": true,
485 |         ])
486 |         let target = """
487 |             <|begin_of_text|>You are a function calling AI model. You are provided with function signatures within <tools></tools> XML tags. You may call one or more functions to assist with the user query. Don't make assumptions about what values to plug into functions. Here are the available tools: <tools> {"type": "function", "function": {"name": get_stock_fundamentals", "description": "get_stock_fundamentals(symbol: str) -> dict - Get fundamental data for a given stock symbol using yfinance API.\n\n    Args:\n        symbol(str): The stock symbol.\n    Returns:\n        A dictionary containing fundamental data.\n\nKeys:\n    - 'symbol': The stock symbol.\n    - 'company_name': The long name of the company.\n    - 'sector': The sector to which the company belongs.\n    - 'industry': The industry to which the company belongs.\n    - 'market_cap': The market capitalization of the company.\n    - 'pe_ratio': The forward price-to-earnings ratio.\n    - 'pb_ratio': The price-to-book ratio.\n    - 'dividend_yield': The dividend yield.\n    - 'eps': The trailing earnings per share.\n    - 'beta': The beta value of the stock.\n    - '52_week_high': The 52-week high price of the stock.\n    - '52_week_low': The 52-week low price of the stock.", "parameters": {"type": "object", "properties": {"symbol": {"type": "string", "description": "The stock symbol."}}, "required": ["symbol"]}} </tools>Use the following pydantic model json schema for each tool call you will make: {"properties": {"arguments": {"title": "Arguments", "type": "object"}, "name": {"title": "Name", "type": "string"}}, "required": ["arguments", "name"], "title": "FunctionCall", "type": "object"}\nFor each function call return a json object with function name and arguments within <tool_call></tool_call> XML tags as follows:\n<tool_call>\n{"arguments": <args-dict>, "name": <function-name>}\n</tool_call><|im_end|><|im_start|>user\nFetch the stock fundamentals data for Tesla (TSLA)<|im_end|>\n<|im_start|>assistant\n
488 |             """
489 |         XCTAssertEqual(result, target)
490 |     }
491 | 
492 |     //    func testMetaLlamaLlama3_18BInstruct() throws {
493 |     //        let chatTemplate = """
494 |     //            {{- bos_token }}\n{%- if custom_tools is defined %}\n    {%- set tools = custom_tools %}\n{%- endif %}\n{%- if not tools_in_user_message is defined %}\n    {%- set tools_in_user_message = true %}\n{%- endif %}\n{%- if not date_string is defined %}\n    {%- set date_string = "26 Jul 2024" %}\n{%- endif %}\n{%- if not tools is defined %}\n    {%- set tools = none %}\n{%- endif %}\n\n{#- This block extracts the system message, so we can slot it into the right place. #}\n{%- if messages[0]['role'] == 'system' %}\n    {%- set system_message = messages[0]['content']|trim %}\n    {%- set messages = messages[1:] %}\n{%- else %}\n    {%- set system_message = "" %}\n{%- endif %}\n\n{#- System message + builtin tools #}\n{{- "<|start_header_id|>system<|end_header_id|>\\n\\n" }}\n{%- if builtin_tools is defined or tools is not none %}\n    {{- "Environment: ipython\\n" }}\n{%- endif %}\n{%- if builtin_tools is defined %}\n    {{- "Tools: " + builtin_tools | reject('equalto', 'code_interpreter') | join(", ") + "\\n\\n"}}\n{%- endif %}\n{{- "Cutting Knowledge Date: December 2023\\n" }}\n{{- "Today Date: " + date_string + "\\n\\n" }}\n{%- if tools is not none and not tools_in_user_message %}\n    {{- "You have access to the following functions. To call a function, please respond with JSON for a function call." }}\n    {{- 'Respond in the format {"name": function name, "parameters": dictionary of argument name and its value}.' }}\n    {{- "Do not use variables.\\n\\n" }}\n    {%- for t in tools %}\n        {{- t | tojson(indent=4) }}\n        {{- "\\n\\n" }}\n    {%- endfor %}\n{%- endif %}\n{{- system_message }}\n{{- "<|eot_id|>" }}\n\n{#- Custom tools are passed in a user message with some extra guidance #}\n{%- if tools_in_user_message and not tools is none %}\n    {#- Extract the first user message so we can plug it in here #}\n    {%- if messages | length != 0 %}\n        {%- set first_user_message = messages[0]['content']|trim %}\n        {%- set messages = messages[1:] %}\n    {%- else %}\n        {{- raise_exception("Cannot put tools in the first user message when there's no first user message!") }}\n{%- endif %}\n    {{- '<|start_header_id|>user<|end_header_id|>\\n\\n' -}}\n    {{- "Given the following functions, please respond with a JSON for a function call " }}\n    {{- "with its proper arguments that best answers the given prompt.\\n\\n" }}\n    {{- 'Respond in the format {"name": function name, "parameters": dictionary of argument name and its value}.' }}\n    {{- "Do not use variables.\\n\\n" }}\n    {%- for t in tools %}\n        {{- t | tojson(indent=4) }}\n        {{- "\\n\\n" }}\n    {%- endfor %}\n    {{- first_user_message + "<|eot_id|>"}}\n{%- endif %}\n\n{%- for message in messages %}\n    {%- if not (message.role == 'ipython' or message.role == 'tool' or 'tool_calls' in message) %}\n        {{- '<|start_header_id|>' + message['role'] + '<|end_header_id|>\\n\\n'+ message['content'] | trim + '<|eot_id|>' }}\n    {%- elif 'tool_calls' in message %}\n        {%- if not message.tool_calls|length == 1 %}\n            {{- raise_exception("This model only supports single tool-calls at once!") }}\n        {%- endif %}\n        {%- set tool_call = message.tool_calls[0].function %}\n        {%- if builtin_tools is defined and tool_call.name in builtin_tools %}\n            {{- '<|start_header_id|>assistant<|end_header_id|>\\n\\n' -}}\n            {{- "<|python_tag|>" + tool_call.name + ".call(" }}\n            {%- for arg_name, arg_val in tool_call.arguments | items %}\n                {{- arg_name + '="' + arg_val + '"' }}\n                {%- if not loop.last %}\n                    {{- ", " }}\n                {%- endif %}\n                {%- endfor %}\n            {{- ")" }}\n        {%- else  %}\n            {{- '<|start_header_id|>assistant<|end_header_id|>\\n\\n' -}}\n            {{- '{"name": "' + tool_call.name + '", ' }}\n            {{- '"parameters": ' }}\n            {{- tool_call.arguments | tojson }}\n            {{- "}" }}\n        {%- endif %}\n        {%- if builtin_tools is defined %}\n            {#- This means we're in ipython mode #}\n            {{- "<|eom_id|>" }}\n        {%- else %}\n            {{- "<|eot_id|>" }}\n        {%- endif %}\n    {%- elif message.role == "tool" or message.role == "ipython" %}\n        {{- "<|start_header_id|>ipython<|end_header_id|>\\n\\n" }}\n        {%- if message.content is mapping or message.content is iterable %}\n            {{- message.content | tojson }}\n        {%- else %}\n            {{- message.content }}\n        {%- endif %}\n        {{- "<|eot_id|>" }}\n    {%- endif %}\n{%- endfor %}\n{%- if add_generation_prompt %}\n    {{- '<|start_header_id|>assistant<|end_header_id|>\\n\\n' }}\n{%- endif %}\n
495 |     //            """
496 |     //        let template = try Template(chatTemplate)
497 |     //        let result = try template.render([
498 |     //            "messages": [
499 |     //                ["role": "system", "content": "You are a bot that responds to weather queries."],
500 |     //                ["role": "user", "content": "Hey, what's the temperature in Paris right now?"],
501 |     //            ],
502 |     //            "tools": [exampleToolJSONSchemas["get_current_temperature_v1"]!],
503 |     //            "bos_token": "<|begin_of_text|>",
504 |     //            "eos_token": "<|im_end|>",
505 |     //            "add_generation_prompt": true,
506 |     //        ])
507 |     //        let target = """
508 |     //            <|begin_of_text|><|start_header_id|>system<|end_header_id|>\n\nEnvironment: ipython\nCutting Knowledge Date: December 2023\nToday Date: 26 Jul 2024\n\nYou are a bot that responds to weather queries.<|eot_id|><|start_header_id|>user<|end_header_id|>\n\nGiven the following functions, please respond with a JSON for a function call with its proper arguments that best answers the given prompt.\n\nRespond in the format {"name": function name, "parameters": dictionary of argument name and its value}.Do not use variables.\n\n{\n    "type": "function",\n    "function": {\n        "name": "get_current_temperature",\n        "description": "Get the current temperature at a location.",\n        "parameters": {\n            "type": "object",\n            "properties": {\n                "location": {\n                    "type": "string",\n                    "description": "The location to get the temperature for, in the format \\"City, Country\\""\n                }\n            },\n            "required": [\n                "location"\n            ]\n        },\n        "return": {\n            "type": "number",\n            "description": "The current temperature at the specified location in the specified units, as a float."\n        }\n    }\n}\n\nHey, what's the temperature in Paris right now?<|eot_id|><|start_header_id|>assistant<|end_header_id|>\n\n
509 |     //            """
510 |     //        XCTAssertEqual(result, target)
511 |     //    }
512 | 
513 |     //
514 | 
515 |     func testLlama3_1() throws {
516 |         let chatTemplate = ChatTemplate.llama3_1
517 |         let template = try Template(chatTemplate)
518 |         let result = try template.render([
519 |             "messages": Messages.weatherQuery,
520 |             "tools": [ToolSpec.getCurrentWeather],
521 |             "bos_token": "<|begin_of_text|>",
522 |             //      "eos_token": "<|im_end|>",
523 |             "add_generation_prompt": true,
524 |         ])
525 |         let target = """
526 |             <|begin_of_text|><|start_header_id|>system<|end_header_id|>
527 | 
528 |             Environment: ipython
529 |             Cutting Knowledge Date: December 2023
530 |             Today Date: 26 Jul 2024
531 | 
532 |             <|eot_id|><|start_header_id|>user<|end_header_id|>
533 | 
534 |             Given the following functions, please respond with a JSON for a function call with its proper arguments that best answers the given prompt.
535 | 
536 |             Respond in the format {"name": function name, "parameters": dictionary of argument name and its value}.Do not use variables.
537 | 
538 |             {
539 |                 "type": "function",
540 |                 "function": {
541 |                     "name": "get_current_weather",
542 |                     "description": "Get the current weather in a given location",
543 |                     "parameters": {
544 |                         "type": "object",
545 |                         "properties": {
546 |                             "location": {
547 |                                 "type": "string",
548 |                                 "description": "The city and state, e.g. San Francisco, CA"
549 |                             },
550 |                             "unit": {
551 |                                 "type": "string",
552 |                                 "enum": [
553 |                                     "celsius",
554 |                                     "fahrenheit"
555 |                                 ]
556 |                             }
557 |                         },
558 |                         "required": [
559 |                             "location"
560 |                         ]
561 |                     }
562 |                 }
563 |             }
564 | 
565 |             What is the weather in Paris today?<|eot_id|><|start_header_id|>assistant<|end_header_id|>
566 | 
567 | 
568 |             """
569 |         XCTAssertEqual(result, target)
570 |     }
571 | 
572 |     func testLlama3_2() throws {
573 |         let chatTemplate = ChatTemplate.llama3_2
574 |         let template = try Template(chatTemplate)
575 |         let result = try template.render([
576 |             "messages": Messages.weatherQuery,
577 |             "tools": [ToolSpec.getCurrentWeather],
578 |             "bos_token": "<|begin_of_text|>",
579 |             //      "eos_token": "<|im_end|>",
580 |             "add_generation_prompt": true,
581 |         ])
582 |         let target = """
583 |             <|begin_of_text|><|start_header_id|>system<|end_header_id|>
584 | 
585 |             Environment: ipython
586 |             Cutting Knowledge Date: December 2023
587 |             Today Date: \(Environment.formatDate(Date(), withFormat: "%d %b %Y"))
588 | 
589 |             <|eot_id|><|start_header_id|>user<|end_header_id|>
590 | 
591 |             Given the following functions, please respond with a JSON for a function call with its proper arguments that best answers the given prompt.
592 | 
593 |             Respond in the format {"name": function name, "parameters": dictionary of argument name and its value}.Do not use variables.
594 | 
595 |             {
596 |                 "type": "function",
597 |                 "function": {
598 |                     "name": "get_current_weather",
599 |                     "description": "Get the current weather in a given location",
600 |                     "parameters": {
601 |                         "type": "object",
602 |                         "properties": {
603 |                             "location": {
604 |                                 "type": "string",
605 |                                 "description": "The city and state, e.g. San Francisco, CA"
606 |                             },
607 |                             "unit": {
608 |                                 "type": "string",
609 |                                 "enum": [
610 |                                     "celsius",
611 |                                     "fahrenheit"
612 |                                 ]
613 |                             }
614 |                         },
615 |                         "required": [
616 |                             "location"
617 |                         ]
618 |                     }
619 |                 }
620 |             }
621 | 
622 |             What is the weather in Paris today?<|eot_id|><|start_header_id|>assistant<|end_header_id|>
623 | 
624 | 
625 |             """
626 |         XCTAssertEqual(result, target)
627 |     }
628 | 
629 |     func testQwen2_5() throws {
630 |         let chatTemplate = ChatTemplate.qwen2_5
631 |         let template = try Template(chatTemplate)
632 |         let result = try template.render([
633 |             "messages": Messages.weatherQuery,
634 |             "tools": [ToolSpec.getCurrentWeather],
635 |             "bos_token": "<|begin_of_text|>",
636 |             //      "eos_token": "<|im_end|>",
637 |             "add_generation_prompt": true,
638 |         ])
639 |         let target = """
640 |             <|im_start|>system
641 |             You are Qwen, created by Alibaba Cloud. You are a helpful assistant.
642 | 
643 |             # Tools
644 | 
645 |             You may call one or more functions to assist with the user query.
646 | 
647 |             You are provided with function signatures within <tools></tools> XML tags:
648 |             <tools>
649 |             {"type": "function", "function": {"name": "get_current_weather", "description": "Get the current weather in a given location", "parameters": {"type": "object", "properties": {"location": {"type": "string", "description": "The city and state, e.g. San Francisco, CA"}, "unit": {"type": "string", "enum": ["celsius", "fahrenheit"]}}, "required": ["location"]}}}
650 |             </tools>
651 | 
652 |             For each function call, return a json object with function name and arguments within <tool_call></tool_call> XML tags:
653 |             <tool_call>
654 |             {"name": <function-name>, "arguments": <args-json-object>}
655 |             </tool_call><|im_end|>
656 |             <|im_start|>user
657 |             What is the weather in Paris today?<|im_end|>
658 |             <|im_start|>assistant
659 | 
660 |             """
661 |         XCTAssertEqual(result, target)
662 |     }
663 | 
664 |     func testMistral7b() throws {
665 |         let chatTemplate = ChatTemplate.mistral7b
666 |         let template = try Template(chatTemplate)
667 |         let result = try template.render([
668 |             "messages": Messages.weatherQuery,
669 |             "tools": [ToolSpec.getCurrentWeather],
670 |             "bos_token": "<|begin_of_text|>",
671 |             //      "eos_token": "<|im_end|>",
672 |             "add_generation_prompt": true,
673 |         ])
674 |         let target = """
675 |             <|begin_of_text|>[AVAILABLE_TOOLS][{"type": "function", "function": {"name": "get_current_weather", "description": "Get the current weather in a given location", "parameters": {"type": "object", "properties": {"location": {"type": "string", "description": "The city and state, e.g. San Francisco, CA"}, "unit": {"type": "string", "enum": ["celsius", "fahrenheit"]}}, "required": ["location"]}}}][/AVAILABLE_TOOLS][INST]What is the weather in Paris today?[/INST]
676 |             """
677 |         XCTAssertEqual(result, target)
678 |     }
679 | }
680 | 
681 | extension Data {
682 |     var string: String? {
683 |         return String(data: self, encoding: .utf8)
684 |     }
685 | }
686 | 


--------------------------------------------------------------------------------
/Tests/Templates/VisionTests.swift:
--------------------------------------------------------------------------------
  1 | //
  2 | //  VisionTests.swift
  3 | //  Jinja
  4 | //
  5 | //  Created by Anthony DePasquale on 31.12.2024.
  6 | //
  7 | 
  8 | import XCTest
  9 | import OrderedCollections
 10 | 
 11 | @testable import Jinja
 12 | 
 13 | final class VisionTests: XCTestCase {
 14 |     let llama3_2visionChatTemplate =
 15 |         "{{- bos_token }}\n{%- if custom_tools is defined %}\n    {%- set tools = custom_tools %}\n{%- endif %}\n{%- if not tools_in_user_message is defined %}\n    {%- set tools_in_user_message = true %}\n{%- endif %}\n{%- if not date_string is defined %}\n    {%- if strftime_now is defined %}\n        {%- set date_string = strftime_now(\"%d %b %Y\") %}\n    {%- else %}\n        {%- set date_string = \"26 Jul 2024\" %}\n    {%- endif %}\n{%- endif %}\n{%- if not tools is defined %}\n    {%- set tools = none %}\n{%- endif %}\n\n{#- This block extracts the system message, so we can slot it into the right place. #}\n{%- if messages[0]['role'] == 'system' %}\n    {%- set system_message = messages[0]['content']|trim %}\n    {%- set messages = messages[1:] %}\n{%- else %}\n    {%- set system_message = \"\" %}\n{%- endif %}\n\n{#- Find out if there are any images #}\n{% set image_ns = namespace(has_images=false) %}      \n{%- for message in messages %}\n    {%- for content in message['content'] %}\n        {%- if content['type'] == 'image' %}\n            {%- set image_ns.has_images = true %}\n        {%- endif %}\n    {%- endfor %}\n{%- endfor %}\n\n{#- Error out if there are images and system message #}\n{%- if image_ns.has_images and not system_message == \"\" %}\n    {{- raise_exception(\"Prompting with images is incompatible with system messages.\") }}\n{%- endif %}\n\n{#- System message if there are no images #}\n{%- if not image_ns.has_images %}\n    {{- \"<|start_header_id|>system<|end_header_id|>\\n\\n\" }}\n    {%- if tools is not none %}\n        {{- \"Environment: ipython\\n\" }}\n    {%- endif %}\n    {{- \"Cutting Knowledge Date: December 2023\\n\" }}\n    {{- \"Today Date: \" + date_string + \"\\n\\n\" }}\n    {%- if tools is not none and not tools_in_user_message %}\n        {{- \"You have access to the following functions. To call a function, please respond with JSON for a function call.\" }}\n        {{- 'Respond in the format {\"name\": function name, \"parameters\": dictionary of argument name and its value}.' }}\n        {{- \"Do not use variables.\\n\\n\" }}\n        {%- for t in tools %}\n            {{- t | tojson(indent=4) }}\n            {{- \"\\n\\n\" }}\n        {%- endfor %}\n    {%- endif %}\n    {{- system_message }}\n    {{- \"<|eot_id|>\" }}\n{%- endif %}\n\n{#- Custom tools are passed in a user message with some extra guidance #}\n{%- if tools_in_user_message and not tools is none %}\n    {#- Extract the first user message so we can plug it in here #}\n    {%- if messages | length != 0 %}\n        {%- set first_user_message = messages[0]['content']|trim %}\n        {%- set messages = messages[1:] %}\n    {%- else %}\n        {{- raise_exception(\"Cannot put tools in the first user message when there's no first user message!\") }}\n{%- endif %}\n    {{- '<|start_header_id|>user<|end_header_id|>\\n\\n' -}}\n    {{- \"Given the following functions, please respond with a JSON for a function call \" }}\n    {{- \"with its proper arguments that best answers the given prompt.\\n\\n\" }}\n    {{- 'Respond in the format {\"name\": function name, \"parameters\": dictionary of argument name and its value}.' }}\n    {{- \"Do not use variables.\\n\\n\" }}\n    {%- for t in tools %}\n        {{- t | tojson(indent=4) }}\n        {{- \"\\n\\n\" }}\n    {%- endfor %}\n    {{- first_user_message + \"<|eot_id|>\"}}\n{%- endif %}\n\n{%- for message in messages %}\n    {%- if not (message.role == 'ipython' or message.role == 'tool' or 'tool_calls' in message) %}\n    {{- '<|start_header_id|>' + message['role'] + '<|end_header_id|>\\n\\n' }}\n        {%- if message['content'] is string %}\n            {{- message['content'] }}\n        {%- else %}\n            {%- for content in message['content'] %}\n                {%- if content['type'] == 'image' %}\n                    {{- '<|image|>' }}\n                {%- elif content['type'] == 'text' %}\n                    {{- content['text'] }}\n                {%- endif %}\n            {%- endfor %}\n        {%- endif %}\n        {{- '<|eot_id|>' }}\n    {%- elif 'tool_calls' in message %}\n        {%- if not message.tool_calls|length == 1 %}\n            {{- raise_exception(\"This model only supports single tool-calls at once!\") }}\n        {%- endif %}\n        {%- set tool_call = message.tool_calls[0].function %}\n        {{- '<|start_header_id|>assistant<|end_header_id|>\\n\\n' -}}\n        {{- '{\"name\": \"' + tool_call.name + '\", ' }}\n        {{- '\"parameters\": ' }}\n        {{- tool_call.arguments | tojson }}\n        {{- \"}\" }}\n        {{- \"<|eot_id|>\" }}\n    {%- elif message.role == \"tool\" or message.role == \"ipython\" %}\n        {{- \"<|start_header_id|>ipython<|end_header_id|>\\n\\n\" }}\n        {%- if message.content is mapping or message.content is iterable %}\n            {{- message.content | tojson }}\n        {%- else %}\n            {{- message.content }}\n        {%- endif %}\n        {{- \"<|eot_id|>\" }}\n    {%- endif %}\n{%- endfor %}\n{%- if add_generation_prompt %}\n    {{- '<|start_header_id|>assistant<|end_header_id|>\\n\\n' }}\n{%- endif %}\n"
 16 |     let qwen2VLChatTemplate =
 17 |         "{% set image_count = namespace(value=0) %}{% set video_count = namespace(value=0) %}{% for message in messages %}{% if loop.first and message['role'] != 'system' %}<|im_start|>system\nYou are a helpful assistant.<|im_end|>\n{% endif %}<|im_start|>{{ message['role'] }}\n{% if message['content'] is string %}{{ message['content'] }}<|im_end|>\n{% else %}{% for content in message['content'] %}{% if content['type'] == 'image' or 'image' in content or 'image_url' in content %}{% set image_count.value = image_count.value + 1 %}{% if add_vision_id %}Picture {{ image_count.value }}: {% endif %}<|vision_start|><|image_pad|><|vision_end|>{% elif content['type'] == 'video' or 'video' in content %}{% set video_count.value = video_count.value + 1 %}{% if add_vision_id %}Video {{ video_count.value }}: {% endif %}<|vision_start|><|video_pad|><|vision_end|>{% elif 'text' in content %}{{ content['text'] }}{% endif %}{% endfor %}<|im_end|>\n{% endif %}{% endfor %}{% if add_generation_prompt %}<|im_start|>assistant\n{% endif %}"
 18 | 
 19 |     func testLlama3_2_11BVisionInstructTextChatOnly() throws {
 20 |         let template = try Template(llama3_2visionChatTemplate)
 21 |         let result = try template.render([
 22 |             "messages": [
 23 |                 [
 24 |                     "role": "user",
 25 |                     "content": [
 26 |                         [
 27 |                             "type": "text",
 28 |                             "text": "Hello, how are you?",
 29 |                         ] as [String: Any]
 30 |                     ] as [[String: Any]],
 31 |                 ] as [String: Any],
 32 |                 [
 33 |                     "role": "assistant",
 34 |                     "content": [
 35 |                         [
 36 |                             "type": "text",
 37 |                             "text": "I'm doing great. How can I help you today?",
 38 |                         ] as [String: Any]
 39 |                     ] as [[String: Any]],
 40 |                 ] as [String: Any],
 41 |                 [
 42 |                     "role": "user",
 43 |                     "content": [
 44 |                         [
 45 |                             "type": "text",
 46 |                             "text": "I'd like to show off how chat templating works!",
 47 |                         ] as [String: Any]
 48 |                     ] as [[String: Any]],
 49 |                 ] as [String: Any],
 50 |             ] as [[String: Any]] as Any,
 51 |             "bos_token": "<s>" as Any,
 52 |             "date_string": "26 Jul 2024" as Any,
 53 |             "tools_in_user_message": true as Any,
 54 |             "system_message": "You are a helpful assistant." as Any,
 55 |             "add_generation_prompt": true as Any,
 56 |         ])
 57 |         let target =
 58 |             "<s>\n<|start_header_id|>system<|end_header_id|>\n\nCutting Knowledge Date: December 2023\nToday Date: 26 Jul 2024\n\n<|eot_id|><|start_header_id|>user<|end_header_id|>\n\nHello, how are you?<|eot_id|><|start_header_id|>assistant<|end_header_id|>\n\nI'm doing great. How can I help you today?<|eot_id|><|start_header_id|>user<|end_header_id|>\n\nI'd like to show off how chat templating works!<|eot_id|><|start_header_id|>assistant<|end_header_id|>\n\n"
 59 |         XCTAssertEqual(result, target)
 60 |     }
 61 | 
 62 |     func testLlama3_2_11BVisionInstructWithImages() throws {
 63 |         let template = try Template(llama3_2visionChatTemplate)
 64 |         let result = try template.render([
 65 |             "messages": [
 66 |                 [
 67 |                     "role": "user",
 68 |                     "content": [
 69 |                         [
 70 |                             "type": "text",
 71 |                             "text": "What's in this image?",
 72 |                         ] as [String: Any],
 73 |                         [
 74 |                             "type": "image",
 75 |                             "image": "base64_encoded_image_data",
 76 |                         ] as [String: Any],
 77 |                     ] as [[String: Any]],
 78 |                 ] as [String: Any]
 79 |             ] as [[String: Any]],
 80 |             "bos_token": "<s>" as Any,
 81 |             "add_generation_prompt": true as Any,
 82 |         ])
 83 |         let target = """
 84 |             <s>
 85 |             <|start_header_id|>user<|end_header_id|>
 86 | 
 87 |             What's in this image?<|image|><|eot_id|><|start_header_id|>assistant<|end_header_id|>
 88 | 
 89 | 
 90 |             """
 91 |         XCTAssertEqual(result, target)
 92 |     }
 93 | 
 94 |     func testQwen2VLWithImages() throws {
 95 |         let template = try Template(qwen2VLChatTemplate)
 96 |         let result = try template.render([
 97 |             "messages": [
 98 |                 [
 99 |                     "role": "user",
100 |                     "content": [
101 |                         [
102 |                             "type": "text",
103 |                             "text": "What's in this image?",
104 |                         ] as [String: String],
105 |                         [
106 |                             "type": "image",
107 |                             "image_url": "example.jpg",
108 |                         ] as [String: String],
109 |                     ] as [[String: String]],
110 |                 ] as [String: Any]
111 |             ] as [[String: Any]],
112 |             "add_generation_prompt": true,
113 |             "add_vision_id": true,
114 |         ])
115 |         let target = """
116 |             <|im_start|>system
117 |             You are a helpful assistant.<|im_end|>
118 |             <|im_start|>user
119 |             What's in this image?Picture 1: <|vision_start|><|image_pad|><|vision_end|><|im_end|>
120 |             <|im_start|>assistant
121 | 
122 |             """
123 |         XCTAssertEqual(result, target)
124 |     }
125 | 
126 |     func testQwen2VLWithVideo() throws {
127 |         let template = try Template(qwen2VLChatTemplate)
128 |         let result = try template.render([
129 |             "messages": [
130 |                 [
131 |                     "role": "user",
132 |                     "content": [
133 |                         [
134 |                             "type": "text",
135 |                             "text": "What's happening in this video?",
136 |                         ] as [String: String],
137 |                         [
138 |                             "type": "video",
139 |                             "video_url": "example.mp4",
140 |                         ] as [String: String],
141 |                     ] as [[String: String]],
142 |                 ] as [String: Any]
143 |             ] as [[String: Any]],
144 |             "add_generation_prompt": true,
145 |             "add_vision_id": true,
146 |         ])
147 |         let target = """
148 |             <|im_start|>system
149 |             You are a helpful assistant.<|im_end|>
150 |             <|im_start|>user
151 |             What's happening in this video?Video 1: <|vision_start|><|video_pad|><|vision_end|><|im_end|>
152 |             <|im_start|>assistant
153 | 
154 |             """
155 |         XCTAssertEqual(result, target)
156 |     }
157 | 
158 |     func testLlama3_2_11BVisionInstructWithTools() throws {
159 |         let template = try Template(llama3_2visionChatTemplate)
160 | 
161 |         let tools: [OrderedDictionary<String, Any>] = [
162 |             OrderedDictionary(uniqueKeysWithValues: [
163 |                 ("type", "function" as Any),
164 |                 (
165 |                     "function",
166 |                     OrderedDictionary(uniqueKeysWithValues: [
167 |                         ("name", "get_current_weather" as Any),
168 |                         ("description", "Get the current weather in a given location" as Any),
169 |                         (
170 |                             "parameters",
171 |                             OrderedDictionary(uniqueKeysWithValues: [
172 |                                 ("type", "object" as Any),
173 |                                 (
174 |                                     "properties",
175 |                                     OrderedDictionary(uniqueKeysWithValues: [
176 |                                         (
177 |                                             "location",
178 |                                             OrderedDictionary(uniqueKeysWithValues: [
179 |                                                 ("type", "string" as Any),
180 |                                                 ("description", "The city and state, e.g. San Francisco, CA" as Any),
181 |                                             ]) as Any
182 |                                         ),
183 |                                         (
184 |                                             "unit",
185 |                                             OrderedDictionary(uniqueKeysWithValues: [
186 |                                                 ("type", "string" as Any),
187 |                                                 ("enum", ["celsius", "fahrenheit"] as Any),
188 |                                             ]) as Any
189 |                                         ),
190 |                                     ]) as Any
191 |                                 ),
192 |                                 ("required", ["location"] as Any),
193 |                             ]) as Any
194 |                         ),
195 |                     ]) as Any
196 |                 ),
197 |             ])
198 |         ]
199 | 
200 |         let result = try template.render([
201 |             "messages": [
202 |                 [
203 |                     "role": "system",
204 |                     "content": "You are a helpful assistant.",
205 |                 ],
206 |                 [
207 |                     "role": "user",
208 |                     "content": "What's the weather like in San Francisco?",
209 |                 ] as [String: Any],
210 |             ] as [[String: Any]] as Any,
211 |             "bos_token": "<s>" as Any,
212 |             "add_generation_prompt": true as Any,
213 |             "tools": tools as Any,
214 |             "tools_in_user_message": true as Any,
215 |         ])
216 |         let target = """
217 |             <s>
218 |             <|start_header_id|>system<|end_header_id|>
219 | 
220 |             Environment: ipython
221 |             Cutting Knowledge Date: December 2023
222 |             Today Date: \(Environment.formatDate(Date(), withFormat: "%d %b %Y"))
223 | 
224 |             You are a helpful assistant.<|eot_id|><|start_header_id|>user<|end_header_id|>
225 | 
226 |             Given the following functions, please respond with a JSON for a function call with its proper arguments that best answers the given prompt.
227 | 
228 |             Respond in the format {"name": function name, "parameters": dictionary of argument name and its value}.Do not use variables.
229 | 
230 |             {
231 |                 "type": "function",
232 |                 "function": {
233 |                     "name": "get_current_weather",
234 |                     "description": "Get the current weather in a given location",
235 |                     "parameters": {
236 |                         "type": "object",
237 |                         "properties": {
238 |                             "location": {
239 |                                 "type": "string",
240 |                                 "description": "The city and state, e.g. San Francisco, CA"
241 |                             },
242 |                             "unit": {
243 |                                 "type": "string",
244 |                                 "enum": [
245 |                                     "celsius",
246 |                                     "fahrenheit"
247 |                                 ]
248 |                             }
249 |                         },
250 |                         "required": [
251 |                             "location"
252 |                         ]
253 |                     }
254 |                 }
255 |             }
256 | 
257 |             What's the weather like in San Francisco?<|eot_id|><|start_header_id|>assistant<|end_header_id|>
258 | 
259 | 
260 |             """
261 |         XCTAssertEqual(result, target)
262 |     }
263 | }
264 | 


--------------------------------------------------------------------------------
/Tests/TestTests.swift:
--------------------------------------------------------------------------------
  1 | //
  2 | //  TestTests.swift
  3 | //  Jinja
  4 | //
  5 | //  Created by Anthony DePasquale on 07.01.2025.
  6 | //
  7 | 
  8 | // Adapted from https://github.com/pallets/jinja/blob/main/tests/test_tests.py
  9 | 
 10 | import XCTest
 11 | @testable import Jinja
 12 | 
 13 | final class TestTests: XCTestCase {
 14 |     func testTests() throws {
 15 |         // Helper function to run tests
 16 |         func runTest(
 17 |             testName: String,
 18 |             input: Any,
 19 |             args: [Any?] = [],
 20 |             expected: Bool,
 21 |             file: StaticString = #file,
 22 |             line: UInt = #line
 23 |         ) throws {
 24 |             let env = Environment()
 25 | 
 26 |             // Convert input to RuntimeValue
 27 |             guard let input = try? env.convertToRuntimeValues(input: input) else {
 28 |                 XCTFail(
 29 |                     "Failed to convert input \(input) to RuntimeValue in test for \(testName)",
 30 |                     file: file,
 31 |                     line: line
 32 |                 )
 33 |                 return
 34 |             }
 35 | 
 36 |             // Convert args to RuntimeValues
 37 |             let runtimeArgs = try args.map { arg -> any RuntimeValue in
 38 |                 if let arg = arg {
 39 |                     return try env.convertToRuntimeValues(input: arg)
 40 |                 }
 41 |                 return UndefinedValue()
 42 |             }
 43 | 
 44 |             // Get the test function from the environment
 45 |             guard let test = env.tests[testName] else {
 46 |                 XCTFail("Test not found: \(testName)", file: file, line: line)
 47 |                 return
 48 |             }
 49 | 
 50 |             // Call the test function based on number of arguments
 51 |             let result: Bool
 52 |             switch runtimeArgs.count {
 53 |             case 0:
 54 |                 result = try test(input)
 55 |             case 1:
 56 |                 result = try test(input, runtimeArgs[0])
 57 |             case 2:
 58 |                 result = try test(input, runtimeArgs[0], runtimeArgs[1])
 59 |             case 3:
 60 |                 result = try test(input, runtimeArgs[0], runtimeArgs[1], runtimeArgs[2])
 61 |             default:
 62 |                 throw JinjaError.runtime("Unsupported number of arguments for test: \(testName)")
 63 |             }
 64 | 
 65 |             XCTAssertEqual(result, expected, "\(testName) test failed", file: file, line: line)
 66 |         }
 67 | 
 68 |         // Test defined
 69 |         try runTest(testName: "defined", input: UndefinedValue(), expected: false)
 70 |         try runTest(testName: "defined", input: true, expected: true)
 71 | 
 72 |         // Test even/odd
 73 |         try runTest(testName: "even", input: 1, expected: false)
 74 |         try runTest(testName: "even", input: 2, expected: true)
 75 |         try runTest(testName: "odd", input: 1, expected: true)
 76 |         try runTest(testName: "odd", input: 2, expected: false)
 77 | 
 78 |         // Test lower/upper
 79 |         try runTest(testName: "lower", input: "foo", expected: true)
 80 |         try runTest(testName: "lower", input: "FOO", expected: false)
 81 |         try runTest(testName: "upper", input: "FOO", expected: true)
 82 |         try runTest(testName: "upper", input: "foo", expected: false)
 83 | 
 84 |         // Test type checks
 85 |         try runTest(testName: "none", input: NullValue(), expected: true)
 86 |         try runTest(testName: "none", input: false, expected: false)
 87 |         try runTest(testName: "none", input: true, expected: false)
 88 |         try runTest(testName: "none", input: 42, expected: false)
 89 | 
 90 |         try runTest(testName: "boolean", input: false, expected: true)
 91 |         try runTest(testName: "boolean", input: true, expected: true)
 92 |         try runTest(testName: "boolean", input: 0, expected: false)
 93 |         try runTest(testName: "boolean", input: 1, expected: false)
 94 | 
 95 |         try runTest(testName: "false", input: false, expected: true)
 96 |         try runTest(testName: "false", input: true, expected: false)
 97 |         try runTest(testName: "true", input: true, expected: true)
 98 |         try runTest(testName: "true", input: false, expected: false)
 99 | 
100 |         try runTest(testName: "integer", input: 42, expected: true)
101 |         try runTest(testName: "integer", input: 3.14159, expected: false)
102 |         try runTest(testName: "float", input: 3.14159, expected: true)
103 |         try runTest(testName: "float", input: 42, expected: false)
104 | 
105 |         try runTest(testName: "string", input: "foo", expected: true)
106 |         try runTest(testName: "string", input: 42, expected: false)
107 | 
108 |         try runTest(testName: "sequence", input: [1, 2, 3], expected: true)
109 |         try runTest(testName: "sequence", input: "foo", expected: true)
110 |         try runTest(testName: "sequence", input: 42, expected: false)
111 | 
112 |         try runTest(testName: "mapping", input: ["foo": "bar"], expected: true)
113 |         try runTest(testName: "mapping", input: [1, 2, 3], expected: false)
114 | 
115 |         try runTest(testName: "number", input: 42, expected: true)
116 |         try runTest(testName: "number", input: 3.14159, expected: true)
117 |         try runTest(testName: "number", input: "foo", expected: false)
118 | 
119 |         // Test equalto/eq
120 |         try runTest(testName: "eq", input: 12, args: [12], expected: true)
121 |         try runTest(testName: "eq", input: 12, args: [0], expected: false)
122 |         try runTest(testName: "eq", input: "baz", args: ["baz"], expected: true)
123 |         try runTest(testName: "eq", input: "baz", args: ["zab"], expected: false)
124 | 
125 |         // Test comparison aliases
126 |         try runTest(testName: "ne", input: 2, args: [3], expected: true)
127 |         try runTest(testName: "ne", input: 2, args: [2], expected: false)
128 |         try runTest(testName: "lt", input: 2, args: [3], expected: true)
129 |         try runTest(testName: "lt", input: 2, args: [2], expected: false)
130 |         try runTest(testName: "le", input: 2, args: [2], expected: true)
131 |         try runTest(testName: "le", input: 2, args: [1], expected: false)
132 |         try runTest(testName: "gt", input: 2, args: [1], expected: true)
133 |         try runTest(testName: "gt", input: 2, args: [2], expected: false)
134 |         try runTest(testName: "ge", input: 2, args: [2], expected: true)
135 |         try runTest(testName: "ge", input: 2, args: [3], expected: false)
136 | 
137 |         // Test in
138 |         try runTest(testName: "in", input: "o", args: [["f", "o", "o"]], expected: true)
139 |         try runTest(testName: "in", input: "foo", args: [["foo"]], expected: true)
140 |         try runTest(testName: "in", input: "b", args: [["f", "o", "o"]], expected: false)
141 |         try runTest(testName: "in", input: 1, args: [[1, 2]], expected: true)
142 |         try runTest(testName: "in", input: 3, args: [[1, 2]], expected: false)
143 | 
144 |         // Test filter/test existence
145 |         try runTest(testName: "filter", input: "title", expected: true)
146 |         try runTest(testName: "filter", input: "bad-name", expected: false)
147 |         try runTest(testName: "test", input: "number", expected: true)
148 |         try runTest(testName: "test", input: "bad-name", expected: false)
149 |     }
150 | }
151 | 


--------------------------------------------------------------------------------