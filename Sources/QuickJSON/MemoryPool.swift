// (c) tanner silva 2023. all rights reserved.
import yyjson

/// a "pool" of memory that can be used to either encode or decode JSON data.
public class MemoryPool {
	/// thrown when `malloc` fails to allocate memory for the memory pool.
	public struct MemoryAllocationError:Swift.Error  {}
	/// thrown when ``yyjson_alc_pool_init`` fails to initialize with a given buffer.
	public struct InitializationError:Swift.Error {}

	internal var alc:yyjson_alc
	private let bufferPointer:UnsafeMutableRawPointer
	internal let bufferSize:size_t

	/// returns the recommended read buffer size for decoding data, provided a given input size and flags.
	public static func recommendedReadBufferSize(maximumInput:size_t, flags:Decoder.Flags) -> size_t {
		return yyjson_read_max_memory_usage(maximumInput, flags.rawValue)
	}

	/// initialize a memory pool with a given buffer size. the buffer will be allocated using malloc and automatically freed when the memory pool is deinitialized.
	public init(bufferSize:size_t) throws {
		let newBuffer = malloc(bufferSize)
		guard newBuffer != nil else {
			throw MemoryAllocationError()
		}
		var newAlc = yyjson_alc()
		guard yyjson_alc_pool_init(&newAlc, newBuffer, bufferSize) else {
			free(newBuffer)
			throw InitializationError()
		}
		self.alc = newAlc
		self.bufferPointer = newBuffer!
		self.bufferSize = bufferSize
	}

	/// exposes the underlying yyjson_alc for use in other functions.
	internal func expose<R>(_ exposureBlock:(inout yyjson_alc) throws -> R) rethrows -> R {
		return try exposureBlock(&self.alc)
	}

	/// frees the enclosed buffer when the memory pool is deinitialized.
	deinit {
		free(bufferPointer)
	}
}