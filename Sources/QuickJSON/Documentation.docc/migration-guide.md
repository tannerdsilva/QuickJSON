# Migration guide: v1 → v2

@Metadata {
  @PageKind(article)
  @SupportedLanguage(swift)
}

v2.0.0 is a breaking release. Most of the changes remove dead weight and repair behaviors that silently misled callers; the migration is small.

## Logging: build flag → runtime parameter

The `QUICKJSON_SHOULDLOG` build flag is gone. Logging is always compiled in and disabled by default. Replace:

```swift
.define("QUICKJSON_SHOULDLOG")   // Package.swift
```

with a per-call `logLevel`:

```swift
let bytes = try QuickJSON.encode(user, logLevel: .debug)
```

`QuickJSON.loggingEnabled` was removed (it reported which build you were in).

## Decode argument labels

- The collection-based overload used a `bytes:` label; it is now `from:`.

```swift
// v1
try QuickJSON.decode(User.self, bytes: data, size: data.count)
// v2
try QuickJSON.decode(User.self, from: data)
```

- The dead `size:` parameter on collection-based overloads was removed. It was ignored at runtime; pass `from:` only.

## New decoding error: numberOutOfRange

Narrow integer decoding is now range-checked.

```swift
do {
  _ = try QuickJSON.decode(Int8Model.self, from: bytes)   // {"v":300}
} catch Decoding.Error.numberOutOfRange {
  // v1 trapped here instead
}
```

## Behavior repairs

- ``…/contains(_:)`` — v1 returned `true` for absent keys; it now returns `false`.
- Nested keyed containers — v1 wrote them into the wrong container; they now encode under their key.
- Preallocated encoding — v1 allocated a region and never used it; v2 creates the document with the region's allocator.
- `superEncoder`/`superDecoder` — v1 crashed with `fatalError("unimplemented")`; v2 implements them (keyed variants use a reserved `"super"` key).

## Toolchain

The manifest is `swift-tools-version: 6.0` with explicit platform floors (macOS 13+, iOS 13+, tvOS 13+, watchOS 7+, visionOS 1+, Linux). Building QuickJSON v2 requires a Swift 6 toolchain; the package compiles under strict concurrency (Swift 6 language mode) with `Sendable` public types.
