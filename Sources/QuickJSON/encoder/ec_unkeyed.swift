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
	private let logger:Logger
	private let logLevel:Logger.Level
	/// initializes a new unkeyed container
	/// - parameter doc: the document that this container is writing to
	/// - parameter root: the root object of the json document. this is where the container will write its keys and values to.
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>, root:UnsafeMutablePointer<yyjson_mut_val>, logLevel:Logger.Level = .critical) {
		let iid = UInt16.random(in:UInt16.min...UInt16.max)
		var buildLogger = Encoding.logger
		buildLogger[metadataKey: "iid"] = "\(iid)"
		buildLogger.logLevel = logLevel
		self.logger = buildLogger
		self.logLevel = logLevel
		buildLogger.debug("enter: ec_unkeyed.init(doc:root:)")
		defer {
			buildLogger.trace("exit: ec_unkeyed.init(doc:root:)")
		}
		self.doc = doc
		self.root = root
		self.count = 0
	}
	#else
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>, root:UnsafeMutablePointer<yyjson_mut_val>) {
		self.doc = doc
		self.root = root
		self.count = 0
	}
	#endif

	/// append a null value into the container
	internal mutating func encodeNil() throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: ec_unkeyed.encodeNil()")
		defer {
			logger.trace("exit: ec_unkeyed.encodeNil()")
		}
		#endif
		
		let newVal = yyjson_mut_null(doc)
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a bool value into the container
	internal mutating func encode(_ value:Bool) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_unkeyed.encode(_:)")
		defer {
			self.logger.trace("exit: ec_unkeyed.encode(_:)")
		}
		#endif

		let newVal = yyjson_mut_bool(doc, value)
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a nested keyed container into the container
	internal mutating func nestedContainer<NestedKey>(keyedBy keyType:NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey :CodingKey {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_unkeyed.nestedContainer(keyedBy:)")
		defer {
			self.logger.trace("exit: ec_unkeyed.nestedContainer(keyedBy:)")
		}
		#endif

		let newObj = yyjson_mut_obj(doc)!
		assert(yyjson_mut_arr_append(self.root, newObj) == true)
		self.count += 1

		#if QUICKJSON_SHOULDLOG
		return KeyedEncodingContainer(ec_keyed(doc:doc, root:newObj, logLevel:self.logLevel))
		#else
		return KeyedEncodingContainer(ec_keyed(doc:doc, root:newObj))
		#endif
	}

	/// append a nested unkeyed container into the container
	internal mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_unkeyed.nestedUnkeyedContainer()")
		defer {
			self.logger.trace("exit: ec_unkeyed.nestedUnkeyedContainer()")
		}
		#endif

		let newArr = yyjson_mut_arr(doc)!
		assert(yyjson_mut_arr_append(self.root, newArr) == true)
		self.count += 1

		#if QUICKJSON_SHOULDLOG
		return ec_unkeyed(doc:doc, root:newArr, logLevel:self.logLevel)
		#else
		return ec_unkeyed(doc:doc, root:newArr)
		#endif
	}

	/// append a codable value into the container
	internal mutating func encode<T>(_ value:T) throws where T :Encodable {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_unkeyed.encode(_:)")
		defer {
			self.logger.trace("exit: ec_unkeyed.encode(_:)")
		}
		#endif

		do {
			#if QUICKJSON_SHOULDLOG
			try value.encode(to:encoder_from_unkeyed_container(doc:doc, arr:self.root, logLevel:self.logLevel))
			#else
			try value.encode(to:encoder_from_unkeyed_container(doc:doc, arr:self.root))
			#endif
			self.count += 1
		} catch let error {
			throw error
		}
    }

	/// append a string value into the container
	internal mutating func encode(_ value:String) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_unkeyed.encode(_:)")
		defer {
			self.logger.trace("exit: ec_unkeyed.encode(_:)")
		}
		#endif
		
		let newVal = yyjson_mut_strncpy(doc, value, value.utf8.count)
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a double value into the container
	internal mutating func encode(_ value:Double) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_unkeyed.encode(_:)")
		defer {
			self.logger.trace("exit: ec_unkeyed.encode(_:)")
		}
		#endif

		let newVal = yyjson_mut_real(doc, value)
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a float value into the container
	internal mutating func encode(_ value:Float) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_unkeyed.encode(_:)")
		defer {
			self.logger.trace("exit: ec_unkeyed.encode(_:)")
		}
		#endif

		let newVal = yyjson_mut_real(doc, Double(value))
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append an int value into the container
	internal mutating func encode(_ value:Int) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_unkeyed.encode(_:)")
		defer {
			self.logger.trace("exit: ec_unkeyed.encode(_:)")
		}
		#endif
		
		let newVal = yyjson_mut_int(doc, Int64(value))
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append an int8 value into the container
	internal mutating func encode(_ value:Int8) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_unkeyed.encode(_:)")
		defer {
			self.logger.trace("exit: ec_unkeyed.encode(_:)")
		}
		#endif
		
		let newVal = yyjson_mut_int(doc, Int64(value))
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append an int16 value into the container
	internal mutating func encode(_ value:Int16) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_unkeyed.encode(_:)")
		defer {
			self.logger.trace("exit: ec_unkeyed.encode(_:)")
		}
		#endif
		
		let newVal = yyjson_mut_int(doc, Int64(value))
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append an int32 value into the container
	internal mutating func encode(_ value:Int32) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_unkeyed.encode(_:)")
		defer {
			self.logger.trace("exit: ec_unkeyed.encode(_:)")
		}
		#endif

		let newVal = yyjson_mut_int(doc, Int64(value))
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append an int64 value into the container
	internal mutating func encode(_ value:Int64) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_unkeyed.encode(_:)")
		defer {
			self.logger.trace("exit: ec_unkeyed.encode(_:)")
		}
		#endif

		let newVal = yyjson_mut_int(doc, value)
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a uint value into the container
	internal mutating func encode(_ value:UInt) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_unkeyed.encode(_:)")
		defer {
			self.logger.trace("exit: ec_unkeyed.encode(_:)")
		}
		#endif

		let newVal = yyjson_mut_uint(doc, UInt64(value))
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a uint8 value into the container
	internal mutating func encode(_ value:UInt8) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_unkeyed.encode(_:)")
		defer {
			self.logger.trace("exit: ec_unkeyed.encode(_:)")
		}
		#endif
		
		let newVal = yyjson_mut_uint(doc, UInt64(value))
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(self.root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a uint16 value into the container
	internal mutating func encode(_ value:UInt16) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_unkeyed.encode(_:)")
		defer {
			self.logger.trace("exit: ec_unkeyed.encode(_:)")
		}
		#endif
		
		let newVal = yyjson_mut_uint(doc, UInt64(value))
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(self.root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a uint32 value into the container
	internal mutating func encode(_ value:UInt32) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_unkeyed.encode(_:)")
		defer {
			self.logger.trace("exit: ec_unkeyed.encode(_:)")
		}
		#endif
		
		let newVal = yyjson_mut_uint(doc, UInt64(value))
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(self.root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a uint64 value into the container
	internal mutating func encode(_ value:UInt64) throws {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: ec_unkeyed.encode(_:)")
		defer {
			self.logger.trace("exit: ec_unkeyed.encode(_:)")
		}
		#endif
		
		let newVal = yyjson_mut_uint(doc, value)
		guard newVal != nil else {
			throw Encoding.Error.assignmentError
		}
		guard yyjson_mut_arr_append(self.root, newVal) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
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