// (c) tanner silva 2023. all rights reserved.
import yyjson

internal struct ec_keyed<K>:Swift.KeyedEncodingContainerProtocol where K:CodingKey {
	internal typealias Key = K

	/// the document that this container is writing to
	private let doc:UnsafeMutablePointer<yyjson_mut_doc>
	/// the current keyed encoding container
	private let root:UnsafeMutablePointer<yyjson_mut_val>

	/// initializes a new keyed container
	/// - parameter doc: the document that this container is writing to
	/// - parameter root: the root object of the json document. this is where the container will write its keys and values to.
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>, root:UnsafeMutablePointer<yyjson_mut_val>) {
		self.doc = doc
		self.root = root
	}

	/// encode a null value for the given key
	internal func encodeNil(forKey key:K) throws {
		let key = key.stringValue.withCString { (cstr) in
			return yyjson_mut_strncpy(doc, cstr, key.stringValue.utf8.count)!
		}
		let makeNull = yyjson_mut_null(doc)
		guard yyjson_mut_obj_put(root, key, makeNull) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode a boolean value for the given key
	internal func encode(_ value:Bool, forKey key:K) throws {
		let key = key.stringValue.withCString { (cstr) in
			return yyjson_mut_strncpy(doc, cstr, key.stringValue.utf8.count)!
		}
		let makeBool = yyjson_mut_bool(doc, value)
		guard yyjson_mut_obj_put(root, key, makeBool) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal func encode(_ value:String, forKey key:K) throws {
		let key = key.stringValue.withCString { (cstr) in
			return yyjson_mut_strncpy(doc, cstr, key.stringValue.utf8.count)!
		}
		let makeString = yyjson_mut_strncpy(doc, value, value.utf8.count)
		guard yyjson_mut_obj_put(root, key, makeString) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode a double value for the given key
	internal func encode(_ value:Double, forKey key:K) throws {
		let key = key.stringValue.withCString { (cstr) in
			return yyjson_mut_strncpy(doc, cstr, key.stringValue.utf8.count)!
		}
		let makeDouble = yyjson_mut_real(doc, value)
		guard yyjson_mut_obj_put(root, key, makeDouble) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode a float value for the given key
	internal func encode(_ value:Float, forKey key:K) throws {
		let key = key.stringValue.withCString { (cstr) in
			return yyjson_mut_strncpy(doc, cstr, key.stringValue.utf8.count)!
		}
		let makeFloat = yyjson_mut_real(doc, Double(value))
		guard yyjson_mut_obj_put(root, key, makeFloat) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal func encode(_ value:Int, forKey key:K) throws {
		let key = key.stringValue.withCString { (cstr) in
			return yyjson_mut_strncpy(doc, cstr, key.stringValue.utf8.count)!
		}
		let makeInt = yyjson_mut_int(doc, Int64(value))
		guard yyjson_mut_obj_put(root, key, makeInt) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal func encode(_ value:Int8, forKey key:K) throws {
		let key = key.stringValue.withCString { (cstr) in
			return yyjson_mut_strncpy(doc, cstr, key.stringValue.utf8.count)!
		}
		let makeInt8 = yyjson_mut_int(doc, Int64(value))
		guard yyjson_mut_obj_put(root, key, makeInt8) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal func encode(_ value:Int16, forKey key:K) throws {
		let key = key.stringValue.withCString { (cstr) in
			return yyjson_mut_strncpy(doc, cstr, key.stringValue.utf8.count)!
		}
		let makeInt16 = yyjson_mut_int(doc, Int64(value))
		guard yyjson_mut_obj_put(root, key, makeInt16) == true else {
			throw Encoder.Error.assignmentError
		}

	}

	/// encode an integer value for the given key
	internal func encode(_ value:Int32, forKey key:K) throws {
		let key = key.stringValue.withCString { (cstr) in
			return yyjson_mut_strncpy(doc, cstr, key.stringValue.utf8.count)!
		}
		let makeInt32 = yyjson_mut_int(doc, Int64(value))
		guard yyjson_mut_obj_put(root, key, makeInt32) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal func encode(_ value:Int64, forKey key:K) throws {
		let key = key.stringValue.withCString { (cstr) in
			return yyjson_mut_strncpy(doc, cstr, key.stringValue.utf8.count)!
		}
		let makeInt64 = yyjson_mut_int(doc, Int64(value))
		guard yyjson_mut_obj_put(root, key, makeInt64) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal func encode(_ value:UInt, forKey key:K) throws {
		let key = key.stringValue.withCString { (cstr) in
			return yyjson_mut_strncpy(doc, cstr, key.stringValue.utf8.count)!
		}
		let makeUInt = yyjson_mut_uint(doc, UInt64(value))
		guard yyjson_mut_obj_put(root, key, makeUInt) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal func encode(_ value:UInt8, forKey key:K) throws {
		let key = key.stringValue.withCString { (cstr) in
			return yyjson_mut_strncpy(doc, cstr, key.stringValue.utf8.count)!
		}
		let makeUInt8 = yyjson_mut_uint(doc, UInt64(value))
		guard yyjson_mut_obj_put(root, key, makeUInt8) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal func encode(_ value:UInt16, forKey key:K) throws {
		let key = key.stringValue.withCString { (cstr) in
			return yyjson_mut_strncpy(doc, cstr, key.stringValue.utf8.count)!
		}
		let makeUInt16 = yyjson_mut_uint(doc, UInt64(value))
		guard yyjson_mut_obj_put(root, key, makeUInt16) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal func encode(_ value:UInt32, forKey key:K) throws {
		let key = key.stringValue.withCString { (cstr) in
			return yyjson_mut_strncpy(doc, cstr, key.stringValue.utf8.count)!
		}
		let makeUInt32 = yyjson_mut_uint(doc, UInt64(value))
		guard yyjson_mut_obj_put(root, key, makeUInt32) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode an integer value for the given key
	internal func encode(_ value:UInt64, forKey key:K) throws {
		let key = key.stringValue.withCString { (cstr) in
			return yyjson_mut_strncpy(doc, cstr, key.stringValue.utf8.count)!
		}
		let makeUInt64 = yyjson_mut_uint(doc, UInt64(value))
		guard yyjson_mut_obj_put(root, key, makeUInt64) == true else {
			throw Encoder.Error.assignmentError
		}
	}

	/// encode a float value for the given key
	internal func encode<T>(_ value:T, forKey inputKey:K) throws where T :Encodable {
		let key = inputKey.stringValue.withCString { (cstr) in
			return yyjson_mut_strncpy(doc, cstr, inputKey.stringValue.utf8.count)!
		}
		try value.encode(to:encoder_from_keyed_container(doc:doc, obj:root, assignKey:key, codingPath:codingPath + [inputKey]))
	}

	/// returns a keyed container for the given key
	internal func nestedContainer<NestedKey>(keyedBy keyType:NestedKey.Type, forKey inputKey:K) -> KeyedEncodingContainer<NestedKey> where NestedKey :CodingKey {
		let newObj = yyjson_mut_obj(doc)!
		assert(yyjson_mut_arr_append(self.root, newObj) == true)
		return KeyedEncodingContainer(ec_keyed<NestedKey>(doc:doc, root:newObj))
	}

	/// returns an unkeyed container for the given key
	internal func nestedUnkeyedContainer(forKey inputKey:K) -> UnkeyedEncodingContainer {
		let key = inputKey.stringValue.withCString { (cstr) in
			return yyjson_mut_strncpy(doc, cstr, inputKey.stringValue.utf8.count)!
		}
		let makeNestedUnkeyedContainer = yyjson_mut_arr(doc)!
		assert(yyjson_mut_obj_put(root, key, makeNestedUnkeyedContainer) == true)
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

