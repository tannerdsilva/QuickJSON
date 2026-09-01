// (c) tanner silva 2023. all rights reserved.
import Logging
import yyjson

/// a single value encoding container that applies a value to the document tree at a given position.
internal struct SingleValueEncoder: Swift.SingleValueEncodingContainer {
	private let doc: UnsafeMutablePointer<yyjson_mut_doc>
	private let position: EncodingPosition
	private let logger: Logger

	/// initialize a single value container.
	/// - parameter doc: the mutable document to write to.
	/// - parameter position: where the encoded value should be placed.
	/// - parameter logLevel: the log level to use for this container.
	internal init(doc: UnsafeMutablePointer<yyjson_mut_doc>, position: EncodingPosition, logLevel: Logger.Level = .critical) {
		self.doc = doc
		self.position = position
		self.logger = Encoding.logger.settingLogLevel(logLevel)
	}

	/// encode a null value.
	internal func encodeNil() throws {
		try placeValue { yyjson_mut_null(doc) }
	}

	/// encode a boolean value.
	internal func encode(_ value: Bool) throws {
		try placeValue { yyjson_mut_bool(doc, value) }
	}

	/// encode a string value.
	internal func encode(_ value: String) throws {
		try placeValue { yyjson_mut_strncpy(doc, value, value.utf8.count) }
	}

	/// encode a double value.
	internal func encode(_ value: Double) throws {
		try placeValue { yyjson_mut_real(doc, value) }
	}

	/// encode a float value.
	internal func encode(_ value: Float) throws {
		try placeValue { yyjson_mut_real(doc, Double(value)) }
	}

	/// encode an integer value.
	internal func encode(_ value: Int) throws {
		try placeValue { yyjson_mut_int(doc, Int64(value)) }
	}

	/// encode an int8 value.
	internal func encode(_ value: Int8) throws {
		try placeValue { yyjson_mut_int(doc, Int64(value)) }
	}

	/// encode an int16 value.
	internal func encode(_ value: Int16) throws {
		try placeValue { yyjson_mut_int(doc, Int64(value)) }
	}

	/// encode an int32 value.
	internal func encode(_ value: Int32) throws {
		try placeValue { yyjson_mut_int(doc, Int64(value)) }
	}

	/// encode an int64 value.
	internal func encode(_ value: Int64) throws {
		try placeValue { yyjson_mut_int(doc, value) }
	}

	/// encode an unsigned integer value.
	internal func encode(_ value: UInt) throws {
		try placeValue { yyjson_mut_uint(doc, UInt64(value)) }
	}

	/// encode a uint8 value.
	internal func encode(_ value: UInt8) throws {
		try placeValue { yyjson_mut_uint(doc, UInt64(value)) }
	}

	/// encode a uint16 value.
	internal func encode(_ value: UInt16) throws {
		try placeValue { yyjson_mut_uint(doc, UInt64(value)) }
	}

	/// encode a uint32 value.
	internal func encode(_ value: UInt32) throws {
		try placeValue { yyjson_mut_uint(doc, UInt64(value)) }
	}

	/// encode a uint64 value.
	internal func encode(_ value: UInt64) throws {
		try placeValue { yyjson_mut_uint(doc, value) }
	}

	/// encode a value of an arbitrary encodable type.
	internal func encode<T>(_ value: T) throws where T: Encodable {
		logger.debug("enter: SingleValueEncoder.encode(_:)")
		try value.encode(to: NodeEncoder(doc: doc, position: position, logLevel: logger.logLevel))
	}

	// required by swift. unused.
	internal var codingPath: [CodingKey] {
		[]
	}

	/// construct a new value with the given maker and attach it to the document tree at this container's position.
	private func placeValue(_ make: () -> UnsafeMutablePointer<yyjson_mut_val>?) throws {
		guard let newVal = make() else {
			throw Encoding.Error.assignmentError
		}
		switch position {
		case .root:
			yyjson_mut_doc_set_root(doc, newVal)
		case .arrayElement(let arr):
			guard yyjson_mut_arr_append(arr, newVal) == true else {
				throw Encoding.Error.assignmentError
			}
		case .keyedValue(let obj, let key):
			guard yyjson_mut_obj_put(obj, key, newVal) == true else {
				throw Encoding.Error.assignmentError
			}
		}
	}
}
