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
            name: "Memory Primitive",
            targets: ["Memory Primitive"]
        ),
        .library(
            name: "Memory",
            targets: ["Memory"]
        ),
        .library(
            name: "Memory Standard Library Integration",
            targets: ["Memory Standard Library Integration"]
        ),
        .library(
            name: "Memory Address",
            targets: ["Memory Address"]
        ),
        .library(
            name: "Memory Alignment",
            targets: ["Memory Alignment"]
        ),
        .library(
            name: "Memory Shift",
            targets: ["Memory Shift"]
        ),
        .library(
            name: "Memory Region",
            targets: ["Memory Region"]
        ),
        .library(
            name: "Memory Test Support",
            targets: ["Memory Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-ordinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-cardinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-carrier.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-affine.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-tagged.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-index.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-bit-index.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-span.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Memory Primitive",
            dependencies: []
        ),

        .target(
            name: "Memory",
            dependencies: [
                .target(name: "Memory Primitive"),
                .target(name: "Memory Standard Library Integration"),
                .target(name: "Memory Address"),
                .target(name: "Memory Alignment"),
                .target(name: "Memory Shift"),
                .target(name: "Memory Region"),
            ]
        ),

        .target(
            name: "Memory Standard Library Integration",
            dependencies: [
                .target(name: "Memory Address"),
                .target(name: "Memory Alignment"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Span Protocol", package: "swift-span"),
            ]
        ),

        .target(
            name: "Memory Address",
            dependencies: [
                .target(name: "Memory Primitive"),
                .product(name: "Affine", package: "swift-affine"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),

        .target(
            name: "Memory Shift",
            dependencies: [
                .target(name: "Memory Primitive"),
                .product(name: "Bit Index", package: "swift-bit-index"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Carrier", package: "swift-carrier"),
            ]
        ),

        .target(
            name: "Memory Alignment",
            dependencies: [
                .target(name: "Memory Primitive"),
                .target(name: "Memory Shift"),
                .product(name: "Carrier", package: "swift-carrier"),
            ]
        ),

        .target(
            name: "Memory Region",
            dependencies: [
                .target(name: "Memory Primitive"),
                .target(name: "Memory Address"),
            ]
        ),

        .target(
            name: "Memory Test Support",
            dependencies: [
                "Memory",
                .product(
                    name: "Tagged Test Support",
                    package: "swift-tagged"
                ),
                .product(name: "Index Test Support", package: "swift-index"),
                .product(
                    name: "Ordinal Test Support",
                    package: "swift-ordinal"
                ),
                .product(
                    name: "Cardinal Test Support",
                    package: "swift-cardinal"
                ),
                .product(
                    name: "Affine Test Support",
                    package: "swift-affine"
                ),
            ],
            path: "Tests/Support"
        ),

        .testTarget(
            name: "Memory Tests",
            dependencies: [
                "Memory",
                "Memory Test Support",
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
