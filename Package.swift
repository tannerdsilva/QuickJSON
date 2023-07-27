// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription
let package = Package(
	name: "QuickJSON",
	products: [
		.library(
			name: "QuickJSON",
			targets: ["QuickJSON"]
		),
	],
	dependencies: [
		/// high performance json parsing library
		.package(url:"https://github.com/ibireme/yyjson.git", revision:"0.7.0"),

		/// swift logging (helpful for debugging, not built into release builds)
		.package(url:"https://github.com/apple/swift-log.git", "1.0.0"..<"2.0.0")
	],
	targets: [
		.target(
			name: "QuickJSON",
			dependencies: [
				.product(name:"yyjson", package:"yyjson"),
				.product(name:"Logging", package:"swift-log")
			],
			swiftSettings: [
				.define("QUICKJSON_SHOULDLOG", .when(configuration:.debug))
			]
		),
		.testTarget(
			name: "QuickJSONTests",
			dependencies: ["QuickJSON"],
			swiftSettings: [
				.define("QUICKJSON_SHOULDLOG", .when(configuration:.debug))
			]
		),
	]
)
