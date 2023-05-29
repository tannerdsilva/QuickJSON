// (c) tanner silva 2023. all rights reserved.
import yyjson

internal struct ec_single_from_unkeyed_container:Swift.SingleValueEncodingContainer {
	private let doc:UnsafeMutablePointer<yyjson_mut_doc>
	private let arr:UnsafeMutablePointer<yyjson_mut_val>

	/// initialize a new single value container from an unkeyed parent.
	/// - parameter doc: the document this container belongs to
	/// - parameter arr: the array this container will assign values to
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>, arr:UnsafeMutablePointer<yyjson_mut_val>) {
		self.doc = doc
		self.arr = arr
	}

	/// encode a nil value
	internal func encodeNil() throws {
		let nilVal = yyjson_mut_null(doc)
		guard nilVal != nil else {
			throw Encoder.Error.assignmentError
		}
		 yyjson_mut_arr_append(arr, nilVal)
	}

	/// encode a bool value
	internal func encode(_ value:Bool) throws {
		let boolVal = yyjson_mut_bool(doc, value)
		guard boolVal != nil else {
			throw Encoder.Error.assignmentError
		}
		 yyjson_mut_arr_append(arr, boolVal)
	}

	/// encode a string value
	internal func encode(_ value:String) throws {
		let stringVal = yyjson_mut_strncpy(doc, value, value.utf8.count)
		guard stringVal != nil else {
			throw Encoder.Error.assignmentError
		}
		 yyjson_mut_arr_append(arr, stringVal)
	}

	/// encode a double value
	internal func encode(_ value:Double) throws {
		let doubleVal = yyjson_mut_real(doc, value)
		guard doubleVal != nil else {
			throw Encoder.Error.assignmentError
		}
		 yyjson_mut_arr_append(arr, doubleVal)
	}

	/// encode a float value
	internal func encode(_ value:Float) throws {
		let floatVal = yyjson_mut_real(doc, Double(value))
		guard floatVal != nil else {
			throw Encoder.Error.assignmentError
		}
		 yyjson_mut_arr_append(arr, floatVal)
	}

	/// encode an int value
	internal func encode(_ value:Int) throws {
		let intVal = yyjson_mut_int(doc, Int64(value))
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		 yyjson_mut_arr_append(arr, intVal)
	}

	/// encode an int8 value
	internal func encode(_ value:Int8) throws {
		let intVal = yyjson_mut_int(doc, Int64(value))
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		 yyjson_mut_arr_append(arr, intVal)
	}

	/// encode an int16 value
	internal func encode(_ value:Int16) throws {
		let intVal = yyjson_mut_int(doc, Int64(value))
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		 yyjson_mut_arr_append(arr, intVal)
	}

	/// encode an int32 value
	internal func encode(_ value:Int32) throws {
		let intVal = yyjson_mut_int(doc, Int64(value))
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		 yyjson_mut_arr_append(arr, intVal)
	}

	/// encode an int64 value
	internal func encode(_ value:Int64) throws {
		let intVal = yyjson_mut_int(doc, value)
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		 yyjson_mut_arr_append(arr, intVal)
	}

	/// encode a uint value
	internal func encode(_ value:UInt) throws {
		let intVal = yyjson_mut_uint(doc, UInt64(value))
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		 yyjson_mut_arr_append(arr, intVal)
	}

	/// encode a uint8 value
	internal func encode(_ value:UInt8) throws {
		let intVal = yyjson_mut_uint(doc, UInt64(value))
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		 yyjson_mut_arr_append(arr, intVal)
	}

	/// encode a uint16 value
	internal func encode(_ value:UInt16) throws {
		let intVal = yyjson_mut_uint(doc, UInt64(value))
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		 yyjson_mut_arr_append(arr, intVal)
	}

	/// encode a uint32 value
	internal func encode(_ value:UInt32) throws {
		let intVal = yyjson_mut_uint(doc, UInt64(value))
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		 yyjson_mut_arr_append(arr, intVal)
	}

	/// encode a uint64 value
	internal func encode(_ value:UInt64) throws {
		let intVal = yyjson_mut_uint(doc, value)
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		 yyjson_mut_arr_append(arr, intVal)
	}

	/// encode an encodable value
	internal func encode<T>(_ value:T) throws where T:Encodable {
		try value.encode(to:encoder_from_unkeyed_container(doc:doc, arr:arr))
	}

	// required by swift. unused.
	internal var codingPath:[CodingKey] {
		get {
			return []
		}
	}
}

