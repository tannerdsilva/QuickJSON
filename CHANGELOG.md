## v2.0.0 (unreleased)

- **Removed the `QUICKJSON_SHOULDLOG` build flag.** logging is now always compiled in and controlled at runtime via the `logLevel` parameter on every `encode`/`decode` call, which defaults to `.critical` (log output disabled). this replaces the duplicated conditional-compilation code that doubled the source tree and whose build was broken; it also removes `QuickJSON.loggingEnabled`.
- **Simplified the public decode API.**
  - unified the `bytes:` and `from:` argument labels on the decode functions to a single `from:` label.
  - removed the dead `size:` parameter from the collection-based `decode` overloads (the value was silently ignored).
  - removed the unused `T: Decodable` generic parameter from the handler-based `decode` overloads.
  - converted `size_t` parameters to `Int` on the pointer-based overloads and `Memory.Region`.
- **Implemented `superEncoder`/`superDecoder`** on all containers, previously `fatalError("unimplemented")`. the keyed variants use a reserved `"super"` key.
- **New `Decoding.Error.numberOutOfRange`** case, thrown when a numeric value does not fit in the requested narrow integer type. previously the decoder would trap at runtime on overflow.
- **Bugfix: `KeyedDecodingContainer.contains(_:)`** no longer reports `true` for absent keys.
- **Bugfix: `nestedContainer(keyedBy:forKey:)`** on the encoder now writes the nested container under its key in the object, instead of appending it to the object as if it were an array.
- **Bugfix: the preallocated encoding path** now creates the yyjson document with the memory region's allocator, so the region is actually used (previously the region was created and discarded).
- **Bugfix: removed dead public API** — the unused `ParseInfo(writeInfo:)` initializer was deleted.
- **Strict concurrency:** the package compiles in Swift 6 language mode (`swiftLanguageModes: [.v6]`) with `Sendable` public types; `Memory.Region` is `@unchecked Sendable` and documented as not safe to share across threads.
- Updated the package manifest to `swift-tools-version: 6.0` with explicit platform declarations.
- Reorganized the source tree: one type per file, without the former `ec_`/`dc_` prefixes, and collapsed the three single-value encoding container variants into a single position-based implementation.
- Updated yyjson to 0.11..<0.13 (resolved 0.12.0).
- Added a hand-rolled benchmark suite (Swift Testing, no external dependencies) comparing against Foundation's JSON codecs.
- Rewrote the test suite using Swift Testing (8 suites, 49 tests), covering round trips, flags, error paths, container semantics, memory regions, handler decoding, benchmarks, and edge cases.
- Rewrote the README with accurate claims, usage examples, and measured performance numbers.
- Added a DocC catalog (`Documentation.docc/`) with articles on the memory architecture, error semantics, and v1 → v2 migration.
- Added a CI workflow running build/test/release on macOS and Linux under Swift 6.0 and 6.1.

## v1.1.2 (2024-06-30)

- Fixed memory leak.

## v1.1.1 (2023-09-21)

- Updated to yyjson 0.8.0.

## v1.1.0 (2023-08-06)

- Improvements to decoding.
- New functions that can take data input from a `Collection where Element == UInt8`.
- Added the ability to get all the keys for a keyed decoding container.

## v1.0.2 (2023-07-27)

- Tweaked `Package.swift` again, trying to find the right combo that makes SwiftPM happy in various external projects.

## v1.0.1 (2023-07-27)

- Tweaked `Package.swift` to use version descriptions that will be easier to build with other projects.
- Added notes in `README.md` regarding semantic versioning of this project.
- Improved documentation on the handler-based decoding function.

## v1.0.0 (2023-07-27)

- Eliminated `Encoder` and `Decoder` as to not conflict with the names of the native language protocols.
  - Introduction of `QuickJSON.encode()` to take the primary role of encoding data from the outgoing struct.
  - Introduction of `QuickJSON.decode()` to take the primary role of decoding data from the outgoing struct.
- Inclusion of a new build flag that includes descriptive log information when enabled: `QUICKJSON_SHOULDLOG`.
  - Default loggers may be provided for encoding and decoding independently.
  - Log levels can be provided per job.
- Addition of a special `decode` function that handles its decoding and type interpretation with a handler function instead of using type-integrated decoding via `Codable`.
- Completely reimplemented `MemoryPool` name. no longer a typealias for `yyjson_alc`, which is now abstracted from the developer. a simple call to the `MemoryPool` initializer is all that is needed to guarantee safe memory use.
- Bugfix: decoding flags were not being passed into yyjson.

## v0.1.1 (2023-06-29)

- Improvements to the unkeyed decoding container. specific errors are now thrown to handle circumstances where a user of the unkeyed container exceeds the boundaries of the data.

## v0.1.0 (2023-06-29)

- Unkeyed decoding container no longer increments (moving on to the next item in its bounds) when an error is thrown trying to decode a value.

## v0.0.8 (2023-06-17)

- Bugfix: optimized and completed implementation of MemoryPools.
- Converted `QuickJSON.Encoder` and `QuickJSON.Decoder` to classes.

## v0.0.7 (2023-06-16)

- Bugfix: unkeyed decoding containers failed to load the first object within their bounds, causing them to fail immediately.
  - Added test coverage for unkeyed decoding containers.
- Bugfix: `QuickJSON.Encoder.encode(...)` was returning an array containing a `NUL` byte at the end of every return value. this has been corrected.

## v0.0.6 (2023-06-15)

- `MemoryPool.allocate(...)` now throws a `MemoryPool.InitializationError` instead of returning an optional value.

## v0.0.5 (2023-06-04)

- Improvements to `MemoryPool` typealias.
  - Added extension function `maxReadSize` that returns the appropriate maximum buffer size for decoding data of known maximum length.
  - Improved documentation on existing extension function `allocate`.

## v0.0.4 (2023-06-04)

- Added decoding variant that uses `from:UnsafeRawPointer, size:size_t` as input.

## v0.0.3 (2023-05-30)

- Updated `Package.swift` to reference C lib `yyjson` directly, since the `tannerdsilva/yyjson` fork was simply a mirror (a fork initially deemed necessary for managing release tags).

## v0.0.2 (2023-05-29)

- Updated `Package.swift` to use SemVer range for `yyjson` instead of explicit revision hashes.

## v0.0.1 (2023-05-28)

- First tag. expecting a fairly stable experience, but more development is needed to really finish off the API surface.
- Basic tests to prove high-level functionality.
- Plentiful comments and consistent naming.
- MIT license.
- One dependency (`yyjson`, of course).
