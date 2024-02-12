// (c) tanner silva 2023. all rights reserved.
import yyjson

#if QUICKJSON_SHOULDLOG
import Logging
#endif

/// an unkeyed encoding container.
internal struct ec_unkeyed:Swift.UnkeyedEncodingContainer {
	private let doc:UnsafeMutablePointer<yyjson_mut_doc>
	private let root:UnsafeMutablePointer<yyjson_mut_val>
	internal var count:Int

	#if QUICKJSON_SHOULDLOG
	private let logger:Logger?
	/// initializes a new unkeyed container
	/// - parameter doc: the document that this container is writing to
	/// - parameter root: the root object of the json document. this is where the container will write its keys and values to.
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>, root:UnsafeMutablePointer<yyjson_mut_val>, logger:Logger?) {
		let iid = UInt16.random(in:UInt16.min...UInt16.max)
		var buildLogger = logger
		buildLogger?[metadataKey:"iid"] = "\(iid)"
		buildLogger?[metadataKey:"type"] = "ec_unkeyed"
		logger = buildLogger
		buildLogger.debug("instance init")
		self.doc = doc
		self.root = root
		count = 0
	}
	#else
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>, root:UnsafeMutablePointer<yyjson_mut_val>) {
		self.doc = doc
		self.root = root
		count = 0
	}
	#endif

	/// append a null value into the container
	internal mutating func encodeNil() throws {
		#if QUICKJSON_SHOULDLOG
		logger?.debug("enter: encodeNil()")
		defer {
			logger?.trace("exit: encodeNil()")
		}
		#endif
		
		let newVal = yyjson_mut_null(doc)
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		count += 1
	}

	/// append a bool value into the container
	internal mutating func encode(_ value:Bool) throws {
		#if QUICKJSON_SHOULDLOG
		logger?.debug("enter: encode(_:Bool)")
		defer {
			logger?.trace("exit: encode(_:Bool)")
		}
		#endif

		let newVal = yyjson_mut_bool(doc, value)
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		count += 1
	}

	/// append a nested keyed container into the container
	internal mutating func nestedContainer<NestedKey>(keyedBy keyType:NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey :CodingKey {
		#if QUICKJSON_SHOULDLOG
		logger?.debug("enter: nestedContainer<NestedKey>(keyedBy:)")
		defer {
			logger?.trace("exit: nestedContainer<NestedKey>(keyedBy:)")
		}
		#endif

		let newObj = yyjson_mut_obj(doc)!
		assert(yyjson_mut_arr_append(root, newObj) == true)
		count += 1

		#if QUICKJSON_SHOULDLOG
		return KeyedEncodingContainer(ec_keyed(doc:doc, root:newObj, logger:logger))
		#else
		return KeyedEncodingContainer(ec_keyed(doc:doc, root:newObj))
		#endif
	}

	/// append a nested unkeyed container into the container
	internal mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
		#if QUICKJSON_SHOULDLOG
		logger?.debug("enter: nestedUnkeyedContainer()")
		defer {
			logger?.trace("exit: nestedUnkeyedContainer()")
		}
		#endif

		let newArr = yyjson_mut_arr(doc)!
		assert(yyjson_mut_arr_append(root, newArr) == true)
		count += 1

		#if QUICKJSON_SHOULDLOG
		return ec_unkeyed(doc:doc, root:newArr, logger:logger)
		#else
		return ec_unkeyed(doc:doc, root:newArr)
		#endif
	}

	/// append a codable value into the container
	internal mutating func encode<T>(_ value:T) throws where T:Encodable {
		#if QUICKJSON_SHOULDLOG
		logger?.debug("enter: encode<T>(_:T) where T:Encodable")
		defer {
			logger?.trace("exit: encode<T>(_:T) where T:Encodable")
		}
		#endif

		do {
			#if QUICKJSON_SHOULDLOG
			try value.encode(to:encoder_from_unkeyed_container(doc:doc, arr:root, logger:logger))
			#else
			try value.encode(to:encoder_from_unkeyed_container(doc:doc, arr:root))
			#endif
			count += 1
		} catch let error {
			throw error
		}
    }

	/// append a string value into the container
	internal mutating func encode(_ value:String) throws {
		#if QUICKJSON_SHOULDLOG
		logger?.debug("enter: encode(_:String)")
		defer {
			logger?.trace("exit: encode(_:String)")
		}
		#endif
		
		let newVal = yyjson_mut_strncpy(doc, value, value.utf8.count)
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		count += 1
	}

	/// append a double value into the container
	internal mutating func encode(_ value:Double) throws {
		#if QUICKJSON_SHOULDLOG
		logger?.debug("enter: encode(_:Double)")
		defer {
			logger?.trace("exit: encode(_:Double)")
		}
		#endif

		let newVal = yyjson_mut_real(doc, value)
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		count += 1
	}

	/// append a float value into the container
	internal mutating func encode(_ value:Float) throws {
		#if QUICKJSON_SHOULDLOG
		logger?.debug("enter: encode(_:Float)")
		defer {
			logger?.trace("exit: encode(_:Float)")
		}
		#endif

		let newVal = yyjson_mut_real(doc, Double(value))
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		count += 1
	}

	/// append an int value into the container
	internal mutating func encode(_ value:Int) throws {
		#if QUICKJSON_SHOULDLOG
		logger?.debug("enter: encode(_:Int)")
		defer {
			logger?.trace("exit: encode(_:Int)")
		}
		#endif
		
		let newVal = yyjson_mut_int(doc, Int64(value))
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		count += 1
	}

	/// append an int8 value into the container
	internal mutating func encode(_ value:Int8) throws {
		#if QUICKJSON_SHOULDLOG
		logger?.debug("enter: encode(_:Int8)")
		defer {
			logger?.trace("exit: encode(_:Int8)")
		}
		#endif
		
		let newVal = yyjson_mut_int(doc, Int64(value))
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		count += 1
	}

	/// append an int16 value into the container
	internal mutating func encode(_ value:Int16) throws {
		#if QUICKJSON_SHOULDLOG
		logger?.debug("enter: encode(_:Int16)")
		defer {
			logger?.trace("exit: encode(_:Int16)")
		}
		#endif
		
		let newVal = yyjson_mut_int(doc, Int64(value))
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		count += 1
	}

	/// append an int32 value into the container
	internal mutating func encode(_ value:Int32) throws {
		#if QUICKJSON_SHOULDLOG
		logger?.debug("enter: encode(_:Int32)")
		defer {
			logger?.trace("exit: encode(_:Int32)")
		}
		#endif

		let newVal = yyjson_mut_int(doc, Int64(value))
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		count += 1
	}

	/// append an int64 value into the container
	internal mutating func encode(_ value:Int64) throws {
		#if QUICKJSON_SHOULDLOG
		logger?.debug("enter: encode(_:Int64)")
		defer {
			logger?.trace("exit: encode(_:Int64)")
		}
		#endif

		let newVal = yyjson_mut_int(doc, value)
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		count += 1
	}

	/// append a uint value into the container
	internal mutating func encode(_ value:UInt) throws {
		#if QUICKJSON_SHOULDLOG
		logger?.debug("enter: encode(_:UInt)")
		defer {
			logger?.trace("exit: encode(_:UInt)")
		}
		#endif

		let newVal = yyjson_mut_uint(doc, UInt64(value))
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		count += 1
	}

	/// append a uint8 value into the container
	internal mutating func encode(_ value:UInt8) throws {
		#if QUICKJSON_SHOULDLOG
		logger?.debug("enter: encode(_:UInt8)")
		defer {
			logger?.trace("exit: encode(_:UInt8)")
		}
		#endif
		
		let newVal = yyjson_mut_uint(doc, UInt64(value))
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		count += 1
	}

	/// append a uint16 value into the container
	internal mutating func encode(_ value:UInt16) throws {
		#if QUICKJSON_SHOULDLOG
		logger?.debug("enter: encode(_:UInt16)")
		defer {
			logger?.trace("exit: encode(_:UInt16)")
		}
		#endif
		
		let newVal = yyjson_mut_uint(doc, UInt64(value))
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		count += 1
	}

	/// append a uint32 value into the container
	internal mutating func encode(_ value:UInt32) throws {
		#if QUICKJSON_SHOULDLOG
		logger?.debug("enter: encode(_:UInt32)")
		defer {
			logger?.trace("exit: encode(_:UInt32)")
		}
		#endif
		
		let newVal = yyjson_mut_uint(doc, UInt64(value))
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		count += 1
	}

	/// append a uint64 value into the container
	internal mutating func encode(_ value:UInt64) throws {
		#if QUICKJSON_SHOULDLOG
		logger?.debug("enter: encode(_:UInt64)")
		defer {
			logger?.trace("exit: encode(_:UInt64)")
		}
		#endif
		
		let newVal = yyjson_mut_uint(doc, value)
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		count += 1
	}

	// required by swift. unused.
	internal var codingPath:[CodingKey] {
		get {
			return []
		}
	}
	
	internal func superEncoder() -> Swift.Encoder {
		fatalError("unimplemented")
	}
}