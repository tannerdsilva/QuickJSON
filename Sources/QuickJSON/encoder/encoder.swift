// (c) tanner silva 2023. all rights reserved.
import yyjson

/// this is the public interface for the json encoder
/// - note: this struct is NOT thread safe, and is meant for serialized use only.
public struct Encoder {
	/// errors that may occurr during encoding
	public enum Error:Swift.Error {
		/// the value could not be assigned
		case assignmentError

		/// memory allocation failed
		case memoryAllocationFailure
	}

	/// the memory pool that this encoder will use.
	private var memory:MemoryPool? = nil

	/// create a new encoder.
	/// - parameter memory: the memory pool that this encoder will use. _**note**_:if no memory pool is provided, the encoder will use the default memory pool.
	public init(_ memory:MemoryPool? = nil) {
		self.memory = memory
	}

	/// encode an object into a json-based byte encoding. 
	public func encode<T:Encodable>(_ object:T, flags:Flags = Flags()) throws -> [UInt8] {
		let newDoc = yyjson_mut_doc_new(nil)
		guard newDoc != nil else {
			throw Error.memoryAllocationFailure
		}
		defer {
			yyjson_mut_doc_free(newDoc)
		}
		try object.encode(to:encoder_from_root(doc:newDoc!))
		var outLen = 0
		var errInfo = yyjson_write_err()
		let outputDat:UnsafeMutablePointer<CChar>?
		if self.memory == nil {
			outputDat = yyjson_mut_write_opts(newDoc, flags.rawValue, nil, &outLen, &errInfo)
		} else {
			outputDat = withUnsafePointer(to:self.memory!) { memBod in
				return yyjson_mut_write_opts(newDoc, flags.rawValue, memBod, &outLen, &errInfo)
			}
		}
		guard outputDat != nil && errInfo.code == 0 else {
			throw Error.memoryAllocationFailure
		}
		defer {
			free(outputDat)
		}
		return Array(UnsafeBufferPointer(start:outputDat!.withMemoryRebound(to:UInt8.self, capacity:outLen, { $0 }), count:outLen)) + [0 as UInt8]
	}
}

extension Encoder {
	public struct Flags:OptionSet {
		public let rawValue:UInt32
		public init(rawValue:UInt32 = 0) { self.rawValue = rawValue }
		public static let pretty = Flags(rawValue:YYJSON_WRITE_PRETTY)
		public static let escapeUnicode = Flags(rawValue:YYJSON_WRITE_ESCAPE_UNICODE)
		public static let escapeSlashes = Flags(rawValue:YYJSON_WRITE_ESCAPE_SLASHES)
		public static let allowInfAndNan = Flags(rawValue:YYJSON_WRITE_ALLOW_INF_AND_NAN)
		public static let infAndNanAsNull = Flags(rawValue:YYJSON_WRITE_INF_AND_NAN_AS_NULL)
		public static let allowInvalidUnicode = Flags(rawValue:YYJSON_WRITE_ALLOW_INVALID_UNICODE)
		public static let prettyTwoSpaces = Flags(rawValue:YYJSON_WRITE_PRETTY_TWO_SPACES)
	}

}

/// encoder from root
internal struct encoder_from_root:Swift.Encoder {
	/// the root object of the json document
	private let doc:UnsafeMutablePointer<yyjson_mut_doc>
	
	/// internal initializer
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>) {
		self.doc = doc
	}

	/// retrieve a keyed container for this encoder
	internal func container<Key>(keyedBy type:Key.Type) -> KeyedEncodingContainer<Key> where Key :CodingKey {
		let getObject = yyjson_mut_obj(doc)!
		yyjson_mut_doc_set_root(doc, getObject)
		return KeyedEncodingContainer(ec_keyed(doc:self.doc, root:getObject))
	}

	/// retrieve a unkeyed container for this encoder
	internal func unkeyedContainer() -> UnkeyedEncodingContainer {
		let getObject = yyjson_mut_arr(doc)!
		yyjson_mut_doc_set_root(doc, getObject)
		return ec_unkeyed(doc:self.doc, root:getObject)
	}

	/// retrieve the single value container for this encoder
	internal func singleValueContainer() -> SingleValueEncodingContainer {
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
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>, arr:UnsafeMutablePointer<yyjson_mut_val>) {
		self.doc = doc
		self.arr = arr
	}

	/// retrieve a keyed container for this encoder
	internal func container<Key>(keyedBy type:Key.Type) -> KeyedEncodingContainer<Key> where Key :CodingKey {
		// create the new key-value container
		let newObject = yyjson_mut_obj(doc)!

		// append the container to the parent
		yyjson_mut_arr_append(arr, newObject)

		return KeyedEncodingContainer(ec_keyed(doc:doc, root:newObject))
	}

	/// retrieve an unkeyed container for this encoder
	internal func unkeyedContainer() -> UnkeyedEncodingContainer {
		// create the array container
		let newObject = yyjson_mut_arr(doc)!

		// append the container to the parent
		yyjson_mut_arr_append(arr, newObject)

		return ec_unkeyed(doc:doc, root:newObject)
	}

	/// retrieve the single value container for this encoder
	internal func singleValueContainer() -> SingleValueEncodingContainer {
		return ec_single_from_unkeyed_container(doc:doc, arr:arr)
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
	
	internal init(doc:UnsafeMutablePointer<yyjson_mut_doc>, obj:UnsafeMutablePointer<yyjson_mut_val>, assignKey:UnsafeMutablePointer<yyjson_mut_val>, codingPath:[CodingKey] = []) {
		self.doc = doc
		self.obj = obj
		self.assignKey = assignKey
	}

	/// retrieve a keyed container for this encoder
	internal func container<Key>(keyedBy type:Key.Type) -> KeyedEncodingContainer<Key> where Key:CodingKey {
		// create the new key-value container
		let newObject = yyjson_mut_obj(doc)!

		// append the container to the parent
		yyjson_mut_obj_put(obj, assignKey, newObject)

		return KeyedEncodingContainer(ec_keyed(doc:doc, root:newObject))
	}

	/// retrieve an unkeyed container for this encoder
	internal func unkeyedContainer() -> UnkeyedEncodingContainer {
		// create the array container
		let newObject = yyjson_mut_arr(doc)!

		// append the container to the parent
		yyjson_mut_obj_put(obj, assignKey, newObject)

		return ec_unkeyed(doc:doc, root:newObject)
	}

	/// retrieve the single value container for this encoder
	internal func singleValueContainer() -> SingleValueEncodingContainer {
		return ec_single_from_keyed_container(doc:doc, obj:obj, assignKey:assignKey)
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