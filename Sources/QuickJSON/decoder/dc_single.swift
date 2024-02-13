// (c) tanner silva 2023. all rights reserved.
import yyjson

#if QUICKJSON_SHOULDLOG
import Logging
#endif

/// primary single value decoding container
internal struct dc_single:Swift.SingleValueDecodingContainer {
	private let root:UnsafeMutablePointer<yyjson_val>

	#if QUICKJSON_SHOULDLOG
	private let logger:Logger?
	/// initialize a single value container 
	/// - parameter root: the given root object which the value will be decoded from.
	internal init(root:UnsafeMutablePointer<yyjson_val>, logger:Logging.Logger?) {
		let iid = UInt16.random(in:UInt16.min...UInt16.max)
		var buildLogger = logger
		buildLogger?[metadataKey:"iid"] = "\(iid)"
		buildLogger?[metadataKey:"type"] = "dc_single"
		self.logger = buildLogger
		buildLogger?.debug("instance init")
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
		self.logger?.debug("enter: decodeNil()")
		defer {
			self.logger?.trace("exit: decodeNil()")
		}
		#endif
		return root.decodeNil()
	}

	/// returns the value as a boolean.
	internal func decode(_ type:Bool.Type) throws -> Bool {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:Bool.Type)")
		defer {
			self.logger?.trace("exit: decode(_:Bool.Type)")
		}
		return try root.decodeBool(logger:logger)
		#else
		return try root.decodeBool()
		#endif
	}

	/// returns the value as a string.
	internal func decode(_ type:String.Type) throws -> String {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:String.Type)")
		defer {
			self.logger?.trace("exit: decode(_:String.Type)")
		}
		return try root.decodeString(logger:logger)
		#else
		return try root.decodeString()
		#endif
	}

	/// returns the value as a double.
	internal func decode(_ type:Double.Type) throws -> Double {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:Double.Type)")
		defer {
			self.logger?.trace("exit: decode(_:Double.Type)")
		}
		return try root.decodeDouble(logger:logger)
		#else
		return try root.decodeDouble()
		#endif
	}

	/// returns the value as a float.
	internal func decode(_ type:Float.Type) throws -> Float {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:Float.Type)")
		defer {
			self.logger?.trace("exit: decode(_:Float.Type)")
		}
		return try root.decodeFloat(logger:logger)
		#else
		return try root.decodeFloat()
		#endif
	}

	/// returns the value as an integer.
	internal func decode(_ type:Int.Type) throws -> Int {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:Int.Type)")
		defer {
			self.logger?.trace("exit: decode(_:Int.Type)")
		}
		return try root.decodeInt(logger:logger)
		#else
		return try root.decodeInt()
		#endif
	}

	/// returns the value as an 8 bit integer.
	internal func decode(_ type:Int8.Type) throws -> Int8 {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:Int8.Type)")
		defer {
			self.logger?.trace("exit: decode(_:Int8.Type)")
		}
		return try root.decodeInt8(logger:logger)
		#else
		return try root.decodeInt8()
		#endif
	}

	/// returns the value as a 16 bit integer.
	internal func decode(_ type:Int16.Type) throws -> Int16 {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:Int16.Type)")
		defer {
			self.logger?.trace("exit: decode(_:Int16.Type)")
		}
		return try root.decodeInt16(logger:logger)
		#else
		return try root.decodeInt16()
		#endif
	}

	/// returns the value as a 32 bit integer.
	internal func decode(_ type:Int32.Type) throws -> Int32 {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:Int32.Type)")
		defer {
			self.logger?.trace("exit: decode(_:Int32.Type)")
		}
		return try root.decodeInt32(logger:logger)
		#else
		return try root.decodeInt32()
		#endif
	}

	/// returns the value as a 64 bit integer.
	internal func decode(_ type:Int64.Type) throws -> Int64 {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:Int64.Type)")
		defer {
			self.logger?.trace("exit: decode(_:Int64.Type)")
		}
		return try root.decodeInt64(logger:logger)
		#else
		return try root.decodeInt64()
		#endif
	}

	/// returns the value as an unsigned integer.
	internal func decode(_ type:UInt.Type) throws -> UInt {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:UInt.Type)")
		defer {
			self.logger?.trace("exit: decode(_:UInt.Type)")
		}
		return try root.decodeUInt(logger:logger)
		#else
		return try root.decodeUInt()
		#endif
	}

	/// returns the value as an unsigned 8 bit integer.
	internal func decode(_ type:UInt8.Type) throws -> UInt8 {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:UInt8.Type)")
		defer {
			self.logger?.trace("exit: decode(_:UInt8.Type)")
		}
		return try root.decodeUInt8(logger:logger)
		#else
		return try root.decodeUInt8()
		#endif
	}

	/// returns the value as an unsigned 16 bit integer.
	internal func decode(_ type:UInt16.Type) throws -> UInt16 {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:UInt16.Type)")
		defer {
			self.logger?.trace("exit: decode(_:UInt16.Type)")
		}
		return try root.decodeUInt16(logger:logger)
		#else
		return try root.decodeUInt16()
		#endif
	}

	/// returns the value as an unsigned 32 bit integer.
	internal func decode(_ type:UInt32.Type) throws -> UInt32 {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:UInt32.Type)")
		defer {
			self.logger?.trace("exit: decode(_:UInt32.Type)")
		}
		return try root.decodeUInt32(logger:logger)
		#else
		return try root.decodeUInt32()
		#endif
	}

	/// returns the value as an unsigned 64 bit integer.
	internal func decode(_ type:UInt64.Type) throws -> UInt64 {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:UInt64.Type)")
		defer {
			self.logger?.trace("exit: decode(_:UInt64.Type)")
		}
		return try root.decodeUInt64(logger:logger)
		#else
		return try root.decodeUInt64()
		#endif
	}

	/// returns the value as a specified Decodable type.
	internal func decode<T>(_ type:T.Type) throws -> T where T:Decodable {
		#if QUICKJSON_SHOULDLOG
		self.logger?.debug("enter: decode(_:T.Type)")
		defer {
			self.logger?.trace("exit: decode(_:T.Type)")
		}
		return try T(from:decoder(root:root, logger:logger))
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