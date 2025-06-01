// (c) tanner silva 2023-2025. all rights reserved.
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
	private let logger:Logger
	#endif

	/// initializes a new keyed container
	/// - parameter doc: the document that this container is writing to
	/// - parameter root: the root object of the json document. this is where the container will write its keys and values to.
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>, root:UnsafeMutablePointer<yyjson_mut_val>) {
		#if QUICKJSON_SHOULDLOG
		let iid = UInt16.random(in:UInt16.min...UInt16.max)
		var buildLogger = Encoding.logger
		buildLogger[metadataKey: "iid"] = "\(iid)"
		buildLogger[metadataKey: "doc"] = "\(doc.hashValue)"
		buildLogger[metadataKey: "root"] = "\(root.hashValue)"
		self.logger = buildLogger
		buildLogger.debug("enter: \(String(describing:Self.self)) : \(#function)")
		defer {
			buildLogger.trace("exit: \(String(describing:Self.self)) : \(#function)")
		}
		#endif
		self.doc = doc
		self.root = root
	}


	/// encode a null value for the given key
	internal borrowing func encodeNil(forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function)", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function)", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		guard yyjson_mut_obj_put(root, yyjson_mut_strncpy(doc, key.stringValue, key.stringValue.utf8.count)!, yyjson_mut_null(doc)!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a boolean value for the given key
	internal borrowing func encode(_ value:Bool, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		guard yyjson_mut_obj_put(root, yyjson_mut_strncpy(doc, key.stringValue, key.stringValue.utf8.count)!, yyjson_mut_bool(doc, value)!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal borrowing func encode(_ value:String, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		guard yyjson_mut_obj_put(root, yyjson_mut_strncpy(doc, key.stringValue, key.stringValue.utf8.count)!, yyjson_mut_strncpy(doc, value, value.utf8.count)!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a double value for the given key
	internal borrowing func encode(_ value:Double, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		guard yyjson_mut_obj_put(root, yyjson_mut_strncpy(doc, key.stringValue, key.stringValue.utf8.count)!, yyjson_mut_real(doc, value)!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a float value for the given key
	internal borrowing func encode(_ value:Float, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif

		guard yyjson_mut_obj_put(root, yyjson_mut_strncpy(doc, key.stringValue, key.stringValue.utf8.count)!, yyjson_mut_real(doc, Double(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal borrowing func encode(_ value:Int, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		guard yyjson_mut_obj_put(root, yyjson_mut_strncpy(doc, key.stringValue, key.stringValue.utf8.count)!, yyjson_mut_int(doc, Int64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal borrowing func encode(_ value:Int8, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		guard yyjson_mut_obj_put(root, yyjson_mut_strncpy(doc, key.stringValue, key.stringValue.utf8.count)!, yyjson_mut_int(doc, Int64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal borrowing func encode(_ value:Int16, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		guard yyjson_mut_obj_put(root, yyjson_mut_strncpy(doc, key.stringValue, key.stringValue.utf8.count)!, yyjson_mut_int(doc, Int64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal borrowing func encode(_ value:Int32, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		guard yyjson_mut_obj_put(root, yyjson_mut_strncpy(doc, key.stringValue, key.stringValue.utf8.count)!, yyjson_mut_int(doc, Int64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal borrowing func encode(_ value:Int64, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		guard yyjson_mut_obj_put(root, yyjson_mut_strncpy(doc, key.stringValue, key.stringValue.utf8.count)!, yyjson_mut_int(doc, Int64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal borrowing func encode(_ value:UInt, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		guard yyjson_mut_obj_put(root, yyjson_mut_strncpy(doc, key.stringValue, key.stringValue.utf8.count)!, yyjson_mut_uint(doc, UInt64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal borrowing func encode(_ value:UInt8, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		guard yyjson_mut_obj_put(root, yyjson_mut_strncpy(doc, key.stringValue, key.stringValue.utf8.count)!, yyjson_mut_uint(doc, UInt64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal borrowing func encode(_ value:UInt16, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		guard yyjson_mut_obj_put(root, yyjson_mut_strncpy(doc, key.stringValue, key.stringValue.utf8.count)!, yyjson_mut_uint(doc, UInt64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal borrowing func encode(_ value:UInt32, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		guard yyjson_mut_obj_put(root, yyjson_mut_strncpy(doc, key.stringValue, key.stringValue.utf8.count)!, yyjson_mut_uint(doc, UInt64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal borrowing func encode(_ value:UInt64, forKey key:K) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		guard yyjson_mut_obj_put(root, yyjson_mut_strncpy(doc, key.stringValue, key.stringValue.utf8.count)!, yyjson_mut_uint(doc, UInt64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an encodable value for the given key
	internal borrowing func encode<T>(_ value:T, forKey key:K) throws where T:Encodable {
		let ik = key
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		try value.encode(to:encoder_from_keyed_container(doc:doc, obj:root, assignKey:yyjson_mut_strncpy(doc, ik.stringValue, ik.stringValue.utf8.count)!, codingPath:codingPath + [ik]))
	}

	/// returns a keyed container for the given key
	internal borrowing func nestedContainer<NestedKey>(keyedBy keyType:NestedKey.Type, forKey key:K) -> KeyedEncodingContainer<NestedKey> where NestedKey :CodingKey {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function)", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function)", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		let newObj = yyjson_mut_obj(doc)!
		guard yyjson_mut_obj_put(root, yyjson_mut_strncpy(doc, key.stringValue, key.stringValue.utf8.count)!, newObj) == true else {
			fatalError("QuickJSON encoding error: could not put keyed container into root. this is an internal and fatal error. \(#file):\(#line) \(#function)")
		}
		return KeyedEncodingContainer(ec_keyed<NestedKey>(doc:doc, root:newObj))
	}

	/// returns an unkeyed container for the given key
	internal borrowing func nestedUnkeyedContainer(forKey key:K) -> UnkeyedEncodingContainer {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function)", metadata:["forKey_arg":"\(key.stringValue)"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function)", metadata:["forKey_arg":"\(key.stringValue)"])
		}
		#endif
		let makeNestedUnkeyedContainer = yyjson_mut_arr(doc)!
		guard yyjson_mut_obj_put(root, yyjson_mut_strncpy(doc, key.stringValue, key.stringValue.utf8.count)!, makeNestedUnkeyedContainer) == true else {
			fatalError("QuickJSON encoding error: could not put unkeyed container into root. this is an internal and fatal error. \(#file):\(#line) \(#function)")
		}
		return ec_unkeyed(doc:doc, root:makeNestedUnkeyedContainer)
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

