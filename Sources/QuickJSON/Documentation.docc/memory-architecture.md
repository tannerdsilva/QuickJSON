# Memory architecture

@Metadata {
  @PageKind(article)
  @SupportedLanguage(swift)
}

QuickJSON separates *how* memory is obtained from *where* the JSON work happens. By default every operation uses yyjson's standard malloc-based allocation. When you want to control allocation, you supply a ``Memory/Region`` — a single fixed buffer that yyjson borrows from for the duration of one operation.

## The two configurations

```swift
Memory.Configuration.automatic                        // malloc-backed (default)
Memory.Configuration.preallocated(Memory.Region)      // backed by one pooled buffer
```

A region is created either with an explicit byte size or from a known maximum input size:

```swift
let region = try Memory.Region(bufferSize: 4096)
let sized = try Memory.Region(maximumReadingSize: 1024)
```

``Memory/Region/recommendedReadBufferSize(maximumInput:flags:)`` returns yyjson's recommendation for a parser pool given a known upper bound on document size and the read flags you intend to use — this is what ``Memory/Region/init(maximumReadingSize:)-2xk1m`` uses internally.

## How the region is used

**Decoding.** `yyjson_read_opts` receives the region's allocator directly. All document and value allocations come from the pool.

**Encoding.** The mutable document is *created* with the region's allocator, so every value built during encoding — objects, arrays, keys, strings — is carved from the pool. (This was a silent failure mode before v2: the pool was allocated but never consulted, because the document was created with the default allocator.)

## Contract

A ``Memory/Region`` is a single-threaded resource: yyjson's pool allocator is **not safe to share across threads**, so a region must not be used by two operations concurrently. Because it wraps a `malloc`'d buffer that is freed on deinit, the type is `@unchecked Sendable` — the thread-safety promise is yours to honor.

If the pool is too small for the work, yyjson fails the operation and QuickJSON throws (``Encoding/Error/memoryAllocationFailure`` or ``Decoding/Error/documentParseError(_:)``); it never crashes.
