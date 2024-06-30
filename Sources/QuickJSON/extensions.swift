// (c) tanner silva 2023. all rights reserved.
import yyjson

#if QUICKJSON_SHOULDLOG
import Logging
#endif

// an encoding extension to reduce duplicate code to export a json document as a byte array.
extension UnsafeMutablePointer where Pointee == yyjson_mut_doc {
	#if QUICKJSON_SHOULDLOG
	internal func exportDocumentBytes(flags:Encoding.Flags, logger:Logging.Logger?) throws -> [UInt8] {
		var outLen = 0
		var errInfo = yyjson_write_err()
		let outputDat = yyjson_mut_write_opts(self, flags.rawValue, nil, &outLen, &errInfo)
		switch outputDat {
			case nil:
				logger?.error("internal memory failure while exporting json document bytes")
				throw Encoding.Error.memoryAllocationFailure
			default:
				defer {
					free(outputDat)
				}
				guard errInfo.code == 0 else {
					logger?.error("nonzero return code while exporting json document bytes")
					throw Encoding.Error.assignmentError
				}
				guard outLen > 0 else {
					logger?.warning("exporting zero-length json document")
					return []
				}
				logger?.debug("exported json document body of \(outLen) bytes")
				return Array(unsafeUninitializedCapacity:outLen, initializingWith: { (arrBuff, arrSize) in
					arrSize = outLen
					memcpy(arrBuff.baseAddress!, outputDat!, outLen)
				})
		}
	}
	#else
	internal func exportDocumentBytes(flags:Encoding.Flags) throws -> [UInt8] {
		var outLen = 0
		var errInfo = yyjson_write_err()
		let outputDat = yyjson_mut_write_opts(self, flags.rawValue, nil, &outLen, &errInfo)
		switch outputDat {
			case nil:
				throw Encoding.Error.memoryAllocationFailure
			default:
				defer {
					free(outputDat)
				}
				guard errInfo.code == 0 else {
					throw Encoding.Error.assignmentError
				}
				guard outLen > 0 else {
					return []
				}
				return Array(unsafeUninitializedCapacity:outLen, initializingWith: { (arrBuff, arrSize) in
					arrSize = outLen
					memcpy(arrBuff.baseAddress!, outputDat!, outLen)
				})
		}
	}
	#endif
}

// decoding extensions help prevent code duplication across the various decoding containers.
extension UnsafeMutablePointer where Pointee == yyjson_val {
	/// returns true if the value is nil
	internal func decodeNil() -> Bool {
		return yyjson_get_type(self) == YYJSON_TYPE_NULL
	}
}

// decode bool
extension UnsafeMutablePointer where Pointee == yyjson_val {	
	#if QUICKJSON_SHOULDLOG
	internal func decodeBool(logger:Logger?) throws -> Bool {
		logger?.debug("enter: decodeBool()")
		defer {
			logger?.trace("exit: decodeBool()")
		}
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_BOOL else {
			logger?.error("unable to decode value - unexptected value type found")
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.bool, found:ValueType(type)))
		}
		return yyjson_get_bool(self)
	}
	#else
	internal func decodeBool() throws -> Bool {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_BOOL else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.bool, found:ValueType(type)))
		}
		return yyjson_get_bool(self)
	}
	#endif
}

// decode string
extension UnsafeMutablePointer where Pointee == yyjson_val {
	
	#if QUICKJSON_SHOULDLOG
	internal func decodeString(logger:Logger?) throws -> String {
		logger?.debug("enter: decodeString()")
		defer {
			logger?.trace("exit: decodeString()")
		}
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_STR else {
			logger?.error("unable to decode value - unexptected value type found")
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.str, found:ValueType(type)))
		}
		return String(cString:yyjson_get_str(self)!)
	}
	#else
	/// returns the value in string form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a string
	internal func decodeString() throws -> String {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_STR else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.str, found:ValueType(type)))
		}
		return String(cString:yyjson_get_str(self)!)
	}
	#endif
}

// decode floats
extension UnsafeMutablePointer where Pointee == yyjson_val {
	
	#if QUICKJSON_SHOULDLOG
	internal func decodeDouble(logger:Logger?) throws -> Double {
		logger?.debug("enter: decodeDouble()")
		defer {
			logger?.trace("exit: decodeDouble()")
		}
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			logger?.error("unable to decode value - unexptected value type found")
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		return yyjson_get_num(self)
	}
	#else
	/// returns the value in double form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number
	internal func decodeDouble() throws -> Double {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		return yyjson_get_num(self)
	}
	#endif
	
	#if QUICKJSON_SHOULDLOG
	internal func decodeFloat(logger:Logger?) throws -> Float {
		logger?.debug("enter: decodeFloat()")
		defer {
			logger?.trace("exit: decodeFloat()")
		}
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			logger?.error("unable to decode value - unexptected value type found")
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		return Float(yyjson_get_num(self))
	}
	#else
	/// returns the value in float form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number
	internal func decodeFloat() throws -> Float {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		return Float(yyjson_get_num(self))
	}
	#endif
}

