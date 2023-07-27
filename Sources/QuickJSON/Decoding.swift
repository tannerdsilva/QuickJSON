// (c) tanner silva 2023. all rights reserved.
import yyjson

#if QUICKJSON_SHOULDLOG
import Logging
#endif

// MARK: Decoding Data
#if QUICKJSON_SHOULDLOG
/// decode an unknown type from a json document using a specified handler function.
public func decode<T:Decodable, R>(
	data:UnsafeRawPointer, size:size_t,
	flags:Decoding.Flags = Decoding.Flags(),
	memory memconfig:Memory.Configuration = .automatic,
	logLevel:Logging.Logger.Level = .critical,
	_ handlerFunc:(Swift.Decoder) throws -> R
) throws -> R {
	var errorinfo = yyjson_read_err()
	let yyjsonDoc:UnsafeMutablePointer<yyjson_doc>?
	switch memconfig {
		case .automatic:
		yyjsonDoc = yyjson_read_opts(UnsafeMutableRawPointer(mutating:data), size, flags.rawValue, nil, &errorinfo)
		case .preallocated(let region):
		yyjsonDoc = region.expose { (alc) -> UnsafeMutablePointer<yyjson_doc>? in
			return yyjson_read_opts(UnsafeMutableRawPointer(mutating:data), size, flags.rawValue, &alc, &errorinfo)
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
	return try handlerFunc(decoder(root:getRoot!, logLevel:logLevel))
}
#else
/// decode an unknown type from a json document using a specified handler function.
public func decode<R>(
	data:UnsafeRawPointer, size:size_t,
	flags:Decoding.Flags = Decoding.Flags(),
	memory memconfig:Memory.Configuration = .automatic,
	_ handlerFunc:(Swift.Decoder) throws -> R
) throws -> R {
	var errorinfo = yyjson_read_err()
	let yyjsonDoc:UnsafeMutablePointer<yyjson_doc>?
	switch memconfig {
		case .automatic:
		yyjsonDoc = yyjson_read_opts(UnsafeMutableRawPointer(mutating:data), size, flags.rawValue, nil, &errorinfo)
		case .preallocated(let region):
		yyjsonDoc = region.expose { (alc) -> UnsafeMutablePointer<yyjson_doc>? in
			return yyjson_read_opts(UnsafeMutableRawPointer(mutating:data), size, flags.rawValue, &alc, &errorinfo)
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
#endif

#if QUICKJSON_SHOULDLOG
/// decode a value from a json document
/// - parameter type: the type of the value to decode
/// - parameter data: the pointer to the json document to decode
/// - parameter flags: decoding option flags
public func decode<T:Decodable>(
	_ type:T.Type, 
	from data:UnsafeRawPointer, size:size_t, 
	flags:Decoding.Flags = Decoding.Flags(), 
	memory memconfig:Memory.Configuration = .automatic, 
	logLevel:Logging.Logger.Level = .critical
) throws -> T {
	var errorinfo = yyjson_read_err()
	let yyjsonDoc:UnsafeMutablePointer<yyjson_doc>?
	switch memconfig {
		case .automatic:
		yyjsonDoc = yyjson_read_opts(UnsafeMutableRawPointer(mutating:data), size, flags.rawValue, nil, &errorinfo)
		case .preallocated(let region):
		yyjsonDoc = region.expose { (alc) -> UnsafeMutablePointer<yyjson_doc>? in
			return yyjson_read_opts(UnsafeMutableRawPointer(mutating:data), size, flags.rawValue, &alc, &errorinfo)
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
	return try T(from:decoder(root:getRoot!, logLevel:logLevel))
}
#else
/// decode a value from a json document
/// - parameter type: the type of the value to decode
/// - parameter data: the pointer to the json document to decode
/// - parameter flags: decoding option flags
public func decode<T:Decodable>(
	_ type:T.Type, 
	from data:UnsafeRawPointer, 
	size:size_t, 
	flags:Decoding.Flags = Decoding.Flags(), 
	memory memconfig:Memory.Configuration = .automatic
) throws -> T {
	var errorinfo = yyjson_read_err()
	let yyjsonDoc:UnsafeMutablePointer<yyjson_doc>?
	switch memconfig {
		case .automatic:
		yyjsonDoc = yyjson_read_opts(UnsafeMutableRawPointer(mutating:data), size, flags.rawValue, nil, &errorinfo)
		case .preallocated(let region):
		yyjsonDoc = region.expose { (alc) -> UnsafeMutablePointer<yyjson_doc>? in
			return yyjson_read_opts(UnsafeMutableRawPointer(mutating:data), size, flags.rawValue, &alc, &errorinfo)
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
#endif
/// namespace related to decoding.
public struct Decoding {
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

	#if QUICKJSON_SHOULDLOG
	/// the default logger for any decoding operation. this may be replaced with a custom logger before operating quickjson.
	/// - note: this logger is only used if `QUICKJSON_SHOULDLOG` is defined.	
	public static var logger = makeDefaultLogger(label:"com.tannersilva.quickjson.decoding", logLevel:.debug)
	#endif

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

	// nothing to see here
	private init() {}
}