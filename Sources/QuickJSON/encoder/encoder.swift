// (c) tanner silva 2023-2025. all rights reserved.
import yyjson

#if QUICKJSON_SHOULDLOG
import Logging
#endif

/// encoder from root
internal struct encoder_from_root:Swift.Encoder {
	/// the root object of the json document
	private let doc:UnsafeMutablePointer<yyjson_mut_doc>
	#if QUICKJSON_SHOULDLOG
	private let logger:Logger
	#endif
	/// initialize the encoder from the root object
	/// - pararmeter doc: the root object of the json document
	/// - pararmeter logLevel: the log level to use for this encoder
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>) {
		#if QUICKJSON_SHOULDLOG
		let iid = UInt16.random(in:UInt16.min...UInt16.max)
		var buildLogger = Encoding.logger
		buildLogger[metadataKey: "iid"] = "\(iid)"
		buildLogger[metadataKey:"doc"] = "\(doc.hashValue)"
		self.logger = buildLogger
		buildLogger.debug("enter: \(String(describing:Self.self)) : \(#function)")
		defer {
			buildLogger.trace("exit: \(String(describing:Self.self)) : \(#function)")
		}
		#endif
		self.doc = doc
	}

	/// retrieve a keyed container for this encoder
	internal func container<Key>(keyedBy type:Key.Type) -> KeyedEncodingContainer<Key> where Key:CodingKey {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function)", metadata:["keyedBy_arg":"\(String(describing:type))"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function)", metadata:["keyedBy_arg":"\(String(describing:type))"])
		}
		#endif
		let getObject = yyjson_mut_obj(doc)!
		yyjson_mut_doc_set_root(doc, getObject)
		return KeyedEncodingContainer(ec_keyed(doc:doc, root:getObject))
	}

	/// retrieve a unkeyed container for this encoder
	internal func unkeyedContainer() -> UnkeyedEncodingContainer {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function)")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function)")
		}
		#endif
		let getObject = yyjson_mut_arr(doc)!
		yyjson_mut_doc_set_root(doc, getObject)
		return ec_unkeyed(doc:doc, root:getObject)
	}

	/// retrieve the single value container for this encoder
	internal func singleValueContainer() -> SingleValueEncodingContainer {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function)")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function)")
		}
		#endif
		return ec_single_from_root(doc:doc)
	}

	// required by swift. unused.
	internal var userInfo:[CodingUserInfoKey:Any] {
		get {
			return [:]
		}
	}
	// required by swift. unused.
	internal var codingPath:[CodingKey] {
		get {
			return []
		}
	}
}

