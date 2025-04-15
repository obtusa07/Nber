// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Finance",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AddPaymentMethod",
            targets: ["AddPaymentMethod"]
        ),
        .library(
            name: "AddPaymentMethodImp",
            targets: ["AddPaymentMethodImp"]
        ),
        .library(
            name: "FinanceEntity",
            targets: ["FinanceEntity"]
        ),
        .library(
            name: "FinanceRepository",
            targets: ["FinanceRepository"]
        ),
        .library(
            name: "Topup",
            targets: ["Topup"]
        ),
        .library(
            name: "TopupImp",
            targets: ["TopupImp"]
        ),
        .library(
          name: "FinanceHome",
          targets: ["FinanceHome"]
        )
    ],
    dependencies: [
      .package(url: "https://github.com/DevYeom/ModernRIBs", branch: "main"),
      .package(path: "../Platform")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AddPaymentMethod",
            dependencies: [
              "ModernRIBs",
              "FinanceEntity",
              .product(name: "RIBsUtil", package: "Platform"),
            ]
        ),
        .target(
            name: "AddPaymentMethodImp",
            dependencies: [
              "ModernRIBs",
              "AddPaymentMethod",
              "FinanceEntity",
              "FinanceRepository",
              .product(name: "RIBsUtil", package: "Platform"),
              .product(name: "NberUI", package: "Platform")
            ]
        ),
        .target(
            name: "Topup",
            dependencies: [
              "ModernRIBs",
            ]
        ),
        .target(
            name: "TopupImp",
            dependencies: [
              "ModernRIBs",
              "Topup",
              "FinanceEntity",
              "FinanceRepository",
              "AddPaymentMethod",
//              .product(name: "DefaultsStore", package: "Platform"),
              .product(name: "RIBsUtil", package: "Platform"),
              .product(name: "NberUI", package: "Platform")
            ]
        ),
        .target(
            name: "FinanceHome",
            dependencies: [
              "ModernRIBs",
              "FinanceEntity",
              "FinanceRepository",
              "AddPaymentMethod",
              "Topup",
              .product(name: "RIBsUtil", package: "Platform"),
              .product(name: "NberUI", package: "Platform")
            ]
        ),
        .target(
            name: "FinanceEntity",
            dependencies: []
        ),
        .target(
          name: "FinanceRepository",
          dependencies: [
            "FinanceEntity",
            .product(name: "CombineUtil", package: "Platform"),
            .product(name: "Network", package: "Platform")
          ]
        )
    ],
    swiftLanguageModes: [.v5],
)
