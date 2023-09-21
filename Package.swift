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
		.package(url:"https://github.com/ibireme/yyjson.git", "0.8.0"..<"0.9.0"),

		/// swift logging (helpful for debugging, not built into release builds)
		.package(url:"https://github.com/apple/swift-log.git", from:"1.0.0")
	],
	targets: [
		.target(
			name: "QuickJSON",
			dependencies: [
				.product(name:"yyjson", package:"yyjson"),
				.product(name:"Logging", package:"swift-log")
			]
		),
		.testTarget(
			name: "QuickJSONTests",
			dependencies: ["QuickJSON"]
		)
	]
)
