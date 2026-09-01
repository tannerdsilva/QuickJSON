// (c) tanner silva 2023. all rights reserved.
import yyjson

/// public namespace related to memory management.
public struct Memory {
	
	/// various ways that the memory backing for quickjson can be managed.
	public enum Configuration {
		/// memory should be automatically and dynamically claimed as needed.
		case automatic

		/// do not allocate memory for work. all work must be done with the provided preallocated memory region.
		case preallocated(Region)
	}

	/// a "region" of memory that can be used to encode or decode JSON data.
	/// - note: a region is not safe to share across threads; its pool allocator is single-threaded.
	public final class Region: @unchecked Sendable {
		/// thrown when `malloc` fails to allocate memory for the memory region.
		public struct MemoryAllocationError: Swift.Error, Sendable  {}
		/// thrown when `yyjson_alc_pool_init` fails to initialize with a given buffer.
		public struct InitializationError: Swift.Error, Sendable {}

		internal var alc: yyjson_alc
		private let bufferPointer: UnsafeMutableRawPointer
		internal let bufferSize: Int

		/// returns the recommended read buffer size for decoding data, provided a given input size and flags.
		public static func recommendedReadBufferSize(maximumInput: Int, flags: Decoding.Flags) -> Int {
			return yyjson_read_max_memory_usage(maximumInput, flags.rawValue)
		}

		/// allocate a memory region with a given buffer size. the buffer will be allocated using `malloc` and automatically freed when the region is deinitialized.
		/// - parameter bufferSize: the size of the buffer to allocate, in bytes.
		/// - throws: `MemoryAllocationError` if `malloc` fails.
		public required init(bufferSize: Int) throws {
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

		/// allocate a memory region sized by the recommended buffer size for a known maximum input size. memory is automatically freed when the region is deinitialized.
		/// - parameter maximumReadingSize: the maximum size of the input that this region will be asked to process.
		public convenience init(maximumReadingSize: Int) throws {
			let bufferSize = Self.recommendedReadBufferSize(maximumInput: maximumReadingSize, flags: Decoding.Flags())
			try self.init(bufferSize: bufferSize)
		}

		/// exposes the underlying `yyjson_alc` for use in other functions.
		internal func expose<R>(_ exposureBlock: (inout yyjson_alc) throws -> R) rethrows -> R {
			return try exposureBlock(&self.alc)
		}

		/// frees the enclosed buffer when the memory region is deinitialized.
		deinit {
			free(bufferPointer)
		}
	}
}
