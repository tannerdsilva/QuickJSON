// (c) tanner silva 2023. all rights reserved.
import yyjson

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