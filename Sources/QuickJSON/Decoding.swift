// (c) tanner silva 2023. all rights reserved.
import yyjson

#if QUICKJSON_SHOULDLOG
import Logging
#endif

/// decode an explicit type from a json document
/// - parameters:
///		- type: the type of the value to decode
///		- bytes: the json document to decode
///		- flags: the decoding flags to use
///		- memconfig: the memory configuration to use
/// - returns: the decoded value
/// - throws: throws an error if the document could not be parsed, or if the root of the document could not be found.
public func decode<T:Decodable>(_ type:T.Type, bytes:UnsafeMutableRawBufferPointer, flags:Decoding.Flags = Decoding.Flags(), memory memconfig:Memory.Configuration = .automatic) throws -> T {
	var errorinfo = yyjson_read_err()
	let yyjsonDoc:UnsafeMutablePointer<yyjson_doc>?
	switch memconfig {
		case .automatic:
			yyjsonDoc = yyjson_read_opts(bytes.baseAddress, bytes.count, flags.rawValue, nil, &errorinfo)
		case .preallocated(let region):
			yyjsonDoc = region.expose { (alc) -> UnsafeMutablePointer<yyjson_doc>? in
				return yyjson_read_opts(bytes.baseAddress, bytes.count, flags.rawValue, &alc, &errorinfo)
			}
	}
	guard yyjsonDoc != nil && errorinfo.code == 0 else {
		throw Decoding.Error.documentParseError(Decoding.Error.ParseInfo(readInfo:errorinfo))
	}
	defer {
		yyjson_doc_free(yyjsonDoc)
	}
	let getRoot = yyjson_doc_get_root(yyjsonDoc)
	guard getRoot != nil else {
		throw Decoding.Error.documentRootError
	}
	return try T(from:decoder(root:getRoot!))
}

/// decode a value from a json document using a handler function. the handler function allows for more flexible decoding, such as decoding into a custom type or performing additional processing on the decoded value without tieing it to a specific type.
/// - parameters:
///		- bytes: the json document to decode
///		- flags: the decoding flags to use
///		- memconfig: the memory configuration to use
///		- handlerFunc: the function to call with the decoded value. this function should take a `Swift.Decoder` and return a value of type `R`.
/// - returns: the value returned by the handler function
public func decode<R>(bytes:UnsafeMutableRawBufferPointer, flags:Decoding.Flags = Decoding.Flags(), memory memconfig:Memory.Configuration = .automatic, _ handlerFunc:(Swift.Decoder) throws -> R) throws -> R {
	var errorinfo = yyjson_read_err()
	let yyjsonDoc:UnsafeMutablePointer<yyjson_doc>?
	switch memconfig {
		case .automatic:
			yyjsonDoc = yyjson_read_opts(bytes.baseAddress, bytes.count, flags.rawValue, nil, &errorinfo)
		case .preallocated(let region):
			yyjsonDoc = region.expose { (alc) -> UnsafeMutablePointer<yyjson_doc>? in
				return yyjson_read_opts(bytes.baseAddress, bytes.count, flags.rawValue, &alc, &errorinfo)
			}
	}
	guard yyjsonDoc != nil && errorinfo.code == 0 else {
		throw Decoding.Error.documentParseError(Decoding.Error.ParseInfo(readInfo:errorinfo))
	}
	defer {
		yyjson_doc_free(yyjsonDoc)
	}
	let getRoot = yyjson_doc_get_root(yyjsonDoc)
	guard getRoot != nil else {
		throw Decoding.Error.documentRootError
	}
	return try handlerFunc(decoder(root:getRoot!))
}

/// namespace related to decoding.
public struct Decoding {
	/// errors that can be thrown by the decoder
	public enum Error:Swift.Error, CustomDebugStringConvertible {
		/// thrown by an unkeyed decoding container when the bounds of the container have been exceeded
		case contentOverflow
		/// thrown when the decoder encounters a value that is not the type that was expected
		case valueTypeMismatch(ValueTypeMismatchInfo)
		/// additional information about the value type mismatch error
		public struct ValueTypeMismatchInfo:Sendable {
			public let expected:ValueType
			public let found:ValueType
			internal init(expected:ValueType, found:ValueType) {
				self.expected = expected
				self.found = found
			}
		}
		/// the key could not be found
		case notFound(String)
		/// the root of the document could not be found
		case documentParseError(ParseInfo)
		/// detailed information about a parse error
		public struct ParseInfo:Sendable {
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

	#if QUICKJSON_SHOULDLOG
	/// the default logger for any decoding operation. this may be replaced with a custom logger before operating quickjson.
	/// - note: this logger is only used if `QUICKJSON_SHOULDLOG` is defined.	
	public static let logger = makeDefaultLogger(label:"com.tannersilva.quickjson.decoding", logLevel:.debug)
	#endif

	/// option flags for the decoder
	public struct Flags:OptionSet, Sendable {
		public let rawValue:UInt32
		public init(rawValue:UInt32 = 0) { self.rawValue = rawValue }
		public static let inSitu = Flags(rawValue:YYJSON_READ_INSITU)
		public static let stopWhenDone = Flags(rawValue:YYJSON_READ_STOP_WHEN_DONE)
		public static let allowTrailingCommas = Flags(rawValue:YYJSON_READ_ALLOW_TRAILING_COMMAS)
		public static let allowComments = Flags(rawValue:YYJSON_READ_ALLOW_COMMENTS)
		public static let allowInfAndNaN = Flags(rawValue:YYJSON_READ_ALLOW_INF_AND_NAN)
		public static let allowInvalidUnicode = Flags(rawValue:YYJSON_READ_ALLOW_INVALID_UNICODE)
	}

	// nothing to see here
	private init() {}
}

extension Decoding.Flags:CustomDebugStringConvertible {
	/// a description of the flags
	public var debugDescription:String {
		var components:[String] = []
		if contains(.inSitu) {
			components.append("inSitu")
		}
		if contains(.stopWhenDone) {
			components.append("stopWhenDone")
		}
		if contains(.allowTrailingCommas) {
			components.append("allowTrailingCommas")
		}
		if contains(.allowComments) {
			components.append("allowComments")
		}
		if contains(.allowInfAndNaN) {
			components.append("allowInfAndNaN")
		}
		if contains(.allowInvalidUnicode) {
			components.append("allowInvalidUnicode")
		}
		return "QuickJSON.Decoding.Flags(" + components.joined(separator:", ") + ")"
	}
}

extension Decoding.Error {
	/// a description of the error
	public var debugDescription:String {
		switch self {
			case .contentOverflow:
				return "QuickJSON.Decoding.Error.contentOverflow"
			case .valueTypeMismatch(let info):
				return "QuickJSON.Decoding.Error.valueTypeMismatch(expected: \(info.expected), found: \(info.found))"
			case .notFound(let key):
				return "QuickJSON.Decoding.Error.notFound(key:\(key))"
			case .documentParseError(let info):
				return "QuickJSON.Decoding.Error.documentParseError(error: \(info.error), offset: \(info.offset), code: \(info.code))"
			case .documentRootError:
				return "QuickJSON.Decoding.Error.documentRootError"
		}
	}
}