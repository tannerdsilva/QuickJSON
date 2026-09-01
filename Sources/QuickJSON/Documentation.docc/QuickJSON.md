# QuickJSON

@Metadata {
  @PageKind(article)
  @PageColor(orange)
  @SupportedLanguage(swift)
}

An easy, efficient, and uncompromising integration of the [yyjson][] parsing library.

QuickJSON rounds trip Swift `Codable` types through yyjson with **no Foundation involvement** — the library uses primitive Swift types, raw pointers, and C interop only. It offers preallocated memory regions, handler-based decoding for dynamic type interpretation, and runtime-configurable logging built on swift-log (off by default).

## Essentials

- ``encode(_:flags:memory:logLevel:)`` — encode any `Encodable` value to `[UInt8]`.
- ``decode(_:from:flags:memory:logLevel:)`` — decode any `Decodable` value from a `Collection` of `UInt8` or a raw pointer.
- ``decode(from:flags:memory:logLevel:_:)`` — decode with a handler function for dynamic type interpretation.
- ``Encoding`` — encoding flags and errors.
- ``Decoding`` — decoding flags and errors.
- ``Memory`` — automatic vs. preallocated memory configuration.
- ``ValueType`` — JSON value types, used to describe type mismatches.

## Articles

- <doc:memory-architecture>
- <doc:error-semantics>
- <doc:migration-guide>

[yyjson]: https://github.com/ibireme/yyjson
