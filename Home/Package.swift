// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Home",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AppHome",
            targets: ["AppHome"]
        ),
    ],
    dependencies: [
      .package(url: "https://github.com/DevYeom/ModernRIBs", branch: "main"),
      .package(path: "../Finance"),
      .package(path: "../Transport"),
      .package(path: "../Platform")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AppHome",
            dependencies: [
              "ModernRIBs",
              .product(name: "FinanceRepository", package: "Finance"),
              .product(name: "TransportHome", package: "Transport"),
              .product(name: "NberUI", package: "Platform")
            ]
        ),
    ],
    swiftLanguageModes: [.v5]
)
