import Testing
import QuickJSON

@Suite("handler-based decoding")
struct HandlerTests {

	struct HandledResult: Equatable {
		let id: Int
		let name: String
	}

	private func parse<T>(_ json: String, _ handler: (Swift.Decoder) throws -> T) throws -> T {
		return try QuickJSON.decode(from: Array(json.utf8), handler)
	}

	@Test("handler decodes a typed value from collection bytes")
	func handlerOverBytes() throws {
		let result = try parse(#"{"id":3,"name":"three"}"#) { decoder in
			let container = try decoder.container(keyedBy: TestKey.self)
			return HandledResult(
				id: try container.decode(Int.self, forKey: .id),
				name: try container.decode(String.self, forKey: .name)
			)
		}
		#expect(result == HandledResult(id: 3, name: "three"))
	}

	@Test("handler enumerates all keys")
	func handlerAllKeys() throws {
		var randomNumbers = Set<UInt64>()
		for _ in 0..<5 {
			randomNumbers.insert(UInt64.random(in: 0..<UInt64.max))
		}
		let keySet = Set(randomNumbers.map { "#\($0)" })
		let dict = Dictionary(uniqueKeysWithValues: keySet.map { ($0, "testing") })

		let encoded = try QuickJSON.encode(dict)
		let found = try QuickJSON.decode(from: encoded) { decoder in
			let container = try decoder.container(keyedBy: AnyStringKey.self)
			return Set(container.allKeys.compactMap { $0.stringValue })
		}
		#expect(found == keySet)
	}

	@Test("handler decodes from an unsafe raw pointer")
	func handlerOverPointer() throws {
		let json = Array(#"{"id":4,"name":"four"}"#.utf8)
		let result = try json.withUnsafeBytes { raw in
			try QuickJSON.decode(from: raw.baseAddress!, size: raw.count) { decoder in
				let container = try decoder.container(keyedBy: TestKey.self)
				return HandledResult(
					id: try container.decode(Int.self, forKey: .id),
					name: try container.decode(String.self, forKey: .name)
				)
			}
		}
		#expect(result == HandledResult(id: 4, name: "four"))
	}

	@Test("handler receives a working single value container for scalar roots")
	func handlerScalarRoot() throws {
		let result = try parse("42") { decoder in
			let container = try decoder.singleValueContainer()
			return try container.decode(Int.self)
		}
		#expect(result == 42)
	}
}
