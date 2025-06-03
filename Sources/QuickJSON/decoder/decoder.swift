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
	private let logger:Logger
	#endif

	/// initialize a new decoder from a root json object
	internal init(root:UnsafeMutablePointer<yyjson_val>) {
		#if QUICKJSON_SHOULDLOG
		let iid = UInt16.random(in:UInt16.min...UInt16.max)
		var buildLogger = Decoding.logger
		buildLogger[metadataKey: "iid"] = "\(iid)"
		buildLogger[metadataKey: "root"] = "\(root)"
		self.logger = buildLogger
		buildLogger.debug("enter: \(String(describing:Self.self)) : \(#function)")
		defer {
			buildLogger.trace("exit: \(String(describing:Self.self)) : \(#function)")
		}
		#endif
		self.root = root
	}

	/// retrieve the keyed container for this decoder
	internal func container<Key>(keyedBy type:Key.Type) throws -> KeyedDecodingContainer<Key> where Key:CodingKey {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		}
		#endif
		return try KeyedDecodingContainer(dc_keyed<Key>(root:root))
	}

	/// retrieve the unkeyed container for this decoder
	internal func unkeyedContainer() throws -> UnkeyedDecodingContainer {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function)")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function)")
		}
		#endif
		return try dc_unkeyed(root:root)
	}

	/// retrieve the single value container for this decoder
	internal func singleValueContainer() throws -> SingleValueDecodingContainer {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function)")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function)")
		}
		#endif
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