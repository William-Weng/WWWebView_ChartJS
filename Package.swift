// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWWebView_ChartJS",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "WWWebView_ChartJS", targets: ["WWWebView_ChartJS"]),
    ],
    targets: [
        .target(name: "WWWebView_ChartJS", resources: [.process("Xib"), .copy("HTML"), .copy("Privacy")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
