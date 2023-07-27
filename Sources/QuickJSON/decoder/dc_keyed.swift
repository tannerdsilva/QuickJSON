// (c) tanner silva 2023. all rights reserved.
import yyjson

#if QUICKJSON_SHOULDLOG
import Logging
#endif

/// primary keyed decoding container.
internal struct dc_keyed<K>:Swift.KeyedDecodingContainerProtocol where K:CodingKey {
	/// key type for this container
	internal typealias Key = K

	private let root:UnsafeMutablePointer<yyjson_val>

	#if QUICKJSON_SHOULDLOG
	private let logger:Logger
	private let logLevel:Logging.Logger.Level

	/// initialize a keyed container with the given root object.
	/// - parameter root: the root object of the json document.
	/// - parameter logLevel: the log level to use for this container.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the root object is not an object.
	internal init(root:UnsafeMutablePointer<yyjson_val>, logLevel:Logging.Logger.Level) throws {
		let iid = UInt16.random(in:UInt16.min...UInt16.max)
		var buildLogger = Encoding.logger
		buildLogger[metadataKey:"iid"] = "\(iid)"
		self.logger = buildLogger
		self.logLevel = logLevel
		buildLogger.debug("enter: dc_keyed.init(root:)")
		defer {
			buildLogger.trace("exit: dc_keyed.init(root:)")
		}
		guard yyjson_get_type(root) == YYJSON_TYPE_OBJ else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected: ValueType.obj, found: ValueType(yyjson_get_type(root))))
		}
		self.root = root
	}
	#else
	/// initialize a keyed container with the given root object.
	/// - parameter root: the root object of the json document.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the root object is not an object.
	internal init(root:UnsafeMutablePointer<yyjson_val>) throws {
		guard yyjson_get_type(root) == YYJSON_TYPE_OBJ else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected: ValueType.obj, found: ValueType(yyjson_get_type(root))))
		}
		self.root = root
	}
	#endif

	/// returns true if the given key is present in the container.
	internal func contains(_ key:K) -> Bool {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_keyed.contains(_:K)")
		defer {
			self.logger.trace("exit: dc_keyed.contains(_:K)")
		}
		#endif

		return yyjson_obj_get(root, key.stringValue) == nil
	}

	/// returns true if the following value is null.
	internal func decodeNil(forKey key:K) throws -> Bool {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_keyed.decodeNil(forKey:K)")
		defer {
			self.logger.trace("exit: dc_keyed.decodeNil(forKey:K)")
		}
		#endif

		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound
		}
		return getKeyRoot!.decodeNil()
	}

	/// decode a string value for the given key.
	internal func decode(_ type:Bool.Type, forKey key:K) throws -> Bool {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_keyed.decode(_:Bool.Type, forKey:K)")
		defer {
			self.logger.trace("exit: dc_keyed.decode(_:Bool.Type, forKey:K)")
		}
		#endif

		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound
		}
		return try getKeyRoot!.decodeBool()
	}

	/// decode a string value for the given key.
	internal func decode(_ type:String.Type, forKey key:K) throws -> String {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_keyed.decode(_:String.Type, forKey:K)")
		defer {
			self.logger.trace("exit: dc_keyed.decode(_:String.Type, forKey:K)")
		}
		#endif
		
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound
		}
		return try getKeyRoot!.decodeString()
	}

	/// decode a double value for the given key.
	internal func decode(_ type:Double.Type, forKey key:K) throws -> Double {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_keyed.decode(_:Double.Type, forKey:K)")
		defer {
			self.logger.trace("exit: dc_keyed.decode(_:Double.Type, forKey:K)")
		}
		#endif
		
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound
		}
		return try getKeyRoot!.decodeDouble()
	}

	/// decode a float value for the given key.
	internal func decode(_ type:Float.Type, forKey key:K) throws -> Float {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_keyed.decode(_:Float.Type, forKey:K)")
		defer {
			self.logger.trace("exit: dc_keyed.decode(_:Float.Type, forKey:K)")
		}
		#endif
		
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound
		}
		return try getKeyRoot!.decodeFloat()
	}

	/// decode an int value for the given key.
	internal func decode(_ type:Int.Type, forKey key:K) throws -> Int {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_keyed.decode(_:Int.Type, forKey:K)")
		defer {
			self.logger.trace("exit: dc_keyed.decode(_:Int.Type, forKey:K)")
		}
		#endif
		
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound
		}
		return try getKeyRoot!.decodeInt()
	}

	/// decode an int8 value for the given key.
	internal func decode(_ type:Int8.Type, forKey key:K) throws -> Int8 {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_keyed.decode(_:Int.Type, forKey:K)")
		defer {
			self.logger.trace("exit: dc_keyed.decode(_:Int.Type, forKey:K)")
		}
		#endif

		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound
		}
		return try getKeyRoot!.decodeInt8()
	}

	/// decode an int16 value for the given key.
	internal func decode(_ type:Int16.Type, forKey key:K) throws -> Int16 {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_keyed.decode(_:Int16.Type, forKey:K)")
		defer {
			self.logger.trace("exit: dc_keyed.decode(_:Int16.Type, forKey:K)")
		}
		#endif
		
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound
		}
		return try getKeyRoot!.decodeInt16()
	}

	/// decode an int32 value for the given key.
	internal func decode(_ type:Int32.Type, forKey key:K) throws -> Int32 {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_keyed.decode(_:Int32.Type, forKey:K)")
		defer {
			self.logger.trace("exit: dc_keyed.decode(_:Int32.Type, forKey:K)")
		}
		#endif
		
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound
		}
		return try getKeyRoot!.decodeInt32()
	}

	/// decode an int64 value for the given key.
	internal func decode(_ type:Int64.Type, forKey key:K) throws -> Int64 {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_keyed.decode(_:Int64.Type, forKey:K)")
		defer {
			self.logger.trace("exit: dc_keyed.decode(_:Int64.Type, forKey:K)")
		}
		#endif

		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound
		}
		return try getKeyRoot!.decodeInt64()
	}

	/// decode a uint value for the given key.
	internal func decode(_ type:UInt.Type, forKey key:K) throws -> UInt {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_keyed.decode(_:UInt.Type, forKey:K)")
		defer {
			self.logger.trace("exit: dc_keyed.decode(_:UInt.Type, forKey:K)")
		}
		#endif
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound
		}
		return try getKeyRoot!.decodeUInt()
	}

	/// decode a uint8 value for the given key.
	internal func decode(_ type:UInt8.Type, forKey key:K) throws -> UInt8 {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_keyed.decode(_:UInt8.Type, forKey:K)")
		defer {
			self.logger.trace("exit: dc_keyed.decode(_:UInt8.Type, forKey:K)")
		}
		#endif
		
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound
		}
		return try getKeyRoot!.decodeUInt8()
	}

	/// decode a uint16 value for the given key.
	internal func decode(_ type:UInt16.Type, forKey key:K) throws -> UInt16 {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_keyed.decode(_:UInt16.Type, forKey:K)")
		defer {
			self.logger.trace("exit: dc_keyed.decode(_:UInt16.Type, forKey:K)")
		}
		#endif
		
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound
		}
		return try getKeyRoot!.decodeUInt16()
	}

	/// decode a uint32 value for the given key.
	internal func decode(_ type:UInt32.Type, forKey key:K) throws -> UInt32 {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_keyed.decode(_:UInt32.Type, forKey:K)")
		defer {
			self.logger.trace("exit: dc_keyed.decode(_:UInt32.Type, forKey:K)")
		}
		#endif

		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound
		}
		return try getKeyRoot!.decodeUInt32()
	}

	/// decode a uint64 value for the given key.
	internal func decode(_ type:UInt64.Type, forKey key:K) throws -> UInt64 {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_keyed.decode(_:UInt64.Type, forKey:K)")
		defer {
			self.logger.trace("exit: dc_keyed.decode(_:UInt64.Type, forKey:K)")
		}
		#endif

		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound
		}
		return try getKeyRoot!.decodeUInt64()
	}

	/// decode a decodable value type for a specified key.
	internal func decode<T>(_ type:T.Type, forKey key:K) throws -> T where T:Decodable {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_keyed.decode(_:T.Type, forKey:K)")
		defer {
			self.logger.trace("exit: dc_keyed.decode(_:T.Type, forKey:K)")
		}
		#endif
		
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound
		}

		#if QUICKJSON_SHOULDLOG
		return try T(from:decoder(root:getKeyRoot!, logLevel:self.logLevel))
		#else
		return try T(from:decoder(root:getKeyRoot!))
		#endif
	}

	/// decode a nested keyed container for a specified key.
	internal func nestedContainer<NestedKey>(keyedBy type:NestedKey.Type, forKey key:K) throws -> KeyedDecodingContainer<NestedKey> where NestedKey:CodingKey {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_keyed.nestedContainer(keyedBy:K, forKey:K)")
		defer {
			self.logger.trace("exit: dc_keyed.nestedContainer(keyedBy:K, forKey:K)")
		}
		#endif
		
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound
		}

		#if QUICKJSON_SHOULDLOG
		return KeyedDecodingContainer(try dc_keyed<NestedKey>(root:getKeyRoot!, logLevel:self.logLevel))
		#else
		return KeyedDecodingContainer(try dc_keyed<NestedKey>(root:getKeyRoot!))
		#endif
	}

	/// decode a nested unkeyed container for a specified key.
	internal func nestedUnkeyedContainer(forKey key:K) throws -> UnkeyedDecodingContainer {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_keyed.nestedUnkeyedContainer(forKey:K)")
		defer {
			self.logger.trace("exit: dc_keyed.nestedUnkeyedContainer(forKey:K)")
		}
		#endif
	
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound
		}

		#if QUICKJSON_SHOULDLOG
		return try dc_unkeyed(root:getKeyRoot!, logLevel:self.logLevel)
		#else
		return try dc_unkeyed(root:getKeyRoot!)
		#endif
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