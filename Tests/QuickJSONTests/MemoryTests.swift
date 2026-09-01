import Testing
import QuickJSON

@Suite("memory configuration")
struct MemoryTests {

	@Test("recommendedReadBufferSize grows with input size")
	func recommendedSize() {
		let small = Memory.Region.recommendedReadBufferSize(maximumInput: 64, flags: Decoding.Flags())
		let large = Memory.Region.recommendedReadBufferSize(maximumInput: 65536, flags: Decoding.Flags())
		#expect(small > 0)
		#expect(large > small)
	}

	@Test("decoding with a preallocated region matches automatic decoding")
	func preallocatedDecode() throws {
		let json = Array(#"{"id":1,"name":"pooled"}"#.utf8)
		let automatic = try QuickJSON.decode(SimpleModel.self, from: json)
		let region = try Memory.Region(maximumReadingSize: json.count)
		let pooled = try QuickJSON.decode(SimpleModel.self, from: json, memory: .preallocated(region))
		#expect(pooled == automatic)
	}

	@Test("encoding with a preallocated region actually uses the pool")
	func preallocatedEncode() throws {
		// regression: the preallocated encoding path used to create the document with the
		// default allocator, so the region was never consulted.
		let model = SimpleModel(id: 1, name: "hello world")
		let region = try Memory.Region(bufferSize: 4096)
		let encoded = try QuickJSON.encode(model, memory: .preallocated(region))
		let decoded = try QuickJSON.decode(SimpleModel.self, from: encoded)
		#expect(decoded == model)
	}

	@Test("too-small region causes decode to throw, not crash")
	func tinyRegionDecode() throws {
		let region = try Memory.Region(bufferSize: 64)
		let bigPayload = "{\"id\":1,\"name\":\"" + String(repeating: "x", count: 2048) + "\"}"
		do {
			_ = try QuickJSON.decode(SimpleModel.self, from: Array(bigPayload.utf8), memory: .preallocated(region))
			Issue.record("expected allocation failure to throw")
		} catch {
			// expected: yyjson cannot parse a large document within a 64-byte pool
		}
	}

	@Test("too-small region causes encode to throw, not crash")
	func tinyRegionEncode() throws {
		let region = try Memory.Region(bufferSize: 64)
		do {
			let bigName = String(repeating: "x", count: 2048)
			_ = try QuickJSON.encode(SimpleModel(id: 1, name: bigName), memory: .preallocated(region))
			Issue.record("expected allocation failure to throw")
		} catch {
			// expected: yyjson cannot build a document within a 64-byte pool
		}
	}
}
