// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SabineWren",
    products: [
        .executable(
            name: "SabineWren",
            targets: ["SabineWren"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-collections", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "SabineWren",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Collections", package: "swift-collections")
            ]),
        .testTarget(
            name: "SabineWrenTests",
            dependencies: ["SabineWren"]),
    ]
)