// decode ints
extension UnsafeMutablePointer where Pointee == yyjson_val {
	/// returns the value in int form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number
	#if QUICKJSON_SHOULDLOG
	internal func decodeInt(logger:Logger?) throws -> Int {
		logger?.debug("enter: decodeInt()")
		defer {
			logger?.trace("exit: decodeInt()")
		}
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			logger?.error("unable to decode value - unexptected value type found")
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		return Int(yyjson_get_sint(self))
	}
	#else
	internal func decodeInt() throws -> Int {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		return Int(yyjson_get_sint(self))
	}
	#endif

	/// returns the value in int8 form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number
	#if QUICKJSON_SHOULDLOG
	internal func decodeInt8(logger:Logger?) throws -> Int8 {
		logger?.debug("enter: decodeInt8()")
		defer {
			logger?.trace("exit: decodeInt8()")
		}
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			logger?.error("unable to decode value - unexptected value type found")
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		return Int8(yyjson_get_sint(self))
	}
	#else
	internal func decodeInt8() throws -> Int8 {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		return Int8(yyjson_get_sint(self))
	}
	#endif

	/// returns the value in int16 form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number
	#if QUICKJSON_SHOULDLOG
	internal func decodeInt16(logger:Logger?) throws -> Int16 {
		logger?.debug("enter: decodeInt16()")
		defer {
			logger?.trace("exit: decodeInt16()")
		}
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			logger?.error("unable to decode value - unexptected value type found")
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		return Int16(yyjson_get_sint(self))
	}
	#else
	internal func decodeInt16() throws -> Int16 {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		return Int16(yyjson_get_sint(self))
	}
	#endif

	/// returns the value in int32 form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number
	#if QUICKJSON_SHOULDLOG
	internal func decodeInt32(logger:Logger?) throws -> Int32 {
		logger?.debug("enter: decodeInt32()")
		defer {
			logger?.trace("exit: decodeInt32()")
		}
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			logger?.error("unable to decode value - unexptected value type found")
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		return yyjson_get_int(self)
	}
	#else
	internal func decodeInt32() throws -> Int32 {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		return yyjson_get_int(self)
	}

	#endif

	/// returns the value in int64 form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number
	#if QUICKJSON_SHOULDLOG
	internal func decodeInt64(logger:Logger?) throws -> Int64 {
		logger?.debug("enter: decodeInt64()")
		defer {
			logger?.trace("exit: decodeInt64()")
		}
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			logger?.error("unable to decode value - unexptected value type found")
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		return yyjson_get_sint(self)
	}
	#else
	internal func decodeInt64() throws -> Int64 {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		return yyjson_get_sint(self)
	}
	#endif

	/// returns the value in uint form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number
	#if QUICKJSON_SHOULDLOG
	internal func decodeUInt(logger:Logger?) throws -> UInt {
		logger?.debug("enter: decodeUInt()")
		defer {
			logger?.trace("exit: decodeUInt()")
		}
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			logger?.error("unable to decode value - unexptected value type found")
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		return UInt(yyjson_get_uint(self))
	}
	#else
	internal func decodeUInt() throws -> UInt {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		return UInt(yyjson_get_uint(self))
	}
	#endif

	/// returns the value in uint8 form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number
	#if QUICKJSON_SHOULDLOG
	internal func decodeUInt8(logger:Logger?) throws -> UInt8 {
		logger?.debug("enter: decodeUInt8()")
		defer {
			logger?.trace("exit: decodeUInt8()")
		}
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			logger?.error("unable to decode value - unexptected value type found")
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		let intVal = yyjson_get_uint(self)
		return UInt8(intVal)
	}
	#else
	internal func decodeUInt8() throws -> UInt8 {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		let intVal = yyjson_get_uint(self)
		return UInt8(intVal)
	}
	#endif

	/// returns the value in uint16 form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number
	#if QUICKJSON_SHOULDLOG
	internal func decodeUInt16(logger:Logger?) throws -> UInt16 {
		logger?.debug("enter: decodeUInt16()")
		defer {
			logger?.trace("exit: decodeUInt16()")
		}
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			logger?.error("unable to decode value - unexptected value type found")
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		let intVal = yyjson_get_uint(self)
		return UInt16(intVal)
	}
	#else
	internal func decodeUInt16() throws -> UInt16 {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		let intVal = yyjson_get_uint(self)
		return UInt16(intVal)
	}
	#endif

	/// returns the value in uint32 form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number
	#if QUICKJSON_SHOULDLOG
	internal func decodeUInt32(logger:Logger?) throws -> UInt32 {
		logger?.debug("enter: decodeUInt32()")
		defer {
			logger?.trace("exit: decodeUInt32()")
		}
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			logger?.error("unable to decode value - unexptected value type found")
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		let intVal = yyjson_get_uint(self)
		return UInt32(intVal)
	}
	#else
	internal func decodeUInt32() throws -> UInt32 {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		let intVal = yyjson_get_uint(self)
		return UInt32(intVal)
	}
	#endif

	/// returns the value in uint64 form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number
	#if QUICKJSON_SHOULDLOG
	internal func decodeUInt64(logger:Logger?) throws -> UInt64 {
		logger?.debug("enter: decodeUInt64()")
		defer {
			logger?.trace("exit: decodeUInt64()")
		}
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			logger?.error("unable to decode value - unexptected value type found")
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		return yyjson_get_uint(self)
	}
	#else
	internal func decodeUInt64() throws -> UInt64 {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		return yyjson_get_uint(self)
	}
	#endif
}