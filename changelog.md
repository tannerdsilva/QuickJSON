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