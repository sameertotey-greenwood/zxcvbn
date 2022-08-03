// swift-tools-version:5.6

import PackageDescription

let package = Package(name: "zxcvbn", platforms: [
        .macOS(.v11),
        .iOS(.v14),
        .watchOS(.v7),
        .tvOS(.v14)
    ], products: [
        .library(name: "Zxcvbn", targets: [
                "Zxcvbn"
        ]),
        .executable(name: "zxcvbn-cli", targets: [
            "ZxcvbnCLI"
        ])
    ], dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.3")
    ], targets: [
        .target(name: "Zxcvbn"),
        .executableTarget(name: "ZxcvbnCLI", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            "Zxcvbn"
        ]),
        .testTarget(name: "ZxcvbnTests", dependencies: [
            "Zxcvbn"
        ])
    ])
