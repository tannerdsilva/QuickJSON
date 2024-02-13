// (c) tanner silva 2023. all rights reserved.
import yyjson

#if QUICKJSON_SHOULDLOG
import Logging
#endif

#if QUICKJSON_SHOULDLOG
/// decode an unknown type from a json document using a specified handler function.
/// - parameters:
///		- byteArray: the bytes to decode
///		- flags: the decoding flags to use. default: no flags.
///		- memory: the memory configuration to use. default: automatic memory pool.
///		- logger: the logger to use to diagnose the decode.
///		- handlerFunc: the function to handle the parsing actions
public func decode<R>(
	_ byteArray:[UInt8],
	flags:Decoding.Flags = Decoding.Flags(),
	memory memconfig:Memory.Configuration = .automatic,
	logger immutableLoggerIn:Logger?,
	_ handlerFunc:(Swift.Decoder) throws -> R
) throws -> R {
	return try decode(ptr:byteArray, size:byteArray.count, flags:flags, memory:memconfig, logger:immutableLoggerIn, handlerFunc)
}
#else
/// decode an unknown type from a json document using a specified handler function.
/// - parameters:
///		- byteArray: the bytes to decode
///		- flags: the decoding flags to use. default: no flags.
///		- memory: the memory configuration to use. default: automatic memory pool.
///		- handlerFunc: the function to handle the parsing actions
public func decode<R>(
	_ byteArray:[UInt8],
	flags:Decoding.Flags = Decoding.Flags(),
	memory memconfig:Memory.Configuration = .automatic,
	_ handlerFunc:(Swift.Decoder) throws -> R
) throws -> R {
	return try decode(ptr:byteArray, size:byteArray.count, flags:flags, memory:memconfig, handlerFunc)
}
#endif

// MARK: Decode with Handler
#if QUICKJSON_SHOULDLOG

