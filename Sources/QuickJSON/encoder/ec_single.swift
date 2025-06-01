// (c) tanner silva 2023-2025. all rights reserved.
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
	#endif

	/// initialize a new single value container from an unkeyed parent.
	/// - parameter doc: the document this container belongs to
	/// - parameter arr: the array this container will assign values to
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>, arr:UnsafeMutablePointer<yyjson_mut_val>, codingPath:[CodingKey]) {
		let iid = UInt16.random(in:UInt16.min...UInt16.max)
		#if QUICKJSON_SHOULDLOG
		var buildLogger = Encoding.logger
		buildLogger[metadataKey: "iid"] = "\(iid)"
		buildLogger[metadataKey: "doc"] = "\(doc.hashValue)"
		buildLogger[metadataKey: "arr"] = "\(arr.hashValue)"
		self.logger = buildLogger
		buildLogger.debug("enter: \(String(describing:Self.self)) : \(#function)")
		defer {
			buildLogger.trace("exit: \(String(describing:Self.self)) : \(#function)")
		}
		#endif
		self.doc = doc
		self.arr = arr
	}

	/// encode a nil value
	internal borrowing func encodeNil() throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function)")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function)")
		}
		#endif
		guard yyjson_mut_arr_append(arr, yyjson_mut_null(doc)!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a bool value
	internal borrowing func encode(_ value:Bool) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		guard yyjson_mut_arr_append(arr, yyjson_mut_bool(doc, value)!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a string value
	internal borrowing func encode(_ value:String) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		guard yyjson_mut_arr_append(arr, yyjson_mut_strncpy(doc, value, value.utf8.count)!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a double value
	internal borrowing func encode(_ value:Double) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		guard yyjson_mut_arr_append(arr, yyjson_mut_real(doc, value)!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a float value
	internal borrowing func encode(_ value:Float) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		guard yyjson_mut_arr_append(arr, yyjson_mut_real(doc, Double(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an int value
	internal borrowing func encode(_ value:Int) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		guard yyjson_mut_arr_append(arr, yyjson_mut_int(doc, Int64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an int8 value
	internal borrowing func encode(_ value:Int8) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		guard yyjson_mut_arr_append(arr, yyjson_mut_int(doc, Int64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an int16 value
	internal borrowing func encode(_ value:Int16) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		guard yyjson_mut_arr_append(arr, yyjson_mut_int(doc, Int64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an int32 value
	internal borrowing func encode(_ value:Int32) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		guard yyjson_mut_arr_append(arr, yyjson_mut_int(doc, Int64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an int64 value
	internal func encode(_ value:Int64) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		guard yyjson_mut_arr_append(arr, yyjson_mut_int(doc, value)!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a uint value
	internal borrowing func encode(_ value:UInt) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		guard yyjson_mut_arr_append(arr, yyjson_mut_uint(doc, UInt64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a uint8 value
	internal borrowing func encode(_ value:UInt8) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		guard yyjson_mut_arr_append(arr, yyjson_mut_uint(doc, UInt64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a uint16 value
	internal borrowing func encode(_ value:UInt16) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		guard yyjson_mut_arr_append(arr, yyjson_mut_uint(doc, UInt64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a uint32 value
	internal borrowing func encode(_ value:UInt32) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		guard yyjson_mut_arr_append(arr, yyjson_mut_uint(doc, UInt64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a uint64 value
	internal borrowing func encode(_ value:UInt64) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		guard yyjson_mut_arr_append(arr, yyjson_mut_uint(doc, value)!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an encodable value
	internal borrowing func encode<T>(_ value:T) throws where T:Encodable {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		try value.encode(to:encoder_from_unkeyed_container(doc:doc, arr:arr))
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
	#endif
	/// initialize a new single value container that will assign a value to a parent object.
	/// - parameter doc: the document to encode into
	/// - parameter obj: the object to encode into
	/// - parameter assignKey: the key to use to assign the single value to the parent object after it is encoded
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>, obj:UnsafeMutablePointer<yyjson_mut_val>, assignKey:UnsafeMutablePointer<yyjson_mut_val>, codingPath:[CodingKey]) {
		#if QUICKJSON_SHOULDLOG
		let iid = UInt16.random(in:UInt16.min...UInt16.max)
		var buildLogger = Encoding.logger
		buildLogger[metadataKey: "iid"] = "\(iid)"
		buildLogger[metadataKey: "doc"] = "\(doc.hashValue)"
		buildLogger[metadataKey: "obj"] = "\(obj.hashValue)"
		buildLogger[metadataKey: "assignKey"] = "\(assignKey.hashValue)"
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

	/// encode a nil value
	internal borrowing func encodeNil() throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function)")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function)")
		}
		#endif
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, yyjson_mut_null(doc)!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a bool value
	internal borrowing func encode(_ value:Bool) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, yyjson_mut_bool(doc, value)!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a string value
	internal borrowing func encode(_ value:String) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, yyjson_mut_strncpy(doc, value, value.utf8.count)!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a double value
	internal borrowing func encode(_ value:Double) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, yyjson_mut_real(doc, value)!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a float value
	internal func encode(_ value:Float) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, yyjson_mut_real(doc, Double(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a int value
	internal borrowing func encode(_ value:Int) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, yyjson_mut_int(doc, Int64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a int8 value
	internal borrowing func encode(_ value:Int8) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, yyjson_mut_int(doc, Int64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a int16 value
	internal borrowing func encode(_ value:Int16) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, yyjson_mut_int(doc, Int64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a int32 value
	internal borrowing func encode(_ value:Int32) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, yyjson_mut_int(doc, Int64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a int64 value
	internal borrowing func encode(_ value:Int64) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, yyjson_mut_int(doc, value)!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a uint value
	internal borrowing func encode(_ value:UInt) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, yyjson_mut_uint(doc, UInt64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a uint8 value
	internal borrowing func encode(_ value:UInt8) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		guard yyjson_mut_obj_put(obj, assignKey, yyjson_mut_uint(doc, UInt64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a uint16 value
	internal borrowing func encode(_ value:UInt16) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, yyjson_mut_uint(doc, UInt64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a uint32 value
	internal borrowing func encode(_ value:UInt32) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, yyjson_mut_uint(doc, UInt64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode a uint64 value
	internal borrowing func encode(_ value:UInt64) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, yyjson_mut_uint(doc, value)!) == true else {
			throw Encoding.Error.assignmentError
		}
	}

	/// encode an encodable value
	internal borrowing func encode<T>(_ value:T) throws where T:Encodable {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		try value.encode(to:encoder_from_keyed_container(doc:doc, obj:obj, assignKey:assignKey, codingPath:codingPath))
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
	#endif
	/// initialize a new single value container that encodes directly to the root of the document
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>) {
		#if QUICKJSON_SHOULDLOG
		let iid = UInt16.random(in:UInt16.min...UInt16.max)
		var buildLogger = Encoding.logger
		buildLogger[metadataKey: "iid"] = "\(iid)"
		buildLogger[metadataKey: "doc"] = "\(doc.hashValue)"
		self.logger = buildLogger
		buildLogger.debug("enter: \(String(describing:Self.self)) : \(#function)")
		defer {
			buildLogger.trace("exit: \(String(describing:Self.self)) : \(#function)")
		}
		#endif
		self.doc = doc
	}

	/// encode a nil value
	internal borrowing func encodeNil() {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function)")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function)")
		}
		#endif
		yyjson_mut_doc_set_root(doc, yyjson_mut_null(doc)!)
	}

	/// encode a boolean value
	internal borrowing func encode(_ value:Bool) {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		yyjson_mut_doc_set_root(doc, yyjson_mut_bool(doc, value)!)
	}

	/// encode a string value
	internal borrowing func encode(_ value:String) {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		yyjson_mut_doc_set_root(doc, yyjson_mut_strncpy(doc, value, value.utf8.count)!)
	}

	/// encode a double value
	internal borrowing func encode(_ value:Double) {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		yyjson_mut_doc_set_root(doc, yyjson_mut_real(doc, value)!)
	}

	/// encode a float value
	internal borrowing func encode(_ value:Float) {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		yyjson_mut_doc_set_root(doc, yyjson_mut_real(doc, Double(value))!)
	}

	/// encode an int value
	internal borrowing func encode(_ value:Int) {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		yyjson_mut_doc_set_root(doc, yyjson_mut_int(doc, Int64(value))!)
	}

	/// encode an int8 value
	internal borrowing func encode(_ value:Int8) {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		yyjson_mut_doc_set_root(doc, yyjson_mut_int(doc, Int64(value))!)
	}

	/// encode an int16 value
	internal borrowing func encode(_ value:Int16) {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		yyjson_mut_doc_set_root(doc, yyjson_mut_int(doc, Int64(value))!)
	}

	/// encode an int32 value
	internal borrowing func encode(_ value:Int32) {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		yyjson_mut_doc_set_root(doc, yyjson_mut_int(doc, Int64(value))!)
	}

	/// encode an int64 value
	internal borrowing func encode(_ value:Int64) {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		yyjson_mut_doc_set_root(doc, yyjson_mut_int(doc, value)!)
	}

	/// encode a uint value
	internal borrowing func encode(_ value:UInt) {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		yyjson_mut_doc_set_root(doc, yyjson_mut_uint(doc, UInt64(value))!)
	}

	/// encode a uint8 value
	internal borrowing func encode(_ value:UInt8) {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		yyjson_mut_doc_set_root(doc, yyjson_mut_uint(doc, UInt64(value))!)
	}

	/// encode a uint16 value
	internal borrowing func encode(_ value:UInt16) {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		yyjson_mut_doc_set_root(doc, yyjson_mut_uint(doc, UInt64(value))!)
	}

	/// encode a uint32 value
	internal borrowing func encode(_ value:UInt32) {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		yyjson_mut_doc_set_root(doc, yyjson_mut_uint(doc, UInt64(value))!)
	}

	/// encode a uint64 value
	internal borrowing func encode(_ value:UInt64) {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		yyjson_mut_doc_set_root(doc, yyjson_mut_uint(doc, value)!)
	}

	/// encode an encodable value
	internal borrowing func encode<T>(_ value:T) throws where T:Encodable {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type(of:value)))")
		}
		#endif
		try value.encode(to:encoder_from_root(doc:doc))
	}

	// required by swift. unused.
	internal var codingPath:[CodingKey] {
		get {
			return []
		}
	}
}