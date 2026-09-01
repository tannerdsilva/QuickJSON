# QuickJSON

QuickJSON is an easy, efficient, and uncompromising integration of the [yyjson](https://github.com/ibireme/yyjson) parsing library.

- Swift-native `Codable` round tripping backed by yyjson — no Foundation involved.
- Supports preallocated memory regions for both encoding and decoding, letting you control allocation.
- Handler-based decoding for dynamic type interpretation without `Codable` structs.
- Runtime configurable logging built on `swift-log`, off by default.
- Two dependencies total (`yyjson`, `swift-log`); the core never imports Foundation and uses primitive Swift types only.

## Usage

### Basic encode/decode

```swift
import QuickJSON

struct User: Codable {
    let id: Int
    let name: String
}

let user = User(id: 1, name: "Tanner")
let bytes = try QuickJSON.encode(user)                     // [UInt8]
let roundTrip = try QuickJSON.decode(User.self, from: bytes)
```

`decode` accepts any `Collection` of `UInt8` (arrays, slices, lazy filters, `Data`…), or a raw pointer:

```swift
let fromSlice = try QuickJSON.decode(User.self, from: bytes[0..<4])
let fromPointer = try bytes.withUnsafeBytes { raw in
    try QuickJSON.decode(User.self, from: raw.baseAddress!, size: raw.count)
}
```

### Handler-based decoding

When you want dynamic parsing — reading keys directly, custom control flow — use the handler overloads. The closure receives a `Swift.Decoder` and its return value is returned transparently:

```swift
let keys = try QuickJSON.decode(from: bytes) { decoder in
    let container = try decoder.container(keyedBy: UserKeys.self)
    return Set(container.allKeys)
}
```

### Preallocated memory

`Memory.Region` allocates a fixed pool once; both encode and decode can run inside it:

```swift
let region = try Memory.Region(maximumReadingSize: 1024)
let decoded = try QuickJSON.decode(User.self, from: bytes, memory: .preallocated(region))

// resolve the recommended pool size for a known input size up front:
let size = Memory.Region.recommendedReadBufferSize(maximumInput: 4096, flags: .init())
```

### Flags

Encoding and decoding flags mirror yyjson's option sets:

```swift
let pretty = try QuickJSON.encode(user, flags: [.pretty])            // human readable
let permissive = try QuickJSON.decode(
    User.self, from: bytes,
    flags: [.allowComments, .allowTrailingCommas]
)
```

## API overview

| symbol | purpose |
| --- | --- |
| `QuickJSON.encode(_:flags:memory:logLevel:)` | encode any `Encodable` value to `[UInt8]` |
| `QuickJSON.decode(_:from:flags:memory:logLevel:)` | decode any `Decodable` value from a collection or raw pointer |
| `QuickJSON.decode(from:flags:memory:logLevel:_:)` | decode with a handler function |
| `Encoding.Flags` | write options: `.pretty`, `.escapeUnicode`, `.escapeSlashes`, `.allowInfAndNan`, `.infAndNanAsNull`, `.allowInvalidUnicode`, `.prettyTwoSpaces` |
| `Decoding.Flags` | read options: `.inSitu`, `.stopWhenDone`, `.allowTrailingCommas`, `.allowComments`, `.allowInfAndNaN`, `.allowInvalidUnicode` |
| `Memory.Configuration` / `Memory.Region` | automatic or pooled allocation |
| `Decoding.Error` | typed decoding errors (see below) |

## Error model

Encoding failures throw `Encoding.Error`:

| error | thrown when |
| --- | --- |
| `assignmentError` | a value could not be attached to the document |
| `memoryAllocationFailure` | yyjson could not allocate the document or output buffer |

Decoding failures throw `Decoding.Error`:

| error | thrown when |
| --- | --- |
| `valueTypeMismatch(ValueTypeMismatchInfo)` | the JSON value is a different type than requested |
| `numberOutOfRange(requestedType:value:)` | a numeric value does not fit in the requested type |
| `notFound` | a requested key is not present in the object |
| `contentOverflow` | an unkeyed container is read past its end |
| `documentParseError(ParseInfo)` | the JSON document could not be parsed |
| `documentRootError` | the parsed document has no root value |

## Logging

Logging is compiled in and **off by default**: every call no-ops its log statements unless a `logLevel` other than `.critical` is supplied.

```swift
let bytes = try QuickJSON.encode(user, logLevel: .debug)
```

The default loggers (`Encoding.logger`, `Decoding.logger`) can be replaced with custom `Logger` instances; per-call log levels apply on top.

## Performance

Measured with the bundled benchmark suite (`swift test --filter BenchmarkTests`) against Foundation's `JSONEncoder`/`JSONDecoder`, yyjson 0.12, Swift 6.3, Apple Silicon (nanoseconds per operation):

| workload | QuickJSON encode | JSONEncoder encode | QuickJSON decode | JSONDecoder decode |
| --- | --- | --- | --- | --- |
| small model | 779 | 903 | 846 | 1,272 |
| nested object | 1,251 | 1,523 | 1,338 | 1,957 |
| array of 100 | 54,772 | 62,833 | 46,261 | 62,437 |
| unicode-heavy strings | 5,334 | 4,665 | 5,325 | 4,172 |

QuickJSON is roughly 1.1–1.2× faster encoding and 1.3–1.5× faster decoding than Foundation on structural payloads. On string-dominated payloads Foundation is faster (~0.8–0.9×) — measure your workload before assuming a win.

## Compatibility

### Platforms

- macOS 13+
- iOS 13+ and variants (tvOS 13+, watchOS 7+, visionOS 1+)
- Linux

### Swift

This package requires a **Swift 6 toolchain** (the manifest is `swift-tools-version: 6.0`). The package targets Swift language mode 5; consumer builds in strict concurrency mode interoperate with the `Sendable`-conforming public types.

## Dependencies

- `yyjson`: the high-performance JSON core.
- `swift-log`: used for optional runtime logging. Log output is disabled by default, so the dependency adds no output overhead unless a `logLevel` is supplied.

## Versioning

QuickJSON follows [Semantic Versioning 2.0.0](https://semver.org/). See [CHANGELOG.md](CHANGELOG.md) for the release history.

## License

QuickJSON and yyjson are both available under the MIT license.