/// decode an unknown type from a json document using a specified handler function.
/// - parameters:
/// 	- ptr: a pointer to the bytes containing the json document to decode.
/// 	- size: the byte length of the json document.
/// 	- flags: the decoding flags to use. default: no flags.
/// 	- memory: the memory configuration to use. default: automatic memory pool.
/// 	- logger: the logger to use to diagnose the decode.
/// 	- handlerFunc: the function to handle the parsing actions
/// - returns: transparently returns the return value of the handler function
public func decode<R>(
	ptr immutableBytesIn:UnsafeRawPointer,
	size:size_t,
	flags:Decoding.Flags = Decoding.Flags(),
	memory memconfig:Memory.Configuration = .automatic,
	logger immutableLoggerIn:Logger?,
	_ handlerFunc:(Swift.Decoder) throws -> R
) throws -> R {
	// mutate the logger with info from the document
	var logger = immutableLoggerIn
	logger?[metadataKey:"did"] = "\(immutableBytesIn.hashValue)"
	logger?.debug("decoding json document of \(size) bytes")
	
	// cast the immutable pointer to a mutable pointer
	let bytes = UnsafeMutableRawPointer(mutating:immutableBytesIn)
	
	// initialize the json document based on the configured memory mode
	var errorinfo = yyjson_read_err()
	let yyjsonDoc:UnsafeMutablePointer<yyjson_doc>?
	switch memconfig {
		case .automatic:
			logger?.trace("using auto-allocated memory region")
			yyjsonDoc = yyjson_read_opts(bytes, size, flags.rawValue, nil, &errorinfo)
		case .preallocated(let region):
			logger?.trace("using preallocated memory region")
			yyjsonDoc = region.expose { (alc) -> UnsafeMutablePointer<yyjson_doc>? in
				return yyjson_read_opts(bytes, size, flags.rawValue, &alc, &errorinfo)
			}
	}
	guard yyjsonDoc != nil && errorinfo.code == 0 else {
		logger?.error("unable to initialize json document for parsing")
		throw Decoding.Error.documentParseError(Decoding.Error.ParseInfo(readInfo:errorinfo))
	}
	defer {
		yyjson_doc_free(yyjsonDoc)
	}
	let getRoot = yyjson_doc_get_root(yyjsonDoc)
	guard getRoot != nil else {
		logger?.error("unable to extract root element of json document.")
		throw Decoding.Error.documentRootError
	}
	logger?.trace("calling handler function")
	do {
		let retItem = try handlerFunc(decoder(root:getRoot!, logger:logger))
		logger?.trace("handler function return")
		return retItem
	} catch let error {
		logger?.debug("handler function threw", metadata:["error_thrown":"\(error)"])
		throw error
	}
}
#else
/// decode an unknown type from a json document using a specified handler function.
/// - parameters:
/// 	- ptr: a pointer to the bytes containing the json document to decode.
/// 	- size: the byte length of the json document.
/// 	- flags: the decoding flags to use. default: no flags.
/// 	- memory: the memory configuration to use. default: automatic memory pool.
/// 	- handlerFunc: the function to handle the parsing actions
/// - returns: transparently returns the return value of the handler function
public func decode<R>(
	ptr immutableBytesIn:UnsafeRawPointer,
	size:size_t,
	flags:Decoding.Flags = Decoding.Flags(),
	memory memconfig:Memory.Configuration = .automatic,
	_ handlerFunc:(Swift.Decoder) throws -> R
) throws -> R {
	// cast the immutable pointer to a mutable pointer
	let bytes = UnsafeMutableRawPointer(mutating:immutableBytesIn)
	
	// initialize the json document based on the configured memory mode
	var errorinfo = yyjson_read_err()
	let yyjsonDoc:UnsafeMutablePointer<yyjson_doc>?
	switch memconfig {
		case .automatic:
			yyjsonDoc = yyjson_read_opts(bytes, size, flags.rawValue, nil, &errorinfo)
		case .preallocated(let region):
			yyjsonDoc = region.expose { (alc) -> UnsafeMutablePointer<yyjson_doc>? in
				return yyjson_read_opts(bytes, size, flags.rawValue, &alc, &errorinfo)
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
	do {
		let retItem = try handlerFunc(decoder(root:getRoot!))
		return retItem
	} catch let error {
		throw error
	}
}
#endif


// MARK: Decode with Type
#if QUICKJSON_SHOULDLOG

/// decode a value from a json document
///	- parameters:
///		- type: the type of the value to decode
///		- ptr: the pointer to the json document to decode
///		- size: the size of the json document buffer
///		- flags: the decoding flags to use
///		- memory: the memory configuration to use
///		- logger: the log level to use for this job
///	- returns: the decoded value
public func decode<T:Decodable>(
	_ type:T.Type, 
	ptr immutableBytesIn:UnsafeRawPointer,
	size:size_t, 
	flags:Decoding.Flags = Decoding.Flags(), 
	memory memconfig:Memory.Configuration = .automatic, 
	logger immutableLoggerIn:Logging.Logger?
) throws -> T {
	// mutate the logger with info from the document
	var logger = immutableLoggerIn
	logger?[metadataKey:"did"] = "\(immutableBytesIn.hashValue)"
	logger?.debug("decoding json document of \(size) bytes")

	let bytes = UnsafeMutableRawPointer(mutating:immutableBytesIn)

	var errorinfo = yyjson_read_err()
	let yyjsonDoc:UnsafeMutablePointer<yyjson_doc>?
	switch memconfig {
		case .automatic:
			logger?.trace("using auto-allocated memory region")
			yyjsonDoc = yyjson_read_opts(bytes, size, flags.rawValue, nil, &errorinfo)
		case .preallocated(let region):
			logger?.trace("using preallocated memory region")
			yyjsonDoc = region.expose { (alc) -> UnsafeMutablePointer<yyjson_doc>? in
				return yyjson_read_opts(bytes, size, flags.rawValue, &alc, &errorinfo)
			}
	}
	guard yyjsonDoc != nil && errorinfo.code == 0 else {
		logger?.error("unable to initialize json document for parsing")
		throw Decoding.Error.documentParseError(Decoding.Error.ParseInfo(readInfo:errorinfo))
	}
	defer {
		yyjson_doc_free(yyjsonDoc)
	}
	let getRoot = yyjson_doc_get_root(yyjsonDoc)
	guard getRoot != nil else {
		logger?.error("unable to extract root element of json document")
		throw Decoding.Error.documentRootError
	}
	logger?.trace("decoding document for \(String(describing:T.self)) type")
	do {
		let retItem = try T(from:decoder(root:getRoot!, logger:logger))
		logger?.trace("decoding success")
		return retItem
	} catch let error {
		logger?.debug("decoding error", metadata:["error_thrown":"\(error)"])
		throw error
	}
}
#else
/// decode a value from a json document
///	- parameters:
///		- type: the type of the value to decode
///		- ptr: the pointer to the json document to decode
///		- size: the size of the json document buffer
///		- flags: the decoding flags to use
///		- memory: the memory configuration to use
///	- returns: the decoded value
public func decode<T:Decodable>(
	_ type:T.Type, 
	ptr immutableBytesIn:UnsafeRawPointer,
	size:size_t, 
	flags:Decoding.Flags = Decoding.Flags(), 
	memory memconfig:Memory.Configuration = .automatic
) throws -> T {
	let bytes = UnsafeMutableRawPointer(mutating:immutableBytesIn)

	var errorinfo = yyjson_read_err()
	let yyjsonDoc:UnsafeMutablePointer<yyjson_doc>?
	switch memconfig {
		case .automatic:
			yyjsonDoc = yyjson_read_opts(bytes, size, flags.rawValue, nil, &errorinfo)
		case .preallocated(let region):
			yyjsonDoc = region.expose { (alc) -> UnsafeMutablePointer<yyjson_doc>? in
				return yyjson_read_opts(bytes, size, flags.rawValue, &alc, &errorinfo)
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
