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
        .library(name: "Memory Foreign Test Support", targets: ["Memory Foreign Test Support"]),
        .library(name: "Memory Map Test Support", targets: ["Memory Map Test Support"]),
        .library(name: "Memory Shared Test Support", targets: ["Memory Shared Test Support"]),
        .library(name: "Memory Lock Test Support", targets: ["Memory Lock Test Support"]),
        .library(name: "Memory", targets: ["Memory"]),

        .library(name: "Memory Foundation Integration", targets: ["Memory Foundation Integration"]),
        .library(name: "Memory Test Support", targets: ["Memory Test Support"]),
    ],
    traits: [
        .trait(name: "Carrier", description: "Carrier integration"),
        .trait(name: "TaggedMemory", description: "TaggedMemory integration"),
        .trait(name: "Lock", description: "Lock integration"),
        .trait(name: "Shared", description: "Shared integration"),
        .trait(name: "Map", description: "Map integration", enabledTraits: ["Lock"]),
        .trait(name: "Foreign", description: "Foreign integration"),
        .trait(name: "Cursor", description: "Cursor integration"),
        .trait(name: "Sequence", description: "Sequence integration", enabledTraits: ["Cursor"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-cursor.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-carrier.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-sequence.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-iterator.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-span.git", branch: "main", traits: [.trait(name: "Byte", condition: .when(traits: ["Foreign"]))]),
        .package(url: "https://github.com/swift-atoms/swift-byte.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-error.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-property.git", branch: "main"),
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
        .testTarget(
            name: "Absorbed Memory Sequence Tests",
            dependencies: [
                .product(name: "Span", package: "swift-span"),
                .target(name: "Memory", condition: .when(traits: ["Sequence"])),
            ],
            path: "Tests/Absorbed Memory Sequence Tests"
        ),
        .testTarget(
            name: "Absorbed Owned Memory Cursor Tests",
            dependencies: [
                .product(name: "Iterator", package: "swift-iterator"),
                .product(name: "Span", package: "swift-span"),
                .target(name: "Memory", condition: .when(traits: ["Cursor", "Sequence"])),
            ],
            path: "Tests/Absorbed Owned Memory Cursor Tests"
        ),
        .testTarget(
            name: "Absorbed swift-memory-foreign Tests",
            dependencies: [
                .target(name: "Memory Foreign Test Support", condition: .when(traits: ["Foreign"])),
                .target(name: "Memory", condition: .when(traits: ["Foreign"])),
            ],
            path: "Tests/Absorbed swift-memory-foreign Tests"
        ),
        .target(
            name: "Memory Foreign Test Support",
            dependencies: [
                .product(name: "Span Test Support", package: "swift-span"),
                .target(name: "Memory Test Support", condition: .when(traits: ["Foreign"])),
                .target(name: "Memory", condition: .when(traits: ["Foreign"])),
            ],
            path: "Tests/Memory Foreign Test Support"
        ),
        .testTarget(
            name: "Absorbed swift-memory-map Tests",
            dependencies: [
                .target(name: "Memory", condition: .when(traits: ["Map"])),
            ],
            path: "Tests/Absorbed swift-memory-map Tests"
        ),
        .target(
            name: "Memory Map Test Support",
            dependencies: [
                .target(name: "Memory Test Support", condition: .when(traits: ["Map"])),
                .target(name: "Memory", condition: .when(traits: ["Map"])),
            ],
            path: "Tests/Memory Map Test Support"
        ),
        .testTarget(
            name: "Absorbed swift-memory-shared Tests",
            dependencies: [
                .target(name: "Memory", condition: .when(traits: ["Shared"])),
            ],
            path: "Tests/Absorbed swift-memory-shared Tests"
        ),
        .target(
            name: "Memory Shared Test Support",
            dependencies: [
                .target(name: "Memory Test Support", condition: .when(traits: ["Shared"])),
                .target(name: "Memory", condition: .when(traits: ["Shared"])),
            ],
            path: "Tests/Memory Shared Test Support"
        ),
        .testTarget(
            name: "Absorbed swift-memory-lock Tests",
            dependencies: [
                .target(name: "Memory", condition: .when(traits: ["Lock", "Map"])),
            ],
            path: "Tests/Absorbed swift-memory-lock Tests"
        ),
        .target(
            name: "Memory Lock Test Support",
            dependencies: [
                .target(name: "Memory", condition: .when(traits: ["Lock", "Map"])),
            ],
            path: "Tests/Memory Lock Test Support"
        ),
        .testTarget(
            name: "Absorbed swift-memory-tagged Tests",
            dependencies: [
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Tagged", package: "swift-tagged"),
                .target(name: "Memory", condition: .when(traits: ["TaggedMemory"])),
            ],
            path: "Tests/Absorbed swift-memory-tagged Tests"
        ),
        .testTarget(
            name: "Absorbed swift-memory-carrier Tests",
            dependencies: [
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Carrier", package: "swift-carrier"),
                .product(name: "Property", package: "swift-property"),
                .target(name: "Memory", condition: .when(traits: ["Carrier"])),
            ],
            path: "Tests/Absorbed swift-memory-carrier Tests"
        ),
        .target(
            name: "Memory",
            dependencies: [
                .product(name: "Cursor", package: "swift-cursor"),
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Carrier", package: "swift-carrier"),
                .product(name: "Error", package: "swift-error"),
                .product(name: "Iterator", package: "swift-iterator"),
                .product(name: "Property", package: "swift-property"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Span", package: "swift-span"),
                .product(name: "Bit", package: "swift-bit"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Ordinal", package: "swift-ordinal"),
            ],
            path: "Sources/Memory"
        ),

        .target(
            name: "Memory Foundation Integration",
            dependencies: [
                .target(name: "Memory"),
            ],
            path: "Sources/Memory Foundation Integration"
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
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .target(name: "Memory Test Support"),
                .target(name: "Memory Foundation Integration"),
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
