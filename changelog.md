### v2.0.0

- Improved chaotic frontend API surface from `v1.x.x` tags.

- Now BYO `Logger`. Enabling `QUICKJSON_SHOULDLOG` exposes an argument that allows a developer to pass a pre-configured Logger of their choice.

- Rectified encoding bug with keyed containers with nested objects.

- Simplified base API for encoding and decoding that is based on raw pointer memory.

	- Extensions continue to provide high-level and convenient support for an assortment of "data-like" programming objects.

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