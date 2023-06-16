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
		self.root = unsafe_yyjson_get_first(root)
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
		defer {
			self.increment()
		}
		return try root.decodeBool()
	}

	/// decodes the next value in the container as a string.
	internal func decode(_ type:String.Type) throws -> String {
		defer {
			self.increment()
		}
		return try root.decodeString()
	}

	/// decodes the next value in the container as a double.
	internal func decode(_ type:Double.Type) throws -> Double {
		defer {
			self.increment()
		}
		return try root.decodeDouble()
	}

	/// decodes the next value in the container as a float.
	internal func decode(_ type:Float.Type) throws -> Float {
		defer {
			self.increment()
		}
		return try root.decodeFloat()
	}

	/// decodes the next value in the container as an int.
	internal func decode(_ type:Int.Type) throws -> Int {
		defer {
			self.increment()
		}
		return try root.decodeInt()
	}

	/// decodes the next value in the container as an int8.
	internal func decode(_ type:Int8.Type) throws -> Int8 {
		defer {
			self.increment()
		}
		return try root.decodeInt8()
	}

	/// decodes the next value in the container as an int16.
	internal func decode(_ type:Int16.Type) throws -> Int16 {
		defer {
			self.increment()
		}
		return try root.decodeInt16()
	}

	/// decodes the next value in the container as an int32.
	internal func decode(_ type:Int32.Type) throws -> Int32 {
		defer {
			self.increment()
		}
		return try root.decodeInt32()
	}

	/// decodes the next value in the container as an int64.
	internal func decode(_ type:Int64.Type) throws -> Int64 {
		defer {
			self.increment()
		}
		return try root.decodeInt64()
	}

	/// decodes the next value in the container as a uint.
	internal func decode(_ type:UInt.Type) throws -> UInt {
		defer {
			self.increment()
		}
		return try root.decodeUInt()
	}

	/// decodes the next value in the container as a uint8.
	internal func decode(_ type:UInt8.Type) throws -> UInt8 {
		defer {
			self.increment()
		}
		return try root.decodeUInt8()
	}

	/// decodes the next value in the container as a uint16.
	internal func decode(_ type:UInt16.Type) throws -> UInt16 {
		defer {
			self.increment()
		}
		return try root.decodeUInt16()
	}

	/// decodes the next value in the container as a uint32.
	internal func decode(_ type:UInt32.Type) throws -> UInt32 {
		defer {
			self.increment()
		}
		return try root.decodeUInt32()
	}

	/// decodes the next value in the container as a uint64.
	internal func decode(_ type:UInt64.Type) throws -> UInt64 {
		defer {
			self.increment()
		}
		return try root.decodeUInt64()
	}

	/// decodes a given decodable type from the next value in the container.
	internal func decode<T>(_ type:T.Type) throws -> T where T:Decodable {
		defer {
			self.increment()
		}
		return try T(from: decoder(root: root))
	}

	/// decodes the next value in the container as a keyed container.
	internal func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
		defer {
			self.increment()
		}
		return KeyedDecodingContainer(try dc_keyed(root:self.root))
	}

	/// decode the next value in the container as an unkeyed container.
	internal func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
		defer {
			self.increment()
		}
		return try dc_unkeyed(root:self.root)
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