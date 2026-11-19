// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Bunq",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .library(name: "Bunq", targets: ["Bunq"]),
        .executable(name: "t_bunq", targets: ["BunqTests"]),
        .executable(name: "t_bunq_live", targets: ["BunqLive"]),
    ],
    dependencies: [
        .package(url: "https://github.com/leviouwendijk/Primitives.git", branch: "master"),
        .package(url: "https://github.com/leviouwendijk/HTTP.git", branch: "master"),
        .package(url: "https://github.com/leviouwendijk/Cryptography.git", branch: "master"),
        .package(url: "https://github.com/leviouwendijk/Milieu.git", branch: "master"),
        .package(url: "https://github.com/leviouwendijk/Sensitivity.git", branch: "master"),
    ],
    targets: [
        .target(
            name: "Bunq",
            dependencies: [
                .product(name: "Primitives", package: "Primitives"),
                .product(name: "HTTP", package: "HTTP"),
                .product(name: "Cryptography", package: "Cryptography"),
                .product(name: "Sensitivity", package: "Sensitivity"),
            ],
            path: "Sources/Bunq"
        ),
        .executableTarget(
            name: "BunqTests",
            dependencies: ["Bunq"],
            path: "Testing/BunqTests"
        ),
        .executableTarget(
            name: "BunqLive",
            dependencies: ["Bunq", .product(name: "Milieu", package: "Milieu")],
            path: "Testing/BunqLive"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    switch target.type {
    case .regular, .executable, .test, .macro:
        var settings = target.swiftSettings ?? []
        settings.append(.treatAllWarnings(as: .error))
        settings.append(.unsafeFlags(["-continue-building-after-errors"]))
        target.swiftSettings = settings

    case .plugin, .system, .binary:
        break

    @unknown default:
        break
    }
}
