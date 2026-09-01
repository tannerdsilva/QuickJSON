// (c) tanner silva 2023. all rights reserved.
import Logging
import yyjson

/// describes where a value produced by an encoding operation should be placed in the document tree.
internal enum EncodingPosition {
	/// the value becomes the root value of the document.
	case root
	/// the value is appended as the next element of the given array.
	case arrayElement(UnsafeMutablePointer<yyjson_mut_val>)
	/// the value is assigned under the given pre-created key in the given object.
	case keyedValue(UnsafeMutablePointer<yyjson_mut_val>, UnsafeMutablePointer<yyjson_mut_val>)
}

/// an encoder that writes values into a yyjson mutable document at a given position.
/// this is the sole `Swift.Encoder` implementation in the package: the position determines whether the value
/// lands at the document root, as an array element, or as a keyed value in an object.
internal struct NodeEncoder: Swift.Encoder {
	private let doc: UnsafeMutablePointer<yyjson_mut_doc>
	private let position: EncodingPosition
	private let logger: Logger

	/// initialize an encoder that writes to the given document at the given position.
	/// - parameter doc: the mutable document to write to.
	/// - parameter position: where values produced by this encoder should be placed.
	/// - parameter logLevel: the log level to use for this encoder.
	internal init(doc: UnsafeMutablePointer<yyjson_mut_doc>, position: EncodingPosition, logLevel: Logger.Level = .critical) {
		self.doc = doc
		self.position = position
		self.logger = Encoding.logger.settingLogLevel(logLevel)
	}

	/// retrieve a keyed container for this encoder.
	internal func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
		logger.debug("enter: NodeEncoder.container(keyedBy:)")
		let newObj = yyjson_mut_obj(doc)!
		place(newObj)
		return KeyedEncodingContainer(KeyedEncoder(doc: doc, root: newObj, logLevel: logger.logLevel))
	}

	/// retrieve an unkeyed container for this encoder.
	internal func unkeyedContainer() -> UnkeyedEncodingContainer {
		logger.debug("enter: NodeEncoder.unkeyedContainer()")
		let newArr = yyjson_mut_arr(doc)!
		place(newArr)
		return UnkeyedEncoder(doc: doc, root: newArr, logLevel: logger.logLevel)
	}

	/// retrieve the single value container for this encoder.
	internal func singleValueContainer() -> SingleValueEncodingContainer {
		logger.debug("enter: NodeEncoder.singleValueContainer()")
		return SingleValueEncoder(doc: doc, position: position, logLevel: logger.logLevel)
	}

	// required by swift. unused.
	internal var userInfo: [CodingUserInfoKey: Any] {
		[:]
	}

	// required by swift. unused.
	internal var codingPath: [CodingKey] {
		[]
	}

	/// attach a freshly created container value to the document tree at this encoder's position.
	private func place(_ val: UnsafeMutablePointer<yyjson_mut_val>) {
		switch position {
		case .root:
			yyjson_mut_doc_set_root(doc, val)
		case .arrayElement(let arr):
			assert(yyjson_mut_arr_append(arr, val) == true)
		case .keyedValue(let obj, let key):
			assert(yyjson_mut_obj_put(obj, key, val) == true)
		}
	}
}
