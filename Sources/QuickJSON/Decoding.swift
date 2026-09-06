// (c) tanner silva 2023. all rights reserved.
import Logging
import yyjson

/// decode a value from a json document.
/// - parameters:
///   - type: the type of the value to decode.
///   - bytes: the json document to decode.
///   - flags: the decoding flags to use.
///   - memconfig: the memory configuration to use.
///   - logLevel: the log level to use for this decoding.
/// - returns: the decoded value.
/// - throws: `Decoding.Error` if the document could not be parsed or the value could not be decoded.
public func decode<T: Decodable, C: Collection>(
	_ type: T.Type,
	from bytes: C,
	flags: Decoding.Flags = Decoding.Flags(),
	memory memconfig: Memory.Configuration = .automatic,
	logLevel: Logging.Logger.Level = .critical
) throws -> T where C.Element == UInt8 {
	let getVal = try bytes.withContiguousStorageIfAvailable { contiguous in
		return try decode(type, from: contiguous.baseAddress!, size: contiguous.count, flags: flags, memory: memconfig, logLevel: logLevel)
	}
	if getVal != nil {
		return getVal!
	} else {
		let buffer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: bytes.count)
		defer { buffer.deallocate() }
		_ = buffer.initialize(from: bytes)
		return try decode(type, from: buffer.baseAddress!, size: buffer.count, flags: flags, memory: memconfig, logLevel: logLevel)
	}
}

/// decode a value from a json document.
/// - parameters:
///   - type: the type of the value to decode.
///   - data: a pointer to the json document to decode.
///   - size: the size of the json document in bytes.
///   - flags: the decoding flags to use.
///   - memconfig: the memory configuration to use.
///   - logLevel: the log level to use for this decoding.
/// - returns: the decoded value.
/// - throws: `Decoding.Error` if the document could not be parsed or the value could not be decoded.
public func decode<T: Decodable>(
	_ type: T.Type,
	from data: UnsafeRawPointer,
	size: Int,
	flags: Decoding.Flags = Decoding.Flags(),
	memory memconfig: Memory.Configuration = .automatic,
	logLevel: Logging.Logger.Level = .critical
) throws -> T {
	var errorinfo = yyjson_read_err()
	let yyjsonDoc: UnsafeMutablePointer<yyjson_doc>?
	switch memconfig {
	case .automatic:
		yyjsonDoc = yyjson_read_opts(UnsafeMutableRawPointer(mutating: data), size, flags.rawValue, nil, &errorinfo)
	case .preallocated(let region):
		yyjsonDoc = region.expose { (alc) -> UnsafeMutablePointer<yyjson_doc>? in
			return yyjson_read_opts(UnsafeMutableRawPointer(mutating: data), size, flags.rawValue, &alc, &errorinfo)
		}
	}
	guard yyjsonDoc != nil && errorinfo.code == 0 else {
		throw Decoding.Error.documentParseError(Decoding.Error.ParseInfo(readInfo: errorinfo))
	}
	defer {
		yyjson_doc_free(yyjsonDoc)
	}
	let root = yyjson_doc_get_root(yyjsonDoc)
	guard root != nil else {
		throw Decoding.Error.documentRootError
	}
	return try T(from: RootDecoder(root: root!, logLevel: logLevel))
}

/// decode an unknown value from a json document using a specified handler function.
/// - parameters:
///   - bytes: the json document to decode.
///   - flags: the decoding flags to use.
///   - memconfig: the memory configuration to use.
///   - logLevel: the log level to use for this decoding.
///   - handlerFunc: the function to handle the parsing actions. its return value is returned transparently.
/// - returns: the value returned by the handler function.
/// - throws: `Decoding.Error` if the document could not be parsed; any error thrown by the handler function.
public func decode<R, C: Collection>(
	from bytes: C,
	flags: Decoding.Flags = Decoding.Flags(),
	memory memconfig: Memory.Configuration = .automatic,
	logLevel: Logging.Logger.Level = .critical,
	_ handlerFunc: (Swift.Decoder) throws -> R
) throws -> R where C.Element == UInt8 {
	let getVal = try bytes.withContiguousStorageIfAvailable { contiguous in
		return try decode(from: contiguous.baseAddress!, size: contiguous.count, flags: flags, memory: memconfig, logLevel: logLevel, handlerFunc)
	}
	if getVal != nil {
		return getVal!
	} else {
		let buffer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: bytes.count)
		defer { buffer.deallocate() }
		_ = buffer.initialize(from: bytes)
		return try decode(from: buffer.baseAddress!, size: buffer.count, flags: flags, memory: memconfig, logLevel: logLevel, handlerFunc)
	}
}

