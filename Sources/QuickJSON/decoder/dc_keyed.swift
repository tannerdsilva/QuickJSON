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
	private let logger:Logger?
	/// initialize a keyed container with the given root object.
	/// - parameter root: the root object of the json document.
	/// - parameter logLevel: the log level to use for this container.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the root object is not an object.
	internal init(root:UnsafeMutablePointer<yyjson_val>, logger:Logging.Logger?) throws {
		let iid = UInt16.random(in:UInt16.min...UInt16.max)
		var buildLogger = logger
		buildLogger?[metadataKey:"iid"] = "\(iid)"
		buildLogger?[metadataKey:"type"] = "dc_keyed<K:\(String(describing:K.self))>"
		self.logger = buildLogger
		guard yyjson_get_type(root) == YYJSON_TYPE_OBJ else {
			buildLogger?.error("error initializing instance: JSON object type not found")
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected: ValueType.obj, found: ValueType(yyjson_get_type(root))))
		}
		buildLogger?.debug("instance init")
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
		self.logger?.debug("enter: contains(_:K)")
		defer {
			self.logger?.trace("exit: contains(_:K)")
		}
		#endif

		return yyjson_obj_get(root, key.stringValue) == nil
	}

	/// returns true if the following value is null.
	internal func decodeNil(forKey key:K) throws -> Bool {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decodeNil(forKey:K)")
		defer {
			self.logger?.trace("exit: decodeNil(forKey:K)")
		}
		#endif

		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("key not found: '\(key.stringValue)'")
			#endif
			throw Decoding.Error.notFound
		}
		return getKeyRoot!.decodeNil()
	}

	/// decode a string value for the given key.
	internal func decode(_ type:Bool.Type, forKey key:K) throws -> Bool {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:Bool.Type, forKey:K)")
		defer {
			self.logger?.trace("exit: decode(_:Bool.Type, forKey:K)")
		}
		#endif

		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("key not found: '\(key.stringValue)'")
			#endif
			throw Decoding.Error.notFound
		}
		
		#if QUICKJSON_SHOULDLOG
		return try getKeyRoot!.decodeBool(logger:logger)
		#else
		return try getKeyRoot!.decodeBool()
		#endif
	}

	/// decode a string value for the given key.
	internal func decode(_ type:String.Type, forKey key:K) throws -> String {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:String.Type, forKey:K)")
		defer {
			self.logger?.trace("exit: decode(_:String.Type, forKey:K)")
		}
		#endif
		
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("key not found: '\(key.stringValue)'")
			#endif
			throw Decoding.Error.notFound
		}
		#if QUICKJSON_SHOULDLOG
		return try getKeyRoot!.decodeString(logger:logger)
		#else
		return try getKeyRoot!.decodeString()
		#endif
	}

	/// decode a double value for the given key.
	internal func decode(_ type:Double.Type, forKey key:K) throws -> Double {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:Double.Type, forKey:K)")
		defer {
			self.logger?.trace("exit: decode(_:Double.Type, forKey:K)")
		}
		#endif
		
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("key not found: '\(key.stringValue)'")
			#endif
			throw Decoding.Error.notFound
		}
		#if QUICKJSON_SHOULDLOG
		return try getKeyRoot!.decodeDouble(logger:logger)
		#else
		return try getKeyRoot!.decodeDouble()
		#endif
	}

	/// decode a float value for the given key.
	internal func decode(_ type:Float.Type, forKey key:K) throws -> Float {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:Float.Type, forKey:K)")
		defer {
			self.logger?.trace("exit: decode(_:Float.Type, forKey:K)")
		}
		#endif
		
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("key not found: '\(key.stringValue)'")
			#endif
			throw Decoding.Error.notFound
		}
		#if QUICKJSON_SHOULDLOG
		return try getKeyRoot!.decodeFloat(logger:logger)
		#else
		return try getKeyRoot!.decodeFloat()
		#endif
	}

	/// decode an int value for the given key.
	internal func decode(_ type:Int.Type, forKey key:K) throws -> Int {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:Int.Type, forKey:K)")
		defer {
			self.logger?.trace("exit: decode(_:Int.Type, forKey:K)")
		}
		#endif
		
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("key not found: '\(key.stringValue)'")
			#endif
			throw Decoding.Error.notFound
		}
		#if QUICKJSON_SHOULDLOG
		return try getKeyRoot!.decodeInt(logger:logger)
		#else
		return try getKeyRoot!.decodeInt()
		#endif
	}

	/// decode an int8 value for the given key.
	internal func decode(_ type:Int8.Type, forKey key:K) throws -> Int8 {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:Int8.Type, forKey:K)")
		defer {
			self.logger?.trace("exit: decode(_:Int8.Type, forKey:K)")
		}
		#endif

		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("key not found: '\(key.stringValue)'")
			#endif
			throw Decoding.Error.notFound
		}
		#if QUICKJSON_SHOULDLOG
		return try getKeyRoot!.decodeInt8(logger:logger)
		#else
		return try getKeyRoot!.decodeInt8()
		#endif
	}

	/// decode an int16 value for the given key.
	internal func decode(_ type:Int16.Type, forKey key:K) throws -> Int16 {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:Int16.Type, forKey:K)")
		defer {
			self.logger?.trace("exit: decode(_:Int16.Type, forKey:K)")
		}
		#endif
		
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("key not found: '\(key.stringValue)'")
			#endif
			throw Decoding.Error.notFound
		}
		#if QUICKJSON_SHOULDLOG
		return try getKeyRoot!.decodeInt16(logger:logger)
		#else
		return try getKeyRoot!.decodeInt16()
		#endif
	}

	/// decode an int32 value for the given key.
	internal func decode(_ type:Int32.Type, forKey key:K) throws -> Int32 {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:Int32.Type, forKey:K)")
		defer {
			self.logger?.trace("exit: decode(_:Int32.Type, forKey:K)")
		}
		#endif
		
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("key not found: '\(key.stringValue)'")
			#endif
			throw Decoding.Error.notFound
		}
		#if QUICKJSON_SHOULDLOG
		return try getKeyRoot!.decodeInt32(logger:logger)
		#else
		return try getKeyRoot!.decodeInt32()
		#endif
	}

	/// decode an int64 value for the given key.
	internal func decode(_ type:Int64.Type, forKey key:K) throws -> Int64 {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:Int64.Type, forKey:K)")
		defer {
			self.logger?.trace("exit: decode(_:Int64.Type, forKey:K)")
		}
		#endif

		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("key not found: '\(key.stringValue)'")
			#endif
			throw Decoding.Error.notFound
		}
		#if QUICKJSON_SHOULDLOG
		return try getKeyRoot!.decodeInt64(logger:logger)
		#else
		return try getKeyRoot!.decodeInt64()
		#endif
	}

	/// decode a uint value for the given key.
	internal func decode(_ type:UInt.Type, forKey key:K) throws -> UInt {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:UInt.Type, forKey:K)")
		defer {
			self.logger?.trace("exit: decode(_:UInt.Type, forKey:K)")
		}
		#endif
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("key not found: '\(key.stringValue)'")
			#endif
			throw Decoding.Error.notFound
		}
		#if QUICKJSON_SHOULDLOG
		return try getKeyRoot!.decodeUInt(logger:logger)
		#else
		return try getKeyRoot!.decodeUInt()
		#endif
	}

	/// decode a uint8 value for the given key.
	internal func decode(_ type:UInt8.Type, forKey key:K) throws -> UInt8 {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:UInt8.Type, forKey:K)")
		defer {
			self.logger?.trace("exit: decode(_:UInt8.Type, forKey:K)")
		}
		#endif
		
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("key not found: '\(key.stringValue)'")
			#endif
			throw Decoding.Error.notFound
		}
		#if QUICKJSON_SHOULDLOG
		return try getKeyRoot!.decodeUInt8(logger:logger)
		#else
		return try getKeyRoot!.decodeUInt8()
		#endif
	}

	/// decode a uint16 value for the given key.
	internal func decode(_ type:UInt16.Type, forKey key:K) throws -> UInt16 {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:UInt16.Type, forKey:K)")
		defer {
			self.logger?.trace("exit: decode(_:UInt16.Type, forKey:K)")
		}
		#endif
		
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("key not found: '\(key.stringValue)'")
			#endif
			throw Decoding.Error.notFound
		}
		#if QUICKJSON_SHOULDLOG
		return try getKeyRoot!.decodeUInt16(logger:logger)
		#else
		return try getKeyRoot!.decodeUInt16()
		#endif
	}

	/// decode a uint32 value for the given key.
	internal func decode(_ type:UInt32.Type, forKey key:K) throws -> UInt32 {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:UInt32.Type, forKey:K)")
		defer {
			self.logger?.trace("exit: decode(_:UInt32.Type, forKey:K)")
		}
		#endif

		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("key not found: '\(key.stringValue)'")
			#endif
			throw Decoding.Error.notFound
		}
		#if QUICKJSON_SHOULDLOG
		return try getKeyRoot!.decodeUInt32(logger:logger)
		#else
		return try getKeyRoot!.decodeUInt32()
		#endif
	}

	/// decode a uint64 value for the given key.
	internal func decode(_ type:UInt64.Type, forKey key:K) throws -> UInt64 {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:UInt64.Type, forKey:K)")
		defer {
			self.logger?.trace("exit: decode(_:UInt64.Type, forKey:K)")
		}
		#endif

		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("key not found: '\(key.stringValue)'")
			#endif
			throw Decoding.Error.notFound
		}
		#if QUICKJSON_SHOULDLOG
		return try getKeyRoot!.decodeUInt64(logger:logger)
		#else
		return try getKeyRoot!.decodeUInt64()
		#endif
	}

	/// decode a decodable value type for a specified key.
	internal func decode<T>(_ type:T.Type, forKey key:K) throws -> T where T:Decodable {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode<T>(_:T.Type, forKey:K)")
		defer {
			self.logger?.trace("exit: decode<T>(_:T.Type, forKey:K)")
		}
		#endif
		
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("key not found: '\(key.stringValue)'")
			#endif
			throw Decoding.Error.notFound
		}

		#if QUICKJSON_SHOULDLOG
		return try T(from:decoder(root:getKeyRoot!, logger:logger))
		#else
		return try T(from:decoder(root:getKeyRoot!))
		#endif
	}

	/// decode a nested keyed container for a specified key.
	internal func nestedContainer<NestedKey>(keyedBy type:NestedKey.Type, forKey key:K) throws -> KeyedDecodingContainer<NestedKey> where NestedKey:CodingKey {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: nestedContainer<NestedKey>(keyedBy:NestedKey.Type, forKey:K)")
		defer {
			self.logger?.trace("exit: nestedContainer<NestedKey>(keyedBy:NestedKey.Type, forKey:K)")
		}
		#endif
		
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("key not found: '\(key.stringValue)'")
			#endif
			throw Decoding.Error.notFound
		}

		#if QUICKJSON_SHOULDLOG
		return KeyedDecodingContainer(try dc_keyed<NestedKey>(root:getKeyRoot!, logger:logger))
		#else
		return KeyedDecodingContainer(try dc_keyed<NestedKey>(root:getKeyRoot!))
		#endif
	}

	/// decode a nested unkeyed container for a specified key.
	internal func nestedUnkeyedContainer(forKey key:K) throws -> UnkeyedDecodingContainer {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: nestedUnkeyedContainer(forKey:K)")
		defer {
			self.logger?.trace("exit: nestedUnkeyedContainer(forKey:K)")
		}
		#endif
	
		let getKeyRoot = yyjson_obj_get(root, key.stringValue)
		guard getKeyRoot != nil else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("key not found: '\(key.stringValue)'")
			#endif
			throw Decoding.Error.notFound
		}

		#if QUICKJSON_SHOULDLOG
		return try dc_unkeyed(root:getKeyRoot!, logger:logger)
		#else
		return try dc_unkeyed(root:getKeyRoot!)
		#endif
	}

	// required by swift. unused.
	internal var allKeys:[K] {
		get {
			#if QUICKJSON_SHOULDLOG
			self.logger?.debug("enter: allKeys")
			defer {
				self.logger?.trace("exit: allKeys")
			}
			#endif

			var yyiter = yyjson_obj_iter()
			let initIter = yyjson_obj_iter_init(root, &yyiter)
			guard initIter == true else {
				#if QUICKJSON_SHOULDLOG
				self.logger?.error("failed to initialize iterator")
				#endif
				fatalError("could not initialize iterator")
			}
			var buildKeys = [K]()
			while yyjson_obj_iter_has_next(&yyiter) == true {
				let getKey = yyjson_obj_iter_next(&yyiter)!
				do {
					#if QUICKJSON_SHOULDLOG
					let getString = try getKey.decodeString(logger:nil)
					self.logger?.trace("found key '\(getString)'")
					#else
					let getString = try getKey.decodeString()
					#endif
					let buildKey = K(stringValue:getString)
					if buildKey != nil {
						buildKeys.append(buildKey!)
					}
				} catch {
					continue
				}
			}
			#if QUICKJSON_SHOULDLOG
			self.logger?.trace("returning \(buildKeys.count) items")
			#endif
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