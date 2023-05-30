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
		.package(url:"https://github.com/ibireme/yyjson.git", "0.7.0"..<"0.8.0")
	],
	targets: [
		.target(
			name: "QuickJSON",
			dependencies: [
				.product(name:"yyjson", package:"yyjson")
			]
		),
		.testTarget(
			name: "QuickJSONTests",
			dependencies: ["QuickJSON"]
		),
	]
)
