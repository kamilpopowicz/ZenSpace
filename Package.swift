// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "ZenSpace",
    platforms: [
        .macOS(.v13)
    ],
    targets: [
        .executableTarget(
            name: "ZenSpace",
            path: "Sources/ZenSpace",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "ZenSpaceTests",
            dependencies: ["ZenSpace"],
            path: "Tests/ZenSpaceTests"
        )
    ]
)
