// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Synacor",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(
            name: "synacor",
            targets: [
                "Synacor"
            ]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/apple/swift-algorithms.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .executableTarget(
            name: "Synacor",
            dependencies: [
                "VirtualMachine",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .target(
            name: "VirtualMachine",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "Collections", package: "swift-collections"),
            ]),
        .testTarget(
            name: "VirtualMachineTests",
            dependencies: [
                "VirtualMachine",
            ]),
    ]
)
