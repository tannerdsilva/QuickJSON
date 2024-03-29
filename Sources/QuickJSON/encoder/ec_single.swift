// (c) tanner silva 2023. all rights reserved.
import yyjson

#if QUICKJSON_SHOULDLOG
import Logging
#endif

/// an encoding container designed specifically for encoding single values into an unkeyed container.
internal struct ec_single_from_unkeyed_container:Swift.SingleValueEncodingContainer {
	private let doc:UnsafeMutablePointer<yyjson_mut_doc>
	private let arr:UnsafeMutablePointer<yyjson_mut_val>

	#if QUICKJSON_SHOULDLOG
	private let logger:Logger
	private let logLevel:Logging.Logger.Level
	/// initialize a new single value container from an unkeyed parent.
	/// - parameter doc: the document this container belongs to
	/// - parameter arr: the array this container will assign values to
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>, arr:UnsafeMutablePointer<yyjson_mut_val>, codingPath:[CodingKey], logLevel:Logging.Logger.Level = .critical) {
		let iid = UInt16.random(in:UInt16.min...UInt16.max)
		var buildLogger = Encoding.logger
		buildLogger[metadataKey: "iid"] = "\(iid)"
		buildLogger.logLevel = logLevel
		self.logger = buildLogger
		self.logLevel = logLevel
		buildLogger.debug("enter: ec_single_from_unkeyed_container.init(doc:arr:codingPath:)")
		defer {
			buildLogger.trace("exit: ec_single_from_unkeyed_container.init(doc:arr:codingPath:)")
		}
		self.doc = doc
		self.arr = arr
	}
	#else
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>, arr:UnsafeMutablePointer<yyjson_mut_val>, codingPath:[CodingKey]) {
		self.doc = doc
		self.arr = arr
	}
	#endif

	/// encode a nil value
	internal func encodeNil() throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_unkeyed_container.encodeNil()")
		defer {
			self.logger.trace("exit: ec_single_from_unkeyed_container.encodeNil()")
		}
		#endif

		let nilVal = yyjson_mut_null(doc)
		guard nilVal != nil else {
			throw Encoding.Error.assignmentError
		}
		yyjson_mut_arr_append(arr, nilVal)
	}

	/// encode a bool value
	internal func encode(_ value:Bool) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_unkeyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_unkeyed_container.encode(_:)")
		}
		#endif
		
		let boolVal = yyjson_mut_bool(doc, value)
		guard boolVal != nil else {
			throw Encoding.Error.assignmentError
		}
		yyjson_mut_arr_append(arr, boolVal)
	}

	/// encode a string value
	internal func encode(_ value:String) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_unkeyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_unkeyed_container.encode(_:)")
		}
		#endif
		
		let stringVal = yyjson_mut_strncpy(doc, value, value.utf8.count)
		guard stringVal != nil else {
			throw Encoding.Error.assignmentError
		}
		yyjson_mut_arr_append(arr, stringVal)
	}

	/// encode a double value
	internal func encode(_ value:Double) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_unkeyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_unkeyed_container.encode(_:)")
		}
		#endif
		let doubleVal = yyjson_mut_real(doc, value)
		guard doubleVal != nil else {
			throw Encoding.Error.assignmentError
		}
		yyjson_mut_arr_append(arr, doubleVal)
	}

	/// encode a float value
	internal func encode(_ value:Float) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_unkeyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_unkeyed_container.encode(_:)")
		}
		#endif
		
		let floatVal = yyjson_mut_real(doc, Double(value))
		guard floatVal != nil else {
			throw Encoding.Error.assignmentError
		}
		yyjson_mut_arr_append(arr, floatVal)
	}

	/// encode an int value
	internal func encode(_ value:Int) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_unkeyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_unkeyed_container.encode(_:)")
		}
		#endif

		let intVal = yyjson_mut_int(doc, Int64(value))
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		yyjson_mut_arr_append(arr, intVal)
	}

	/// encode an int8 value
	internal func encode(_ value:Int8) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_unkeyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_unkeyed_container.encode(_:)")
		}
		#endif

		let intVal = yyjson_mut_int(doc, Int64(value))
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		yyjson_mut_arr_append(arr, intVal)
	}

	/// encode an int16 value
	internal func encode(_ value:Int16) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_unkeyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_unkeyed_container.encode(_:)")
		}
		#endif
		
		let intVal = yyjson_mut_int(doc, Int64(value))
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		yyjson_mut_arr_append(arr, intVal)
	}

	/// encode an int32 value
	internal func encode(_ value:Int32) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_unkeyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_unkeyed_container.encode(_:)")
		}
		#endif

		let intVal = yyjson_mut_int(doc, Int64(value))
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		yyjson_mut_arr_append(arr, intVal)
	}

	/// encode an int64 value
	internal func encode(_ value:Int64) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_unkeyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_unkeyed_container.encode(_:)")
		}
		#endif

		let intVal = yyjson_mut_int(doc, value)
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		yyjson_mut_arr_append(arr, intVal)
	}

	/// encode a uint value
	internal func encode(_ value:UInt) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_unkeyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_unkeyed_container.encode(_:)")
		}
		#endif

		let intVal = yyjson_mut_uint(doc, UInt64(value))
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		yyjson_mut_arr_append(arr, intVal)
	}

	/// encode a uint8 value
	internal func encode(_ value:UInt8) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_unkeyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_unkeyed_container.encode(_:)")
		}
		#endif

		let intVal = yyjson_mut_uint(doc, UInt64(value))
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		yyjson_mut_arr_append(arr, intVal)
	}

	/// encode a uint16 value
	internal func encode(_ value:UInt16) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_unkeyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_unkeyed_container.encode(_:)")
		}
		#endif

		let intVal = yyjson_mut_uint(doc, UInt64(value))
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		yyjson_mut_arr_append(arr, intVal)
	}

	/// encode a uint32 value
	internal func encode(_ value:UInt32) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_unkeyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_unkeyed_container.encode(_:)")
		}
		#endif

		let intVal = yyjson_mut_uint(doc, UInt64(value))
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		yyjson_mut_arr_append(arr, intVal)
	}

	/// encode a uint64 value
	internal func encode(_ value:UInt64) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_unkeyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_unkeyed_container.encode(_:)")
		}
		#endif

		let intVal = yyjson_mut_uint(doc, value)
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		yyjson_mut_arr_append(arr, intVal)
	}

	/// encode an encodable value
	internal func encode<T>(_ value:T) throws where T:Encodable {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_unkeyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_unkeyed_container.encode(_:)")
		}
		try value.encode(to:encoder_from_unkeyed_container(doc:doc, arr:arr, logLevel:self.logLevel))
		#else
		try value.encode(to:encoder_from_unkeyed_container(doc:doc, arr:arr))
		#endif
	}

	// required by swift. unused.
	internal var codingPath:[CodingKey] {
		get {
			return []
		}
	}
}

