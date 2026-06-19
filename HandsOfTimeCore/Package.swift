// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "HandsOfTimeCore",
    platforms: [
        .iOS(.v18),
        .macOS(.v15)
    ],
    products: [
        .library(
            name: "HandsOfTimeCore",
            targets: ["HandsOfTimeCore"]
        )
    ],
    targets: [
        .target(name: "HandsOfTimeCore"),
        .testTarget(
            name: "HandsOfTimeCoreTests",
            dependencies: ["HandsOfTimeCore"]
        )
    ]
)
