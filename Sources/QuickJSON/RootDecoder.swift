// (c) tanner silva 2023. all rights reserved.
import Logging
import yyjson

/// a decoder that reads values from the root value of a parsed json document.
/// this is the sole `Swift.Decoder` implementation in the package.
internal struct RootDecoder: Swift.Decoder {
	/// the root value for this decoder
	private let root: UnsafeMutablePointer<yyjson_val>
	private let logger: Logger

	/// initialize a decoder from a root json value.
	/// - parameter root: the root value of the json document.
	/// - parameter logLevel: the log level to use for this decoder.
	internal init(root: UnsafeMutablePointer<yyjson_val>, logLevel: Logger.Level = .critical) {
		self.root = root
		self.logger = Decoding.logger.settingLogLevel(logLevel)
	}

	/// retrieve the keyed container for this decoder.
	internal func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
		return try KeyedDecodingContainer(KeyedDecoder<Key>(root: root, logLevel: logger.logLevel))
	}

	/// retrieve the unkeyed container for this decoder.
	internal func unkeyedContainer() throws -> UnkeyedDecodingContainer {
		return try UnkeyedDecoder(root: root, logLevel: logger.logLevel)
	}

	/// retrieve the single value container for this decoder.
	internal func singleValueContainer() throws -> SingleValueDecodingContainer {
		return SingleValueDecoder(root: root, logLevel: logger.logLevel)
	}

	// required by swift. unused.
	internal var codingPath: [CodingKey] {
		[]
	}

	// required by swift. unused.
	internal var userInfo: [CodingUserInfoKey: Any] {
		[:]
	}
}
