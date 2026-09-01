import Foundation
import Testing
import QuickJSON

// shared test models and helpers for the quickjson test suite.

/// a simple flat model.
struct SimpleModel: Codable, Equatable {
	let id: Int
	let name: String
}

/// a nested model: a keyed container inside a keyed container.
struct NestedModel: Codable, Equatable {
	let title: String
	let inner: InnerModel
}

struct InnerModel: Codable, Equatable {
	let x: Int
	let y: String
}

/// an array inside an object: an unkeyed container inside a keyed container.
struct ArrayInObject: Codable, Equatable {
	let id: String
	let arr: [String]
}

/// an object inside an array: a keyed container inside an unkeyed container.
struct ObjectInArray: Codable, Equatable {
	let items: [Point]
}

struct Point: Codable, Equatable {
	let x: Double
	let y: Double
}

/// a model that exercises every scalar encode/decode path.
struct PrimitiveHolder: Codable, Equatable {
	let bool: Bool
	let string: String
	let double: Double
	let float: Float
	let int: Int
	let int8: Int8
	let int16: Int16
	let int32: Int32
	let int64: Int64
	let uint: UInt
	let uint8: UInt8
	let uint16: UInt16
	let uint32: UInt32
	let uint64: UInt64
}

/// a model with optional fields.
struct OptionalHolder: Codable, Equatable {
	let present: Int?
	let absent: Int?
}

/// a dictionary-backed model.
struct DictHolder: Codable, Equatable {
	let dict: [String: Int]
}

/// a coding key enum used by the handler-based tests.
enum TestKey: String, CodingKey {
	case a, b, c, missing, id, name, payload
}

/// a coding key that accepts any string value.
struct AnyStringKey: CodingKey, Hashable {
	var stringValue: String
	var intValue: Int? { nil }

	init?(stringValue: String) {
		self.stringValue = stringValue
	}

	init?(intValue: Int) {
		return nil
	}
}

/// a model that manually exercises `superEncoder(forKey:)`/`superDecoder(forKey:)`.
struct SuperUser: Codable, Equatable {
	let id: Int
	let payload: InnerModel

	enum CodingKeys: String, CodingKey {
		case id, payload
	}

	init(id: Int, payload: InnerModel) {
		self.id = id
		self.payload = payload
	}

	init(from decoder: Swift.Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decode(Int.self, forKey: .id)
		let superDec = try container.superDecoder(forKey: .payload)
		self.payload = try InnerModel(from: superDec)
	}

	func encode(to encoder: Swift.Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		let superEnc = container.superEncoder(forKey: .payload)
		try payload.encode(to: superEnc)
	}
}

/// a decodable that attempts to read past the end of an unkeyed container.
struct Overreader: Decodable {
	init(from decoder: Swift.Decoder) throws {
		var container = try decoder.unkeyedContainer()
		while !container.isAtEnd {
			_ = try container.decode(Int.self)
		}
		// deliberately read one element past the end
		_ = try container.decode(Int.self)
	}
}

// MARK: helpers

/// encode a value, decode it back, and assert the result equals the input.
func assertRoundTrip<T: Codable & Equatable>(_ value: T, memory: Memory.Configuration = .automatic) throws {
	let encoded = try QuickJSON.encode(value, memory: memory)
	let decoded = try QuickJSON.decode(T.self, from: encoded, memory: memory)
	#expect(decoded == value)
}
