// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
    .package(url: "https://github.com/ml-explore/mlx-swift-examples", branch: "main")
  ],
  targets: [
    .target(
      name: "FoundryKit",
      dependencies: [
        .product(name: "MLXLLM", package: "mlx-swift-examples"),
        .product(name: "MLXLMCommon", package: "mlx-swift-examples"),
        .product(name: "MLXVLM", package: "mlx-swift-examples"),
      ]
    ),
    .testTarget(
      name: "FoundryKitTests",
      dependencies: ["FoundryKit"]
    ),
  ]
)
