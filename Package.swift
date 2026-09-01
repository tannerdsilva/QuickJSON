// swift-tools-version: 6.0
// QuickJSON — a performant wrapper around the yyjson C library.
import PackageDescription

let package = Package(
	name: "QuickJSON",
	platforms: [
		.macOS(.v13),
		.iOS(.v13),
		.tvOS(.v13),
		.watchOS(.v7),
		.visionOS(.v1),
	],
	products: [
		.library(name: "QuickJSON", targets: ["QuickJSON"]),
	],
	dependencies: [
		.package(url: "https://github.com/ibireme/yyjson.git", "0.11.0"..<"0.13.0"),
		.package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
	],
	targets: [
		.target(
			name: "QuickJSON",
			dependencies: [
				.product(name: "yyjson", package: "yyjson"),
				.product(name: "Logging", package: "swift-log"),
			]
		),
		.testTarget(
			name: "QuickJSONTests",
			dependencies: ["QuickJSON"]
		),
	],
	// strict concurrency is enforced; all public types are Sendable.
	swiftLanguageModes: [.v6]
)
