// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WorkHotelSearchOption",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "WorkHotelSearchOption",
            targets: ["WorkHotelSearchOption"]),
    ],
    dependencies: [
        .package(url: "./Packages/WorkHotelCore", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "WorkHotelSearchOption",
            dependencies: ["WorkHotelCore"]),
        .testTarget(
            name: "WorkHotelSearchOptionTests",
            dependencies: ["WorkHotelSearchOption"]),
    ]
)
