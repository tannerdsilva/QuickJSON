// (c) tanner silva 2023. all rights reserved.
import yyjson

internal final class dc_unkeyed:Swift.UnkeyedDecodingContainer {
	private enum ParseState {
		/// there is content in the container
		/// - argument 1: the next object in the array to consume
		case content(UnsafeMutablePointer<yyjson_val>)

		/// the end of the array has been reached
		case end
	}
	private var state:ParseState
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
		self.length = yyjson_arr_size(root)
		if self.length == 0 {
			self.state = .end
		} else {
			self.state = .content(unsafe_yyjson_get_first(root))
		}
	}

	// called every time a value is decoded. 
	private func increment() {
		switch self.state {
			case .end:
			fatalError("increment called when at end of container")
			case .content(let root):
			self.currentIndex += 1
			switch self.currentIndex < self.length {
				case true:
				self.state = .content(unsafe_yyjson_get_next(root))
				case false:
				self.state = .end
			}
		}
	}

	/// returns true if the next value in the container is null.
	internal func decodeNil() throws -> Bool {
		switch self.state {
			case .end:
			throw Decoder.Error.contentOverflow
			case .content(let root):
			let decodedValue = yyjson_is_null(root)
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as a boolean.
	internal func decode(_ type:Bool.Type) throws -> Bool {
		switch self.state {
			case .end:
			throw Decoder.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeBool()
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as a string.
	internal func decode(_ type:String.Type) throws -> String {
		switch self.state {
			case .end:
			throw Decoder.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeString()
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as a double.
	internal func decode(_ type:Double.Type) throws -> Double {
		switch self.state {
			case .end:
			throw Decoder.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeDouble()
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as a float.
	internal func decode(_ type:Float.Type) throws -> Float {
		switch self.state {
			case .end:
			throw Decoder.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeFloat()
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as an int.
	internal func decode(_ type:Int.Type) throws -> Int {
		switch self.state {
			case .end:
			throw Decoder.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeInt()
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as an int8.
	internal func decode(_ type:Int8.Type) throws -> Int8 {
		switch self.state {
			case .end:
			throw Decoder.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeInt8()
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as an int16.
	internal func decode(_ type:Int16.Type) throws -> Int16 {
		switch self.state {
			case .end:
			throw Decoder.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeInt16()
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as an int32.
	internal func decode(_ type:Int32.Type) throws -> Int32 {
		switch self.state {
			case .end:
			throw Decoder.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeInt32()
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as an int64.
	internal func decode(_ type:Int64.Type) throws -> Int64 {
		switch self.state {
			case .end:
			throw Decoder.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeInt64()
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as a uint.
	internal func decode(_ type:UInt.Type) throws -> UInt {
		switch self.state {
			case .end:
			throw Decoder.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeUInt()
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as a uint8.
	internal func decode(_ type:UInt8.Type) throws -> UInt8 {
		switch self.state {
			case .end:
			throw Decoder.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeUInt8()
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as a uint16.
	internal func decode(_ type:UInt16.Type) throws -> UInt16 {
		switch self.state {
			case .end:
			throw Decoder.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeUInt16()
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as a uint32.
	internal func decode(_ type:UInt32.Type) throws -> UInt32 {
		switch self.state {
			case .end:
			throw Decoder.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeUInt32()
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as a uint64.
	internal func decode(_ type:UInt64.Type) throws -> UInt64 {
		switch self.state {
			case .end:
			throw Decoder.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeUInt64()
			self.increment()
			return decodedValue
		}
	}

	/// decodes a given decodable type from the next value in the container.
	internal func decode<T>(_ type:T.Type) throws -> T where T:Decodable {
		switch self.state {
			case .end:
			throw Decoder.Error.contentOverflow
			case .content(let root):
			let decodedValue = try T(from:decoder(root:root))
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as a keyed container.
	internal func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
		switch self.state {
			case .end:
			throw Decoder.Error.contentOverflow
			case .content(let root):
			let decodedValue = try KeyedDecodingContainer(dc_keyed<NestedKey>(root:root))
			self.increment()
			return decodedValue
		}
	}

	/// decode the next value in the container as an unkeyed container.
	internal func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
		switch self.state {
			case .end:
			throw Decoder.Error.contentOverflow
			case .content(let root):
			let decodedValue = try dc_unkeyed(root:root)
			self.increment()
			return decodedValue
		}
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