// swift-tools-version:6.0
import PackageDescription
let package = Package(
	name: "QuickJSON",
	products:[
		.library(
			name:"QuickJSON",
			targets:["QuickJSON"]
		),
	],
	dependencies:[
		// high performance json parsing library that this package wraps
		.package(url:"https://github.com/ibireme/yyjson.git", "0.11.0"..<"1.0.0"),
		// swift logging (helpful for debugging, not built into release builds)
		.package(url:"https://github.com/apple/swift-log.git", "1.0.0"..<"2.0.0")
	],
	targets:[
		.target(
			name: "QuickJSON",
			dependencies:[
				.product(name:"yyjson", package:"yyjson"),
				.product(name:"Logging", package:"swift-log")
			],
			swiftSettings:[
				.define("QUICKJSON_SHOULDLOG"),
			]
		),
		.testTarget(
			name:"QuickJSONTests",
			dependencies:["QuickJSON"],
			swiftSettings:[
				.define("QUICKJSON_SHOULDLOG"),
			]
		)
	]
)
