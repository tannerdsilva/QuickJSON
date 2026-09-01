// (c) tanner silva 2023. all rights reserved.
import Logging
import yyjson

/// a single value decoding container that reads a value from a yyjson value.
internal struct SingleValueDecoder: Swift.SingleValueDecodingContainer {
	private let root: UnsafeMutablePointer<yyjson_val>
	private let logger: Logger

	/// initialize a single value container.
	/// - parameter root: the value that this container will decode from.
	/// - parameter logLevel: the log level to use for this container.
	internal init(root: UnsafeMutablePointer<yyjson_val>, logLevel: Logger.Level = .critical) {
		self.root = root
		self.logger = Decoding.logger.settingLogLevel(logLevel)
	}

	/// returns true if the following value is null.
	internal func decodeNil() -> Bool {
		return root.decodeNil()
	}

	/// returns the value as a boolean.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a boolean.
	internal func decode(_ type: Bool.Type) throws -> Bool {
		return try root.decodeBool()
	}

	/// returns the value as a string.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a string.
	internal func decode(_ type: String.Type) throws -> String {
		return try root.decodeString()
	}

	/// returns the value as a double.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number.
	internal func decode(_ type: Double.Type) throws -> Double {
		return try root.decodeDouble()
	}

	/// returns the value as a float.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number.
	internal func decode(_ type: Float.Type) throws -> Float {
		return try root.decodeFloat()
	}

	/// returns the value as an integer.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number.
	internal func decode(_ type: Int.Type) throws -> Int {
		return try root.decodeInt()
	}

	/// returns the value as an int8.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.numberOutOfRange` if it does not fit in an `Int8`.
	internal func decode(_ type: Int8.Type) throws -> Int8 {
		return try root.decodeInt8()
	}

	/// returns the value as an int16.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.numberOutOfRange` if it does not fit in an `Int16`.
	internal func decode(_ type: Int16.Type) throws -> Int16 {
		return try root.decodeInt16()
	}

	/// returns the value as an int32.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.numberOutOfRange` if it does not fit in an `Int32`.
	internal func decode(_ type: Int32.Type) throws -> Int32 {
		return try root.decodeInt32()
	}

	/// returns the value as an int64.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number.
	internal func decode(_ type: Int64.Type) throws -> Int64 {
		return try root.decodeInt64()
	}

	/// returns the value as an unsigned integer.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number.
	internal func decode(_ type: UInt.Type) throws -> UInt {
		return try root.decodeUInt()
	}

	/// returns the value as a uint8.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.numberOutOfRange` if it does not fit in a `UInt8`.
	internal func decode(_ type: UInt8.Type) throws -> UInt8 {
		return try root.decodeUInt8()
	}

	/// returns the value as a uint16.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.numberOutOfRange` if it does not fit in a `UInt16`.
	internal func decode(_ type: UInt16.Type) throws -> UInt16 {
		return try root.decodeUInt16()
	}

	/// returns the value as a uint32.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.numberOutOfRange` if it does not fit in a `UInt32`.
	internal func decode(_ type: UInt32.Type) throws -> UInt32 {
		return try root.decodeUInt32()
	}

	/// returns the value as a uint64.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number.
	internal func decode(_ type: UInt64.Type) throws -> UInt64 {
		return try root.decodeUInt64()
	}

	/// returns the value as a specified decodable type.
	/// - throws: any error thrown while decoding the value.
	internal func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
		return try T(from: RootDecoder(root: root, logLevel: logger.logLevel))
	}

	// required by swift. unused.
	internal var codingPath: [CodingKey] {
		[]
	}
}
