// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WorkHotelCore",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "WorkHotelCore",
            targets: ["WorkHotelCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/u5-03/SwiftExtensions", from: "1.0.0"),
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.6.1"),
    ],
    targets: [
        .target(
            name: "WorkHotelCore",
            dependencies: ["SwiftExtensions", "Alamofire"]),
        .testTarget(
            name: "WorkHotelCoreTests",
            dependencies: ["WorkHotelCore"]),
    ]
)
