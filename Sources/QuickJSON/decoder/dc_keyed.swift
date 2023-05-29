// (c) tanner silva 2023. all rights reserved.
import yyjson

/// primary keyed decoding container.
internal struct dc_keyed<K>:Swift.KeyedDecodingContainerProtocol where K:CodingKey {
	/// key type for this container
	internal typealias Key = K

	private let root:UnsafeMutablePointer<yyjson_val>

	/// initialize a keyed container with the given root object.
	/// - throws: `Decoder.Error.valueTypeMismatch` if the root object is not an object.
	internal init(root:UnsafeMutablePointer<yyjson_val>) throws {
		guard yyjson_get_type(root) == YYJSON_TYPE_OBJ else {
			throw Decoder.Error.valueTypeMismatch(Decoder.Error.ValueTypeMismatchInfo(expected: ValueType.obj, found: ValueType(yyjson_get_type(root))))
		}
		self.root = root
	}

	/// returns true if the given key is present in the container.
	internal func contains(_ key:K) -> Bool {
		return yyjson_obj_get(root, key.stringValue) == nil
	}

	/// returns true if the following value is null.
	internal func decodeNil(forKey key:K) throws -> Bool {
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoder.Error.notFound
		}
		return getKeyRoot!.decodeNil()
	}

	/// decode a string value for the given key.
	internal func decode(_ type:Bool.Type, forKey key:K) throws -> Bool {
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoder.Error.notFound
		}
		return try getKeyRoot!.decodeBool()
	}

	/// decode a string value for the given key.
	internal func decode(_ type:String.Type, forKey key:K) throws -> String {
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoder.Error.notFound
		}
		return try getKeyRoot!.decodeString()
	}

	/// decode a double value for the given key.
	internal func decode(_ type:Double.Type, forKey key:K) throws -> Double {
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoder.Error.notFound
		}
		return try getKeyRoot!.decodeDouble()
	}

	/// decode a float value for the given key.
	internal func decode(_ type:Float.Type, forKey key:K) throws -> Float {
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoder.Error.notFound
		}
		return try getKeyRoot!.decodeFloat()
	}

	/// decode an int value for the given key.
	internal func decode(_ type:Int.Type, forKey key:K) throws -> Int {
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoder.Error.notFound
		}
		return try getKeyRoot!.decodeInt()
	}

	/// decode an int8 value for the given key.
	internal func decode(_ type:Int8.Type, forKey key:K) throws -> Int8 {
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoder.Error.notFound
		}
		return try getKeyRoot!.decodeInt8()
	}

	/// decode an int16 value for the given key.
	internal func decode(_ type:Int16.Type, forKey key:K) throws -> Int16 {
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoder.Error.notFound
		}
		return try getKeyRoot!.decodeInt16()
	}

	/// decode an int32 value for the given key.
	internal func decode(_ type:Int32.Type, forKey key:K) throws -> Int32 {
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoder.Error.notFound
		}
		return try getKeyRoot!.decodeInt32()
	}

	/// decode an int64 value for the given key.
	internal func decode(_ type:Int64.Type, forKey key:K) throws -> Int64 {
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoder.Error.notFound
		}
		return try getKeyRoot!.decodeInt64()
	}

	/// decode a uint value for the given key.
	internal func decode(_ type:UInt.Type, forKey key:K) throws -> UInt {
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoder.Error.notFound
		}
		return try getKeyRoot!.decodeUInt()
	}

	/// decode a uint8 value for the given key.
	internal func decode(_ type:UInt8.Type, forKey key:K) throws -> UInt8 {
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoder.Error.notFound
		}
		return try getKeyRoot!.decodeUInt8()
	}

	/// decode a uint16 value for the given key.
	internal func decode(_ type:UInt16.Type, forKey key:K) throws -> UInt16 {
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoder.Error.notFound
		}
		return try getKeyRoot!.decodeUInt16()
	}

	/// decode a uint32 value for the given key.
	internal func decode(_ type:UInt32.Type, forKey key:K) throws -> UInt32 {
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoder.Error.notFound
		}
		return try getKeyRoot!.decodeUInt32()
	}

	/// decode a uint64 value for the given key.
	internal func decode(_ type:UInt64.Type, forKey key:K) throws -> UInt64 {
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoder.Error.notFound
		}
		return try getKeyRoot!.decodeUInt64()
	}

	/// decode a decodable value type for a specified key.
	internal func decode<T>(_ type:T.Type, forKey key:K) throws -> T where T:Decodable {
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoder.Error.notFound
		}
		return try T(from:decoder(root:getKeyRoot!))
	}

	/// decode a nested keyed container for a specified key.
	internal func nestedContainer<NestedKey>(keyedBy type:NestedKey.Type, forKey key:K) throws -> KeyedDecodingContainer<NestedKey> where NestedKey:CodingKey {
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoder.Error.notFound
		}
		return KeyedDecodingContainer(try dc_keyed<NestedKey>(root:getKeyRoot!))
	}

	/// decode a nested unkeyed container for a specified key.
	internal func nestedUnkeyedContainer(forKey key:K) throws -> UnkeyedDecodingContainer {
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoder.Error.notFound
		}
		return try dc_unkeyed(root:getKeyRoot!)
	}

	// required by swift. unused.
	internal var allKeys:[K] {
		get {
			return []
		}
	}
	internal var codingPath:[CodingKey] {
		get {
			return []
		}
	}
	internal func superDecoder() throws -> Swift.Decoder {
		fatalError("fatalErrorMessage")
	}
	internal func superDecoder(forKey key: K) throws -> Swift.Decoder {
		fatalError("fatalErrorMessage")
	}
}