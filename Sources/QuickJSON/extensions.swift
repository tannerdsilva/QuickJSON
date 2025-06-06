// (c) tanner silva 2023. all rights reserved.
import yyjson

// an encoding extension to reduce duplicate code to export a json document as a byte array.
extension UnsafeMutablePointer where Pointee == yyjson_mut_doc {
	/// export the json document as a byte array.
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
}

// decoding extensions help prevent code duplication across the various decoding containers.
extension UnsafeMutablePointer where Pointee == yyjson_val {
	/// returns true if the value is nil
	internal func decodeNil() -> Bool {
		return yyjson_get_type(self) == YYJSON_TYPE_NULL
	}

	/// returns the value in boolean form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a boolean
	internal func decodeBool() throws -> Bool {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_BOOL else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.bool, found:ValueType(type)))
		}
		return yyjson_get_bool(self)
	}

	/// returns the value in boolean form, or nil if the value is null
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a boolean or null
	/// - returns: `nil` if the value is null, otherwise the boolean value
	internal func decodeBoolIfPresent() throws -> Bool? {
		let type = yyjson_get_type(self)
		switch type {
			case YYJSON_TYPE_NULL:
				return nil
			case YYJSON_TYPE_BOOL:
				return yyjson_get_bool(self)
			default:
				throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.bool, found:ValueType(type)))
		}
	}

	/// returns the value in string form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a string
	internal func decodeString() throws -> String {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_STR else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.str, found:ValueType(type)))
		}
		let str = yyjson_get_str(self)!
		return String(cString:str)
	}

	/// returns the value in string form, or nil if the value is null
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a string or null
	/// - returns: `nil` if the value is null, otherwise the string value
	internal func decodeStringIfPresent() throws -> String? {
		let type = yyjson_get_type(self)
		switch type {
			case YYJSON_TYPE_NULL:
				return nil
			case YYJSON_TYPE_STR:
				let str = yyjson_get_str(self)!
				return String(cString:str)
			default:
				throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.str, found:ValueType(type)))
		}
	}

	/// returns the value in double form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number
	internal func decodeDouble() throws -> Double {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		return yyjson_get_num(self)
	}

	/// returns the value in float form, or nil if the value is null
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number or null
	/// - returns: `nil` if the value is null, otherwise the double value
	internal func decodeDoubleIfPresent() throws -> Double? {
		let type = yyjson_get_type(self)
		switch type {
			case YYJSON_TYPE_NULL:
				return nil
			case YYJSON_TYPE_NUM:
				return yyjson_get_num(self)
			default:
				throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
	}

	/// returns the value in float form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number
	internal func decodeFloat() throws -> Float {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		let dubVal = yyjson_get_num(self)
		return Float(dubVal)
	}

	/// returns the value in float form, or nil if the value is null
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number or null
	/// - returns: `nil` if the value is null, otherwise the float value
	internal func decodeFloatIfPresent() throws -> Float? {
		let type = yyjson_get_type(self)
		switch type {
			case YYJSON_TYPE_NULL:
				return nil
			case YYJSON_TYPE_NUM:
				let dubVal = yyjson_get_num(self)
				return Float(dubVal)
			default:
				throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
	}

	/// returns the value in int form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number
	internal func decodeInt() throws -> Int {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		let intVal = yyjson_get_sint(self)
		return Int(intVal)
	}

	/// returns the value in int form, or nil if the value is null
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number or null
	/// - returns: `nil` if the value is null, otherwise the int value
	internal func decodeIntIfPresent() throws -> Int? {
		let type = yyjson_get_type(self)
		switch type {
			case YYJSON_TYPE_NULL:
				return nil
			case YYJSON_TYPE_NUM:
				let intVal = yyjson_get_sint(self)
				return Int(intVal)
			default:
				throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
	}

	/// returns the value in int8 form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number
	internal func decodeInt8() throws -> Int8 {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		let intVal = yyjson_get_sint(self)
		return Int8(intVal)
	}

	/// returns the value in int8 form, or nil if the value is null
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number or null
	/// - returns: `nil` if the value is null, otherwise the int8 value
	internal func decodeInt8IfPresent() throws -> Int8? {
		let type = yyjson_get_type(self)
		switch type {
			case YYJSON_TYPE_NULL:
				return nil
			case YYJSON_TYPE_NUM:
				let intVal = yyjson_get_sint(self)
				return Int8(intVal)
			default:
				throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
	}

	/// returns the value in int16 form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number
	internal func decodeInt16() throws -> Int16 {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		let intVal = yyjson_get_sint(self)
		return Int16(intVal)
	}

	/// returns the value in int16 form, or nil if the value is null
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number or null
	/// - returns: `nil` if the value is null, otherwise the int16 value
	internal func decodeInt16IfPresent() throws -> Int16? {
		let type = yyjson_get_type(self)
		switch type {
			case YYJSON_TYPE_NULL:
				return nil
			case YYJSON_TYPE_NUM:
				let intVal = yyjson_get_sint(self)
				return Int16(intVal)
			default:
				throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
	}

	/// returns the value in int32 form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number
	internal func decodeInt32() throws -> Int32 {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		return yyjson_get_int(self)
	}

	/// returns the value in int32 form, or nil if the value is null
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number or null
	/// - returns: `nil` if the value is null, otherwise the int32 value
	internal func decodeInt32IfPresent() throws -> Int32? {
		let type = yyjson_get_type(self)
		switch type {
			case YYJSON_TYPE_NULL:
				return nil
			case YYJSON_TYPE_NUM:
				return yyjson_get_int(self)
			default:
				throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
	}

	/// returns the value in int64 form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number
	internal func decodeInt64() throws -> Int64 {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		return yyjson_get_sint(self)
	}

	/// returns the value in int64 form, or nil if the value is null
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number or null
	/// - returns: `nil` if the value is null, otherwise the int64 value
	internal func decodeInt64IfPresent() throws -> Int64? {
		let type = yyjson_get_type(self)
		switch type {
			case YYJSON_TYPE_NULL:
				return nil
			case YYJSON_TYPE_NUM:
				return yyjson_get_sint(self)
			default:
				throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
	}

	/// returns the value in uint form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number
	internal func decodeUInt() throws -> UInt {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		let intVal = yyjson_get_uint(self)
		return UInt(intVal)
	}

	/// returns the value in uint form, or nil if the value is null
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number or null
	/// - returns: `nil` if the value is null, otherwise the uint value
	internal func decodeUIntIfPresent() throws -> UInt? {
		let type = yyjson_get_type(self)
		switch type {
			case YYJSON_TYPE_NULL:
				return nil
			case YYJSON_TYPE_NUM:
				let intVal = yyjson_get_uint(self)
				return UInt(intVal)
			default:
				throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
	}

	/// returns the value in uint8 form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number
	internal func decodeUInt8() throws -> UInt8 {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		let intVal = yyjson_get_uint(self)
		return UInt8(intVal)
	}

	/// returns the value in uint8 form, or nil if the value is null
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number or null
	/// - returns: `nil` if the value is null, otherwise the uint8 value
	internal func decodeUInt8IfPresent() throws -> UInt8? {
		let type = yyjson_get_type(self)
		switch type {
			case YYJSON_TYPE_NULL:
				return nil
			case YYJSON_TYPE_NUM:
				let intVal = yyjson_get_uint(self)
				return UInt8(intVal)
			default:
				throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
	}

	/// returns the value in uint16 form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number
	internal func decodeUInt16() throws -> UInt16 {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		let intVal = yyjson_get_uint(self)
		return UInt16(intVal)
	}

	/// returns the value in uint16 form, or nil if the value is null
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number or null
	/// - returns: `nil` if the value is null, otherwise the uint16 value
	internal func decodeUInt16IfPresent() throws -> UInt16? {
		let type = yyjson_get_type(self)
		switch type {
			case YYJSON_TYPE_NULL:
				return nil
			case YYJSON_TYPE_NUM:
				let intVal = yyjson_get_uint(self)
				return UInt16(intVal)
			default:
				throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
	}

	/// returns the value in uint32 form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number
	internal func decodeUInt32() throws -> UInt32 {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		let intVal = yyjson_get_uint(self)
		return UInt32(intVal)
	}

	/// returns the value in uint32 form, or nil if the value is null
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number or null
	/// - returns: `nil` if the value is null, otherwise the uint32 value
	internal func decodeUInt32IfPresent() throws -> UInt32? {
		let type = yyjson_get_type(self)
		switch type {
			case YYJSON_TYPE_NULL:
				return nil
			case YYJSON_TYPE_NUM:
				let intVal = yyjson_get_uint(self)
				return UInt32(intVal)
			default:
				throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
	}

	/// returns the value in uint64 form
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number
	internal func decodeUInt64() throws -> UInt64 {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		return yyjson_get_uint(self)
	}

	/// returns the value in uint64 form, or nil if the value is null
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number or null
	/// - returns: `nil` if the value is null, otherwise the uint64 value
	internal func decodeUInt64IfPresent() throws -> UInt64? {
		let type = yyjson_get_type(self)
		switch type {
			case YYJSON_TYPE_NULL:
				return nil
			case YYJSON_TYPE_NUM:
				return yyjson_get_uint(self)
			default:
				throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
	}
}