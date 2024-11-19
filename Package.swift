// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "IAPManagerLib", // Set the name of the package
    // bump swift v to 5.7?
    platforms: [.iOS(.v17), .macOS(.v14)], // Set the supported platforms for the package
    products: [
        .library(
            name: "IAPManagerLib", // Set the name of the library product
            targets: ["IAPManagerLib"]) // Set the targets for the library product
    ],
    dependencies: [
      .package(url: "https://github.com/eonist/UserDefaultSugar.git", branch: "master"),
      .package(url: "https://github.com/sentryco/Logger.git", branch: "main"),
      // Needed for tests
      .package(url: "https://github.com/eonist/JSONSugar.git", branch: "master"), // Set the dependency on the JSONSugar package for tests
      .package(url: "https://github.com/eonist/ResultSugar.git", branch: "master"), // Set the dependency on the ResultSugar package for tests
      .package(url: "https://github.com/tikhop/TPInAppReceipt.git", .upToNextMajor(from: "3.0.0")) // Set the dependency on the TPInAppReceipt package
    ],
    targets: [
        .target(
            name: "IAPManagerLib", // Set the name of the target
            dependencies: ["Logger", "UserDefaultSugar", "TPInAppReceipt", "ResultSugar"]), // Set the dependencies for the target
        .testTarget(
            name: "IAPManagerLibTests", // Set the name of the test target
            dependencies: ["IAPManagerLib", "JSONSugar"]) // Set the dependencies for the test target
    ]
)
