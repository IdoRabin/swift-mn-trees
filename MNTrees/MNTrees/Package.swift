// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "MNTrees",
    platforms: [
        .macOS(.v14),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "MNTrees",
            targets: ["MNTrees"]),
    ],
    dependencies: [
        // In-House pakcages
        // .package(url: "https://gitlab.com/ido_r_demos/MNUtils.git", from:"0.0.2"),
        .package(path: "../../MNUtils/MNUtils"),
        .package(path: "../../DSLogger/"),
    ],
    targets: [
        .target(
            name: "MNTrees",
            dependencies: [
                // In-House pakcages
                .product(name: "MNUtils", package: "MNUtils"),
                .product(name: "DSLogger", package: "DSLogger"),
            ],
            swiftSettings: [
                // Enables better optimizations when building in Release
                // .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release)),
                
                .define("PRODUCTION", .when(configuration: .release)),
                .define("DEBUG", .when(configuration: .debug)),
            ]
        ),
        .testTarget(
            name: "MNTreesTests",
            dependencies: ["MNTrees"],
            swiftSettings: [
                .define("DEBUG"),
                .define("TESTING"),
            ]
        ),
    ]
)
