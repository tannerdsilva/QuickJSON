# AGENTS.md

Operational guidance for autonomous agents working in the QuickJSON repository. API documentation lives in the `Sources/QuickJSON` doc comments and the DocC catalog under `Sources/QuickJSON/Documentation.docc`; this file is about how to work here safely.

## Repository shape

QuickJSON is a thin, Foundation-free Swift wrapper around the yyjson C library. Two dependencies: `yyjson` (the JSON core, range `0.11.0..<0.13.0`) and `swift-log` (runtime-configurable logging, off by default).

```
Sources/QuickJSON/
  QuickJSON.swift            module core: ValueType
  Encoding.swift             encode() entry points + Encoding namespace (Flags/Error/logger)
  Decoding.swift             decode() entry points + Decoding namespace (Flags/Error/logger)
  Memory.swift               Memory.Configuration + Memory.Region (pooled allocation)
  Encoder.swift              NodeEncoder (Swift.Encoder, position-based)
  SingleValueEncoder.swift   SingleValueEncodingContainer, position-based
  KeyedEncoder.swift         KeyedEncodingContainerProtocol implementation
  UnkeyedEncoder.swift       UnkeyedEncodingContainer implementation
  RootDecoder.swift          Swift.Decoder implementation
  SingleValueDecoder.swift   SingleValueDecodingContainer implementation
  KeyedDecoder.swift         KeyedDecodingContainerProtocol implementation
  UnkeyedDecoder.swift       UnkeyedDecodingContainer implementation
  PointerSupport.swift       yyjson pointer helpers shared by the containers
  LoggerSupport.swift        makeDefaultLogger + Logger convenience

Tests/QuickJSONTests/         Swift Testing, one suite per file
```

## Build and verify

```bash
swift build                 # library target, must be warning-free
swift test                  # full suite; must be green
swift build -c release      # release build; catches assert-only paths
swift test --filter BenchmarkTests   # performance comparison vs Foundation
xcrun docc convert Sources/QuickJSON/Documentation.docc \
  --fallback-display-name QuickJSON \
  --fallback-bundle-identifier com.tannersilva.quickjson \
  --fallback-bundle-version 2.0.0 \
  --additional-symbol-graph-dir <dir> --output-path <out>   # DocC catalog
```

End-to-end verification greps (all must return no Swift-code matches):

```bash
grep -rn "fatalError" Sources        # no crash paths in library code
grep -rn "#if" Sources               # no conditional compilation
grep -rn "QUICKJSON_SHOULDLOG" Sources  # removed build flag must not return
grep -rn "size_t" Sources            # C size_t is imported as Int; never use it
```

## Non-negotiable invariants

1. **Zero Foundation in `Sources/`.** The library uses primitive Swift types, `UnsafeRawPointer`, and C interop only. `Foundation` may be imported by tests (the benchmark comparison needs it) — never by the library.
2. **No new dependencies without explicit user approval.** The current two-dependency surface is deliberate.
3. **No `fatalError()` in library code.** Prefer throwing errors; `preconditionFailure` is only acceptable inside provably-unreachable invariant guards.
4. **No `#if` / conditional compilation.** Logging is runtime-controlled via `logLevel` (default `.critical`). A new `#if` is a design smell — question it.
5. **Swift 6 language mode is ON.** `Package.swift` sets `swiftLanguageModes: [.v6]`. All code, including tests, must compile warning-free under strict concurrency. New public types should be `Sendable`.
6. **One test file per suite, Swift Testing only.** No new XCTest.
7. **`Memory.Region` is not safe to share across threads.** Its pool allocator is single-threaded; the `@unchecked Sendable` conformance expresses the buffer-ownership guarantee, not thread safety.

## Conventions

- **Comments are lowercase prose** (`///` doc comments, `//` line comments). Preserve backticked identifiers and string literals. The comment-free rule applies only to distributed web assets, which do not exist here.
- **Tabs for indentation.**
- **Public API symbols carry `///` documentation**; extended discussion lives in `Documentation.docc` articles.
- **Public API is final for v2.0.0.** Breaking changes require explicit user approval and a `CHANGELOG.md` entry.
- **Memorized yyjson interop facts:** C `size_t` imports as `Int` on current toolchains — never wrap in `UInt`. `yyjson_read_opts` takes an in-place `char*` buffer; do not mutate it unless the `.inSitu` flag is intentionally used. The preallocated encode path must create the mutable document *with the region's allocator* (`yyjson_mut_doc_new(&alc)`), or the pool is never consulted.

## Lifecycle of a change

1. Make the change; `swift build` (zero warnings).
2. Add or update Swift Testing coverage for changed behavior.
3. `swift test` green, then `swift build -c release`.
4. If public API changed: update `README.md` (API overview / error model), `CHANGELOG.md`, and any `Documentation.docc` articles that reference it.
5. If performance-relevant: run the benchmark suite and note movement in the change description.
