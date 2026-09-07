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
        .library(name: "Memory", targets: ["Memory"]),
        .library(name: "Memory Standard Library Integration", targets: ["Memory Standard Library Integration"]),
        .library(name: "Memory Foundation Library Integration", targets: ["Memory Foundation Library Integration"]),
        .library(name: "Memory Test Support", targets: ["Memory Test Support"]),
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
            ],
            path: "Sources/Memory"
        ),
        .target(
            name: "Memory Standard Library Integration",
            dependencies: [
                .target(name: "Memory"),
            ],
            path: "Sources/Memory Standard Library Integration"
        ),
        .target(
            name: "Memory Foundation Library Integration",
            dependencies: [
                .target(name: "Memory"),
                .target(name: "Memory Standard Library Integration"),
            ],
            path: "Sources/Memory Foundation Library Integration"
        ),
        .target(
            name: "Memory Test Support",
            dependencies: [
                .target(name: "Memory"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Memory Tests",
            dependencies: [
                .target(name: "Memory"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Tagged Standard Library Integration", package: "swift-tagged"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Cardinal Standard Library Integration", package: "swift-cardinal"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .target(name: "Memory Test Support"),
                .target(name: "Memory Standard Library Integration"),
                .target(name: "Memory Foundation Library Integration"),
            ],
            path: "Tests/Memory Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableExperimentalFeature("RawLayout"),
    ]
}
