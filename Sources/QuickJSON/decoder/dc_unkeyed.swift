// (c) tanner silva 2023. all rights reserved.
import yyjson

#if QUICKJSON_SHOULDLOG
import Logging
#endif

internal struct dc_unkeyed:Swift.UnkeyedDecodingContainer {
	/// helps ``dc_unkeyed`` keep track of its internal state
	private enum ParseState {
		/// there is content in the container
		/// - argument 1: the next object in the array to consume
		case content(UnsafeMutablePointer<yyjson_val>)
		/// the end of the array has been reached
		case end
	}
	
	/// the current state of the container
	private var state:ParseState

	/// the number of elements in the container
	internal let length:size_t
	/// the index of the current element
	internal var currentIndex:size_t = 0
	internal var isAtEnd:Bool {
		get {
			return currentIndex >= length
		}
	}

	#if QUICKJSON_SHOULDLOG
	private let logger:Logger
	#endif

	/// initialize an unkeyed container with the given root object.
	/// - parameter root: the root object to decode.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the root object is not an array.
	internal init(root:UnsafeMutablePointer<yyjson_val>) throws {
		#if QUICKJSON_SHOULDLOG
		let iid = UInt16.random(in:UInt16.min...UInt16.max)
		var buildLogger = Decoding.logger
		buildLogger[metadataKey: "iid"] = "\(iid)"
		self.logger = buildLogger
		buildLogger.debug("enter: dc_unkeyed.init(root:)")
		defer {
			buildLogger.trace("exit: dc_unkeyed.init(root:)")
		}
		#endif
		guard yyjson_get_type(root) == YYJSON_TYPE_ARR else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.arr, found:ValueType(yyjson_get_type(root))))
		}
		length = yyjson_arr_size(root)
		if length == 0 {
			state = .end
		} else {
			state = .content(unsafe_yyjson_get_first(root))
		}
	}

	// called every time a value is decoded. 
	private mutating func increment() {
		switch state {
			case .end:
				fatalError("increment called when at end of container")
			case .content(let root):
				currentIndex += 1
				switch currentIndex < length {
					case true:
					state = .content(unsafe_yyjson_get_next(root))
					case false:
					state = .end
				}
		}
	}

	/// returns true if the next value in the container is null.
	internal mutating func decodeNil() throws -> Bool {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function)")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function)")
		}
		#endif
		switch state {
			case .end:
				throw Decoding.Error.contentOverflow
			case .content(let root):
				let decodedValue = yyjson_is_null(root)
				increment()
				return decodedValue
		}
	}

	/// decodes the next value in the container as a boolean.
	internal mutating func decode(_ type:Bool.Type) throws -> Bool {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		}
		#endif
		switch state {
			case .end:
				throw Decoding.Error.contentOverflow
			case .content(let root):
				let decodedValue = try root.decodeBool()
				increment()
				return decodedValue
		}
	}

	/// decodes the next value in the container as a string.
	internal mutating func decode(_ type:String.Type) throws -> String {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		}
		#endif
		switch state {
			case .end:
				throw Decoding.Error.contentOverflow
			case .content(let root):
				let decodedValue = try root.decodeString()
				increment()
				return decodedValue
		}
	}

	/// decodes the next value in the container as a double.
	internal mutating func decode(_ type:Double.Type) throws -> Double {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		}
		#endif
		switch state {
			case .end:
				throw Decoding.Error.contentOverflow
			case .content(let root):
				let decodedValue = try root.decodeDouble()
				increment()
				return decodedValue
		}
	}

	/// decodes the next value in the container as a float.
	internal mutating func decode(_ type:Float.Type) throws -> Float {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		}
		#endif
		switch state {
			case .end:
				throw Decoding.Error.contentOverflow
			case .content(let root):
				let decodedValue = try root.decodeFloat()
				increment()
				return decodedValue
		}
	}

	/// decodes the next value in the container as an int.
	internal mutating func decode(_ type:Int.Type) throws -> Int {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		}
		#endif
		switch self.state {
			case .end:
				throw Decoding.Error.contentOverflow
			case .content(let root):
				let decodedValue = try root.decodeInt()
				increment()
				return decodedValue
		}
	}

	/// decodes the next value in the container as an int8.
	internal mutating func decode(_ type:Int8.Type) throws -> Int8 {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		}
		#endif
		switch state {
			case .end:
				throw Decoding.Error.contentOverflow
			case .content(let root):
				let decodedValue = try root.decodeInt8()
				increment()
				return decodedValue
		}
	}

	/// decodes the next value in the container as an int16.
	internal mutating func decode(_ type:Int16.Type) throws -> Int16 {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		}
		#endif
		switch self.state {
			case .end:
				throw Decoding.Error.contentOverflow
			case .content(let root):
				let decodedValue = try root.decodeInt16()
				increment()
				return decodedValue
		}
	}

	/// decodes the next value in the container as an int32.
	internal mutating func decode(_ type:Int32.Type) throws -> Int32 {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		}
		#endif
		switch self.state {
			case .end:
				throw Decoding.Error.contentOverflow
			case .content(let root):
				let decodedValue = try root.decodeInt32()
				increment()
				return decodedValue
		}
	}

	/// decodes the next value in the container as an int64.
	internal mutating func decode(_ type:Int64.Type) throws -> Int64 {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		}
		#endif
		switch self.state {
			case .end:
				throw Decoding.Error.contentOverflow
			case .content(let root):
				let decodedValue = try root.decodeInt64()
				increment()
				return decodedValue
		}
	}

	/// decodes the next value in the container as a uint.
	internal mutating func decode(_ type:UInt.Type) throws -> UInt {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		}
		#endif
		switch self.state {
			case .end:
				throw Decoding.Error.contentOverflow
			case .content(let root):
				let decodedValue = try root.decodeUInt()
				increment()
				return decodedValue
		}
	}

	/// decodes the next value in the container as a uint8.
	internal mutating func decode(_ type:UInt8.Type) throws -> UInt8 {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		}
		#endif
		switch self.state {
			case .end:
				throw Decoding.Error.contentOverflow
			case .content(let root):
				let decodedValue = try root.decodeUInt8()
				increment()
				return decodedValue
		}
	}

	/// decodes the next value in the container as a uint16.
	internal mutating func decode(_ type:UInt16.Type) throws -> UInt16 {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		}
		#endif
		switch state {
			case .end:
				throw Decoding.Error.contentOverflow
			case .content(let root):
				let decodedValue = try root.decodeUInt16()
				increment()
				return decodedValue
		}
	}

	/// decodes the next value in the container as a uint32.
	internal mutating func decode(_ type:UInt32.Type) throws -> UInt32 {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		}
		#endif
		switch self.state {
			case .end:
				throw Decoding.Error.contentOverflow
			case .content(let root):
				let decodedValue = try root.decodeUInt32()
				increment()
				return decodedValue
		}
	}

	/// decodes the next value in the container as a uint64.
	internal mutating func decode(_ type:UInt64.Type) throws -> UInt64 {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		}
		#endif
		switch self.state {
			case .end:
				throw Decoding.Error.contentOverflow
			case .content(let root):
				let decodedValue = try root.decodeUInt64()
				increment()
				return decodedValue
		}
	}

	/// decodes a given decodable type from the next value in the container.
	internal mutating func decode<T>(_ type:T.Type) throws -> T where T:Decodable {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		}
		#endif
		switch self.state {
			case .end:
				throw Decoding.Error.contentOverflow
			case .content(let root):
				let decodedValue = try T(from:decoder(root:root))
				increment()
				return decodedValue
		}
	}

	/// decodes the next value in the container as a keyed container.
	internal mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function) : \(String(describing:type))")
		}
		#endif
		switch state {
			case .end:
				throw Decoding.Error.contentOverflow
			case .content(let root):
				defer {
					self.increment()
				}
				return try KeyedDecodingContainer(dc_keyed<NestedKey>(root:root))
		}
	}

	/// decode the next value in the container as an unkeyed container.
	internal mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
		#if QUICKJSON_SHOULDLOG
		logger.debug("enter: \(String(describing:Self.self)) : \(#function)")
		defer {
			logger.trace("exit: \(String(describing:Self.self)) : \(#function)")
		}
		#endif
		switch state {
			case .end:
				throw Decoding.Error.contentOverflow
			case .content(let root):
			defer {
				self.increment()
			}
			return try dc_unkeyed(root:root)
		}
	}

	/// returns the number of elements in the decoding container.
	internal var count:Int? {
		get {
			return length
		}
	}

	// required by swift.
	internal var codingPath:[CodingKey] {
		return []
	}
	internal func superDecoder() throws -> Swift.Decoder {
		fatalError("not supported")
	}
}