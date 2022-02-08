// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "sabine-wren",
    products: [
        .executable(
            name: "sabine-wren",
            targets: ["sabine-wren"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "sabine-wren",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .testTarget(
            name: "sabine-wrenTests",
            dependencies: ["sabine-wren"]),
    ]
)
