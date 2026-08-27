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
            url: "https://github.com/swift-molecules/swift-bit-index.git",
            branch: "main"
        )
    ],
    targets: [
        .target(
            name: "Memory",
            dependencies: [
                .product(name: "Bit Index", package: "swift-bit-index")
            ]
        ),
        .target(
            name: "Memory Standard Library Integration",
            dependencies: [
                "Memory"
            ]
        ),
        .target(
            name: "Memory Apple Foundation Integration",
            dependencies: [
                "Memory",
                "Memory Standard Library Integration",
            ]
        ),
        .testTarget(
            name: "Memory Tests",
            dependencies: [
                "Memory"
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
