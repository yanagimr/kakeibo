// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "KakeiboCore",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(name: "KakeiboCore", targets: ["KakeiboCore"])
    ],
    targets: [
        .target(
            name: "KakeiboCore",
            path: "kakeibo",
            exclude: [
                "Views",
                "Preview Content",
                "Assets.xcassets",
                "kakeiboApp.swift",
                "ContentView.swift",
                "Previews.swift"
            ]
        ),
        .testTarget(
            name: "KakeiboCoreTests",
            dependencies: ["KakeiboCore"]
        )
    ]
)
