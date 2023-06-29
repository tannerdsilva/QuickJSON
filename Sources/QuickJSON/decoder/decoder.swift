// (c) tanner silva 2023. all rights reserved.
import yyjson

public class Decoder {
	private var memory:MemoryPool? = nil
	
	/// create a new decoder.
	/// - parameter memory:the memory pool that this decoder will use. _**note**_:if no memory pool is provided, the decoder will use the default memory pool.
	public init(memory:MemoryPool? = nil) {
		self.memory = memory
	}

	/// decode a value from a json document
	/// - parameter type: the type of the value to decode
	/// - parameter data: the pointer to the json document to decode
	/// - parameter flags: decoding option flags
	public func decode<T:Decodable>(_ type:T.Type, from data:UnsafeRawPointer, size:size_t, flags:Flags = Flags()) throws -> T {
		var errorinfo = yyjson_read_err()
		let yyjsonDoc:UnsafeMutablePointer<yyjson_doc>? 
		if memory == nil {
			yyjsonDoc = yyjson_read_opts(UnsafeMutableRawPointer(mutating:data), size, 0, nil, &errorinfo)
		} else {
			yyjsonDoc = yyjson_read_opts(UnsafeMutableRawPointer(mutating:data), size, 0, &self.memory!, &errorinfo)
		}
		guard yyjsonDoc != nil && errorinfo.code == 0 else {
			throw Decoder.Error.documentParseError(Decoder.Error.ParseInfo(readInfo:errorinfo))
		}
		defer {
			yyjson_doc_free(yyjsonDoc)
		}
		let getRoot = yyjson_doc_get_root(yyjsonDoc)
		guard getRoot != nil else {
			throw Decoder.Error.documentRootError
		}
		let decoder = decoder(root:getRoot!)
		return try T(from:decoder)
	}
	
	/// decode a value from a json document
	/// - parameter type: the type of the value to decode
	/// - parameter data: the byte array to decode
	/// - parameter flags: decoding option flags
	public func decode<T:Decodable>(_ type:T.Type, from data:[UInt8], flags:Flags = Flags()) throws -> T {
		return try data.withUnsafeBytes { rawBufferPointer -> T in
			let bufferPointer = rawBufferPointer.bindMemory(to:CChar.self)
			var errorinfo = yyjson_read_err()
			let yyjsonDoc:UnsafeMutablePointer<yyjson_doc>?
			if memory == nil {
				yyjsonDoc = yyjson_read_opts(UnsafeMutableRawPointer(mutating:bufferPointer.baseAddress!), size_t(bufferPointer.count), 0, nil, &errorinfo)
			} else {
				yyjsonDoc = yyjson_read_opts(UnsafeMutableRawPointer(mutating:bufferPointer.baseAddress!), size_t(bufferPointer.count), 0, &self.memory!, &errorinfo)
			}
			guard yyjsonDoc != nil && errorinfo.code == 0 else {
				throw Decoder.Error.documentParseError(Decoder.Error.ParseInfo(readInfo:errorinfo))
			}
			defer {
				yyjson_doc_free(yyjsonDoc)
			}
			let getRoot = yyjson_doc_get_root(yyjsonDoc)
			guard getRoot != nil else {
				throw Decoder.Error.documentRootError
			}
			let decoder = decoder(root:getRoot!)
			return try T(from:decoder)
		}
	}
}

extension Decoder {
	/// errors that can be thrown by the decoder
	public enum Error:Swift.Error {
		/// thrown by an unkeyed decoding container when the bounds of the container have been exceeded
		case contentOverflow

		/// thrown when the decoder encounters a value that is not the type that was expected
		case valueTypeMismatch(ValueTypeMismatchInfo)
		
		/// additional information about the value type mismatch error
		public struct ValueTypeMismatchInfo {
			public let expected:ValueType
			public let found:ValueType
			internal init(expected:ValueType, found:ValueType) {
				self.expected = expected
				self.found = found
			}
		}

		/// the key could not be found
		case notFound

		/// the root of the document could not be found
		case documentParseError(ParseInfo)
		/// detailed information about a parse error
		public struct ParseInfo {
			/// description of the error
			let error:String
			/// the buffer offset where the error occurred
			let offset:size_t
			/// the error code
			let code:UInt32
			internal init(writeInfo errorInfo:yyjson_write_err) {
				self.error = String(cString:errorInfo.msg)
				self.offset = 0
				self.code = errorInfo.code
			}
			internal init(readInfo errorInfo:yyjson_read_err) {
				self.error = String(cString:errorInfo.msg)
				self.offset = errorInfo.pos
				self.code = errorInfo.code
			}
		}

		/// the root value, object, or array of the document could not be found 
		case documentRootError
	}

	/// option flags for the decoder
	public struct Flags:OptionSet {
		public let rawValue:UInt32
		public init(rawValue:UInt32 = 0) { self.rawValue = rawValue }
		public static let inSitu = Flags(rawValue:YYJSON_READ_INSITU)
		public static let stopWhenDone = Flags(rawValue:YYJSON_READ_STOP_WHEN_DONE)
		public static let allowTrailingCommas = Flags(rawValue:YYJSON_READ_ALLOW_TRAILING_COMMAS)
		public static let allowComments = Flags(rawValue:YYJSON_READ_ALLOW_COMMENTS)
		public static let allowInfAndNaN = Flags(rawValue:YYJSON_READ_ALLOW_INF_AND_NAN)
		public static let allowInvalidUnicode = Flags(rawValue:YYJSON_READ_ALLOW_INVALID_UNICODE)
	}
}

internal struct decoder:Swift.Decoder {
	/// the root object for the json document
	private var root:UnsafeMutablePointer<yyjson_val>
	/// initialize a new decoder from a root json object
	internal init(root:UnsafeMutablePointer<yyjson_val>) {
		self.root = root
	}

	/// retrieve the keyed container for this decoder
	internal func container<Key>(keyedBy type:Key.Type) throws -> KeyedDecodingContainer<Key> where Key:CodingKey {
		return try KeyedDecodingContainer(dc_keyed<Key>(root:root))
	}

	/// retrieve the unkeyed container for this decoder
	internal func unkeyedContainer() throws -> UnkeyedDecodingContainer {
		return try dc_unkeyed(root:root)
	}

	/// retrieve the single value container for this decoder
	internal func singleValueContainer() throws -> SingleValueDecodingContainer {
		return dc_single(root:root)
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