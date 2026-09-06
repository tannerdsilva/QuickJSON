// (c) tanner silva 2023. all rights reserved.
import yyjson

// pointer helpers shared by the encoding and decoding containers.

extension UnsafeMutablePointer where Pointee == yyjson_mut_doc {
	/// export the mutable document as a byte array in the given json format.
	/// - parameter flags: the write flags to apply during export.
	/// - throws: `Encoding.Error.memoryAllocationFailure` if yyjson could not allocate the output buffer; `Encoding.Error.assignmentError` if writing failed.
	internal func exportDocumentBytes(flags: Encoding.Flags) throws -> [UInt8] {
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
				return Array(unsafeUninitializedCapacity: outLen, initializingWith: { (arrBuff, arrSize) in
					arrSize = outLen
					memcpy(arrBuff.baseAddress!, outputDat!, outLen)
				})
		}
	}
}

// decoding helpers shared by the decoding containers.

extension UnsafeMutablePointer where Pointee == yyjson_val {
	/// returns true if the value is null.
	internal func decodeNil() -> Bool {
		return yyjson_get_type(self) == YYJSON_TYPE_NULL
	}

	/// returns the value in boolean form.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a boolean.
	internal func decodeBool() throws -> Bool {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_BOOL else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected: ValueType.bool, found: ValueType(type)))
		}
		return yyjson_get_bool(self)
	}

	/// returns the value in string form.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a string.
	internal func decodeString() throws -> String {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_STR else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected: ValueType.str, found: ValueType(type)))
		}
		return String(cString: yyjson_get_str(self)!)
	}

	/// returns the value in double form.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number.
	internal func decodeDouble() throws -> Double {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected: ValueType.num, found: ValueType(type)))
		}
		return yyjson_get_num(self)
	}

	/// returns the value in float form.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number.
	internal func decodeFloat() throws -> Float {
		return Float(try decodeDouble())
	}

	/// returns the value as a signed integer within the closed range of the requested type.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.numberOutOfRange` if the value does not fit in the requested type.
	internal func decodeInt() throws -> Int {
		let value = try decodeSignedInteger()
		guard value >= Int.min && value <= Int.max else {
			throw Decoding.Error.numberOutOfRange(requestedType: Int.self, value: Double(value))
		}
		return Int(value)
	}

	/// returns the value as an int8.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.numberOutOfRange` if the value does not fit in an `Int8`.
	internal func decodeInt8() throws -> Int8 {
		let value = try decodeSignedInteger()
		guard value >= Int8.min && value <= Int8.max else {
			throw Decoding.Error.numberOutOfRange(requestedType: Int8.self, value: Double(value))
		}
		return Int8(value)
	}

	/// returns the value as an int16.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.numberOutOfRange` if the value does not fit in an `Int16`.
	internal func decodeInt16() throws -> Int16 {
		let value = try decodeSignedInteger()
		guard value >= Int16.min && value <= Int16.max else {
			throw Decoding.Error.numberOutOfRange(requestedType: Int16.self, value: Double(value))
		}
		return Int16(value)
	}

	/// returns the value as an int32.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.numberOutOfRange` if the value does not fit in an `Int32`.
	internal func decodeInt32() throws -> Int32 {
		let value = try decodeSignedInteger()
		guard value >= Int32.min && value <= Int32.max else {
			throw Decoding.Error.numberOutOfRange(requestedType: Int32.self, value: Double(value))
		}
		return Int32(value)
	}

	/// returns the value as an int64.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number.
	internal func decodeInt64() throws -> Int64 {
		return try decodeSignedInteger()
	}

	/// returns the value as an unsigned integer within the closed range of the requested type.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.numberOutOfRange` if the value does not fit in the requested type.
	internal func decodeUInt() throws -> UInt {
		let value = try decodeUnsignedInteger()
		guard value <= UInt.max else {
			throw Decoding.Error.numberOutOfRange(requestedType: UInt.self, value: Double(value))
		}
		return UInt(value)
	}

	/// returns the value as a uint8.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.numberOutOfRange` if the value does not fit in a `UInt8`.
	internal func decodeUInt8() throws -> UInt8 {
		let value = try decodeUnsignedInteger()
		guard value <= UInt8.max else {
			throw Decoding.Error.numberOutOfRange(requestedType: UInt8.self, value: Double(value))
		}
		return UInt8(value)
	}

	/// returns the value as a uint16.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.numberOutOfRange` if the value does not fit in a `UInt16`.
	internal func decodeUInt16() throws -> UInt16 {
		let value = try decodeUnsignedInteger()
		guard value <= UInt16.max else {
			throw Decoding.Error.numberOutOfRange(requestedType: UInt16.self, value: Double(value))
		}
		return UInt16(value)
	}

	/// returns the value as a uint32.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.numberOutOfRange` if the value does not fit in a `UInt32`.
	internal func decodeUInt32() throws -> UInt32 {
		let value = try decodeUnsignedInteger()
		guard value <= UInt32.max else {
			throw Decoding.Error.numberOutOfRange(requestedType: UInt32.self, value: Double(value))
		}
		return UInt32(value)
	}

	/// returns the value as a uint64.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number.
	internal func decodeUInt64() throws -> UInt64 {
		return try decodeUnsignedInteger()
	}

	/// the raw signed integer backing this value.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.nonIntegerNumber` if the value is a real that is not an exactly-representable integer.
	private func decodeSignedInteger() throws -> Int64 {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected: ValueType.num, found: ValueType(type)))
		}
		if yyjson_is_int(self) {
			return yyjson_get_sint(self)
		}
		// a real-number value: accept it only when it is integral and exactly
		// representable in the requested width (Foundation-compatible —
		// `2.0` decodes as `Int(2)`, while `2.5` and `1e20` do not).
		let real = yyjson_get_real(self)
		guard let integer = Int64(exactly: real) else {
			throw Decoding.Error.nonIntegerNumber(real)
		}
		return integer
	}

	/// the raw unsigned integer backing this value.
	/// - throws: `Decoding.Error.valueTypeMismatch` if the value is not a number; `Decoding.Error.nonIntegerNumber` if the value is a real that is not an exactly-representable integer.
	private func decodeUnsignedInteger() throws -> UInt64 {
		let type = yyjson_get_type(self)
		guard type == YYJSON_TYPE_NUM else {
			throw Decoding.Error.valueTypeMismatch(Decoding.Error.ValueTypeMismatchInfo(expected: ValueType.num, found: ValueType(type)))
		}
		if yyjson_is_int(self) {
			return yyjson_get_uint(self)
		}
		// real-number values: integral and in-range only (see decodeSignedInteger).
		let real = yyjson_get_real(self)
		guard let integer = UInt64(exactly: real) else {
			throw Decoding.Error.nonIntegerNumber(real)
		}
		return integer
	}
}
