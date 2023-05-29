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
		.package(url:"https://github.com/tannerdsilva/yyjson.git", revision:"09ccaa449e01879e23f68d8be165e78e65334443")
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
