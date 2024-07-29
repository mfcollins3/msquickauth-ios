// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MicrosoftQuickAuth",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MicrosoftQuickAuth",
            targets: [
                "MicrosoftQuickAuth",
                "MicrosoftQuickAuthSwift"
            ]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/AzureAD/microsoft-authentication-library-for-objc.git",
            exact: "1.4.0"
        )
    ],
    targets: [
        .target(
            name: "MicrosoftQuickAuth",
            dependencies: [
                .product(name: "MSAL", package: "microsoft-authentication-library-for-objc")
            ],
            resources: [
                .process("resources"),
            ],
            publicHeadersPath: "include"
        ),
        .target(
            name: "MicrosoftQuickAuthSwift",
            dependencies: [.target(name: "MicrosoftQuickAuth")]
        ),
        .testTarget(
            name: "MicrosoftQuickAuthTests",
            dependencies: ["MicrosoftQuickAuth"]
        )
    ]
)
