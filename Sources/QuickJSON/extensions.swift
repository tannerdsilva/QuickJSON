// (c) tanner silva 2023. all rights reserved.
import yyjson

// decoding extensions help prevent code duplication across the various decoding containers.
extension UnsafeMutablePointer where Pointee == yyjson_val {
	/// returns true if the value is nil
	internal func decodeNil() -> Bool {
		return yyjson_get_type(self) == YYJSON_TYPE_NULL
	}

	/// returns the value in boolean form
	/// - throws: `Decoder.Error.valueTypeMismatch` if the value is not a boolean
	internal func decodeBool() throws -> Bool {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_BOOL else {
			throw Decoder.Error.valueTypeMismatch(Decoder.Error.ValueTypeMismatchInfo(expected:ValueType.bool, found:ValueType(type)))
		}
		return yyjson_get_bool(self)
	}

	/// returns the value in string form
	/// - throws: `Decoder.Error.valueTypeMismatch` if the value is not a string
	internal func decodeString() throws -> String {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_STR else {
			throw Decoder.Error.valueTypeMismatch(Decoder.Error.ValueTypeMismatchInfo(expected:ValueType.str, found:ValueType(type)))
		}
		let str = yyjson_get_str(self)!
		return String(cString:str)
	}

	/// returns the value in double form
	/// - throws: `Decoder.Error.valueTypeMismatch` if the value is not a number
	internal func decodeDouble() throws -> Double {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoder.Error.valueTypeMismatch(Decoder.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		return yyjson_get_num(self)
	}

	/// returns the value in float form
	/// - throws: `Decoder.Error.valueTypeMismatch` if the value is not a number
	internal func decodeFloat() throws -> Float {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoder.Error.valueTypeMismatch(Decoder.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		let dubVal = yyjson_get_num(self)
		return Float(dubVal)
	}

	/// returns the value in int form
	/// - throws: `Decoder.Error.valueTypeMismatch` if the value is not a number
	internal func decodeInt() throws -> Int {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoder.Error.valueTypeMismatch(Decoder.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		let intVal = yyjson_get_sint(self)
		return Int(intVal)
	}

	/// returns the value in int8 form
	/// - throws: `Decoder.Error.valueTypeMismatch` if the value is not a number
	internal func decodeInt8() throws -> Int8 {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoder.Error.valueTypeMismatch(Decoder.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		let intVal = yyjson_get_sint(self)
		return Int8(intVal)
	}

	/// returns the value in int16 form
	/// - throws: `Decoder.Error.valueTypeMismatch` if the value is not a number
	internal func decodeInt16() throws -> Int16 {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoder.Error.valueTypeMismatch(Decoder.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		let intVal = yyjson_get_sint(self)
		return Int16(intVal)
	}

	/// returns the value in int32 form
	/// - throws: `Decoder.Error.valueTypeMismatch` if the value is not a number
	internal func decodeInt32() throws -> Int32 {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoder.Error.valueTypeMismatch(Decoder.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		return yyjson_get_int(self)
	}

	/// returns the value in int64 form
	/// - throws: `Decoder.Error.valueTypeMismatch` if the value is not a number
	internal func decodeInt64() throws -> Int64 {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoder.Error.valueTypeMismatch(Decoder.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		return yyjson_get_sint(self)
	}

	/// returns the value in uint form
	/// - throws: `Decoder.Error.valueTypeMismatch` if the value is not a number
	internal func decodeUInt() throws -> UInt {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoder.Error.valueTypeMismatch(Decoder.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		let intVal = yyjson_get_uint(self)
		return UInt(intVal)
	}

	/// returns the value in uint8 form
	/// - throws: `Decoder.Error.valueTypeMismatch` if the value is not a number
	internal func decodeUInt8() throws -> UInt8 {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoder.Error.valueTypeMismatch(Decoder.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		let intVal = yyjson_get_uint(self)
		return UInt8(intVal)
	}

	/// returns the value in uint16 form
	/// - throws: `Decoder.Error.valueTypeMismatch` if the value is not a number
	internal func decodeUInt16() throws -> UInt16 {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoder.Error.valueTypeMismatch(Decoder.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		let intVal = yyjson_get_uint(self)
		return UInt16(intVal)
	}

	/// returns the value in uint32 form
	/// - throws: `Decoder.Error.valueTypeMismatch` if the value is not a number
	internal func decodeUInt32() throws -> UInt32 {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoder.Error.valueTypeMismatch(Decoder.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		let intVal = yyjson_get_uint(self)
		return UInt32(intVal)
	}

	/// returns the value in uint64 form
	/// - throws: `Decoder.Error.valueTypeMismatch` if the value is not a number
	internal func decodeUInt64() throws -> UInt64 {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoder.Error.valueTypeMismatch(Decoder.Error.ValueTypeMismatchInfo(expected:ValueType.num, found:ValueType(type)))
		}
		return yyjson_get_uint(self)
	}
}