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
		/// current version is 0.7.0 (09ccaa449e01879e23f68d8be165e78e65334443)
		/// we use a commit hash here because Swift Package Manager doesn't like pre-1.0 versions in post-1.0 packages
		.package(url:"https://github.com/ibireme/yyjson.git", revision:"09ccaa449e01879e23f68d8be165e78e65334443"),

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
