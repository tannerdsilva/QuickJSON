# QuickJSON

QuickJSON is an easy, efficient, and uncompromising integration of the yyjson parsing library.

- Supports preallocated buffers for higher performance than common options.

- Single dependency (`yyjson`).

	- Optionally utilizes common log infrastructure, useful for debugging.

	- Never imports Foundation - uses primitive Swift types only.

- Only accessible through the `QuickJSON.encode(...)` and `QuickJSON.decode(...)` functions.

	- Serializes and deserializes data structures based on the Swift-native `Codable` protocol.

	- As of version `1.0.0`, QuickJSON also offers encode and decode variants that allow for dynamic type parsing through handler functions.

## Versioning Practices

QuickJSON is developed using [Semantic Versioning 2.0.0](https://semver.org/), where given the following pattern `MAJOR`.`MINOR`.`PATCH`, the various elements will be incremented based on the following conditions:

1. MAJOR is incremented when incompatible API changes are made.

2. MINOR is incremented when backwards compatible features are added.

3. PATCH is incremented when backwards bug fixes are shipped.

## Log Mode

QuickJSON is built for performance first and foremost. Logging is compiled in and is **off by default at runtime**: every `encode`/`decode` call silently no-ops its log statements unless a `logLevel` other than `.critical` is supplied.

To enable log output for a single call, pass an explicit `logLevel`:

```swift
let encoded = try QuickJSON.encode(myObject, logLevel: .debug)
```

The default loggers (`Encoding.logger` and `Decoding.logger`) can be replaced with custom `Logger` instances, which are then used by every operation. Per-call log levels continue to apply on top of the configured logger.

## Compatibility

### Supported Platforms

- Linux

- MacOS

- iOS and variants...

### Supported Swift Versions

This package requires a `swift-tools-version` >= `5.5`.

## Package Dependencies

- `yyjson`: self-explanatory.

- `swift-log`: a core part of the Swift ecosystem. a required build dependency. logging output is disabled by default at runtime, so the dependency imposes no overhead or output unless a `logLevel` is supplied.

## License

QuickJSON and yyjson are both available with an MIT license.