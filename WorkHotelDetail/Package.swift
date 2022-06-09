// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WorkHotelDetail",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "WorkHotelDetail",
            targets: ["WorkHotelDetail"]),
    ],
    dependencies: [
        .package(url: "./Packages/WorkHotelCore", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "WorkHotelDetail",
            dependencies: ["WorkHotelCore"]),
        .testTarget(
            name: "WorkHotelDetailTests",
            dependencies: ["WorkHotelDetail"]),
    ]
)