/// encoder from unkeyed container
internal struct encoder_from_unkeyed_container:Swift.Encoder {
	private let doc:UnsafeMutablePointer<yyjson_mut_doc>
	private let arr:UnsafeMutablePointer<yyjson_mut_val>
	#if QUICKJSON_SHOULDLOG
	private let logger:Logger
	#endif
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>, arr:UnsafeMutablePointer<yyjson_mut_val>) {
		#if QUICKJSON_SHOULDLOG
		let iid = UInt16.random(in:UInt16.min...UInt16.max)
		var buildLogger = Encoding.logger
		buildLogger[metadataKey: "iid"] = "\(iid)"
		buildLogger[metadataKey:"doc"] = "\(doc.hashValue)"
		buildLogger[metadataKey:"arr"] = "\(arr.hashValue)"
		self.logger = buildLogger
		buildLogger.debug("enter: \(String(describing:Self.self)) : \(#function)")
		defer {
			buildLogger.trace("exit: \(String(describing:Self.self)) : \(#function)")
		}
		#endif
		self.doc = doc
		self.arr = arr
	}

	/// retrieve a keyed container for this encoder
	internal func container<Key>(keyedBy type:Key.Type) -> KeyedEncodingContainer<Key> where Key :CodingKey {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(#function)", metadata:["keyedBy_arg":"\(String(describing:type))"])
		defer {
			logger.trace("exit: \(#function)", metadata:["keyedBy_arg":"\(String(describing:type))"])
		}
		#endif
		let newObject = yyjson_mut_obj(doc)!
		yyjson_mut_arr_append(arr, newObject)
		return KeyedEncodingContainer(ec_keyed(doc:doc, root:newObject))
	}

	/// retrieve an unkeyed container for this encoder
	internal func unkeyedContainer() -> UnkeyedEncodingContainer {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(#function)")
		defer {
			logger.trace("exit: \(#function)")
		}
		#endif
		let newObject = yyjson_mut_arr(doc)!
		yyjson_mut_arr_append(arr, newObject)
		return ec_unkeyed(doc:doc, root:newObject)
	}

	/// retrieve the single value container for this encoder
	internal func singleValueContainer() -> SingleValueEncodingContainer {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(#function)")
		defer {
			logger.trace("exit: \(#function)")
		}
		#endif
		return ec_single_from_unkeyed_container(doc:doc, arr:arr, codingPath:[])
	}

	// required by swift. unused.
	internal var userInfo:[CodingUserInfoKey:Any] {
		get {
			return [:]
		}
	}
	// required by swift. unused.
	internal var codingPath:[CodingKey] {
		get {
			return []
		}
	}
}

/// encoder from keyed container
internal struct encoder_from_keyed_container:Swift.Encoder {
	private let doc:UnsafeMutablePointer<yyjson_mut_doc>
	private let obj:UnsafeMutablePointer<yyjson_mut_val>
	private let assignKey:UnsafeMutablePointer<yyjson_mut_val>
	#if QUICKJSON_SHOULDLOG
	private let logger:Logger
	#endif
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>, obj:UnsafeMutablePointer<yyjson_mut_val>, assignKey:UnsafeMutablePointer<yyjson_mut_val>, codingPath:[CodingKey]) {
		#if QUICKJSON_SHOULDLOG
		let iid = UInt16.random(in:UInt16.min...UInt16.max)
		var buildLogger = Encoding.logger
		buildLogger[metadataKey: "iid"] = "\(iid)"
		buildLogger[metadataKey:"doc"] = "\(doc.hashValue)"
		buildLogger[metadataKey:"obj"] = "\(obj.hashValue)"
		buildLogger[metadataKey:"assignKey"] = "\(assignKey.stringValue)"
		self.logger = buildLogger
		buildLogger.debug("enter: \(String(describing:Self.self)) : \(#function)")
		defer {
			buildLogger.trace("exit: \(String(describing:Self.self)) : \(#function)")
		}
		#endif
		self.doc = doc
		self.obj = obj
		self.assignKey = assignKey
	}

	/// retrieve a keyed container for this encoder
	internal func container<Key>(keyedBy type:Key.Type) -> KeyedEncodingContainer<Key> where Key:CodingKey {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function))", metadata:["keyedBy_arg":"\(String(describing:type))"])
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function)", metadata:["keyedBy_arg":"\(String(describing:type))"])
		}
		#endif
		let newObject = yyjson_mut_obj(doc)!
		yyjson_mut_obj_put(obj, assignKey, newObject)
		return KeyedEncodingContainer(ec_keyed(doc:doc, root:newObject))
	}

	/// retrieve an unkeyed container for this encoder
	internal func unkeyedContainer() -> UnkeyedEncodingContainer {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function)")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function)")
		}
		#endif
		let newObject = yyjson_mut_arr(doc)!
		yyjson_mut_obj_put(obj, assignKey, newObject)
		return ec_unkeyed(doc:doc, root:newObject)
	}

	/// retrieve the single value container for this encoder
	internal func singleValueContainer() -> SingleValueEncodingContainer {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function)")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function)")
		}
		#endif
		return ec_single_from_keyed_container(doc:doc, obj:obj, assignKey:assignKey, codingPath:[])
	}


	// required by swift. unused.
	internal var codingPath:[CodingKey] {
		get {
			return []
		}
	}
	// required by swift. unused.
	internal var userInfo:[CodingUserInfoKey:Any] {
		get {
			return [:]
		}
	}
}