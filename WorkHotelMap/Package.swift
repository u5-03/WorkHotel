// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WorkHotelMap",
    defaultLocalization: "en",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "WorkHotelMap",
            targets: ["WorkHotelMap"]),
    ],
    dependencies: [
         .package(url: "./Packages/WorkHotelCore", from: "1.0.0"),
         .package(url: "./Packages/WorkHotelDetail", from: "1.0.0"),
         .package(url: "./Packages/WorkHotelSearchOption", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "WorkHotelMap",
            dependencies: ["WorkHotelCore", "WorkHotelDetail", "WorkHotelSearchOption"]),
        .testTarget(
            name: "WorkHotelMapTests",
            dependencies: ["WorkHotelMap"]),
    ]
)