/// decode an unknown value from a json document using a specified handler function.
/// - parameters:
///   - data: a pointer to the json document to decode.
///   - size: the size of the json document in bytes.
///   - flags: the decoding flags to use.
///   - memconfig: the memory configuration to use.
///   - logLevel: the log level to use for this decoding.
///   - handlerFunc: the function to handle the parsing actions. its return value is returned transparently.
/// - returns: the value returned by the handler function.
/// - throws: `Decoding.Error` if the document could not be parsed; any error thrown by the handler function.
public func decode<R>(
	from data: UnsafeRawPointer,
	size: Int,
	flags: Decoding.Flags = Decoding.Flags(),
	memory memconfig: Memory.Configuration = .automatic,
	logLevel: Logging.Logger.Level = .critical,
	_ handlerFunc: (Swift.Decoder) throws -> R
) throws -> R {
	var errorinfo = yyjson_read_err()
	let yyjsonDoc: UnsafeMutablePointer<yyjson_doc>?
	switch memconfig {
	case .automatic:
		yyjsonDoc = yyjson_read_opts(UnsafeMutableRawPointer(mutating: data), size, flags.rawValue, nil, &errorinfo)
	case .preallocated(let region):
		yyjsonDoc = region.expose { (alc) -> UnsafeMutablePointer<yyjson_doc>? in
			return yyjson_read_opts(UnsafeMutableRawPointer(mutating: data), size, flags.rawValue, &alc, &errorinfo)
		}
	}
	guard yyjsonDoc != nil && errorinfo.code == 0 else {
		throw Decoding.Error.documentParseError(Decoding.Error.ParseInfo(readInfo: errorinfo))
	}
	defer {
		yyjson_doc_free(yyjsonDoc)
	}
	let root = yyjson_doc_get_root(yyjsonDoc)
	guard root != nil else {
		throw Decoding.Error.documentRootError
	}
	return try handlerFunc(RootDecoder(root: root!, logLevel: logLevel))
}

/// namespace related to decoding.
public struct Decoding {
	/// errors that can be thrown by the decoder
	public enum Error: Swift.Error, Sendable {
		/// thrown by an unkeyed decoding container when the bounds of the container have been exceeded
		case contentOverflow
		/// thrown when the decoder encounters a value that is not the type that was expected
		case valueTypeMismatch(ValueTypeMismatchInfo)
		/// the key could not be found
		case notFound
		/// the document could not be parsed
		case documentParseError(ParseInfo)
		/// the root value of the document could not be found
		case documentRootError
		/// a numeric value is outside the representable range of the requested type
		case numberOutOfRange(requestedType: Any.Type, value: Double)
		/// a real number was decoded where an integer was required, and it is not an exactly-representable integer
		/// (e.g. `3.5` decoded as `Int`). Integral reals like `2.0` are accepted.
		case nonIntegerNumber(Double)

		/// additional information about the value type mismatch error
		public struct ValueTypeMismatchInfo: Sendable {
			/// the type that was expected
			public let expected: ValueType
			/// the type that was found
			public let found: ValueType
			internal init(expected: ValueType, found: ValueType) {
				self.expected = expected
				self.found = found
			}
		}

		/// detailed information about a parse error
		public struct ParseInfo: Sendable {
			/// description of the error
			let error: String
			/// the buffer offset where the error occurred
			let offset: Int
			/// the error code
			let code: UInt32
			internal init(readInfo errorInfo: yyjson_read_err) {
				self.error = String(cString: errorInfo.msg)
				self.offset = Int(errorInfo.pos)
				self.code = errorInfo.code
			}
		}
	}

	/// the default logger for any decoding operation. this may be replaced with a custom logger before calling `decode(_:)`.
	public nonisolated(unsafe) static var logger = makeDefaultLogger(label: "com.tannersilva.quickjson.decoding", logLevel: .debug)

	/// option flags for the decoder
	public struct Flags: OptionSet, Sendable {
		/// the raw value of the option flags
		public let rawValue: UInt32
		/// initialize a flag option set with a given raw value
		/// - parameter rawValue: the raw value of the option flags
		public init(rawValue: UInt32 = 0) { self.rawValue = rawValue }
		public static let inSitu = Flags(rawValue: YYJSON_READ_INSITU)
		public static let stopWhenDone = Flags(rawValue: YYJSON_READ_STOP_WHEN_DONE)
		public static let allowTrailingCommas = Flags(rawValue: YYJSON_READ_ALLOW_TRAILING_COMMAS)
		public static let allowComments = Flags(rawValue: YYJSON_READ_ALLOW_COMMENTS)
		public static let allowInfAndNaN = Flags(rawValue: YYJSON_READ_ALLOW_INF_AND_NAN)
		public static let allowInvalidUnicode = Flags(rawValue: YYJSON_READ_ALLOW_INVALID_UNICODE)
	}

	// not instantiable
	private init() {}
}
