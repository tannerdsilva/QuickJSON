// (c) tanner silva 2023. all rights reserved.
import Logging
import yyjson

/// a keyed decoding container that reads values from a yyjson object.
internal struct KeyedDecoder<Key>: Swift.KeyedDecodingContainerProtocol where Key: CodingKey {
	/// the object that this container is reading from
	private let root: UnsafeMutablePointer<yyjson_val>
	private let logger: Logger

	/// initialize a keyed container.
	/// - parameter root: the object that this container is reading from.
	/// - parameter logLevel: the log level to use for this container.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the root value is not an object.
	internal init(root: UnsafeMutablePointer<yyjson_val>, logLevel: Logger.Level = .critical) throws {
		guard yyjson_get_type(root) == YYJSON_TYPE_OBJ else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected: .obj, found: ValueType(yyjson_get_type(root))))
		}
		self.root = root
		self.logger = Decoding.logger.settingLogLevel(logLevel)
	}

	/// returns true if the given key is present in the container.
	internal func contains(_ key: Key) -> Bool {
		return yyjson_obj_get(root, key.stringValue) != nil
	}

	/// returns true if the value for the given key is null.
	/// - throws: `Decoding.Error.notFound` if the key is not present.
	internal func decodeNil(forKey key: Key) throws -> Bool {
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound
		}
		return getKeyRoot!.decodeNil()
	}

	/// decode a boolean value for the given key.
	/// - throws: `Decoding.Error.notFound` if the key is not present; `Decoding.Error.valueTypeMismatch` if the value is not a boolean.
	internal func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
		return try value(forKey: key).decodeBool()
	}

	/// decode a string value for the given key.
	/// - throws: `Decoding.Error.notFound` if the key is not present; `Decoding.Error.valueTypeMismatch` if the value is not a string.
	internal func decode(_ type: String.Type, forKey key: Key) throws -> String {
		return try value(forKey: key).decodeString()
	}

	/// decode a double value for the given key.
	/// - throws: `Decoding.Error.notFound` if the key is not present; `Decoding.Error.valueTypeMismatch` if the value is not a number.
	internal func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
		return try value(forKey: key).decodeDouble()
	}

	/// decode a float value for the given key.
	/// - throws: `Decoding.Error.notFound` if the key is not present; `Decoding.Error.valueTypeMismatch` if the value is not a number.
	internal func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
		return try value(forKey: key).decodeFloat()
	}

	/// decode an integer value for the given key.
	/// - throws: `Decoding.Error.notFound` if the key is not present; `Decoding.Error.valueTypeMismatch` if the value is not a number.
	internal func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
		return try value(forKey: key).decodeInt()
	}

	/// decode an int8 value for the given key.
	/// - throws: `Decoding.Error.notFound` if the key is not present; `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.numberOutOfRange` if it does not fit in an `Int8`.
	internal func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
		return try value(forKey: key).decodeInt8()
	}

	/// decode an int16 value for the given key.
	/// - throws: `Decoding.Error.notFound` if the key is not present; `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.numberOutOfRange` if it does not fit in an `Int16`.
	internal func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
		return try value(forKey: key).decodeInt16()
	}

	/// decode an int32 value for the given key.
	/// - throws: `Decoding.Error.notFound` if the key is not present; `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.numberOutOfRange` if it does not fit in an `Int32`.
	internal func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
		return try value(forKey: key).decodeInt32()
	}

	/// decode an int64 value for the given key.
	/// - throws: `Decoding.Error.notFound` if the key is not present; `Decoding.Error.valueTypeMismatch` if the value is not a number.
	internal func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
		return try value(forKey: key).decodeInt64()
	}

	/// decode an unsigned integer value for the given key.
	/// - throws: `Decoding.Error.notFound` if the key is not present; `Decoding.Error.valueTypeMismatch` if the value is not a number.
	internal func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
		return try value(forKey: key).decodeUInt()
	}

	/// decode a uint8 value for the given key.
	/// - throws: `Decoding.Error.notFound` if the key is not present; `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.numberOutOfRange` if it does not fit in a `UInt8`.
	internal func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
		return try value(forKey: key).decodeUInt8()
	}

	/// decode a uint16 value for the given key.
	/// - throws: `Decoding.Error.notFound` if the key is not present; `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.numberOutOfRange` if it does not fit in a `UInt16`.
	internal func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
		return try value(forKey: key).decodeUInt16()
	}

	/// decode a uint32 value for the given key.
	/// - throws: `Decoding.Error.notFound` if the key is not present; `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.numberOutOfRange` if it does not fit in a `UInt32`.
	internal func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
		return try value(forKey: key).decodeUInt32()
	}

	/// decode a uint64 value for the given key.
	/// - throws: `Decoding.Error.notFound` if the key is not present; `Decoding.Error.valueTypeMismatch` if the value is not a number.
	internal func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
		return try value(forKey: key).decodeUInt64()
	}

	/// decode a value of an arbitrary decodable type for the given key.
	/// - throws: `Decoding.Error.notFound` if the key is not present; any error thrown while decoding the value.
	internal func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T: Decodable {
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound
		}
		return try T(from: RootDecoder(root: getKeyRoot!, logLevel: logger.logLevel))
	}

	/// decode a nested keyed container for the given key.
	internal func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
		return try KeyedDecodingContainer(KeyedDecoder<NestedKey>(root: value(forKey: key), logLevel: logger.logLevel))
	}

	/// decode a nested unkeyed container for the given key.
	internal func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
		return try UnkeyedDecoder(root: value(forKey: key), logLevel: logger.logLevel)
	}

	/// decode a "super" value from the container itself.
	/// - throws: `Decoding.Error.notFound` if no value is stored under the reserved `"super"` key.
	internal func superDecoder() throws -> Swift.Decoder {
		let superValue = yyjson_obj_get(root, "super")
		guard superValue != nil else {
			throw Decoding.Error.notFound
		}
		return RootDecoder(root: superValue!, logLevel: logger.logLevel)
	}

	/// decode a "super" value for the given key.
	/// - throws: `Decoding.Error.notFound` if the key is not present.
	internal func superDecoder(forKey key: Key) throws -> Swift.Decoder {
		return RootDecoder(root: try value(forKey: key), logLevel: logger.logLevel)
	}

	/// returns all keys in the container.
	internal var allKeys: [Key] {
		var yyiter = yyjson_obj_iter()
		guard yyjson_obj_iter_init(root, &yyiter) == true else {
			return []
		}
		var buildKeys = [Key]()
		while yyjson_obj_iter_has_next(&yyiter) == true {
			let getKey = yyjson_obj_iter_next(&yyiter)!
			do {
				let getString = try getKey.decodeString()
				if let buildKey = Key(stringValue: getString) {
					buildKeys.append(buildKey)
				}
			} catch {
				continue
			}
		}
		return buildKeys
	}

	// required by swift. unused.
	internal var codingPath: [CodingKey] {
		[]
	}

	/// the raw value stored under the given key.
	/// - throws: `Decoding.Error.notFound` if the key is not present.
	private func value(forKey key: Key) throws -> UnsafeMutablePointer<yyjson_val> {
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound
		}
		return getKeyRoot!
	}
}
