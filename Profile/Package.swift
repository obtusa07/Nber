// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Profile",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ProfileHome",
            targets: ["ProfileHome"]),
    ],
    dependencies: [
      .package(url: "https://github.com/DevYeom/ModernRIBs", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ProfileHome",
            dependencies: [
              "ModernRIBs"
            ]
        ),
    ],
    swiftLanguageModes: [.v5]
)
