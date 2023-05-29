// (c) tanner silva 2023. all rights reserved.
import yyjson

/// MemoryPool
public typealias MemoryPool = yyjson_alc
extension MemoryPool {
	/// create a new static-sized memory pool. 
	public static func allocate(staticSize:size_t, staticBuffer:UnsafeMutableRawPointer) -> MemoryPool? {
		var initialValue = yyjson_alc()
		guard yyjson_alc_pool_init(&initialValue, staticBuffer, staticSize) else {
			return nil
		}
		return initialValue
	}
}

/// represents various JSON types. this is primarily used to describe type mismatches.
public enum ValueType:UInt8 {
	/// represents no value
	case none = 0
	/// represents a raw value
	case raw = 1
	/// represents a null value
	case null = 2
	/// represents a boolean value
	case bool = 3
	/// represents a numeric value
	case num = 4
	/// represents a string value
	case str = 5
	/// represents an array value
	case arr = 6
	/// represents an object value
	case obj = 7

	/// initialize a value type given a underlying yyjson_type
	internal init(_ yyjsonType:yyjson_type) {
		switch yyjsonType {
		case YYJSON_TYPE_NULL:
			self = .null
		case YYJSON_TYPE_BOOL:
			self = .bool
		case YYJSON_TYPE_NUM:
			self = .num
		case YYJSON_TYPE_STR:
			self = .str
		case YYJSON_TYPE_ARR:
			self = .arr
		case YYJSON_TYPE_OBJ:
			self = .obj
		default:
			self = .none
		}
	}

	/// get the underlying yyjson_type
	internal var yyjsonType:yyjson_type {
		switch self {
		case .null:
			return YYJSON_TYPE_NULL
		case .bool:
			return YYJSON_TYPE_BOOL
		case .num:
			return YYJSON_TYPE_NUM
		case .str:
			return YYJSON_TYPE_STR
		case .arr:
			return YYJSON_TYPE_ARR
		case .obj:
			return YYJSON_TYPE_OBJ
		default:
			return YYJSON_TYPE_NONE
		}
	}
}