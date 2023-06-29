// (c) tanner silva 2023. all rights reserved.
import yyjson

internal final class dc_unkeyed:Swift.UnkeyedDecodingContainer {
	private var root:UnsafeMutablePointer<yyjson_val>
	internal let length:size_t
	internal var currentIndex:size_t = 0
	internal var isAtEnd:Bool {
		get {
			return self.currentIndex >= self.length
		}
	}

	/// initialize an unkeyed container with the given root object.
	/// - parameter root: the root object to decode.
	/// - throws: `Decoder.Error.valueTypeMismatch` if the root object is not an array.
	internal init(root:UnsafeMutablePointer<yyjson_val>) throws {
		guard yyjson_get_type(root) == YYJSON_TYPE_ARR else {
			throw Decoder.Error.valueTypeMismatch(Decoder.Error.ValueTypeMismatchInfo(expected: ValueType.arr, found: ValueType(yyjson_get_type(root))))
		}
		self.root = root
		self.length = yyjson_arr_size(root)
	}

	// called every time a value is decoded. 
	private func increment() {
		if self.currentIndex < self.length {
			self.currentIndex += 1
			root = unsafe_yyjson_get_next(root)
		}
	}

	/// returns true if the next value in the container is null.
	internal func decodeNil() throws -> Bool {
		defer {
			self.increment()
		}
		return root.decodeNil()
	}

	/// decodes the next value in the container as a boolean.
	internal func decode(_ type:Bool.Type) throws -> Bool {
		let decoded = try root.decodeBool()
		self.increment()
		return decoded
	}

	/// decodes the next value in the container as a string.
	internal func decode(_ type:String.Type) throws -> String {
		let decoded = try root.decodeString()
		self.increment()
		return decoded
	}

	/// decodes the next value in the container as a double.
	internal func decode(_ type:Double.Type) throws -> Double {
		let decoded = try root.decodeDouble()
		self.increment()
		return decoded
	}

	/// decodes the next value in the container as a float.
	internal func decode(_ type:Float.Type) throws -> Float {
		let decoded = try root.decodeFloat()
		self.increment()
		return decoded
	}

	/// decodes the next value in the container as an int.
	internal func decode(_ type:Int.Type) throws -> Int {
		let decoded = try root.decodeInt()
		self.increment()
		return decoded
	}

	/// decodes the next value in the container as an int8.
	internal func decode(_ type:Int8.Type) throws -> Int8 {
		let decoded = try root.decodeInt8()
		self.increment()
		return decoded
	}

	/// decodes the next value in the container as an int16.
	internal func decode(_ type:Int16.Type) throws -> Int16 {
		let decoded = try root.decodeInt16()
		self.increment()
		return decoded
	}

	/// decodes the next value in the container as an int32.
	internal func decode(_ type:Int32.Type) throws -> Int32 {
		let decoded = try root.decodeInt32()
		self.increment()
		return decoded
	}

	/// decodes the next value in the container as an int64.
	internal func decode(_ type:Int64.Type) throws -> Int64 {
		let decoded = try root.decodeInt64()
		self.increment()
		return decoded
	}

	/// decodes the next value in the container as a uint.
	internal func decode(_ type:UInt.Type) throws -> UInt {
		let decoded = try root.decodeUInt()
		self.increment()
		return decoded
	}

	/// decodes the next value in the container as a uint8.
	internal func decode(_ type:UInt8.Type) throws -> UInt8 {
		let decoded = try root.decodeUInt8()
		self.increment()
		return decoded
	}

	/// decodes the next value in the container as a uint16.
	internal func decode(_ type:UInt16.Type) throws -> UInt16 {
		let decoded = try root.decodeUInt16()
		self.increment()
		return decoded
	}

	/// decodes the next value in the container as a uint32.
	internal func decode(_ type:UInt32.Type) throws -> UInt32 {
		let decoded = try root.decodeUInt32()
		self.increment()
		return decoded
	}

	/// decodes the next value in the container as a uint64.
	internal func decode(_ type:UInt64.Type) throws -> UInt64 {
		let decoded = try root.decodeUInt64()
		self.increment()
		return decoded
	}

	/// decodes a given decodable type from the next value in the container.
	internal func decode<T>(_ type:T.Type) throws -> T where T:Decodable {
		let decoded = try T(from: decoder(root: root))
		self.increment()
		return decoded
	}

	/// decodes the next value in the container as a keyed container.
	internal func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
		let decoded = KeyedDecodingContainer<NestedKey>(try dc_keyed(root:self.root))
		self.increment()
		return decoded
	}

	/// decode the next value in the container as an unkeyed container.
	internal func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
		let decoded = try dc_unkeyed(root: self.root)
		self.increment()
		return decoded
	}

	// required by swift.
	internal var count:Int? {
		get {
			return self.length
		}
	}
	internal var codingPath:[CodingKey] {
		return []
	}
	internal func superDecoder() throws -> Swift.Decoder {
		fatalError("not supported")
	}
}