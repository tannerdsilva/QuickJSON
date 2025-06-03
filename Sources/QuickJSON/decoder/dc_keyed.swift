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
	#endif

	/// initialize a keyed container with the given root object.
	/// - parameter root: the root object of the json document.
	/// - parameter logLevel: the log level to use for this container.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the root object is not an object.
	internal init(root:UnsafeMutablePointer<yyjson_val>) throws {
		#if QUICKJSON_SHOULDLOG
		let iid = UInt16.random(in:UInt16.min...UInt16.max)
		var buildLogger = Decoding.logger
		buildLogger[metadataKey:"iid"] = "\(iid)"
		buildLogger[metadataKey:"root"] = "\(root.hashValue)"
		self.logger = buildLogger
		buildLogger.debug("enter: \(String(describing:Self.self)) : \(#function)")
		defer {
			buildLogger.trace("exit: \(String(describing:Self.self)) : \(#function)")
		}
		#endif
		guard yyjson_get_type(root) == YYJSON_TYPE_OBJ else {
			#if QUICKJSON_SHOULDLOG
			logger.error("root is not an object, found: \(ValueType(yyjson_get_type(root)))")
			#endif
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.obj, found:ValueType(yyjson_get_type(root))))
		}
		self.root = root
	}

	/// returns true if the given key is present in the container.
	internal func contains(_ key:K) -> Bool {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function)", metadata:["key_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function)", metadata:["key_arg":"\(key.stringValue)"])
		}
		#endif
		return yyjson_obj_get(root, key.stringValue) == nil
	}

	/// returns true if the following value is null.
	internal func decodeNil(forKey key:K) throws -> Bool {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function)", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function)", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound(key.stringValue)
		}
		return getKeyRoot!.decodeNil()
	}

	/// decode a string value for the given key.
	internal func decode(_ type:Bool.Type, forKey key:K) throws -> Bool {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound(key.stringValue)
		}
		return try getKeyRoot!.decodeBool()
	}

	/// decode a string value for the given key.
	internal func decode(_ type:String.Type, forKey key:K) throws -> String {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound(key.stringValue)
		}
		do {
			return try getKeyRoot!.decodeString()
		} catch let error {
			#if QUICKJSON_SHOULDLOG
			logger.error("failed to decode string for key \(key.stringValue): \(error)")
			#endif
			fatalError("This should work and it isn't and its very frustrating.")
		}
	}

	/// decode a double value for the given key.
	internal func decode(_ type:Double.Type, forKey key:K) throws -> Double {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound(key.stringValue)
		}
		return try getKeyRoot!.decodeDouble()
	}

	/// decode a float value for the given key.
	internal func decode(_ type:Float.Type, forKey key:K) throws -> Float {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound(key.stringValue)
		}
		return try getKeyRoot!.decodeFloat()
	}

	/// decode an int value for the given key.
	internal func decode(_ type:Int.Type, forKey key:K) throws -> Int {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound(key.stringValue)
		}
		return try getKeyRoot!.decodeInt()
	}

	/// decode an int8 value for the given key.
	internal func decode(_ type:Int8.Type, forKey key:K) throws -> Int8 {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound(key.stringValue)
		}
		return try getKeyRoot!.decodeInt8()
	}

	/// decode an int16 value for the given key.
	internal func decode(_ type:Int16.Type, forKey key:K) throws -> Int16 {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound(key.stringValue)
		}
		return try getKeyRoot!.decodeInt16()
	}

	/// decode an int32 value for the given key.
	internal func decode(_ type:Int32.Type, forKey key:K) throws -> Int32 {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound(key.stringValue)
		}
		return try getKeyRoot!.decodeInt32()
	}

	/// decode an int64 value for the given key.
	internal func decode(_ type:Int64.Type, forKey key:K) throws -> Int64 {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound(key.stringValue)
		}
		return try getKeyRoot!.decodeInt64()
	}

	/// decode a uint value for the given key.
	internal func decode(_ type:UInt.Type, forKey key:K) throws -> UInt {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound(key.stringValue)
		}
		return try getKeyRoot!.decodeUInt()
	}

	/// decode a uint8 value for the given key.
	internal func decode(_ type:UInt8.Type, forKey key:K) throws -> UInt8 {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound(key.stringValue)
		}
		return try getKeyRoot!.decodeUInt8()
	}

	/// decode a uint16 value for the given key.
	internal func decode(_ type:UInt16.Type, forKey key:K) throws -> UInt16 {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound(key.stringValue)
		}
		return try getKeyRoot!.decodeUInt16()
	}

	/// decode a uint32 value for the given key.
	internal func decode(_ type:UInt32.Type, forKey key:K) throws -> UInt32 {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound(key.stringValue)
		}
		return try getKeyRoot!.decodeUInt32()
	}

	/// decode a uint64 value for the given key.
	internal func decode(_ type:UInt64.Type, forKey key:K) throws -> UInt64 {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound(key.stringValue)
		}
		return try getKeyRoot!.decodeUInt64()
	}

	/// decode a decodable value type for a specified key.
	internal func decode<T>(_ type:T.Type, forKey key:K) throws -> T where T:Decodable {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound(key.stringValue)
		}
		return try T(from:decoder(root:getKeyRoot!))
	}

	/// decode a nested keyed container for a specified key.
	internal func nestedContainer<NestedKey>(keyedBy type:NestedKey.Type, forKey key:K) throws -> KeyedDecodingContainer<NestedKey> where NestedKey:CodingKey {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound(key.stringValue)
		}
		return KeyedDecodingContainer(try dc_keyed<NestedKey>(root:getKeyRoot!))
	}

	/// decode a nested unkeyed container for a specified key.
	internal func nestedUnkeyedContainer(forKey key:K) throws -> UnkeyedDecodingContainer {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function)", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function)", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			throw Decoding.Error.notFound(key.stringValue)
		}

		return try dc_unkeyed(root:getKeyRoot!)
	}

	// required by swift. unused.
	internal var allKeys:[K] {
		get {
			#if QUICKJSON_SHOULDLOG
			logger.debug("enter: \(String(describing:Self.self)) : \(#function)")
			defer {
				logger.trace("exit:  \(String(describing:Self.self)) : \(#function)")
			}
			#endif
			var yyiter = yyjson_obj_iter()
			let initIter = yyjson_obj_iter_init(root, &yyiter)
			guard initIter == true else {
				#if QUICKJSON_SHOULDLOG
				logger.error("failed to initialize iterator")
				#endif
				return []
			}
			var buildKeys = [K]()
			while yyjson_obj_iter_has_next(&yyiter) == true {
				let getKey = yyjson_obj_iter_next(&yyiter)!
				do {
					let getString = try getKey.decodeString()
					let buildKey = K(stringValue:getString)
					if buildKey != nil {
						buildKeys.append(buildKey!)
					}
				} catch {
					continue
				}
			}
			return buildKeys
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