// a single value encoding container that is meant specifically for encoding single values and their keys into a keyed encoding container.
internal struct ec_single_from_keyed_container:Swift.SingleValueEncodingContainer {
	private let doc:UnsafeMutablePointer<yyjson_mut_doc>
	private let obj:UnsafeMutablePointer<yyjson_mut_val>
	private let assignKey:UnsafeMutablePointer<yyjson_mut_val>


	#if QUICKJSON_SHOULDLOG
	private let logger:Logger
	private let logLevel:Logging.Logger.Level
	/// initialize a new single value container that will assign a value to a parent object.
	/// - parameter doc: the document to encode into
	/// - parameter obj: the object to encode into
	/// - parameter assignKey: the key to use to assign the single value to the parent object after it is encoded
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>, obj:UnsafeMutablePointer<yyjson_mut_val>, assignKey:UnsafeMutablePointer<yyjson_mut_val>, codingPath:[CodingKey], logLevel:Logging.Logger.Level = .critical) {
		let iid = UInt16.random(in:UInt16.min...UInt16.max)
		var buildLogger = Encoding.logger
		buildLogger[metadataKey: "iid"] = "\(iid)"
		buildLogger.logLevel = logLevel
		self.logger = buildLogger
		self.logLevel = logLevel
		buildLogger.debug("enter: ec_single_from_keyed_container.init()")
		defer {
			buildLogger.trace("exit: ec_single_from_keyed_container.init()")
		}
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

	/// encode a nil value
	internal func encodeNil() throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_keyed_container.encodeNil()")
		defer {
			self.logger.trace("exit: ec_single_from_keyed_container.encodeNil()")
		}
		#endif

		// create the new value
		let newVal = yyjson_mut_null(doc)
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}

		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a bool value
	internal func encode(_ value:Bool) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_keyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_keyed_container.encode(_:)")
		}
		#endif

		// create the new value
		let newVal = yyjson_mut_bool(doc, value)
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}

		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a string value
	internal func encode(_ value:String) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_keyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_keyed_container.encode(_:)")
		}
		#endif

		// create the new value
		let stringVal = yyjson_mut_strncpy(doc, value, value.utf8.count)
		guard stringVal != nil else {
			throw Encoding.Error.assignmentError
		}
		
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, stringVal) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a double value
	internal func encode(_ value:Double) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_keyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_keyed_container.encode(_:)")
		}
		#endif

		// create the new value
		let doubleVal = yyjson_mut_real(doc, value)
		guard doubleVal != nil else {
			throw Encoding.Error.assignmentError
		}
		
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, doubleVal) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a float value
	internal func encode(_ value:Float) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_keyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_keyed_container.encode(_:)")
		}
		#endif

		// create the new value
		let floatVal = yyjson_mut_real(doc, Double(value))
		guard floatVal != nil else {
			throw Encoding.Error.assignmentError
		}
		
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, floatVal) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a int value
	internal func encode(_ value:Int) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_keyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_keyed_container.encode(_:)")
		}
		#endif

		// create the new value
		let intVal = yyjson_mut_int(doc, Int64(value))
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, intVal) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a int8 value
	internal func encode(_ value:Int8) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_keyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_keyed_container.encode(_:)")
		}
		#endif

		// create the new value
		let intVal = yyjson_mut_int(doc, Int64(value))
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, intVal) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a int16 value
	internal func encode(_ value:Int16) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_keyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_keyed_container.encode(_:)")
		}
		#endif
		
		// create the new value
		let intVal = yyjson_mut_int(doc, Int64(value))
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, intVal) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a int32 value
	internal func encode(_ value:Int32) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_keyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_keyed_container.encode(_:)")
		}
		#endif

		// create the new value
		let intVal = yyjson_mut_int(doc, Int64(value))
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}

		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, intVal) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a int64 value
	internal func encode(_ value:Int64) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_keyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_keyed_container.encode(_:)")
		}
		#endif
		
		// create the new value
		let intVal = yyjson_mut_int(doc, value)
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, intVal) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a uint value
	internal func encode(_ value:UInt) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_keyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_keyed_container.encode(_:)")
		}
		#endif

		// create the new value
		let intVal = yyjson_mut_uint(doc, UInt64(value))
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, intVal) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a uint8 value
	internal func encode(_ value:UInt8) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_keyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_keyed_container.encode(_:)")
		}
		#endif

		let intVal = yyjson_mut_uint(doc, UInt64(value))
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		
		guard yyjson_mut_obj_put(obj, assignKey, intVal) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a uint16 value
	internal func encode(_ value:UInt16) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_keyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_keyed_container.encode(_:)")
		}
		#endif

		let intVal = yyjson_mut_uint(doc, UInt64(value))
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, intVal) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a uint32 value
	internal func encode(_ value:UInt32) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_keyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_keyed_container.encode(_:)")
		}
		#endif

		let intVal = yyjson_mut_uint(doc, UInt64(value))
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, intVal) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a uint64 value
	internal func encode(_ value:UInt64) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_keyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_keyed_container.encode(_:)")
		}
		#endif

		let intVal = yyjson_mut_uint(doc, value)
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, intVal) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an encodable value
	internal func encode<T>(_ value:T) throws where T :Encodable {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_keyed_container.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_keyed_container.encode(_:)")
		}
		try value.encode(to:encoder_from_keyed_container(doc:self.doc, obj:self.obj, assignKey:assignKey, codingPath:self.codingPath, logLevel:self.logLevel))
		#else
		try value.encode(to:encoder_from_keyed_container(doc:self.doc, obj:self.obj, assignKey:assignKey, codingPath:self.codingPath))
		#endif
	}

	// required by swift. unused.
	internal var codingPath:[CodingKey] {
		get {
			return []
		}
	}
}

