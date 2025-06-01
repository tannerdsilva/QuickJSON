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
	#endif

	/// initializes a new unkeyed container
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
		buildLogger.debug("enter: ec_unkeyed.init(doc:root:)")
		defer {
			buildLogger.trace("exit: ec_unkeyed.init(doc:root:)")
		}
		#endif
		self.doc = doc
		self.root = root
		self.count = 0
	}

	/// append a null value into the container
	internal mutating func encodeNil() throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(#function)")
		defer {
			logger.trace("exit: \(#function)")
		}
		#endif
		guard yyjson_mut_arr_append(root, yyjson_mut_null(doc)!) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a bool value into the container
	internal mutating func encode(_ value:consuming Bool) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(#function)")
		defer {
			logger.trace("exit: \(#function)")
		}
		#endif
		guard yyjson_mut_arr_append(root, yyjson_mut_bool(doc, value)!) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a nested keyed container into the container
	internal mutating func nestedContainer<NestedKey>(keyedBy keyType:NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey:CodingKey {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(#function)")
		defer {
			logger.trace("exit: \(#function)")
		}
		#endif
		let newObj = yyjson_mut_obj(doc)!
		guard yyjson_mut_arr_append(self.root, newObj) == true else {
			fatalError("QuickJSON encoding error: unable to append new object to unkeyed container. this is an internal bug and fatal error. \(#file):\(#line) \(#function)")
		}
		self.count += 1
		return KeyedEncodingContainer(ec_keyed(doc:doc, root:newObj))
	}

	/// append a nested unkeyed container into the container
	internal mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(#function)")
		defer {
			logger.trace("exit: \(#function)")
		}
		#endif
		let newArr = yyjson_mut_arr(doc)!
		guard yyjson_mut_arr_append(self.root, newArr) == true else {
			fatalError("QuickJSON encoding error: unable to append new array to unkeyed container. this is an internal bug and fatal error. \(#file):\(#line) \(#function)")
		}
		self.count += 1
		return ec_unkeyed(doc:doc, root:newArr)
	}

	/// append a codable value into the container
	internal mutating func encode<T>(_ value:T) throws where T :Encodable {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(#function)")
		defer {
			logger.trace("exit: \(#function)")
		}
		#endif
		try value.encode(to:encoder_from_unkeyed_container(doc:doc, arr:root))
		self.count += 1
    }

	/// append a string value into the container
	internal mutating func encode(_ value:String) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(#function)")
		defer {
			logger.trace("exit: \(#function)")
		}
		#endif
		guard yyjson_mut_arr_append(root, yyjson_mut_strncpy(doc, value, value.utf8.count)!) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a double value into the container
	internal mutating func encode(_ value:Double) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(#function)")
		defer {
			logger.trace("exit: \(#function)")
		}
		#endif
		guard yyjson_mut_arr_append(root, yyjson_mut_real(doc, value)!) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a float value into the container
	internal mutating func encode(_ value:Float) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(#function)")
		defer {
			logger.trace("exit: \(#function)")
		}
		#endif
		guard yyjson_mut_arr_append(root, yyjson_mut_real(doc, Double(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append an int value into the container
	internal mutating func encode(_ value:Int) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(#function)")
		defer {
			logger.trace("exit: \(#function)")
		}
		#endif
		guard yyjson_mut_arr_append(root, yyjson_mut_int(doc, Int64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append an int8 value into the container
	internal mutating func encode(_ value:Int8) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(#function)")
		defer {
			logger.trace("exit: \(#function)")
		}
		#endif
		guard yyjson_mut_arr_append(root, yyjson_mut_int(doc, Int64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append an int16 value into the container
	internal mutating func encode(_ value:Int16) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(#function)")
		defer {
			logger.trace("exit: \(#function)")
		}
		#endif
		guard yyjson_mut_arr_append(root, yyjson_mut_int(doc, Int64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append an int32 value into the container
	internal mutating func encode(_ value:Int32) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(#function)")
		defer {
			logger.trace("exit: \(#function)")
		}
		#endif
		guard yyjson_mut_arr_append(root, yyjson_mut_int(doc, Int64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append an int64 value into the container
	internal mutating func encode(_ value:Int64) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(#function)")
		defer {
			logger.trace("exit: \(#function)")
		}
		#endif
		guard yyjson_mut_arr_append(root, yyjson_mut_int(doc, value)!) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a uint value into the container
	internal mutating func encode(_ value:UInt) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(#function)")
		defer {
			logger.trace("exit: \(#function)")
		}
		#endif
		guard yyjson_mut_arr_append(root, yyjson_mut_uint(doc, UInt64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a uint8 value into the container
	internal mutating func encode(_ value:UInt8) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(#function)")
		defer {
			logger.trace("exit: \(#function)")
		}
		#endif
		guard yyjson_mut_arr_append(self.root, yyjson_mut_uint(doc, UInt64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a uint16 value into the container
	internal mutating func encode(_ value:UInt16) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(#function)")
		defer {
			logger.trace("exit: \(#function)")
		}
		#endif
		guard yyjson_mut_arr_append(self.root, yyjson_mut_uint(doc, UInt64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a uint32 value into the container
	internal mutating func encode(_ value:UInt32) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(#function)")
		defer {
			logger.trace("exit: \(#function)")
		}
		#endif
		guard yyjson_mut_arr_append(self.root, yyjson_mut_uint(doc, UInt64(value))!) == true else {
			throw Encoding.Error.assignmentError
		}
		self.count += 1
	}

	/// append a uint64 value into the container
	internal mutating func encode(_ value:UInt64) throws {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(#function)")
		defer {
			logger.trace("exit: \(#function)")
		}
		#endif
		guard yyjson_mut_arr_append(self.root, yyjson_mut_uint(doc, value)!) == true else {
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