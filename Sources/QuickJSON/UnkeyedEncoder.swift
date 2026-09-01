// (c) tanner silva 2023. all rights reserved.
import Logging
import yyjson

/// an unkeyed encoding container that appends values to a yyjson array.
internal struct UnkeyedEncoder: Swift.UnkeyedEncodingContainer {
	private let doc: UnsafeMutablePointer<yyjson_mut_doc>
	private let root: UnsafeMutablePointer<yyjson_mut_val>
	/// the number of values that have been appended to this container.
	internal private(set) var count: Int
	private let logger: Logger

	/// initialize an unkeyed container.
	/// - parameter doc: the document that this container is writing to.
	/// - parameter root: the array that this container is appending to.
	/// - parameter logLevel: the log level to use for this container.
	internal init(doc: UnsafeMutablePointer<yyjson_mut_doc>, root: UnsafeMutablePointer<yyjson_mut_val>, logLevel: Logger.Level = .critical) {
		self.doc = doc
		self.root = root
		self.count = 0
		self.logger = Encoding.logger.settingLogLevel(logLevel)
	}

	/// append a null value into the container.
	internal mutating func encodeNil() throws {
		guard let newVal = yyjson_mut_null(doc) else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a boolean value into the container.
	internal mutating func encode(_ value: Bool) throws {
		guard let newVal = yyjson_mut_bool(doc, value) else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a string value into the container.
	internal mutating func encode(_ value: String) throws {
		guard let newVal = yyjson_mut_strncpy(doc, value, value.utf8.count) else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a double value into the container.
	internal mutating func encode(_ value: Double) throws {
		guard let newVal = yyjson_mut_real(doc, value) else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a float value into the container.
	internal mutating func encode(_ value: Float) throws {
		guard let newVal = yyjson_mut_real(doc, Double(value)) else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append an integer value into the container.
	internal mutating func encode(_ value: Int) throws {
		guard let newVal = yyjson_mut_int(doc, Int64(value)) else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append an int8 value into the container.
	internal mutating func encode(_ value: Int8) throws {
		guard let newVal = yyjson_mut_int(doc, Int64(value)) else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append an int16 value into the container.
	internal mutating func encode(_ value: Int16) throws {
		guard let newVal = yyjson_mut_int(doc, Int64(value)) else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append an int32 value into the container.
	internal mutating func encode(_ value: Int32) throws {
		guard let newVal = yyjson_mut_int(doc, Int64(value)) else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append an int64 value into the container.
	internal mutating func encode(_ value: Int64) throws {
		guard let newVal = yyjson_mut_int(doc, value) else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append an unsigned integer value into the container.
	internal mutating func encode(_ value: UInt) throws {
		guard let newVal = yyjson_mut_uint(doc, UInt64(value)) else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a uint8 value into the container.
	internal mutating func encode(_ value: UInt8) throws {
		guard let newVal = yyjson_mut_uint(doc, UInt64(value)) else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a uint16 value into the container.
	internal mutating func encode(_ value: UInt16) throws {
		guard let newVal = yyjson_mut_uint(doc, UInt64(value)) else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a uint32 value into the container.
	internal mutating func encode(_ value: UInt32) throws {
		guard let newVal = yyjson_mut_uint(doc, UInt64(value)) else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a uint64 value into the container.
	internal mutating func encode(_ value: UInt64) throws {
		guard let newVal = yyjson_mut_uint(doc, value) else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a value of an arbitrary encodable type into the container.
	internal mutating func encode<T>(_ value: T) throws where T: Encodable {
		logger.debug("enter: UnkeyedEncoder.encode(_:)")
		try value.encode(to: NodeEncoder(doc: doc, position: .arrayElement(root), logLevel: logger.logLevel))
		self.count += 1
	}

	/// append a nested keyed container into the container.
	internal mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
		logger.debug("enter: UnkeyedEncoder.nestedContainer(keyedBy:)")
		let newObj = yyjson_mut_obj(doc)!
		assert(yyjson_mut_arr_append(root, newObj) == true)
		self.count += 1
		return KeyedEncodingContainer(KeyedEncoder<NestedKey>(doc: doc, root: newObj, logLevel: logger.logLevel))
	}

	/// append a nested unkeyed container into the container.
	internal mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
		logger.debug("enter: UnkeyedEncoder.nestedUnkeyedContainer()")
		let newArr = yyjson_mut_arr(doc)!
		assert(yyjson_mut_arr_append(root, newArr) == true)
		self.count += 1
		return UnkeyedEncoder(doc: doc, root: newArr, logLevel: logger.logLevel)
	}

	/// append a "super" value into the container.
	internal mutating func superEncoder() -> Swift.Encoder {
		return NodeEncoder(doc: doc, position: .arrayElement(root), logLevel: logger.logLevel)
	}

	// required by swift. unused.
	internal var codingPath: [CodingKey] {
		[]
	}
}
