// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SisojesCppKit",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "combinatorics",
            targets: ["combinatorics"]),
        .library(
            name: "data_structures",
            targets: ["data_structures"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "combinatorics",
            dependencies: []),
        .target(
            name: "data_structures",
            dependencies: []),
        .testTarget(
            name: "combinatoricsTests",
            dependencies: ["combinatorics"]),
        .testTarget(
            name: "data_structuresTests",
            dependencies: ["data_structures"]),
    ],
    cxxLanguageStandard: .cxx14
)
