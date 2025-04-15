// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Platform",
  platforms: [.iOS(.v14)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "CombineUtil",
      targets: ["CombineUtil"]
    ),
    .library(
      name: "RIBsUtil",
      targets: ["RIBsUtil"]
    ),
    .library(
      name: "DefaultsStore",
      targets: ["DefaultsStore"]
    ),
    .library(
      name: "Network",
      targets: ["Network"]
    ),
    .library(
      name: "NetworkImp",
      targets: ["NetworkImp"]
    ),
    .library(
      name: "NberUI",
      targets: ["NberUI"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/CombineCommunity/CombineExt", branch: "main"),
    .package(url: "https://github.com/DevYeom/ModernRIBs", branch: "main"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "CombineUtil",
      dependencies: [
        "CombineExt"
      ]
    ),
    .target(
      name: "RIBsUtil",
      dependencies: [
        "ModernRIBs"
      ]
    ),
    .target(
      name: "NberUI",
      dependencies: [
        "RIBsUtil"
      ]
    ),
    .target(
      name: "DefaultsStore",
      dependencies: []
    ),
    .target(
      name: "Network",
      dependencies: []
    ),
    .target(
      name: "NetworkImp",
      dependencies: [
        "Network"
      ]
    )
  ],
  swiftLanguageModes: [.v5],
)
