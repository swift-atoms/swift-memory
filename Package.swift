// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-memory",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Memory",
            targets: ["Memory"]
        ),
        .library(
            name: "Memory Standard Library Integration",
            targets: ["Memory Standard Library Integration"]
        ),
        .library(
            name: "Memory Apple Foundation Integration",
            targets: ["Memory Apple Foundation Integration"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-bit.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-tagged.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-cardinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-ordinal.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Memory",
            dependencies: [
                .product(name: "Bit", package: "swift-bit"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Ordinal", package: "swift-ordinal"),
            ]
        ),
        .target(
            name: "Memory Standard Library Integration",
            dependencies: [
                .target(name: "Memory")
            ]
        ),
        .target(
            name: "Memory Apple Foundation Integration",
            dependencies: [
                .target(name: "Memory"),
                .target(name: "Memory Standard Library Integration"),
            ]
        ),
        .testTarget(
            name: "Memory Tests",
            dependencies: [
                .target(name: "Memory"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(
                    name: "Tagged Standard Library Integration",
                    package: "swift-tagged"
                ),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(
                    name: "Cardinal Standard Library Integration",
                    package: "swift-cardinal"
                ),
                .product(name: "Ordinal", package: "swift-ordinal"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = [
        .enableExperimentalFeature("RawLayout")
    ]

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
