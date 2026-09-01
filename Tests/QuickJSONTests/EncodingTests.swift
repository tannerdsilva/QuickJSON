import Testing
import QuickJSON

@Suite("encoding flags")
struct EncodingTests {

	@Test("pretty flag introduces whitespace")
	func pretty() throws {
		let encoded = try QuickJSON.encode(SimpleModel(id: 1, name: "n"), flags: [.pretty])
		#expect(String(decoding: encoded, as: UTF8.self).contains("\n"))
	}

	@Test("prettyTwoSpaces uses two-space indent")
	func prettyTwoSpaces() throws {
		let encoded = try QuickJSON.encode(SimpleModel(id: 1, name: "n"), flags: [.prettyTwoSpaces])
		#expect(String(decoding: encoded, as: UTF8.self).contains("  \"id\""))
	}

	@Test("escapeUnicode escapes non-ascii characters")
	func escapeUnicode() throws {
		let encoded = try QuickJSON.encode(SimpleModel(id: 1, name: "café"), flags: [.escapeUnicode])
		#expect(String(decoding: encoded, as: UTF8.self).contains("\\u"))
	}

	@Test("escapeSlashes escapes forward slashes")
	func escapeSlashes() throws {
		let encoded = try QuickJSON.encode(SimpleModel(id: 1, name: "a/b"), flags: [.escapeSlashes])
		#expect(String(decoding: encoded, as: UTF8.self).contains("\\/"))
	}

	@Test("encoding infinity without allowInfAndNan throws")
	func infWithoutFlagThrows() {
		do {
			_ = try QuickJSON.encode([Double.infinity])
			Issue.record("expected encoding of infinity to throw")
		} catch {
			// expected: yyjson refuses to write inf/nan without the flag
		}
	}

	@Test("infinity round trips with allowInfAndNan")
	func infWithFlag() throws {
		let encoded = try QuickJSON.encode([Double.infinity], flags: [.allowInfAndNan])
		let decoded = try QuickJSON.decode([Double].self, from: encoded, flags: [.allowInfAndNaN])
		#expect(decoded == [Double.infinity])
	}

	@Test("logLevel parameter is accepted at runtime")
	func logLevelIsRuntime() throws {
		let encoded = try QuickJSON.encode(SimpleModel(id: 1, name: "n"), logLevel: .debug)
		let decoded = try QuickJSON.decode(SimpleModel.self, from: encoded, logLevel: .debug)
		#expect(decoded == SimpleModel(id: 1, name: "n"))
	}
}
