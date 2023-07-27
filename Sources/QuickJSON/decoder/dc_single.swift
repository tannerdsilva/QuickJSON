// (c) tanner silva 2023. all rights reserved.
import yyjson

#if QUICKJSON_SHOULDLOG
import Logging
#endif

/// primary single value decoding container
internal struct dc_single:Swift.SingleValueDecodingContainer {
	private let root:UnsafeMutablePointer<yyjson_val>

	#if QUICKJSON_SHOULDLOG
	private let logger:Logger
	private let logLevel:Logging.Logger.Level
	/// initialize a single value container 
	/// - parameter root: the given root object which the value will be decoded from.
	internal init(root:UnsafeMutablePointer<yyjson_val>, logLevel:Logging.Logger.Level = .critical) {
		let iid = UInt16.random(in:UInt16.min...UInt16.max)
		var buildLogger = Decoding.logger
		buildLogger[metadataKey: "iid"] = "\(iid)"
		buildLogger.logLevel = logLevel
		self.logger = buildLogger
		self.logLevel = logLevel
		buildLogger.debug("enter: dc_single.init(root:)")
		defer {
			buildLogger.trace("exit: dc_single.init(root:)")
		}
		self.root = root
	}
	#else
	internal init(root:UnsafeMutablePointer<yyjson_val>) {
		self.root = root
	}
	#endif

	/// returns true if the following value is nil.
	internal func decodeNil() -> Bool {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_single.decodeNil()")
		defer {
			self.logger.trace("exit: dc_single.decodeNil()")
		}
		#endif
		return root.decodeNil()
	}

	/// returns the value as a boolean.
	internal func decode(_ type:Bool.Type) throws -> Bool {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_single.decode(_:Bool.Type)")
		defer {
			self.logger.trace("exit: dc_single.decode(_:Bool.Type)")
		}
		#endif
		return try root.decodeBool()
	}

	/// returns the value as a string.
	internal func decode(_ type:String.Type) throws -> String {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_single.decode(_:String.Type)")
		defer {
			self.logger.trace("exit: dc_single.decode(_:String.Type)")
		}
		#endif
		return try root.decodeString()
	}

	/// returns the value as a double.
	internal func decode(_ type:Double.Type) throws -> Double {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_single.decode(_:Double.Type)")
		defer {
			self.logger.trace("exit: dc_single.decode(_:Double.Type)")
		}
		#endif
		return try root.decodeDouble()
	}

	/// returns the value as a float.
	internal func decode(_ type:Float.Type) throws -> Float {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_single.decode(_:Float.Type)")
		defer {
			self.logger.trace("exit: dc_single.decode(_:Float.Type)")
		}
		#endif
		return try root.decodeFloat()
	}

	/// returns the value as an integer.
	internal func decode(_ type:Int.Type) throws -> Int {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_single.decode(_:Int.Type)")
		defer {
			self.logger.trace("exit: dc_single.decode(_:Int.Type)")
		}
		#endif
		return try root.decodeInt()
	}

	/// returns the value as an 8 bit integer.
	internal func decode(_ type:Int8.Type) throws -> Int8 {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_single.decode(_:Int8.Type)")
		defer {
			self.logger.trace("exit: dc_single.decode(_:Int8.Type)")
		}
		#endif
		return try root.decodeInt8()
	}

	/// returns the value as a 16 bit integer.
	internal func decode(_ type:Int16.Type) throws -> Int16 {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_single.decode(_:Int16.Type)")
		defer {
			self.logger.trace("exit: dc_single.decode(_:Int16.Type)")
		}
		#endif
		return try root.decodeInt16()
	}

	/// returns the value as a 32 bit integer.
	internal func decode(_ type:Int32.Type) throws -> Int32 {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_single.decode(_:Int32.Type)")
		defer {
			self.logger.trace("exit: dc_single.decode(_:Int32.Type)")
		}
		#endif
		return try root.decodeInt32()
	}

	/// returns the value as a 64 bit integer.
	internal func decode(_ type:Int64.Type) throws -> Int64 {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_single.decode(_:Int64.Type)")
		defer {
			self.logger.trace("exit: dc_single.decode(_:Int64.Type)")
		}
		#endif
		return try root.decodeInt64()
	}

	/// returns the value as an unsigned integer.
	internal func decode(_ type:UInt.Type) throws -> UInt {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_single.decode(_:UInt.Type)")
		defer {
			self.logger.trace("exit: dc_single.decode(_:UInt.Type)")
		}
		#endif
		return try root.decodeUInt()
	}

	/// returns the value as an unsigned 8 bit integer.
	internal func decode(_ type:UInt8.Type) throws -> UInt8 {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_single.decode(_:UInt8.Type)")
		defer {
			self.logger.trace("exit: dc_single.decode(_:UInt8.Type)")
		}
		#endif
		return try root.decodeUInt8()
	}

	/// returns the value as an unsigned 16 bit integer.
	internal func decode(_ type:UInt16.Type) throws -> UInt16 {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_single.decode(_:UInt16.Type)")
		defer {
			self.logger.trace("exit: dc_single.decode(_:UInt16.Type)")
		}
		#endif
		return try root.decodeUInt16()
	}

	/// returns the value as an unsigned 32 bit integer.
	internal func decode(_ type:UInt32.Type) throws -> UInt32 {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_single.decode(_:UInt32.Type)")
		defer {
			self.logger.trace("exit: dc_single.decode(_:UInt32.Type)")
		}
		#endif
		return try root.decodeUInt32()
	}

	/// returns the value as an unsigned 64 bit integer.
	internal func decode(_ type:UInt64.Type) throws -> UInt64 {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_single.decode(_:UInt64.Type)")
		defer {
			self.logger.trace("exit: dc_single.decode(_:UInt64.Type)")
		}
		#endif
		return try root.decodeUInt64()
	}

	/// returns the value as a specified Decodable type.
	internal func decode<T>(_ type:T.Type) throws -> T where T:Decodable {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_single.decode(_:T.Type)")
		defer {
			self.logger.trace("exit: dc_single.decode(_:T.Type)")
		}
		return try T(from:decoder(root:root, logLevel:self.logLevel))
		#else
		return try T(from:decoder(root:root))
		#endif
	}

	// required by swift.
	internal var codingPath:[CodingKey] {
		get {
			return []
		}
	}
}