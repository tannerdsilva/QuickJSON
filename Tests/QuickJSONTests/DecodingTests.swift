import Testing
import QuickJSON

@Suite("decoding errors")
struct DecodingTests {

	@Test("type mismatch throws valueTypeMismatch")
	func typeMismatch() {
		do {
			_ = try QuickJSON.decode(SimpleModel.self, from: Array(#"{"id":"one","name":"x"}"#.utf8))
			Issue.record("expected valueTypeMismatch")
		} catch Decoding.Error.valueTypeMismatch {
			// expected
		} catch {
			Issue.record("unexpected error: \(error)")
		}
	}

	@Test("narrow integer overflow throws numberOutOfRange")
	func narrowOverflow() {
		struct Int8Model: Codable {
			let v: Int8
		}
		do {
			_ = try QuickJSON.decode(Int8Model.self, from: Array(#"{"v":300}"#.utf8))
			Issue.record("expected numberOutOfRange")
		} catch Decoding.Error.numberOutOfRange {
			// expected
		} catch {
			Issue.record("unexpected error: \(error)")
		}
	}

	@Test("missing key throws notFound")
	func missingKey() {
		do {
			_ = try QuickJSON.decode(SimpleModel.self, from: Array(#"{}"#.utf8))
			Issue.record("expected notFound")
		} catch Decoding.Error.notFound {
			// expected
		} catch {
			Issue.record("unexpected error: \(error)")
		}
	}

	@Test("decoding past the end of an array throws contentOverflow")
	func contentOverflow() {
		do {
			_ = try QuickJSON.decode(Overreader.self, from: Array(#"[1,2,3]"#.utf8))
			Issue.record("expected contentOverflow")
		} catch Decoding.Error.contentOverflow {
			// expected
		} catch {
			Issue.record("unexpected error: \(error)")
		}
	}

	@Test("malformed json throws documentParseError")
	func malformedJSON() {
		do {
			_ = try QuickJSON.decode(SimpleModel.self, from: Array("not json".utf8))
			Issue.record("expected documentParseError")
		} catch Decoding.Error.documentParseError {
			// expected
		} catch {
			Issue.record("unexpected error: \(error)")
		}
	}

	@Test("empty input throws documentParseError")
	func emptyInput() {
		do {
			_ = try QuickJSON.decode(SimpleModel.self, from: [UInt8]())
			Issue.record("expected documentParseError")
		} catch Decoding.Error.documentParseError {
			// expected
		} catch {
			Issue.record("unexpected error: \(error)")
		}
	}

	@Test("decoding an array as an object throws valueTypeMismatch")
	func arrayAsObject() {
		do {
			_ = try QuickJSON.decode(SimpleModel.self, from: Array(#"[1,2]"#.utf8))
			Issue.record("expected valueTypeMismatch")
		} catch Decoding.Error.valueTypeMismatch {
			// expected
		} catch {
			Issue.record("unexpected error: \(error)")
		}
	}

	@Test("decoding a null document as an object throws valueTypeMismatch")
	func nullAsObject() {
		do {
			_ = try QuickJSON.decode(SimpleModel.self, from: Array("null".utf8))
			Issue.record("expected valueTypeMismatch")
		} catch Decoding.Error.valueTypeMismatch {
			// expected
		} catch {
			Issue.record("unexpected error: \(error)")
		}
	}
}
