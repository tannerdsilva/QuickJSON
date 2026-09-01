import Testing
import QuickJSON

@Suite("container semantics")
struct ContainerSemanticsTests {

	@Test("contains is true when the key is present and false when absent")
	func containsReflectsPresence() throws {
		let result = try QuickJSON.decode(from: Array(#"{"a":1,"b":2}"#.utf8)) { decoder in
			let container = try decoder.container(keyedBy: TestKey.self)
			return (present: container.contains(.a), absent: container.contains(.missing))
		}
		#expect(result.present == true)
		#expect(result.absent == false)
	}

	@Test("keyed decodeNil reports null and throws notFound for missing keys")
	func keyedDecodeNil() throws {
		let isNil = try QuickJSON.decode(from: Array(#"{"a":null}"#.utf8)) { decoder in
			let container = try decoder.container(keyedBy: TestKey.self)
			return try container.decodeNil(forKey: .a)
		}
		#expect(isNil == true)

		let notNil = try QuickJSON.decode(from: Array(#"{"a":1}"#.utf8)) { decoder in
			let container = try decoder.container(keyedBy: TestKey.self)
			return try container.decodeNil(forKey: .a)
		}
		#expect(notNil == false)

		do {
			_ = try QuickJSON.decode(from: Array(#"{"b":1}"#.utf8)) { decoder in
				let container = try decoder.container(keyedBy: TestKey.self)
				return try container.decodeNil(forKey: .a)
			}
			Issue.record("expected notFound")
		} catch Decoding.Error.notFound {
			// expected
		} catch {
			Issue.record("unexpected error: \(error)")
		}
	}

	@Test("unkeyed decodeNil consumes the null element")
	func unkeyedDecodeNil() throws {
		let result = try QuickJSON.decode(from: Array(#"[null,1]"#.utf8)) { decoder in
			var container = try decoder.unkeyedContainer()
			let isNil = try container.decodeNil()
			let next = try container.decode(Int.self)
			return (isNil: isNil, next: next)
		}
		#expect(result.isNil == true)
		#expect(result.next == 1)
	}

	@Test("allKeys lists every object key")
	func allKeys() throws {
		let keys = try QuickJSON.decode(from: Array(#"{"a":1,"b":2,"c":3}"#.utf8)) { decoder in
			let container = try decoder.container(keyedBy: TestKey.self)
			return Set(container.allKeys.map(\.rawValue))
		}
		#expect(keys == Set(["a", "b", "c"]))
	}

	@Test("nested keyed container decodes under its key")
	func nestedKeyedDecode() throws {
		let model = try QuickJSON.decode(NestedModel.self, from: Array(#"{"title":"t","inner":{"x":1,"y":"z"}}"#.utf8))
		#expect(model == NestedModel(title: "t", inner: InnerModel(x: 1, y: "z")))
	}

	@Test("superDecoder(forKey:) reads the value written by superEncoder(forKey:)")
	func superRoundTrip() throws {
		let model = SuperUser(id: 9, payload: InnerModel(x: 5, y: "v"))
		let encoded = try QuickJSON.encode(model)
		let decoded = try QuickJSON.decode(SuperUser.self, from: encoded)
		#expect(decoded == model)
	}
}
