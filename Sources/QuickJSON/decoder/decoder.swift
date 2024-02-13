// (c) tanner silva 2023. all rights reserved.
import yyjson

#if QUICKJSON_SHOULDLOG
import Logging
#endif

/// decoder from root
internal struct decoder:Swift.Decoder {
	/// the root object for the json document
	private let root:UnsafeMutablePointer<yyjson_val>

	#if QUICKJSON_SHOULDLOG
	private let logger:Logger?
	/// initialize a new decoder from a root json object
	internal init(root:UnsafeMutablePointer<yyjson_val>, logger:Logging.Logger?) {
		let iid = UInt16.random(in:UInt16.min...UInt16.max)
		var buildLogger = logger
		buildLogger?[metadataKey: "iid"] = "\(iid)"
		buildLogger?[metadataKey:"type"] = "decoder"
		buildLogger?.debug("instance init")
		self.logger = buildLogger
		self.root = root
	}
	#else
	/// initialize a new decoder from a root json object
	internal init(root:UnsafeMutablePointer<yyjson_val>) {
		self.root = root
	}
	#endif

	/// retrieve the keyed container for this decoder
	internal func container<Key>(keyedBy type:Key.Type) throws -> KeyedDecodingContainer<Key> where Key:CodingKey {
		#if QUICKJSON_SHOULDLOG
		logger?.debug("enter: container<Key>(keyedBy:Key.Type)")
		defer {
			logger?.trace("exit: container<Key>(keyedBy:Key.Type)")
		}
		return try KeyedDecodingContainer(dc_keyed<Key>(root:root, logger:logger))
		#else
		return try KeyedDecodingContainer(dc_keyed<Key>(root:root))
		#endif
	}

	/// retrieve the unkeyed container for this decoder
	internal func unkeyedContainer() throws -> UnkeyedDecodingContainer {
		#if QUICKJSON_SHOULDLOG
		logger?.debug("enter: unkeyedContainer()")
		defer {
			logger?.trace("exit: unkeyedContainer()")
		}
		return try dc_unkeyed(root:root, logger:logger)
		#else
		return try dc_unkeyed(root:root)
		#endif
	}

	/// retrieve the single value container for this decoder
	internal func singleValueContainer() throws -> SingleValueDecodingContainer {
		#if QUICKJSON_SHOULDLOG
		logger?.debug("enter: singleValueContainer()")
		defer {
			logger?.trace("exit: singleValueContainer()")
		}
		return dc_single(root:root, logger:logger)
		#else
		return dc_single(root:root)
		#endif
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