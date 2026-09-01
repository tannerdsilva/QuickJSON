// (c) tanner silva 2023. all rights reserved.
import Logging
import yyjson

/// an unkeyed decoding container that reads values from a yyjson array.
internal struct UnkeyedDecoder: Swift.UnkeyedDecodingContainer {

	/// helps `UnkeyedDecoder` keep track of its internal state
	private enum ParseState {
		/// there is content in the container; the associated value is the next object to consume.
		case content(UnsafeMutablePointer<yyjson_val>)
		/// the end of the array has been reached
		case end
	}

	/// the current state of the container
	private var state: ParseState

	/// the number of elements in the container
	internal let length: Int
	/// the index of the current element
	internal var currentIndex: Int = 0
	/// true if there are no more elements to consume.
	internal var isAtEnd: Bool {
		return self.currentIndex >= self.length
	}
	/// the number of elements in the container.
	internal var count: Int? {
		return self.length
	}
	private let logger: Logger

	/// initialize an unkeyed container with the given root value.
	/// - parameter root: the root value to decode.
	/// - parameter logLevel: the log level to use for this container.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the root value is not an array.
	internal init(root: UnsafeMutablePointer<yyjson_val>, logLevel: Logger.Level = .critical) throws {
		guard yyjson_get_type(root) == YYJSON_TYPE_ARR else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected: .arr, found: ValueType(yyjson_get_type(root))))
		}
		self.length = Int(yyjson_arr_size(root))
		self.state = self.length == 0 ? .end : .content(unsafe_yyjson_get_first(root))
		self.logger = Decoding.logger.settingLogLevel(logLevel)
	}

	// called after every element is consumed. advances the container state to the next element.
	private mutating func increment(from current: UnsafeMutablePointer<yyjson_val>) {
		self.currentIndex += 1
		self.state = self.currentIndex < self.length ? .content(unsafe_yyjson_get_next(current)) : .end
	}

	/// returns true if the next value in the container is null.
	/// - throws: `Decoding.Error.contentOverflow` if the end of the container has been reached.
	internal mutating func decodeNil() throws -> Bool {
		switch self.state {
		case .end:
			throw Decoding.Error.contentOverflow
		case .content(let root):
			let decodedValue = yyjson_is_null(root)
			self.increment(from: root)
			return decodedValue
		}
	}

	/// decodes the next value in the container as a boolean.
	/// - throws: `Decoding.Error.contentOverflow` if the end of the container has been reached; `Decoding.Error.valueTypeMismatch` if the value is not a boolean.
	internal mutating func decode(_ type: Bool.Type) throws -> Bool {
		switch self.state {
		case .end:
			throw Decoding.Error.contentOverflow
		case .content(let root):
			let decodedValue = try root.decodeBool()
			self.increment(from: root)
			return decodedValue
		}
	}

	/// decodes the next value in the container as a string.
	/// - throws: `Decoding.Error.contentOverflow` if the end of the container has been reached; `Decoding.Error.valueTypeMismatch` if the value is not a string.
	internal mutating func decode(_ type: String.Type) throws -> String {
		switch self.state {
		case .end:
			throw Decoding.Error.contentOverflow
		case .content(let root):
			let decodedValue = try root.decodeString()
			self.increment(from: root)
			return decodedValue
		}
	}

	/// decodes the next value in the container as a double.
	/// - throws: `Decoding.Error.contentOverflow` if the end of the container has been reached; `Decoding.Error.valueTypeMismatch` if the value is not a number.
	internal mutating func decode(_ type: Double.Type) throws -> Double {
		switch self.state {
		case .end:
			throw Decoding.Error.contentOverflow
		case .content(let root):
			let decodedValue = try root.decodeDouble()
			self.increment(from: root)
			return decodedValue
		}
	}

	/// decodes the next value in the container as a float.
	/// - throws: `Decoding.Error.contentOverflow` if the end of the container has been reached; `Decoding.Error.valueTypeMismatch` if the value is not a number.
	internal mutating func decode(_ type: Float.Type) throws -> Float {
		switch self.state {
		case .end:
			throw Decoding.Error.contentOverflow
		case .content(let root):
			let decodedValue = try root.decodeFloat()
			self.increment(from: root)
			return decodedValue
		}
	}

	/// decodes the next value in the container as an integer.
	/// - throws: `Decoding.Error.contentOverflow` if the end of the container has been reached; `Decoding.Error.valueTypeMismatch` if the value is not a number.
	internal mutating func decode(_ type: Int.Type) throws -> Int {
		switch self.state {
		case .end:
			throw Decoding.Error.contentOverflow
		case .content(let root):
			let decodedValue = try root.decodeInt()
			self.increment(from: root)
			return decodedValue
		}
	}

	/// decodes the next value in the container as an int8.
	/// - throws: `Decoding.Error.contentOverflow` if the end of the container has been reached; `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.numberOutOfRange` if it does not fit in an `Int8`.
	internal mutating func decode(_ type: Int8.Type) throws -> Int8 {
		switch self.state {
		case .end:
			throw Decoding.Error.contentOverflow
		case .content(let root):
			let decodedValue = try root.decodeInt8()
			self.increment(from: root)
			return decodedValue
		}
	}

	/// decodes the next value in the container as an int16.
	/// - throws: `Decoding.Error.contentOverflow` if the end of the container has been reached; `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.numberOutOfRange` if it does not fit in an `Int16`.
	internal mutating func decode(_ type: Int16.Type) throws -> Int16 {
		switch self.state {
		case .end:
			throw Decoding.Error.contentOverflow
		case .content(let root):
			let decodedValue = try root.decodeInt16()
			self.increment(from: root)
			return decodedValue
		}
	}

	/// decodes the next value in the container as an int32.
	/// - throws: `Decoding.Error.contentOverflow` if the end of the container has been reached; `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.numberOutOfRange` if it does not fit in an `Int32`.
	internal mutating func decode(_ type: Int32.Type) throws -> Int32 {
		switch self.state {
		case .end:
			throw Decoding.Error.contentOverflow
		case .content(let root):
			let decodedValue = try root.decodeInt32()
			self.increment(from: root)
			return decodedValue
		}
	}

	/// decodes the next value in the container as an int64.
	/// - throws: `Decoding.Error.contentOverflow` if the end of the container has been reached; `Decoding.Error.valueTypeMismatch` if the value is not a number.
	internal mutating func decode(_ type: Int64.Type) throws -> Int64 {
		switch self.state {
		case .end:
			throw Decoding.Error.contentOverflow
		case .content(let root):
			let decodedValue = try root.decodeInt64()
			self.increment(from: root)
			return decodedValue
		}
	}

	/// decodes the next value in the container as an unsigned integer.
	/// - throws: `Decoding.Error.contentOverflow` if the end of the container has been reached; `Decoding.Error.valueTypeMismatch` if the value is not a number.
	internal mutating func decode(_ type: UInt.Type) throws -> UInt {
		switch self.state {
		case .end:
			throw Decoding.Error.contentOverflow
		case .content(let root):
			let decodedValue = try root.decodeUInt()
			self.increment(from: root)
			return decodedValue
		}
	}

	/// decodes the next value in the container as a uint8.
	/// - throws: `Decoding.Error.contentOverflow` if the end of the container has been reached; `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.numberOutOfRange` if it does not fit in a `UInt8`.
	internal mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
		switch self.state {
		case .end:
			throw Decoding.Error.contentOverflow
		case .content(let root):
			let decodedValue = try root.decodeUInt8()
			self.increment(from: root)
			return decodedValue
		}
	}

	/// decodes the next value in the container as a uint16.
	/// - throws: `Decoding.Error.contentOverflow` if the end of the container has been reached; `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.numberOutOfRange` if it does not fit in a `UInt16`.
	internal mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
		switch self.state {
		case .end:
			throw Decoding.Error.contentOverflow
		case .content(let root):
			let decodedValue = try root.decodeUInt16()
			self.increment(from: root)
			return decodedValue
		}
	}

	/// decodes the next value in the container as a uint32.
	/// - throws: `Decoding.Error.contentOverflow` if the end of the container has been reached; `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.numberOutOfRange` if it does not fit in a `UInt32`.
	internal mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
		switch self.state {
		case .end:
			throw Decoding.Error.contentOverflow
		case .content(let root):
			let decodedValue = try root.decodeUInt32()
			self.increment(from: root)
			return decodedValue
		}
	}

	/// decodes the next value in the container as a uint64.
	/// - throws: `Decoding.Error.contentOverflow` if the end of the container has been reached; `Decoding.Error.valueTypeMismatch` if the value is not a number.
	internal mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
		switch self.state {
		case .end:
			throw Decoding.Error.contentOverflow
		case .content(let root):
			let decodedValue = try root.decodeUInt64()
			self.increment(from: root)
			return decodedValue
		}
	}

	/// decodes a value of an arbitrary decodable type from the next value in the container.
	/// - throws: `Decoding.Error.contentOverflow` if the end of the container has been reached; any error thrown while decoding the value.
	internal mutating func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
		switch self.state {
		case .end:
			throw Decoding.Error.contentOverflow
		case .content(let root):
			let decodedValue = try T(from: RootDecoder(root: root, logLevel: logger.logLevel))
			self.increment(from: root)
			return decodedValue
		}
	}

	/// decodes the next value in the container as a nested keyed container.
	/// - throws: `Decoding.Error.contentOverflow` if the end of the container has been reached; `Decoding.Error.valueTypeMismatch` if the value is not an object.
	internal mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
		switch self.state {
		case .end:
			throw Decoding.Error.contentOverflow
		case .content(let root):
			let decodedValue = try KeyedDecodingContainer(KeyedDecoder<NestedKey>(root: root, logLevel: logger.logLevel))
			self.increment(from: root)
			return decodedValue
		}
	}

	/// decodes the next value in the container as a nested unkeyed container.
	/// - throws: `Decoding.Error.contentOverflow` if the end of the container has been reached; `Decoding.Error.valueTypeMismatch` if the value is not an array.
	internal mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
		switch self.state {
		case .end:
			throw Decoding.Error.contentOverflow
		case .content(let root):
			let decodedValue = try UnkeyedDecoder(root: root, logLevel: logger.logLevel)
			self.increment(from: root)
			return decodedValue
		}
	}

	/// decodes the next value in the container as a "super" value.
	/// - throws: `Decoding.Error.contentOverflow` if the end of the container has been reached.
	internal mutating func superDecoder() throws -> Swift.Decoder {
		switch self.state {
		case .end:
			throw Decoding.Error.contentOverflow
		case .content(let root):
			let decodedValue = RootDecoder(root: root, logLevel: logger.logLevel)
			self.increment(from: root)
			return decodedValue
		}
	}

	// required by swift. unused.
	internal var codingPath: [CodingKey] {
		[]
	}
}
