// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PexelsLib",
    platforms: [
        .iOS(.v16),
        .macOS(.v10_15),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PexelsLib",
            targets: ["PexelsLib"]
        ),
        .library(
            name: "PexelsFeatures",
            targets: ["PexelsFeatures"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.12.0"),
        .package(url: "https://github.com/realm/realm-swift", from: "10.51.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.12.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PexelsLib",
            dependencies: [
                .product(name: "RealmSwift", package: "realm-swift"),
            ]
        ),
        .target(
            name: "PexelsFeatures",
            dependencies: [
                "Kingfisher",
                "PexelsLib",
            ]
        ),
        .testTarget(
            name: "PexelsLibTests",
            dependencies: [
                "PexelsLib",
                "PexelsFeatures",
                .product(name: "RealmSwift", package: "realm-swift"),
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ],
            resources: [
                .process("Fixtures/curated_photos_multiple_photos_response.json"),
                .process("Fixtures/curated_photos_empty_photos.json"),
                .process("Fixtures/curated_photos_page_1.json"),
                .process("Fixtures/curated_photos_page_2.json"),
            ]
        ),
    ]
)
