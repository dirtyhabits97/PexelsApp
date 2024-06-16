// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PexelsLib",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PexelsLib",
            targets: ["PexelsLib"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.12.0"),
        // .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PexelsLib"
            // dependencies: ["RxSwift"]
        ),
        .testTarget(
            name: "PexelsLibTests",
            dependencies: [
                "PexelsLib",
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
