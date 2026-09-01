import Testing
import QuickJSON

@Suite("round trips")
struct RoundTripTests {

	@Test("flat model round trips")
	func flatModel() throws {
		try assertRoundTrip(SimpleModel(id: 1, name: "Test Name"))
	}

	@Test("all primitive scalars round trip")
	func primitives() throws {
		try assertRoundTrip(
			PrimitiveHolder(
				bool: true,
				string: "hello",
				double: -123.456,
				float: 3.25,
				int: Int.max,
				int8: -128,
				int16: 32767,
				int32: -2147483648,
				int64: Int64.max,
				uint: UInt.max,
				uint8: 255,
				uint16: 65535,
				uint32: 4294967295,
				uint64: UInt64.max
			)
		)
	}

	@Test("nested keyed-in-keyed structure round trips")
	func nestedKeyedInKeyed() throws {
		try assertRoundTrip(NestedModel(title: "outer", inner: InnerModel(x: 42, y: "inner")))
	}

	@Test("array inside object round trips")
	func unkeyedInKeyed() throws {
		try assertRoundTrip(ArrayInObject(id: "123", arr: ["A", "B", "C"]))
	}

	@Test("object inside array round trips")
	func keyedInUnkeyed() throws {
		try assertRoundTrip(ObjectInArray(items: [Point(x: 1.5, y: 2.5), Point(x: 3.5, y: 4.5)]))
	}

	@Test("array of models round trips")
	func arrayOfModels() throws {
		try assertRoundTrip([SimpleModel(id: 1, name: "a"), SimpleModel(id: 2, name: "b")])
	}

	@Test("dictionary round trips regardless of iteration order")
	func dictionary() throws {
		try assertRoundTrip(DictHolder(dict: ["a": 1, "b": 2, "c": 3]))
	}

	@Test("optional present and absent round trip")
	func optionals() throws {
		try assertRoundTrip(OptionalHolder(present: 5, absent: nil))
	}

	@Test("empty array and empty object round trip")
	func emptyCollections() throws {
		try assertRoundTrip([Int]())
		try assertRoundTrip([String: Int]())
	}

	@Test("scalar document roots round trip")
	func scalarRoots() throws {
		let int = try QuickJSON.encode(42)
		#expect(try QuickJSON.decode(Int.self, from: int) == 42)
		let string = try QuickJSON.encode("hello")
		#expect(try QuickJSON.decode(String.self, from: string) == "hello")
		let bool = try QuickJSON.encode(true)
		#expect(try QuickJSON.decode(Bool.self, from: bool) == true)
		let nilInt = try QuickJSON.encode(Int?.none)
		#expect(try QuickJSON.decode(Int?.self, from: nilInt) == nil)
	}

	@Test("strings with escapes and unicode round trip")
	func escapingStrings() throws {
		try assertRoundTrip(SimpleModel(id: 1, name: "quote\" backslash\\ newline\n tab\t unicode\u{1F600} café"))
		try assertRoundTrip(SimpleModel(id: 2, name: ""))
	}

	@Test("super encoder and super decoder round trip")
	func superContainer() throws {
		try assertRoundTrip(SuperUser(id: 7, payload: InnerModel(x: 3, y: "nested")))
	}
}
