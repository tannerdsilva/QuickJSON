// (c) tanner silva 2023. all rights reserved.
import Logging
import yyjson

/// encode an object into a json based byte encoding.
/// - parameters:
///   - object: the object to encode.
///   - flags: the option flags to use for this encoding. default flag values are used if none are specified.
///   - memconfig: the memory configuration to use for this encoding.
///   - logLevel: the log level to use for this encoding.
/// - returns: the encoded json document as a byte array.
/// - throws: `Encoding.Error` if the encoding fails.
public func encode<T: Encodable>(
	_ object: T,
	flags: Encoding.Flags = Encoding.Flags(),
	memory memconfig: Memory.Configuration = .automatic,
	logLevel: Logging.Logger.Level = .critical
) throws -> [UInt8] {
	switch memconfig {
	case .automatic:
		let newDoc = yyjson_mut_doc_new(nil)
		guard newDoc != nil else {
			throw Encoding.Error.memoryAllocationFailure
		}
		defer { yyjson_mut_doc_free(newDoc) }
		try object.encode(to: NodeEncoder(doc: newDoc!, position: .root, logLevel: logLevel))
		return try newDoc!.exportDocumentBytes(flags: flags)
	case .preallocated(let region):
		// the document must be created with the region's allocator for any of its values to use the pool.
		return try region.expose { alc in
			let newDoc = yyjson_mut_doc_new(&alc)
			guard newDoc != nil else {
				throw Encoding.Error.memoryAllocationFailure
			}
			defer { yyjson_mut_doc_free(newDoc) }
			try object.encode(to: NodeEncoder(doc: newDoc!, position: .root, logLevel: logLevel))
			return try newDoc!.exportDocumentBytes(flags: flags)
		}
	}
}

/// namespace related to encoding.
public struct Encoding {
	/// errors that may occur during encoding
	public enum Error: Swift.Error, Sendable {
		/// the value could not be assigned
		case assignmentError
		/// memory allocation failed
		case memoryAllocationFailure
	}

	/// the default logger for any encoding operation. this may be replaced with a custom logger before calling `encode(_:)`.
	public nonisolated(unsafe) static var logger = makeDefaultLogger(label: "com.tannersilva.quickjson.encoding", logLevel: .debug)

	/// option flags for the encoder
	public struct Flags: OptionSet, Sendable {
		/// the raw value of the option flags
		public let rawValue: UInt32
		/// initialize a flag option set with a given raw value
		/// - parameter rawValue: the raw value of the option flags
		public init(rawValue: UInt32 = 0) { self.rawValue = rawValue }
		public static let pretty = Flags(rawValue: YYJSON_WRITE_PRETTY)
		public static let escapeUnicode = Flags(rawValue: YYJSON_WRITE_ESCAPE_UNICODE)
		public static let escapeSlashes = Flags(rawValue: YYJSON_WRITE_ESCAPE_SLASHES)
		public static let allowInfAndNan = Flags(rawValue: YYJSON_WRITE_ALLOW_INF_AND_NAN)
		public static let infAndNanAsNull = Flags(rawValue: YYJSON_WRITE_INF_AND_NAN_AS_NULL)
		public static let allowInvalidUnicode = Flags(rawValue: YYJSON_WRITE_ALLOW_INVALID_UNICODE)
		public static let prettyTwoSpaces = Flags(rawValue: YYJSON_WRITE_PRETTY_TWO_SPACES)
	}

	// not instantiable
	private init() {}
}
