// (c) tanner silva 2023. all rights reserved.
import yyjson

#if QUICKJSON_SHOULDLOG
import Logging
internal func makeDefaultLogger(label:String, logLevel:Logger.Level) -> Logger {
	var newLogger = Logger(label:label)
	newLogger.logLevel = logLevel
	return newLogger
}
#endif

// MARK: Encoding Data
/// encode an object into a json based byte encoding.
/// - parameter object: the object to encode.
/// - parameter flags: the option flags to use for this encoding. default flag values are used if none are specified.
#if QUICKJSON_SHOULDLOG
public func encode<T:Encodable>(_ object:T, flags:Encoding.Flags = Encoding.Flags(), logLevel:Logging.Logger.Level) throws -> [UInt8] {
	Encoding.logger.debug("enter: QuickJSON.encode(_:flags:)")
	defer {
		Encoding.logger.trace("exit: QuickJSON.encode(_:flags:)")
	}

	let newDoc = yyjson_mut_doc_new(nil)
	guard newDoc != nil else {
		throw Encoding.Error.memoryAllocationFailure
	}
	defer {
		yyjson_mut_doc_free(newDoc)
	}

	try object.encode(to:encoder_from_root(doc:newDoc!, logLevel:logLevel))
	return try newDoc!.exportDocumentBytes(flags:flags)
}
#else
public func encode<T:Encodable>(_ object:T, flags:Encoding.Flags = Encoding.Flags()) throws -> [UInt8] {
	let newDoc = yyjson_mut_doc_new(nil)
	guard newDoc != nil else {
		throw Encoding.Error.memoryAllocationFailure
	}
	defer {
		yyjson_mut_doc_free(newDoc)
	}

	try object.encode(to:encoder_from_root(doc:newDoc!))

	return try newDoc!.exportDocumentBytes(flags:flags)
}
#endif

public struct Encoding {
	/// errors that may occur during encoding
	public enum Error:Swift.Error {
		/// the value could not be assigned
		case assignmentError
		/// memory allocation failed
		case memoryAllocationFailure
	}

	#if QUICKJSON_SHOULDLOG
	public static var logger = makeDefaultLogger(label:"com.tannersilva.quickjson.encoding", logLevel:.debug)
	#endif

	/// option flags for the encoder
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

	// nothing to see here
	private init() {}
}



/// represents various JSON types. this is primarily used to describe type mismatches.
public enum ValueType:UInt8 {
	/// represents no value
	case none = 0
	/// represents a raw value
	case raw = 1
	/// represents a null value
	case null = 2
	/// represents a boolean value
	case bool = 3
	/// represents a numeric value
	case num = 4
	/// represents a string value
	case str = 5
	/// represents an array value
	case arr = 6
	/// represents an object value
	case obj = 7

	/// initialize a value type given a underlying yyjson_type
	internal init(_ yyjsonType:yyjson_type) {
		switch yyjsonType {
		case YYJSON_TYPE_NULL:
			self = .null
		case YYJSON_TYPE_BOOL:
			self = .bool
		case YYJSON_TYPE_NUM:
			self = .num
		case YYJSON_TYPE_STR:
			self = .str
		case YYJSON_TYPE_ARR:
			self = .arr
		case YYJSON_TYPE_OBJ:
			self = .obj
		default:
			self = .none
		}
	}

	/// get the underlying yyjson_type
	internal var yyjsonType:yyjson_type {
		switch self {
		case .null:
			return YYJSON_TYPE_NULL
		case .bool:
			return YYJSON_TYPE_BOOL
		case .num:
			return YYJSON_TYPE_NUM
		case .str:
			return YYJSON_TYPE_STR
		case .arr:
			return YYJSON_TYPE_ARR
		case .obj:
			return YYJSON_TYPE_OBJ
		default:
			return YYJSON_TYPE_NONE
		}
	}
}