/// a single value encoding container that is meant specifically for applying a single value to the "root" of the json document.
internal struct ec_single_from_root:Swift.SingleValueEncodingContainer {
	private let doc:UnsafeMutablePointer<yyjson_mut_doc>

	#if QUICKJSON_SHOULDLOG
	private let logger:Logger
	private let logLevel:Logging.Logger.Level
	/// initialize a new single value container that encodes directly to the root of the document
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>, logLevel:Logging.Logger.Level = .critical) {
		let iid = UInt16.random(in:UInt16.min...UInt16.max)
		var buildLogger = Encoding.logger
		buildLogger[metadataKey: "iid"] = "\(iid)"
		buildLogger.logLevel = logLevel
		self.logger = buildLogger
		self.logLevel = logLevel
		buildLogger.debug("enter: ec_single_from_root.init(doc:)")
		defer {
			buildLogger.trace("exit: ec_single_from_root.init(doc:)")
		}
		self.doc = doc
	}
	#else
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>) {
		self.doc = doc
	}
	#endif

	/// encode a nil value
	internal func encodeNil() throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_root.encodeNil()")
		defer {
			self.logger.trace("exit: ec_single_from_root.encodeNil()")
		}
		#endif

		// create the new value
		let newVal = yyjson_mut_null(doc)
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}

		// assign the new value as root
		yyjson_mut_doc_set_root(doc, newVal)
	}

	/// encode a boolean value
	internal func encode(_ value:Bool) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_root.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_root.encode(_:)")
		}
		#endif

		// create the new value
		let newVal = yyjson_mut_bool(doc, value)
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}

		// assign the new value as root
		yyjson_mut_doc_set_root(doc, newVal)
	}

	/// encode a string value
	internal func encode(_ value:String) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_root.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_root.encode(_:)")
		}
		#endif

		// create the new value
		let stringVal = yyjson_mut_strncpy(doc, value, value.utf8.count)
		guard stringVal != nil else {
			throw Encoding.Error.assignmentError
		}
		
		// assign the new value as root
		yyjson_mut_doc_set_root(doc, stringVal)
	}

	/// encode a double value
	internal func encode(_ value:Double) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_root.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_root.encode(_:)")
		}
		#endif

		// create the new value
		let doubleVal = yyjson_mut_real(doc, value)
		guard doubleVal != nil else {
			throw Encoding.Error.assignmentError
		}
		
		// assign the new value as root
		yyjson_mut_doc_set_root(doc, doubleVal)
	}

	/// encode a float value
	internal func encode(_ value:Float) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_root.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_root.encode(_:)")
		}
		#endif

		// create the new value
		let floatVal = yyjson_mut_real(doc, Double(value))
		guard floatVal != nil else {
			throw Encoding.Error.assignmentError
		}
		
		// assign the new value as root
		yyjson_mut_doc_set_root(doc, floatVal)
	}

	/// encode an int value
	internal func encode(_ value:Int) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_root.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_root.encode(_:)")
		}
		#endif

		// create the new value
		let intVal = yyjson_mut_int(doc, Int64(value))
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		
		// assign the new value as root
		yyjson_mut_doc_set_root(doc, intVal)
	}

	/// encode an int8 value
	internal func encode(_ value:Int8) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_root.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_root.encode(_:)")
		}
		#endif

		// create the new value
		let intVal = yyjson_mut_int(doc, Int64(value))
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		
		// assign the new value as root
		yyjson_mut_doc_set_root(doc, intVal)
	}

	/// encode an int16 value
	internal func encode(_ value:Int16) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_root.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_root.encode(_:)")
		}
		#endif

		// create the new value
		let intVal = yyjson_mut_int(doc, Int64(value))
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		
		// assign the new value as root
		yyjson_mut_doc_set_root(doc, intVal)
	}

	/// encode an int32 value
	internal func encode(_ value:Int32) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_root.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_root.encode(_:)")
		}
		#endif

		// create the new value
		let intVal = yyjson_mut_int(doc, Int64(value))
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}

		// assign the new value as root
		yyjson_mut_doc_set_root(doc, intVal)
	}

	/// encode an int64 value
	internal func encode(_ value:Int64) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_root.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_root.encode(_:)")
		}
		#endif

		// create the new value
		let intVal = yyjson_mut_int(doc, value)
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		
		// assign the new value as root
		yyjson_mut_doc_set_root(doc, intVal)
	}

	/// encode a uint value
	internal func encode(_ value:UInt) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_root.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_root.encode(_:)")
		}
		#endif

		// create the new value
		let intVal = yyjson_mut_uint(doc, UInt64(value))
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		
		// assign the new value as root
		yyjson_mut_doc_set_root(doc, intVal)
	}

	/// encode a uint8 value
	internal func encode(_ value:UInt8) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_root.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_root.encode(_:)")
		}
		#endif

		let intVal = yyjson_mut_uint(doc, UInt64(value))
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		
		// assign the new value as root
		yyjson_mut_doc_set_root(doc, intVal)
	}

	/// encode a uint16 value
	internal func encode(_ value:UInt16) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_root.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_root.encode(_:)")
		}
		#endif

		let intVal = yyjson_mut_uint(doc, UInt64(value))
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		
		// assign the new value as root
		yyjson_mut_doc_set_root(doc, intVal)
	}

	/// encode a uint32 value
	internal func encode(_ value:UInt32) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_root.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_root.encode(_:)")
		}
		#endif
		
		let intVal = yyjson_mut_uint(doc, UInt64(value))
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		
		// assign the new value as root
		yyjson_mut_doc_set_root(doc, intVal)
	}

	/// encode a uint64 value
	internal func encode(_ value:UInt64) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_root.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_root.encode(_:)")
		}
		#endif
		
		let intVal = yyjson_mut_uint(doc, value)
		guard intVal != nil else {
			throw Encoding.Error.assignmentError
		}
		
		// assign the new value as root
		yyjson_mut_doc_set_root(doc, intVal)
	}

	/// encode an encodable value
	internal func encode<T>(_ value:T) throws where T :Encodable {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_single_from_root.encode(_:)")
		defer {
			self.logger.trace("exit: ec_single_from_root.encode(_:)")
		}
		try value.encode(to:encoder_from_root(doc:self.doc, logLevel:self.logLevel))
		#else
		try value.encode(to:encoder_from_root(doc:self.doc))
		#endif
	}

	// required by swift. unused.
	internal var codingPath:[CodingKey] {
		get {
			return []
		}
	}
}