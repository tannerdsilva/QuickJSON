# v2.0.0 (in development)

- **Removed the `QUICKJSON_SHOULDLOG` build flag.** logging is now always compiled in and controlled at runtime via the `logLevel` parameter on every `encode`/`decode` call, which defaults to `.critical` (log output disabled). replaces the duplicated conditional-compilation code that doubled the size of the source tree and whose build was broken.
- **Deprecated `QuickJSON.loggingEnabled`** (now always `true`; configure logging at runtime instead).
- **Simplified the public decode API.**
	- unified the `bytes:` and `from:` argument labels on the decode functions to a single `from:` label.
	- removed the dead `size:` parameter from the collection-based `decode` overloads (the value was silently ignored).
	- removed the unused `T: Decodable` generic parameter from the handler-based `decode` overloads.
	- converted `size_t` parameters to `Int` on the pointer-based overloads and `Memory.Region`.
- **Implemented `superEncoder`/`superDecoder`** on all containers, previously `fatalError("unimplemented")`. the keyed variants now use a reserved `"super"` key.
- **New `Decoding.Error.numberOutOfRange`** case, thrown when a numeric value does not fit in the requested narrow integer type. previously the decoder would trap at runtime on overflow.
- **Bugfix: `KeyedDecodingContainer.contains(_:)`** no longer reports `true` for absent keys.
- **Bugfix: `nestedContainer(keyedBy:forKey:)`** on the encoder now writes the nested container under its key in the object, instead of appending it to the object as if it were an array.
- **Bugfix: the preallocated encoding path** now creates the yyjson document with the memory region's allocator, so the region is actually used (previously the region was created and discarded).
- Updated the package manifest to `swift-tools-version: 6.0` with explicit platform declarations (the package continues to target swift language mode 5).
- Reorganized the source tree: one type per file, `Encoding/`-style names without the former `ec_`/`dc_` prefixes, and collapsed the three single-value encoding container variants into a single position-based implementation.
- Rewrote the test suite using Swift Testing (7 suites, 48 tests), covering round trips, flags, error paths, container semantics, memory regions, handler decoding, and edge cases.

## v1.1.2

- Fixed memory leak.

### v1.1.1

- Updated to yyjson 0.8.0

## v1.1.0

- Improvements to decoding.

	- New functions that can take data input from a `Collection where Element == UInt8`.

	- Added the ability to get all the keys for a keyed decoding container.

### v1.0.2

- Tweaked `Package.swift` again, trying to find the right combo that makes the SwiftPM happy in various external projects.

### v1.0.1

- Tweaked `Package.swift` to use version descriptions that will be easier to build with other projects.

- Added notes in `README.md` regarding semantic versioning of this project.

- Improved documentation on the handler-based decoding function.

# v1.0.0

- Eliminated `Encoder` and `Decoder` as to not conflict with the names of the native language protocols.

	- Introduction of `QuickJSON.encode()` to take the primary role of encoding data from the outgoing struct.

	- Introduction of `QuickJSON.decode()` to take the primary role of decoding data from the outgoing struct.

- Inclusion of a new build flag that includes descriptive log information when enabled: `QUICKJSON_SHOULDLOG`
	
	- Default loggers may be provided for encoding and decoding independently.

	- Log levels can be provided per job.

- Addition of special `decode` function that handles its decoding and type interpretation with a handler function instead of using type-integrated decoding via `Codable`.

- Completely reimplemented `MemoryPool` name. No longer a typealias for `yyjson_alc`...which is now abstracted from the developer. A simple call to the `MemoryPool` initializer is all that is needed to guarantee safe memory use.

- Bugfix: decoding flags were not being passed into yyjson.

## v0.1.1

- Improvements to the unkeyed decoding container. Specific errors are now thrown to handle circumstances where a user of the unkeyed container exceeds the boundaries of the data.

## v0.1.0

- Unkeyed decoding container no longer increments (moving on to the next item in its bounds) when an error is thrown trying to decode a value.

## v0.0.8

- Bugfix: optimized and completed implementation of MemoryPools.

- Converted `QuickJSON.Encoder` and `QuickJSON.Decoder` to classes.

## v0.0.7

- Bugfix: unkeyed decoding containers failed to load the first object within their bounds, causing them to fail immediately.

	- Added test coverage for unkeyed decoding containers.
	
- Bugfix: `QuickJSON.Encoder.encode(...)` was returning an array containing a `NUL` byte at the end of every return value. This has been corrected.

## v0.0.6

- `MemoryPool.allocate(...)` now throws a `MemoryPool.InitializationError` instead of returning an optional value.

## v0.0.5

- Improvements to `MemoryPool` typealias.

	- Added extension function `maxReadSize` that returns the apropriate maximum buffer size for decoding data of known maximum length.

	- Improved documentation on existing extension function `allocate`

## v0.0.4

- Added decoding variant that uses `from:UnsafeRawPointer, size:size_t` as input.

## v0.0.3

- Updated `Package.swift` to reference C lib `yyjson` directly, since the `tannerdsilva/yyjson` fork was simply a mirror (a fork initially deemed necessary for managing release tags).

## v0.0.2

- Updated `Package.swift` to use SemVer range for `yyjson` instead of explicit revision hashes.

## v0.0.1

- First tag. Expecting a fairly stable experience, but more development is needed to really finish off the API surface.

- Basic tests to prove high-level functionality.

- Plentiful comments and consistent naming.

- MIT license.

- One dependency (`yyjson`, of course)