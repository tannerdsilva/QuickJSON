// (c) tanner silva 2023. all rights reserved.
import yyjson

internal struct ec_unkeyed:Swift.UnkeyedEncodingContainer {
	private let doc:UnsafeMutablePointer<yyjson_mut_doc>
	private let root:UnsafeMutablePointer<yyjson_mut_val>
	internal var count:Int

	/// initializes a new unkeyed container
	/// - parameter doc: the document that this container is writing to
	/// - parameter root: the root object of the json document. this is where the container will write its keys and values to.
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>, root:UnsafeMutablePointer<yyjson_mut_val>) {
		self.doc = doc
		self.root = root
		self.count = 0
	}

	/// append a null value into the container
	internal mutating func encodeNil() throws {
		let newVal = yyjson_mut_null(doc)
		guard newVal != nil else {
			throw Encoder.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoder.Error.assignmentError
		}
		self.count += 1
	}

	/// append a bool value into the container
	internal mutating func encode(_ value:Bool) throws {
		let newVal = yyjson_mut_bool(doc, value)
		guard newVal != nil else {
			throw Encoder.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoder.Error.assignmentError
		}
		self.count += 1
	}

	/// append a nested keyed container into the container
	internal mutating func nestedContainer<NestedKey>(keyedBy keyType:NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey :CodingKey {
		let newObj = yyjson_mut_obj(doc)!
		assert(yyjson_mut_arr_append(self.root, newObj) == true)
		self.count += 1
		return KeyedEncodingContainer(ec_keyed(doc:doc, root:newObj))
	}

	/// append a nested unkeyed container into the container
	internal mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
		let newArr = yyjson_mut_arr(doc)!
		assert(yyjson_mut_arr_append(self.root, newArr) == true)
		self.count += 1
		return ec_unkeyed(doc:doc, root:newArr)
	}

	/// append a codable value into the container
	internal mutating func encode<T>(_ value:T) throws where T :Encodable {
		do {
			try value.encode(to:encoder_from_unkeyed_container(doc:doc, arr:self.root))
			self.count += 1
		} catch let error {
			throw error
		}
    }

	/// append a string value into the container
	internal mutating func encode(_ value:String) throws {
		let newVal = yyjson_mut_strncpy(doc, value, value.utf8.count)
		guard newVal != nil else {
			throw Encoder.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoder.Error.assignmentError
		}
		self.count += 1
	}

	/// append a double value into the container
	internal mutating func encode(_ value:Double) throws {
		let newVal = yyjson_mut_real(doc, value)
		guard newVal != nil else {
			throw Encoder.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoder.Error.assignmentError
		}
		self.count += 1
	}

	/// append a float value into the container
	internal mutating func encode(_ value:Float) throws {
		let newVal = yyjson_mut_real(doc, Double(value))
		guard newVal != nil else {
			throw Encoder.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoder.Error.assignmentError
		}
		self.count += 1
	}

	/// append an int value into the container
	internal mutating func encode(_ value:Int) throws {
		let newVal = yyjson_mut_int(doc, Int64(value))
		guard newVal != nil else {
			throw Encoder.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoder.Error.assignmentError
		}
		self.count += 1
	}

	/// append an int8 value into the container
	internal mutating func encode(_ value:Int8) throws {
		let newVal = yyjson_mut_int(doc, Int64(value))
		guard newVal != nil else {
			throw Encoder.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoder.Error.assignmentError
		}
		self.count += 1
	}

	/// append an int16 value into the container
	internal mutating func encode(_ value:Int16) throws {
		let newVal = yyjson_mut_int(doc, Int64(value))
		guard newVal != nil else {
			throw Encoder.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoder.Error.assignmentError
		}
		self.count += 1
	}

	/// append an int32 value into the container
	internal mutating func encode(_ value:Int32) throws {
		let newVal = yyjson_mut_int(doc, Int64(value))
		guard newVal != nil else {
			throw Encoder.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoder.Error.assignmentError
		}
		self.count += 1
	}

	/// append an int64 value into the container
	internal mutating func encode(_ value:Int64) throws {
		let newVal = yyjson_mut_int(doc, value)
		guard newVal != nil else {
			throw Encoder.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoder.Error.assignmentError
		}
		self.count += 1
	}

	/// append a uint value into the container
	internal mutating func encode(_ value:UInt) throws {
		let newVal = yyjson_mut_uint(doc, UInt64(value))
		guard newVal != nil else {
			throw Encoder.Error.assignmentError
		}
		guard yyjson_mut_arr_append(root, newVal) == true else {
			throw Encoder.Error.assignmentError
		}
		self.count += 1
	}

	/// append a uint8 value into the container
	internal mutating func encode(_ value:UInt8) throws {
		let newVal = yyjson_mut_uint(doc, UInt64(value))
		guard newVal != nil else {
			throw Encoder.Error.assignmentError
		}
		guard yyjson_mut_arr_append(self.root, newVal) == true else {
			throw Encoder.Error.assignmentError
		}
		self.count += 1
	}

	/// append a uint16 value into the container
	internal mutating func encode(_ value:UInt16) throws {
		let newVal = yyjson_mut_uint(doc, UInt64(value))
		guard newVal != nil else {
			throw Encoder.Error.assignmentError
		}
		guard yyjson_mut_arr_append(self.root, newVal) == true else {
			throw Encoder.Error.assignmentError
		}
		self.count += 1
	}

	/// append a uint32 value into the container
	internal mutating func encode(_ value:UInt32) throws {
		let newVal = yyjson_mut_uint(doc, UInt64(value))
		guard newVal != nil else {
			throw Encoder.Error.assignmentError
		}
		guard yyjson_mut_arr_append(self.root, newVal) == true else {
			throw Encoder.Error.assignmentError
		}
		self.count += 1
	}

	/// append a uint64 value into the container
	internal mutating func encode(_ value:UInt64) throws {
		let newVal = yyjson_mut_uint(doc, value)
		guard newVal != nil else {
			throw Encoder.Error.assignmentError
		}
		guard yyjson_mut_arr_append(self.root, newVal) == true else {
			throw Encoder.Error.assignmentError
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