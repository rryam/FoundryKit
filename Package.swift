// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
  name: "FoundryKit",
  platforms: [
    .iOS(.v26),
    .macOS(.v26),
    .visionOS(.v26),
  ],
  products: [
    .library(
      name: "FoundryKit",
      targets: ["FoundryKit"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/ml-explore/mlx-swift-examples", branch: "main"),
    .package(url: "https://github.com/apple/swift-syntax", from: "600.0.0"),
  ],
  targets: [
    // Macro implementation
    .macro(
      name: "FoundryGenerableMacros",
      dependencies: [
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
      ]
    ),

    // Main library
    .target(
      name: "FoundryKit",
      dependencies: [
        .product(name: "MLXLLM", package: "mlx-swift-examples"),
        .product(name: "MLXLMCommon", package: "mlx-swift-examples"),
        .product(name: "MLXVLM", package: "mlx-swift-examples"),
        "FoundryGenerableMacros",
      ]
    ),

    // Tests
    .testTarget(
      name: "FoundryKitTests",
      dependencies: ["FoundryKit"]
    ),
  ]
)
