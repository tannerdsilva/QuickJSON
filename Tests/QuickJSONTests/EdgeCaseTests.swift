import Testing
import QuickJSON

@Suite("edge cases")
struct EdgeCaseTests {

	@Test("non-contiguous collections take the copy fallback path")
	func nonContiguousInput() throws {
		let json = Array(#"{"id":1,"name":"n"}"#.utf8)
		let filtered = json.lazy.filter { _ in true }
		let decoded = try QuickJSON.decode(SimpleModel.self, from: filtered)
		#expect(decoded == SimpleModel(id: 1, name: "n"))
	}

	@Test("array slice input decodes")
	func arraySlice() throws {
		let json = Array("xx{\"id\":2,\"name\":\"m\"}yy".utf8)
		let slice = json[2..<(json.count - 2)]
		let decoded = try QuickJSON.decode(SimpleModel.self, from: slice)
		#expect(decoded == SimpleModel(id: 2, name: "m"))
	}

	@Test("trailing commas require the allowTrailingCommas flag")
	func trailingCommas() throws {
		let json = Array(#"{"a":1,}"#.utf8)
		do {
			_ = try QuickJSON.decode([String: Int].self, from: json)
			Issue.record("expected parse error without the flag")
		} catch {
			// expected
		}
		let decoded = try QuickJSON.decode([String: Int].self, from: json, flags: [.allowTrailingCommas])
		#expect(decoded == ["a": 1])
	}

	@Test("comments require the allowComments flag")
	func comments() throws {
		let json = Array("{\"a\":1} // trailing".utf8)
		do {
			_ = try QuickJSON.decode([String: Int].self, from: json)
			Issue.record("expected parse error without the flag")
		} catch {
			// expected
		}
		let decoded = try QuickJSON.decode([String: Int].self, from: json, flags: [.allowComments])
		#expect(decoded == ["a": 1])
	}

	@Test("int64 and uint64 extremes round trip")
	func integerExtremes() throws {
		let intModel = SimpleModel(id: -9_223_372_036_854_775_808, name: "min")
		#expect(try QuickJSON.decode(SimpleModel.self, from: try QuickJSON.encode(intModel)) == intModel)

		struct UInt64Model: Codable, Equatable {
			let v: UInt64
		}
		let uintModel = UInt64Model(v: 18_446_744_073_709_551_615)
		#expect(try QuickJSON.decode(UInt64Model.self, from: try QuickJSON.encode(uintModel)) == uintModel)
	}

	@Test("pretty output still decodes")
	func prettyRoundTrip() throws {
		let encoded = try QuickJSON.encode(SimpleModel(id: 1, name: "n"), flags: [.pretty])
		#expect(try QuickJSON.decode(SimpleModel.self, from: encoded) == SimpleModel(id: 1, name: "n"))
	}
}
