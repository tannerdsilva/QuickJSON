# Error semantics

@Metadata {
  @PageKind(article)
  @SupportedLanguage(swift)
}

Every failure path in QuickJSON is a typed error. Encoding failures are ``Encoding/Error``; decoding failures are ``Decoding/Error``.

## Encoding errors

| case | thrown when |
| --- | --- |
| ``Encoding/Error/assignmentError`` | a value could not be attached to the document tree |
| ``Encoding/Error/memoryAllocationFailure`` | yyjson could not allocate the document or the exported output buffer |

## Decoding errors

| case | thrown when |
| --- | --- |
| ``Decoding/Error/valueTypeMismatch(_:)`` | the JSON value is a different type than the one requested; the payload is a ``Decoding/Error/ValueTypeMismatchInfo`` carrying the expected and found ``ValueType`` |
| ``Decoding/Error/numberOutOfRange(requestedType:value:)`` | a numeric value does not fit in the requested narrow integer type (e.g. decoding `300` as `Int8`) |
| ``Decoding/Error/notFound`` | a requested key is absent from the object (keyed containers, ``Decoding/Error/numberOutOfRange(requestedType:value:)``… ) |
| ``Decoding/Error/contentOverflow`` | an unkeyed container was read past its end |
| ``Decoding/Error/documentParseError(_:)`` | the document could not be parsed; the payload is a ``Decoding/Error/ParseInfo`` with yyjson's message, buffer offset, and error code |
| ``Decoding/Error/documentRootError`` | a parsed document has no root value |

## Semantics worth knowing

- **Narrow integer decoding is range-checked.** Before v2, decoding a JSON number into `Int8`/`Int16`/`Int32`/`UInt8`/`UInt16`/`UInt32` would trap at runtime on overflow. It now throws ``Decoding/Error/numberOutOfRange(requestedType:value:)``. `Int`, `Int64`, `UInt`, and `UInt64` span the full JSON numeric domain.
- **Missing keys are errors, nulls are not.** A keyed container throws ``Decoding/Error/notFound`` when a requested key is absent. A *present* `null` value is reported by ``Decoding/Error/valueTypeMismatch(_:)`` or consumed by `decodeNil` semantics, depending on the call.
- **Error payloads are value types.** ``Decoding/Error/ValueTypeMismatchInfo`` and ``Decoding/Error/ParseInfo`` are `Sendable` structs, so errors can cross concurrency boundaries.
