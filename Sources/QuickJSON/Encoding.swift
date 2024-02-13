// (c) tanner silva 2023. all rights reserved.
import yyjson

#if QUICKJSON_SHOULDLOG
import Logging
#endif

// MARK: Encoding Data
#if QUICKJSON_SHOULDLOG
/// encode an object into a json based byte encoding.
/// - parameter objectPtr: a pointer to the object to encode.
/// - parameter flags: the option flags to use for this encoding. default flag values are used if none are specified.
/// - parameter logger: the log level to use for this encoding.
public func encode<T:Encodable>(
	_ objectPtr:UnsafePointer<T>,
	flags:Encoding.Flags = Encoding.Flags(),
	logger immutableLoggerIn:Logging.Logger?
) throws -> [UInt8] {
	var logger = immutableLoggerIn
	logger?[metadataKey:"did"] = "\(objectPtr.hashValue)"
	logger?.debug("enter: encode(_:UnsafePointer<T>, flags:Encoding.Flags)")
	defer {
		logger?.trace("exit: encode(_:UnsafePointer<T>, flags:Encoding.Flags)")
	}
	let newDoc = yyjson_mut_doc_new(nil)
	guard newDoc != nil else {
		logger?.error("unable to initialize new json document for encoding.")
		throw Encoding.Error.memoryAllocationFailure
	}
	defer {
		yyjson_mut_doc_free(newDoc)
	}

	try objectPtr.pointee.encode(to:encoder_from_root(doc:newDoc!, logger:logger))
	logger?.debug("encoding successful")
	return try newDoc!.exportDocumentBytes(flags:flags, logger:logger)
}
#else
/// encode an object into a json based byte encoding.
/// - parameter objectPtr: a pointer to the object to encode
/// - parameter flags: the option flags to use for this encoding. default flag values are used if none are specified.
public func encode<T:Encodable>(
	_ objectPtr:UnsafePointer<T>, 
	flags:Encoding.Flags = Encoding.Flags()
) throws -> [UInt8] {
	let newDoc = yyjson_mut_doc_new(nil)
	guard newDoc != nil else {
		throw Encoding.Error.memoryAllocationFailure
	}
	defer {
		yyjson_mut_doc_free(newDoc)
	}
	try objectPtr.pointee.encode(to:encoder_from_root(doc:newDoc!))
	return try newDoc!.exportDocumentBytes(flags:flags)
}
#endif

/// namespace related to encoding.
public struct Encoding {
	/// errors that may occur during encoding
	public enum Error:Swift.Error {
		/// the value could not be copied to the buffer
		case assignmentError
		/// memory allocation failed
		case memoryAllocationFailure
	}

	/// option flags for the encoder
	public struct Flags:OptionSet {
		/// the raw value of the option flags
		public let rawValue:UInt32
		/// initialize a flag option set with a given raw value
		/// - parameter rawValue: the raw value of the option flags
		public init(rawValue:UInt32 = 0) { self.rawValue = rawValue }
		public static let pretty = Flags(rawValue:YYJSON_WRITE_PRETTY)
		public static let escapeUnicode = Flags(rawValue:YYJSON_WRITE_ESCAPE_UNICODE)
		public static let escapeSlashes = Flags(rawValue:YYJSON_WRITE_ESCAPE_SLASHES)
		public static let allowInfAndNan = Flags(rawValue:YYJSON_WRITE_ALLOW_INF_AND_NAN)
		public static let infAndNanAsNull = Flags(rawValue:YYJSON_WRITE_INF_AND_NAN_AS_NULL)
		public static let allowInvalidUnicode = Flags(rawValue:YYJSON_WRITE_ALLOW_INVALID_UNICODE)
		public static let prettyTwoSpaces = Flags(rawValue:YYJSON_WRITE_PRETTY_TWO_SPACES)
	}
	
	// nothing to see here.
	private init() {}
}
