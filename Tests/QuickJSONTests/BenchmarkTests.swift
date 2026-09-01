import Foundation
import Testing
import QuickJSON

// hand-rolled benchmark suite. no external benchmark dependencies: timing is
// performed with `ContinuousClock` and reported as a comparison table against
// Foundation's `JSONEncoder`/`JSONDecoder`.
//
// run with: swift test --filter benchmarks
// results are printed to the console and written to `benchmark-results.csv` in
// the current working directory.

@Suite("benchmarks", .serialized)
struct BenchmarkTests {

	/// a single measured row for one workload on one library.
	struct Measurement {
		let workload: String
		let operation: String
		let library: String
		let nsPerOp: Double

		func csv() -> String {
			return "\(workload),\(operation),\(library),\(String(format: "%.1f", nsPerOp))"
		}
	}

	private static let clock = ContinuousClock()

	/// runs one typed workload on both libraries and returns its four measurements.
	/// - parameter value: the payload to round-trip.
	/// - returns: (quickjsonEncode, foundationEncode, quickjsonDecode, foundationDecode).
	private static func measure<T: Codable & Equatable>(_ value: T, encodeIters: Int, decodeIters: Int) throws -> (Double, Double, Double, Double) {
		// warmup both libraries
		_ = try QuickJSON.encode(value)
		_ = try JSONEncoder().encode(value)

		// quickjson encode
		var qjBytes: [UInt8] = []
		let qjEnc = try time(encodeIters) {
			qjBytes = try QuickJSON.encode(value)
		}

		// foundation encode
		let fndEnc = try time(encodeIters) {
			_ = try JSONEncoder().encode(value)
		}

		// quickjson decode
		let qjDec = try time(decodeIters) {
			let decoded = try QuickJSON.decode(T.self, from: qjBytes)
			#expect(decoded == value)
		}

		// foundation decode
		let foundationData = try JSONEncoder().encode(value)
		let fndDec = try time(decodeIters) {
			let decoded = try JSONDecoder().decode(T.self, from: foundationData)
			#expect(decoded == value)
		}

		return (qjEnc, fndEnc, qjDec, fndDec)
	}

	private static func time(_ iterations: Int, _ body: () throws -> Void) throws -> Double {
		let elapsed = try clock.measure {
			for _ in 0..<iterations {
				try body()
			}
		}
		let seconds = Double(elapsed.components.seconds) + Double(elapsed.components.attoseconds) * 1e-18
		return seconds * 1e9 / Double(iterations)
	}

	@Test("all workloads")
	func allWorkloads() throws {
		var rows: [Measurement] = []

		func addWorkload<T: Codable & Equatable>(_ name: String, _ value: T, encodeIters: Int, decodeIters: Int) throws {
			let (qjEnc, fndEnc, qjDec, fndDec) = try BenchmarkTests.measure(value, encodeIters: encodeIters, decodeIters: decodeIters)
			rows.append(Measurement(workload: name, operation: "encode", library: "QuickJSON", nsPerOp: qjEnc))
			rows.append(Measurement(workload: name, operation: "encode", library: "JSONEncoder", nsPerOp: fndEnc))
			rows.append(Measurement(workload: name, operation: "decode", library: "QuickJSON", nsPerOp: qjDec))
			rows.append(Measurement(workload: name, operation: "decode", library: "JSONDecoder", nsPerOp: fndDec))
		}

		try addWorkload("small model", SimpleModel(id: 42, name: "benchmark model"), encodeIters: 50_000, decodeIters: 50_000)
		try addWorkload("nested object", NestedModel(title: "outer title", inner: InnerModel(x: 1, y: "inner")), encodeIters: 20_000, decodeIters: 20_000)
		try addWorkload("array of 100", ObjectInArray(items: (0..<100).map { Point(x: Double($0), y: Double($0) + 0.5) }), encodeIters: 5_000, decodeIters: 5_000)
		try addWorkload("unicode strings", SimpleModel(id: 1, name: String(repeating: "café 🚀 日本語 🧪 ", count: 100)), encodeIters: 10_000, decodeIters: 10_000)

		// write the csv
		let csv = (["workload,operation,library,ns_per_op"] + rows.map { $0.csv() }).joined(separator: "\n")
		try csv.write(toFile: "benchmark-results.csv", atomically: true, encoding: .utf8)

		// print the report
		print("\n================ quickjson benchmarks ================")
		print("workload,operation,library,ns_per_op")
		for row in rows {
			print(row.csv())
		}
		print("---")
		for workload in ["small model", "nested object", "array of 100", "unicode strings"] {
			for operation in ["encode", "decode"] {
				guard let qj = rows.first(where: { $0.workload == workload && $0.operation == operation && $0.library == "QuickJSON" }),
				      let fnd = rows.first(where: { $0.workload == workload && $0.operation == operation && $0.library != "QuickJSON" }) else { continue }
				print("\(workload) \(operation) speedup vs Foundation: \(String(format: "%.1f", fnd.nsPerOp / qj.nsPerOp))x")
			}
		}
		print("=====================================================\n")
	}
}
