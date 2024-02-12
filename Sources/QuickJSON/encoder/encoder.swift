// (c) tanner silva 2023. all rights reserved.
import yyjson

#if QUICKJSON_SHOULDLOG
import Logging
#endif

/// encoder from root.
internal struct encoder_from_root:Swift.Encoder {
	/// the root object of the json document
	private let doc:UnsafeMutablePointer<yyjson_mut_doc>

	#if QUICKJSON_SHOULDLOG
	private let logger:Logger?
	/// initialize the encoder from the root object
	/// - pararmeter doc: the root object of the json document
	/// - pararmeter logLevel: the log level to use for this encoder
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>, logger:Logging.Logger?) {
		let iid = UInt16.random(in:UInt16.min...UInt16.max)
		var mutateLogger = logger
		mutateLogger?[metadataKey: "iid"] = "\(iid)"
		mutateLogger?[metadataKey: "type"] = "encoder_from_root"
		mutateLogger?.debug("instance init")
		self.logger = mutateLogger
		self.doc = doc
	}
	#else
	/// initialize the encoder from the root object
	/// - pararmeter doc: the root object of the json document
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>) {
		self.doc = doc
	}
	#endif

	/// retrieve a keyed container for this encoder
	internal func container<Key>(keyedBy type:Key.Type) -> KeyedEncodingContainer<Key> where Key:CodingKey {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: container<Key>(keyedBy:)")
		defer {
			self.logger?.trace("exit: container<Key>(keyedBy:)")
		}
		#endif

		let getObject = yyjson_mut_obj(doc)!
		yyjson_mut_doc_set_root(doc, getObject)

		#if QUICKJSON_SHOULDLOG
		return KeyedEncodingContainer(ec_keyed(doc:doc, root:getObject, logger:logger))
		#else
		return KeyedEncodingContainer(ec_keyed(doc:doc, root:getObject))
		#endif
	}

	/// retrieve a unkeyed container for this encoder
	internal func unkeyedContainer() -> UnkeyedEncodingContainer {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: unkeyedContainer()")
		defer {
			self.logger?.trace("exit: unkeyedContainer()")
		}
		#endif

		let getObject = yyjson_mut_arr(doc)!
		yyjson_mut_doc_set_root(doc, getObject)

		#if QUICKJSON_SHOULDLOG
		return ec_unkeyed(doc:doc, root:getObject, logger:logger)
		#else
		return ec_unkeyed(doc:doc, root:getObject)
		#endif
	}

	/// retrieve the single value container for this encoder
	internal func singleValueContainer() -> SingleValueEncodingContainer {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: singleValueContainer()")
		defer {
			self.logger?.trace("exit: singleValueContainer()")
		}
		#endif

		#if QUICKJSON_SHOULDLOG
		return ec_single_from_root(doc:doc, logger:logger)
		#else
		return ec_single_from_root(doc:doc)
		#endif
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
	private let logLevel:Logging.Logger.Level
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>, arr:UnsafeMutablePointer<yyjson_mut_val>, logger:Logging.Logger?) {
		let iid = UInt16.random(in:UInt16.min...UInt16.max)
		var buildLogger = logger
		buildLogger?[metadataKey:"iid"] = "\(iid)"
		buildLogger?[metadataKey:"type"] = "encoder_from_unkeyed_container"
		self.logger = buildLogger
		buildLogger?.debug("instance init")
		self.doc = doc
		self.arr = arr
	}
	#else
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>, arr:UnsafeMutablePointer<yyjson_mut_val>) {
		self.doc = doc
		self.arr = arr
	}
	#endif

	/// retrieve a keyed container for this encoder
	internal func container<Key>(keyedBy type:Key.Type) -> KeyedEncodingContainer<Key> where Key :CodingKey {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: container<Key>(keyedBy:)")
		defer {
			self.logger?.trace("exit: container<Key>(keyedBy:)")
		}
		#endif

		// create the new key-value container
		let newObject = yyjson_mut_obj(doc)!
		// append the container to the parent
		yyjson_mut_arr_append(arr, newObject)

		#if QUICKJSON_SHOULDLOG
		return KeyedEncodingContainer(ec_keyed(doc:doc, root:newObject, logger:logger))
		#else
		return KeyedEncodingContainer(ec_keyed(doc:doc, root:newObject))
		#endif
	}

	/// retrieve an unkeyed container for this encoder
	internal func unkeyedContainer() -> UnkeyedEncodingContainer {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: unkeyedContainer()")
		defer {
			self.logger?.trace("exit: unkeyedContainer()")
		}
		#endif

		// create the array container
		let newObject = yyjson_mut_arr(doc)!
		// append the container to the parent
		yyjson_mut_arr_append(arr, newObject)

		#if QUICKJSON_SHOULDLOG
		return ec_unkeyed(doc:doc, root:newObject, logger:logger)
		#else
		return ec_unkeyed(doc:doc, root:newObject)
		#endif
	}

	/// retrieve the single value container for this encoder
	internal func singleValueContainer() -> SingleValueEncodingContainer {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: singleValueContainer()")
		defer {
			self.logger?.trace("exit: singleValueContainer()")
		}
		return ec_single_from_unkeyed_container(doc:doc, arr:arr, codingPath:[], logger:logger)
		#else
		return ec_single_from_unkeyed_container(doc:doc, arr:arr, codingPath:[])
		#endif
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
	private let logger:Logger?
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>, obj:UnsafeMutablePointer<yyjson_mut_val>, assignKey:UnsafeMutablePointer<yyjson_mut_val>, codingPath:[CodingKey], logger:Logging.Logger?) {
		let iid = UInt16.random(in:UInt16.min...UInt16.max)
		var buildLogger = logger
		buildLogger?[metadataKey:"iid"] = "\(iid)"
		buildLogger?[metadataKey:"type"] = "encoder_from_keyed_container"
		self.logger = buildLogger
		buildLogger?.debug("instance init")
		self.doc = doc
		self.obj = obj
		self.assignKey = assignKey
	}
	#else
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>, obj:UnsafeMutablePointer<yyjson_mut_val>, assignKey:UnsafeMutablePointer<yyjson_mut_val>, codingPath:[CodingKey]) {
		self.doc = doc
		self.obj = obj
		self.assignKey = assignKey
	}
	#endif

	/// retrieve a keyed container for this encoder
	internal func container<Key>(keyedBy type:Key.Type) -> KeyedEncodingContainer<Key> where Key:CodingKey {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: container<Key>(keyedBy:)")
		defer {
			self.logger?.trace("exit: container<Key>(keyedBy:)")
		}
		#endif

		// create the new key-value container
		let newObject = yyjson_mut_obj(doc)!

		// append the container to the parent
		yyjson_mut_obj_put(obj, assignKey, newObject)

		#if QUICKJSON_SHOULDLOG
		return KeyedEncodingContainer(ec_keyed(doc:doc, root:newObject, logger:logger))
		#else
		return KeyedEncodingContainer(ec_keyed(doc:doc, root:newObject))
		#endif
	}

	/// retrieve an unkeyed container for this encoder
	internal func unkeyedContainer() -> UnkeyedEncodingContainer {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: unkeyedContainer()")
		defer {
			self.logger?.trace("exit: unkeyedContainer()")
		}
		#endif

		// create the array container
		let newObject = yyjson_mut_arr(doc)!

		// append the container to the parent
		yyjson_mut_obj_put(obj, assignKey, newObject)

		#if QUICKJSON_SHOULDLOG
		return ec_unkeyed(doc:doc, root:newObject, logger:logger)
		#else
		return ec_unkeyed(doc:doc, root:newObject)
		#endif
	}

	/// retrieve the single value container for this encoder
	internal func singleValueContainer() -> SingleValueEncodingContainer {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: singleValueContainer()")
		defer {
			self.logger?.trace("exit: singleValueContainer()")
		}
		#endif
		
		#if QUICKJSON_SHOULDLOG
		return ec_single_from_keyed_container(doc:doc, obj:obj, assignKey:assignKey, codingPath:[], logger:logger)
		#else
		return ec_single_from_keyed_container(doc:doc, obj:obj, assignKey:assignKey, codingPath: [])
		#endif
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