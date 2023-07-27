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

QuickJSON is built for performance first and foremost. As such, it does NOT include any logging facilities in its build as default. This even applies to debug builds.

To enable logging facilities with QuickJSON, you may define the following `swiftSetting` in your Package Description:

```
.define("QUICKJSON_SHOULDLOG") // this enables logging
```

## Compatibility

### Supported Platforms

- Linux

- MacOS

- iOS and variants...

### Supported Swift Versions

This package requires a `swift-tools-version` >= `5.5`.

## Package Dependencies

- `yyjson`: self-explanatory.

- `swift-log`: a core part of the Swift ecosystem. a required build dependency, but only "included" in the final binary when running tests or `QUICKJSON_SHOULDLOG` is defined.

## License

QuickJSON and yyjson are both available with an MIT license.