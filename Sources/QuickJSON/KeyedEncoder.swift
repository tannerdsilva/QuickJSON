// (c) tanner silva 2023. all rights reserved.
import Logging
import yyjson

/// a keyed encoding container that writes keys and values into a yyjson object.
internal struct KeyedEncoder<Key>: Swift.KeyedEncodingContainerProtocol where Key: CodingKey {
	/// the document that this container is writing to
	private let doc: UnsafeMutablePointer<yyjson_mut_doc>
	/// the object that this container is writing into
	private let root: UnsafeMutablePointer<yyjson_mut_val>
	private let logger: Logger

	/// initialize a keyed container.
	/// - parameter doc: the document that this container is writing to.
	/// - parameter root: the object that this container is writing into.
	/// - parameter logLevel: the log level to use for this container.
	internal init(doc: UnsafeMutablePointer<yyjson_mut_doc>, root: UnsafeMutablePointer<yyjson_mut_val>, logLevel: Logger.Level = .critical) {
		self.doc = doc
		self.root = root
		self.logger = Encoding.logger.settingLogLevel(logLevel)
	}

	/// encode a null value for the given key.
	internal func encodeNil(forKey key: Key) throws {
		let keyVal = makeKey(key)
		let makeNull = yyjson_mut_null(doc)
		guard yyjson_mut_obj_put(root, keyVal, makeNull) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a boolean value for the given key.
	internal func encode(_ value: Bool, forKey key: Key) throws {
		let keyVal = makeKey(key)
		let makeBool = yyjson_mut_bool(doc, value)
		guard yyjson_mut_obj_put(root, keyVal, makeBool) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a string value for the given key.
	internal func encode(_ value: String, forKey key: Key) throws {
		let keyVal = makeKey(key)
		let makeString = yyjson_mut_strncpy(doc, value, value.utf8.count)
		guard yyjson_mut_obj_put(root, keyVal, makeString) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a double value for the given key.
	internal func encode(_ value: Double, forKey key: Key) throws {
		let keyVal = makeKey(key)
		let makeDouble = yyjson_mut_real(doc, value)
		guard yyjson_mut_obj_put(root, keyVal, makeDouble) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a float value for the given key.
	internal func encode(_ value: Float, forKey key: Key) throws {
		let keyVal = makeKey(key)
		let makeFloat = yyjson_mut_real(doc, Double(value))
		guard yyjson_mut_obj_put(root, keyVal, makeFloat) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an integer value for the given key.
	internal func encode(_ value: Int, forKey key: Key) throws {
		let keyVal = makeKey(key)
		let makeInt = yyjson_mut_int(doc, Int64(value))
		guard yyjson_mut_obj_put(root, keyVal, makeInt) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an int8 value for the given key.
	internal func encode(_ value: Int8, forKey key: Key) throws {
		let keyVal = makeKey(key)
		let makeInt8 = yyjson_mut_int(doc, Int64(value))
		guard yyjson_mut_obj_put(root, keyVal, makeInt8) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an int16 value for the given key.
	internal func encode(_ value: Int16, forKey key: Key) throws {
		let keyVal = makeKey(key)
		let makeInt16 = yyjson_mut_int(doc, Int64(value))
		guard yyjson_mut_obj_put(root, keyVal, makeInt16) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an int32 value for the given key.
	internal func encode(_ value: Int32, forKey key: Key) throws {
		let keyVal = makeKey(key)
		let makeInt32 = yyjson_mut_int(doc, Int64(value))
		guard yyjson_mut_obj_put(root, keyVal, makeInt32) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an int64 value for the given key.
	internal func encode(_ value: Int64, forKey key: Key) throws {
		let keyVal = makeKey(key)
		let makeInt64 = yyjson_mut_int(doc, value)
		guard yyjson_mut_obj_put(root, keyVal, makeInt64) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an unsigned integer value for the given key.
	internal func encode(_ value: UInt, forKey key: Key) throws {
		let keyVal = makeKey(key)
		let makeUInt = yyjson_mut_uint(doc, UInt64(value))
		guard yyjson_mut_obj_put(root, keyVal, makeUInt) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a uint8 value for the given key.
	internal func encode(_ value: UInt8, forKey key: Key) throws {
		let keyVal = makeKey(key)
		let makeUInt8 = yyjson_mut_uint(doc, UInt64(value))
		guard yyjson_mut_obj_put(root, keyVal, makeUInt8) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a uint16 value for the given key.
	internal func encode(_ value: UInt16, forKey key: Key) throws {
		let keyVal = makeKey(key)
		let makeUInt16 = yyjson_mut_uint(doc, UInt64(value))
		guard yyjson_mut_obj_put(root, keyVal, makeUInt16) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a uint32 value for the given key.
	internal func encode(_ value: UInt32, forKey key: Key) throws {
		let keyVal = makeKey(key)
		let makeUInt32 = yyjson_mut_uint(doc, UInt64(value))
		guard yyjson_mut_obj_put(root, keyVal, makeUInt32) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a uint64 value for the given key.
	internal func encode(_ value: UInt64, forKey key: Key) throws {
		let keyVal = makeKey(key)
		let makeUInt64 = yyjson_mut_uint(doc, value)
		guard yyjson_mut_obj_put(root, keyVal, makeUInt64) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a value of an arbitrary encodable type for the given key.
	internal func encode<T>(_ value: T, forKey inputKey: Key) throws where T: Encodable {
		logger.debug("enter: KeyedEncoder.encode(_:forKey:)")
		let key = makeKey(inputKey)
		try value.encode(to: NodeEncoder(doc: doc, position: .keyedValue(root, key), logLevel: logger.logLevel))
	}

	/// returns a keyed container for the given key.
	internal func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey inputKey: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
		logger.debug("enter: KeyedEncoder.nestedContainer(keyedBy:forKey:)")
		let key = makeKey(inputKey)
		let newObj = yyjson_mut_obj(doc)!
		assert(yyjson_mut_obj_put(root, key, newObj) == true)
		return KeyedEncodingContainer(KeyedEncoder<NestedKey>(doc: doc, root: newObj, logLevel: logger.logLevel))
	}

	/// returns an unkeyed container for the given key.
	internal func nestedUnkeyedContainer(forKey inputKey: Key) -> UnkeyedEncodingContainer {
		logger.debug("enter: KeyedEncoder.nestedUnkeyedContainer(forKey:)")
		let key = makeKey(inputKey)
		let newArr = yyjson_mut_arr(doc)!
		assert(yyjson_mut_obj_put(root, key, newArr) == true)
		return UnkeyedEncoder(doc: doc, root: newArr, logLevel: logger.logLevel)
	}

	/// returns an encoder that writes a "super" value under the given key.
	internal func superEncoder(forKey key: Key) -> Swift.Encoder {
		return NodeEncoder(doc: doc, position: .keyedValue(root, makeKey(key)), logLevel: logger.logLevel)
	}

	/// returns an encoder that writes a "super" value under the reserved `"super"` key.
	internal func superEncoder() -> Swift.Encoder {
		return NodeEncoder(doc: doc, position: .keyedValue(root, makeSyntheticKey("super")), logLevel: logger.logLevel)
	}

	// required by swift. unused.
	internal var codingPath: [CodingKey] {
		[]
	}

	/// create a yyjson key value for the given coding key.
	private func makeKey(_ key: Key) -> UnsafeMutablePointer<yyjson_mut_val> {
		return key.stringValue.withCString { cstr in
			return yyjson_mut_strncpy(doc, cstr, key.stringValue.utf8.count)!
		}
	}

	/// create a yyjson key value from a raw string.
	private func makeSyntheticKey(_ name: String) -> UnsafeMutablePointer<yyjson_mut_val> {
		return yyjson_mut_strncpy(doc, name, name.utf8.count)!
	}
}