// a single value container.
// - note: this is used to encode a single value into a keyed container.
internal struct ec_single_from_keyed_container:Swift.SingleValueEncodingContainer {
	private let doc:UnsafeMutablePointer<yyjson_mut_doc>
	private let obj:UnsafeMutablePointer<yyjson_mut_val>
	private let assignKey:UnsafeMutablePointer<yyjson_mut_val>

	/// initialize a new single value container that will assign a value to a parent object.
	/// - parameter doc: the document to encode into
	/// - parameter obj: the object to encode into
	/// - parameter assignKey: the key to use to assign the single value to the parent object after it is encoded
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>, obj:UnsafeMutablePointer<yyjson_mut_val>, assignKey:UnsafeMutablePointer<yyjson_mut_val>) {
		self.doc = doc
		self.obj = obj
		self.assignKey = assignKey
	}

	/// encode a nil value
	internal func encodeNil() throws {
		// create the new value
		let newVal = yyjson_mut_null(doc)
		guard newVal != nil else {
			throw Encoder.Error.assignmentError
		}

		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, newVal) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode a bool value
	internal func encode(_ value:Bool) throws {
		// create the new value
		let newVal = yyjson_mut_bool(doc, value)
		guard newVal != nil else {
			throw Encoder.Error.assignmentError
		}

		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, newVal) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode a string value
	internal func encode(_ value:String) throws {
		// create the new value
		let stringVal = yyjson_mut_strncpy(doc, value, value.utf8.count)
		guard stringVal != nil else {
			throw Encoder.Error.assignmentError
		}
		
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, stringVal) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode a double value
	internal func encode(_ value:Double) throws {
		// create the new value
		let doubleVal = yyjson_mut_real(doc, value)
		guard doubleVal != nil else {
			throw Encoder.Error.assignmentError
		}
		
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, doubleVal) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode a float value
	internal func encode(_ value:Float) throws {
		// create the new value
		let floatVal = yyjson_mut_real(doc, Double(value))
		guard floatVal != nil else {
			throw Encoder.Error.assignmentError
		}
		
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, floatVal) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode a int value
	internal func encode(_ value:Int) throws {
		// create the new value
		let intVal = yyjson_mut_int(doc, Int64(value))
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, intVal) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode a int8 value
	internal func encode(_ value:Int8) throws {
		// create the new value
		let intVal = yyjson_mut_int(doc, Int64(value))
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, intVal) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode a int16 value
	internal func encode(_ value:Int16) throws {
		// create the new value
		let intVal = yyjson_mut_int(doc, Int64(value))
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, intVal) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode a int32 value
	internal func encode(_ value:Int32) throws {
		// create the new value
		let intVal = yyjson_mut_int(doc, Int64(value))
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}

		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, intVal) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode a int64 value
	internal func encode(_ value:Int64) throws {
		// create the new value
		let intVal = yyjson_mut_int(doc, value)
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, intVal) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode a uint value
	internal func encode(_ value:UInt) throws {
		// create the new value
		let intVal = yyjson_mut_uint(doc, UInt64(value))
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, intVal) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode a uint8 value
	internal func encode(_ value:UInt8) throws {
		let intVal = yyjson_mut_uint(doc, UInt64(value))
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		
		guard yyjson_mut_obj_put(obj, assignKey, intVal) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode a uint16 value
	internal func encode(_ value:UInt16) throws {
		let intVal = yyjson_mut_uint(doc, UInt64(value))
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, intVal) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode a uint32 value
	internal func encode(_ value:UInt32) throws {
		let intVal = yyjson_mut_uint(doc, UInt64(value))
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, intVal) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode a uint64 value
	internal func encode(_ value:UInt64) throws {
		let intVal = yyjson_mut_uint(doc, value)
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		
		// assign the new value to the object
		guard yyjson_mut_obj_put(obj, assignKey, intVal) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode an encodable value
	internal func encode<T>(_ value:T) throws where T :Encodable {
		try value.encode(to:encoder_from_keyed_container(doc:self.doc, obj:self.obj, assignKey:assignKey, codingPath:self.codingPath))
	}

	// required by swift. unused.
	internal var codingPath:[CodingKey] {
		get {
			return []
		}
	}
}

// a single value container for encoding values into an array
internal struct ec_single_from_root:Swift.SingleValueEncodingContainer {
	private let doc:UnsafeMutablePointer<yyjson_mut_doc>

	/// initialize a new single value container that encodes directly to the root of the document
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>) {
		self.doc = doc
	}

	/// encode a nil value
	internal func encodeNil() throws {
		// create the new value
		let newVal = yyjson_mut_null(doc)
		guard newVal != nil else {
			throw Encoder.Error.assignmentError
		}

		// assign the new value as root
		yyjson_mut_doc_set_root(doc, newVal)
	}

	/// encode a boolean value
	internal func encode(_ value:Bool) throws {
		// create the new value
		let newVal = yyjson_mut_bool(doc, value)
		guard newVal != nil else {
			throw Encoder.Error.assignmentError
		}

		// assign the new value as root
		yyjson_mut_doc_set_root(doc, newVal)
	}

	/// encode a string value
	internal func encode(_ value:String) throws {
		// create the new value
		let stringVal = yyjson_mut_strncpy(doc, value, value.utf8.count)
		guard stringVal != nil else {
			throw Encoder.Error.assignmentError
		}
		
		// assign the new value as root
		yyjson_mut_doc_set_root(doc, stringVal)
	}

	/// encode a double value
	internal func encode(_ value:Double) throws {
		// create the new value
		let doubleVal = yyjson_mut_real(doc, value)
		guard doubleVal != nil else {
			throw Encoder.Error.assignmentError
		}
		
		// assign the new value as root
		yyjson_mut_doc_set_root(doc, doubleVal)
	}

	/// encode a float value
	internal func encode(_ value:Float) throws {
		// create the new value
		let floatVal = yyjson_mut_real(doc, Double(value))
		guard floatVal != nil else {
			throw Encoder.Error.assignmentError
		}
		
		// assign the new value as root
		yyjson_mut_doc_set_root(doc, floatVal)
	}

	/// encode an int value
	internal func encode(_ value:Int) throws {
		// create the new value
		let intVal = yyjson_mut_int(doc, Int64(value))
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		
		// assign the new value as root
		yyjson_mut_doc_set_root(doc, intVal)
	}

	/// encode an int8 value
	internal func encode(_ value:Int8) throws {
		// create the new value
		let intVal = yyjson_mut_int(doc, Int64(value))
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		
		// assign the new value as root
		yyjson_mut_doc_set_root(doc, intVal)
	}

	/// encode an int16 value
	internal func encode(_ value:Int16) throws {
		// create the new value
		let intVal = yyjson_mut_int(doc, Int64(value))
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		
		// assign the new value as root
		yyjson_mut_doc_set_root(doc, intVal)
	}

	/// encode an int32 value
	internal func encode(_ value:Int32) throws {
		// create the new value
		let intVal = yyjson_mut_int(doc, Int64(value))
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}

		// assign the new value as root
		yyjson_mut_doc_set_root(doc, intVal)
	}

	/// encode an int64 value
	internal func encode(_ value:Int64) throws {
		// create the new value
		let intVal = yyjson_mut_int(doc, value)
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		
		// assign the new value as root
		yyjson_mut_doc_set_root(doc, intVal)
	}

	/// encode a uint value
	internal func encode(_ value:UInt) throws {
		// create the new value
		let intVal = yyjson_mut_uint(doc, UInt64(value))
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		
		// assign the new value as root
		yyjson_mut_doc_set_root(doc, intVal)
	}

	/// encode a uint8 value
	internal func encode(_ value:UInt8) throws {
		let intVal = yyjson_mut_uint(doc, UInt64(value))
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		
		// assign the new value as root
		yyjson_mut_doc_set_root(doc, intVal)
	}

	/// encode a uint16 value
	internal func encode(_ value:UInt16) throws {
		let intVal = yyjson_mut_uint(doc, UInt64(value))
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		
		// assign the new value as root
		yyjson_mut_doc_set_root(doc, intVal)
	}

	/// encode a uint32 value
	internal func encode(_ value:UInt32) throws {
		let intVal = yyjson_mut_uint(doc, UInt64(value))
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		
		// assign the new value as root
		yyjson_mut_doc_set_root(doc, intVal)
	}

	/// encode a uint64 value
	internal func encode(_ value:UInt64) throws {
		let intVal = yyjson_mut_uint(doc, value)
		guard intVal != nil else {
			throw Encoder.Error.assignmentError
		}
		
		// assign the new value as root
		yyjson_mut_doc_set_root(doc, intVal)
	}

	/// encode an encodable value
	internal func encode<T>(_ value:T) throws where T :Encodable {
		try value.encode(to:encoder_from_root(doc:self.doc))
	}

	// required by swift. unused.
	internal var codingPath:[CodingKey] {
		get {
			return []
		}
	}
}