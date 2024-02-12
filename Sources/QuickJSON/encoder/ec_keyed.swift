// (c) tanner silva 2023. all rights reserved.
import yyjson

#if QUICKJSON_SHOULDLOG
import Logging
#endif

internal struct ec_keyed<K>:Swift.KeyedEncodingContainerProtocol where K:CodingKey {
	internal typealias Key = K

	/// the document that this container is writing to
	private let doc:UnsafeMutablePointer<yyjson_mut_doc>
	/// the current keyed encoding container
	private let root:UnsafeMutablePointer<yyjson_mut_val>

	#if QUICKJSON_SHOULDLOG
	private let logger:Logger?
	/// initializes a new keyed container
	/// - parameter doc: the document that this container is writing to
	/// - parameter root: the root object of the json document. this is where the container will write its keys and values to.
	/// - parameter logger: the logging facility to use to diagnose actions taken by this object.
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>, root:UnsafeMutablePointer<yyjson_mut_val>, logger:Logging.Logger?) {
		let iid = UInt16.random(in:UInt16.min...UInt16.max)
		var buildLogger = logger
		buildLogger?[metadataKey: "iid"] = "\(iid)"
		buildLogger?[metadataKey:"type"] = "ec_keyed<\(String(describing:K.self))>"
		self.logger = buildLogger
		buildLogger?.debug("instance init")
		self.doc = doc
		self.root = root
	}
	#else
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>, root:UnsafeMutablePointer<yyjson_mut_val>) {
		self.doc = doc
		self.root = root
	}
	#endif

	/// encode a null value for the given key
	internal func encodeNil(forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: encodeNil(forKey:)")
		defer {
			self.logger?.trace("exit: encodeNil(forKey:)")
		}
		#endif
		let keyStringValue = key.stringValue
		let key = yyjson_mut_strncpy(doc, keyStringValue, keyStringValue.utf8.count)!
		let makeNull = yyjson_mut_null(doc)
		guard yyjson_mut_obj_put(root, key, makeNull) == true else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("unable to assign value")
			#endif
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a boolean value for the given key
	internal func encode(_ value:Bool, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: encode(_:Bool, forKey:)")
		defer {
			self.logger?.trace("exit: encode(_:Bool, forKey:)")
		}
		#endif
		let keyStringValue = key.stringValue
		let key = yyjson_mut_strncpy(doc, keyStringValue, keyStringValue.utf8.count)!
		let makeBool = yyjson_mut_bool(doc, value)
		guard yyjson_mut_obj_put(root, key, makeBool) == true else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("unable to assign value")
			#endif
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal func encode(_ value:String, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: encode(_:String, forKey:)")
		defer {
			self.logger?.trace("exit: encode(_:String, forKey:)")
		}
		#endif
		let keyStringValue = key.stringValue
		let key = yyjson_mut_strncpy(doc, keyStringValue, keyStringValue.utf8.count)!
		let makeString = yyjson_mut_strncpy(doc, value, value.utf8.count)
		guard yyjson_mut_obj_put(root, key, makeString) == true else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("unable to assign value")
			#endif
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a double value for the given key
	internal func encode(_ value:Double, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: encode(_:Double, forKey:)")
		defer {
			self.logger?.trace("exit: encode(_:Double, forKey:)")
		}
		#endif
		let keyStringValue = key.stringValue
		let key = yyjson_mut_strncpy(doc, keyStringValue, keyStringValue.utf8.count)!
		let makeDouble = yyjson_mut_real(doc, value)
		guard yyjson_mut_obj_put(root, key, makeDouble) == true else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("unable to assign value")
			#endif
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a float value for the given key
	internal func encode(_ value:Float, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: encode(_:Float, forKey:)")
		defer {
			self.logger?.trace("exit: encode(_:Float, forKey:)")
		}
		#endif
		let keyStringValue = key.stringValue
		let key = yyjson_mut_strncpy(doc, keyStringValue, keyStringValue.utf8.count)!
		let makeFloat = yyjson_mut_real(doc, Double(value))
		guard yyjson_mut_obj_put(root, key, makeFloat) == true else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("unable to assign value")
			#endif
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal func encode(_ value:Int, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: encode(_:Int, forKey:)")
		defer {
			self.logger?.trace("exit: encode(_:Int, forKey:)")
		}
		#endif
		let keyStringValue = key.stringValue
		let key = yyjson_mut_strncpy(doc, keyStringValue, keyStringValue.utf8.count)!
		let makeInt = yyjson_mut_int(doc, Int64(value))
		guard yyjson_mut_obj_put(root, key, makeInt) == true else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("unable to assign value")
			#endif
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal func encode(_ value:Int8, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: encode(_:Int8, forKey:)")
		defer {
			self.logger?.trace("exit: encode(_:Int8, forKey:)")
		}
		#endif
		let keyStringValue = key.stringValue
		let key = yyjson_mut_strncpy(doc, keyStringValue, keyStringValue.utf8.count)!
		let makeInt8 = yyjson_mut_int(doc, Int64(value))
		guard yyjson_mut_obj_put(root, key, makeInt8) == true else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("unable to assign value")
			#endif
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal func encode(_ value:Int16, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: encode(_:Int16, forKey:)")
		defer {
			self.logger?.trace("exit: encode(_:Int16, forKey:)")
		}
		#endif
		let keyStringValue = key.stringValue
		let key = yyjson_mut_strncpy(doc, keyStringValue, keyStringValue.utf8.count)!
		let makeInt16 = yyjson_mut_int(doc, Int64(value))
		guard yyjson_mut_obj_put(root, key, makeInt16) == true else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("unable to assign value")
			#endif
			throw Encoding.Error.assignmentError
		}

	}

	/// encode an integer value for the given key
	internal func encode(_ value:Int32, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: encode(_:Int32, forKey:)")
		defer {
			self.logger?.trace("exit: encode(_:Int32, forKey:)")
		}
		#endif
		let keyStringValue = key.stringValue
		let key = yyjson_mut_strncpy(doc, keyStringValue, keyStringValue.utf8.count)!
		let makeInt32 = yyjson_mut_int(doc, Int64(value))
		guard yyjson_mut_obj_put(root, key, makeInt32) == true else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("unable to assign value")
			#endif
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal func encode(_ value:Int64, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: encode(_:Int64, forKey:)")
		defer {
			self.logger?.trace("exit: encode(_:Int64, forKey:)")
		}
		#endif
		let keyStringValue = key.stringValue
		let key = yyjson_mut_strncpy(doc, keyStringValue, keyStringValue.utf8.count)!
		let makeInt64 = yyjson_mut_int(doc, Int64(value))
		guard yyjson_mut_obj_put(root, key, makeInt64) == true else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("unable to assign value")
			#endif
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal func encode(_ value:UInt, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: encode(_:UInt, forKey:)")
		defer {
			self.logger?.trace("exit: encode(_:UInt, forKey:)")
		}
		#endif
		let keyStringValue = key.stringValue
		let key = yyjson_mut_strncpy(doc, keyStringValue, keyStringValue.utf8.count)!
		let makeUInt = yyjson_mut_uint(doc, UInt64(value))
		guard yyjson_mut_obj_put(root, key, makeUInt) == true else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("unable to assign value")
			#endif
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal func encode(_ value:UInt8, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: encode(_:UInt8, forKey:)")
		defer {
			self.logger?.trace("exit: encode(_:UInt8, forKey:)")
		}
		#endif
		let keyStringValue = key.stringValue
		let key = yyjson_mut_strncpy(doc, keyStringValue, keyStringValue.utf8.count)!
		let makeUInt8 = yyjson_mut_uint(doc, UInt64(value))
		guard yyjson_mut_obj_put(root, key, makeUInt8) == true else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("unable to assign value")
			#endif
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal func encode(_ value:UInt16, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: encode(_:UInt16, forKey:)")
		defer {
			self.logger?.trace("exit: encode(_:UInt16, forKey:)")
		}
		#endif
		let keyStringValue = key.stringValue
		let key = yyjson_mut_strncpy(doc, keyStringValue, keyStringValue.utf8.count)!
		let makeUInt16 = yyjson_mut_uint(doc, UInt64(value))
		guard yyjson_mut_obj_put(root, key, makeUInt16) == true else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("unable to assign value")
			#endif
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal func encode(_ value:UInt32, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: encode(_:UInt32, forKey:)")
		defer {
			self.logger?.trace("exit: encode(_:UInt32, forKey:)")
		}
		#endif
		let keyStringValue = key.stringValue
		let key = yyjson_mut_strncpy(doc, keyStringValue, keyStringValue.utf8.count)!
		let makeUInt32 = yyjson_mut_uint(doc, UInt64(value))
		guard yyjson_mut_obj_put(root, key, makeUInt32) == true else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("unable to assign value")
			#endif	
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal func encode(_ value:UInt64, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: encode(_:UInt64, forKey:)")
		defer {
			self.logger?.trace("exit: encode(_:UInt64, forKey:)")
		}
		#endif
		let keyStringValue = key.stringValue
		let key = yyjson_mut_strncpy(doc, keyStringValue, keyStringValue.utf8.count)!
		let makeUInt64 = yyjson_mut_uint(doc, UInt64(value))
		guard yyjson_mut_obj_put(root, key, makeUInt64) == true else {
			#if QUICKJSON_SHOULDLOG
			self.logger?.error("unable to assign value")
			#endif
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a float value for the given key
	internal func encode<T>(_ value:T, forKey inputKey:K) throws where T:Encodable {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: encode<T>(_:T, forKey:) where T:Encodable")
		defer {
			self.logger?.trace("exit: encode<T>(_:T, forKey:) where T:Encodable")
		}
		#endif
		let keyStringValue = inputKey.stringValue
		let key = yyjson_mut_strncpy(doc, keyStringValue, keyStringValue.utf8.count)!
		#if QUICKJSON_SHOULDLOG
		try value.encode(to:encoder_from_keyed_container(doc:doc, obj:root, assignKey:key, codingPath:codingPath + [inputKey], logger:logger))
		#else
		try value.encode(to:encoder_from_keyed_container(doc:doc, obj:root, assignKey:key, codingPath:codingPath + [inputKey]))
		#endif
	}

	/// returns a keyed container for the given key
	internal func nestedContainer<NestedKey>(keyedBy keyType:NestedKey.Type, forKey inputKey:K) -> KeyedEncodingContainer<NestedKey> where NestedKey :CodingKey {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: nestedContainer<\(String(describing:NestedKey.self))>(keyedBy:\(String(describing:NestedKey.self)), forKey:)")
		defer {
			self.logger?.trace("exit: nestedContainer(keyedBy:\(String(describing:NestedKey.self)), forKey:)")
		}
		#endif
		
		// make the key
		let keyStringValue = inputKey.stringValue
		let key = yyjson_mut_strncpy(doc, keyStringValue, keyStringValue.utf8.count)
		
		// make a new object and assign it with the key
		let makeNestedKeyedContainer = yyjson_mut_obj(doc)!
		
		#if DEBUG
		assert(yyjson_mut_obj_put(root, key, makeNestedKeyedContainer) == true)
		#else
		_ = yyjson_mut_obj_put(root, key, makeNestedKeyedContainer)
		#endif
		
		// return
		#if QUICKJSON_SHOULDLOG
		return KeyedEncodingContainer(ec_keyed<NestedKey>(doc:doc, root:makeNestedKeyedContainer, logger:logger))
		#else
		return KeyedEncodingContainer(ec_keyed<NestedKey>(doc:doc, root:makeNestedKeyedContainer))
		#endif
	}

	/// returns an unkeyed container for the given key
	internal func nestedUnkeyedContainer(forKey inputKey:K) -> UnkeyedEncodingContainer {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: nestedUnkeyedContainer(forKey:)")
		defer {
			self.logger?.trace("exit: nestedUnkeyedContainer(forKey:)")
		}
		#endif
		
		// make the key
		let keyStringValue = inputKey.stringValue
		let key = yyjson_mut_strncpy(doc, keyStringValue, keyStringValue.utf8.count)!
		
		// make a new object and assign it with the key
		let makeNestedUnkeyedContainer = yyjson_mut_arr(doc)!
		
		#if DEBUG
		assert(yyjson_mut_obj_put(root, key, makeNestedUnkeyedContainer) == true)
		#else
		_ = yyjson_mut_obj_put(root, key, makeNestedUnkeyedContainer)
		#endif
		
		// return
		#if QUICKJSON_SHOULDLOG
		return ec_unkeyed(doc:doc, root:makeNestedUnkeyedContainer, logger:logger)
		#else
		return ec_unkeyed(doc:doc, root:makeNestedUnkeyedContainer)
		#endif
	}
	
	// required by swift. unimplemented
	internal func superEncoder(forKey key:K) -> Swift.Encoder {
		fatalError("unimplemented")
	}
	internal func superEncoder() -> Swift.Encoder {
		fatalError("unimplemented")
	}
	internal var codingPath:[CodingKey] {
		get {
			return []
		}
	}
}

