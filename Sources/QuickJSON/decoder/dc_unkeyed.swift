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
			return self.currentIndex >= self.length
		}
	}

	#if QUICKJSON_SHOULDLOG
	private let logger:Logger
	private let logLevel:Logger.Level
	/// initialize an unkeyed container with the given root object.
	/// - parameter root: the root object to decode.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the root object is not an array.
	internal init(root:UnsafeMutablePointer<yyjson_val>, logLevel:Logging.Logger.Level = .critical) throws {
		let iid = UInt16.random(in:UInt16.min...UInt16.max)
		var buildLogger = Decoding.logger
		buildLogger[metadataKey: "iid"] = "\(iid)"
		buildLogger.logLevel = logLevel
		self.logger = buildLogger
		self.logLevel = logLevel
		buildLogger.debug("enter: dc_unkeyed.init(root:)")
		defer {
			buildLogger.trace("exit: dc_unkeyed.init(root:)")
		}
		
		guard yyjson_get_type(root) == YYJSON_TYPE_ARR else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected: ValueType.arr, found: ValueType(yyjson_get_type(root))))
		}
		self.length = yyjson_arr_size(root)
		if self.length == 0 {
			self.state = .end
		} else {
			self.state = .content(unsafe_yyjson_get_first(root))
		}
	}
	#else
	/// initialize an unkeyed container with the given root object.
	/// - parameter root: the root object to decode.
	internal init(root:UnsafeMutablePointer<yyjson_val>) throws {
		guard yyjson_get_type(root) == YYJSON_TYPE_ARR else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected: ValueType.arr, found: ValueType(yyjson_get_type(root))))
		}
		self.length = yyjson_arr_size(root)
		if self.length == 0 {
			self.state = .end
		} else {
			self.state = .content(unsafe_yyjson_get_first(root))
		}
	}
	#endif

	// called every time a value is decoded. 
	private mutating func increment() {
		switch self.state {
			case .end:
			fatalError("increment called when at end of container")
			case .content(let root):
			self.currentIndex += 1
			switch self.currentIndex < self.length {
				case true:
				self.state = .content(unsafe_yyjson_get_next(root))
				case false:
				self.state = .end
			}
		}
	}

	/// returns true if the next value in the container is null.
	internal mutating func decodeNil() throws -> Bool {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_unkeyed.decodeNil()")
		defer {
			self.logger.trace("exit: dc_unkeyed.decodeNil()")
		}
		#endif
		switch self.state {
			case .end:
			throw Decoding.Error.contentOverflow
			case .content(let root):
			let decodedValue = yyjson_is_null(root)
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as a boolean.
	internal mutating func decode(_ type:Bool.Type) throws -> Bool {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_unkeyed.decode(_:Bool.Type)")
		defer {
			self.logger.trace("exit: dc_unkeyed.decode(_:Bool.Type)")
		}
		#endif
		switch self.state {
			case .end:
			throw Decoding.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeBool()
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as a string.
	internal mutating func decode(_ type:String.Type) throws -> String {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_unkeyed.decode(_:String.Type)")
		defer {
			self.logger.trace("exit: dc_unkeyed.decode(_:String.Type)")
		}
		#endif
		switch self.state {
			case .end:
			throw Decoding.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeString()
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as a double.
	internal mutating func decode(_ type:Double.Type) throws -> Double {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_unkeyed.decode(_:Double.Type)")
		defer {
			self.logger.trace("exit: dc_unkeyed.decode(_:Double.Type)")
		}
		#endif
		switch self.state {
			case .end:
			throw Decoding.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeDouble()
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as a float.
	internal mutating func decode(_ type:Float.Type) throws -> Float {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_unkeyed.decode(_:Float.Type)")
		defer {
			self.logger.trace("exit: dc_unkeyed.decode(_:Float.Type)")
		}
		#endif
		switch self.state {
			case .end:
			throw Decoding.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeFloat()
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as an int.
	internal mutating func decode(_ type:Int.Type) throws -> Int {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_unkeyed.decode(_:Int.Type)")
		defer {
			self.logger.trace("exit: dc_unkeyed.decode(_:Int.Type)")
		}
		#endif
		switch self.state {
			case .end:
			throw Decoding.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeInt()
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as an int8.
	internal mutating func decode(_ type:Int8.Type) throws -> Int8 {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_unkeyed.decode(_:Int8.Type)")
		defer {
			self.logger.trace("exit: dc_unkeyed.decode(_:Int8.Type)")
		}
		#endif
		switch self.state {
			case .end:
			throw Decoding.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeInt8()
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as an int16.
	internal mutating func decode(_ type:Int16.Type) throws -> Int16 {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_unkeyed.decode(_:Int16.Type)")
		defer {
			self.logger.trace("exit: dc_unkeyed.decode(_:Int16.Type)")
		}
		#endif
		switch self.state {
			case .end:
			throw Decoding.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeInt16()
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as an int32.
	internal mutating func decode(_ type:Int32.Type) throws -> Int32 {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_unkeyed.decode(_:Int32.Type)")
		defer {
			self.logger.trace("exit: dc_unkeyed.decode(_:Int32.Type)")
		}
		#endif
		switch self.state {
			case .end:
			throw Decoding.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeInt32()
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as an int64.
	internal mutating func decode(_ type:Int64.Type) throws -> Int64 {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_unkeyed.decode(_:Int64.Type)")
		defer {
			self.logger.trace("exit: dc_unkeyed.decode(_:Int64.Type)")
		}
		#endif
		switch self.state {
			case .end:
			throw Decoding.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeInt64()
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as a uint.
	internal mutating func decode(_ type:UInt.Type) throws -> UInt {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_unkeyed.decode(_:UInt.Type)")
		defer {
			self.logger.trace("exit: dc_unkeyed.decode(_:UInt.Type)")
		}
		#endif
		switch self.state {
			case .end:
			throw Decoding.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeUInt()
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as a uint8.
	internal mutating func decode(_ type:UInt8.Type) throws -> UInt8 {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_unkeyed.decode(_:UInt8.Type)")
		defer {
			self.logger.trace("exit: dc_unkeyed.decode(_:UInt8.Type)")
		}
		#endif
		switch self.state {
			case .end:
			throw Decoding.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeUInt8()
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as a uint16.
	internal mutating func decode(_ type:UInt16.Type) throws -> UInt16 {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_unkeyed.decode(_:UInt16.Type)")
		defer {
			self.logger.trace("exit: dc_unkeyed.decode(_:UInt16.Type)")
		}
		#endif
		switch self.state {
			case .end:
			throw Decoding.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeUInt16()
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as a uint32.
	internal mutating func decode(_ type:UInt32.Type) throws -> UInt32 {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_unkeyed.decode(_:UInt32.Type)")
		defer {
			self.logger.trace("exit: dc_unkeyed.decode(_:UInt32.Type)")
		}
		#endif
		switch self.state {
			case .end:
			throw Decoding.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeUInt32()
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as a uint64.
	internal mutating func decode(_ type:UInt64.Type) throws -> UInt64 {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_unkeyed.decode(_:UInt64.Type)")
		defer {
			self.logger.trace("exit: dc_unkeyed.decode(_:UInt64.Type)")
		}
		#endif
		switch self.state {
			case .end:
			throw Decoding.Error.contentOverflow
			case .content(let root):
			let decodedValue = try root.decodeUInt64()
			self.increment()
			return decodedValue
		}
	}

	/// decodes a given decodable type from the next value in the container.
	internal mutating func decode<T>(_ type:T.Type) throws -> T where T:Decodable {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: dc_unkeyed.decode(_:T.Type)")
		defer {
			self.logger.trace("exit: dc_unkeyed.decode(_:T.Type)")
		}
		#endif
		switch self.state {
			case .end:
			throw Decoding.Error.contentOverflow
			case .content(let root):

			#if QUICKJSON_SHOULDLOG
			let decodedValue = try T(from:decoder(root:root, logLevel:self.logLevel))
			#else
			let decodedValue = try T(from:decoder(root:root))
			#endif
			self.increment()
			return decodedValue
		}
	}

	/// decodes the next value in the container as a keyed container.
	internal mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: nestedContainer(keyedBy:)")
		defer {
			self.logger.trace("exit: nestedContainer(keyedBy:)")
		}
		#endif
		switch self.state {
			case .end:
			throw Decoding.Error.contentOverflow
			case .content(let root):

			#if QUICKJSON_SHOULDLOG
			let decodedValue = try KeyedDecodingContainer(dc_keyed<NestedKey>(root:root, logLevel:self.logLevel))
			#else
			let decodedValue = try KeyedDecodingContainer(dc_keyed<NestedKey>(root:root))
			#endif
			self.increment()
			return decodedValue
		}
	}

	/// decode the next value in the container as an unkeyed container.
	internal mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
		#if QUICKJSON_SHOULDLOG
		self.logger.debug("enter: nestedUnkeyedContainer()")
		defer {
			self.logger.trace("exit: nestedUnkeyedContainer()")
		}
		#endif
		switch self.state {
			case .end:
			throw Decoding.Error.contentOverflow
			case .content(let root):
			#if QUICKJSON_SHOULDLOG
			let decodedValue = try dc_unkeyed(root:root, logLevel:self.logLevel)
			#else
			let decodedValue = try dc_unkeyed(root:root)
			#endif
			self.increment()
			return decodedValue
		}
	}

	/// returns the number of elements in the decoding container.
	internal var count:Int? {
		get {
			return self.length
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