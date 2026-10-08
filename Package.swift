// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "iOSSettingsURI",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "iOSSettingsURI",
            targets: ["iOSSettingsURI"]
        )
    ],
    targets: [
        .target(
            name: "iOSSettingsURI",
            path: "Sources/iOSSettingsURI"
        ),
        .testTarget(
            name: "iOSSettingsURITests",
            dependencies: ["iOSSettingsURI"],
            path: "Tests/iOSSettingsURITests"
        )
    ]
)
