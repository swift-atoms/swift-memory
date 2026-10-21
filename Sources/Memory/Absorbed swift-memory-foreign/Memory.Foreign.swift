#if Foreign
    public import Span

    extension Memory {

        @frozen
        @safe
        public struct Foreign: ~Copyable {

            @usableFromInline
            internal let _region: Span.Raw.Mutable

            @usableFromInline
            internal var _finalizer: ((Span.Raw.Mutable) -> Void)?

            @unsafe @inlinable
            public init(
                adopting region: Span.Raw.Mutable,
                finalizer: @escaping (Span.Raw.Mutable) -> Void
            ) {
                precondition(!region.isEmpty, "Memory.Foreign cannot adopt an empty region")
                unsafe self._region = region
                unsafe self._finalizer = finalizer
            }

            deinit {
                if let finalizer = unsafe _finalizer { unsafe finalizer(_region) }
            }
        }
    }

    extension Memory.Foreign {

        @inlinable
        public consuming func take() -> (
            region: Span.Raw.Mutable,
            finalizer: (Span.Raw.Mutable) -> Void
        ) {

            guard let finalizer = unsafe _finalizer else {
                preconditionFailure("a foreign memory region's finalizer is taken exactly once")
            }
            unsafe _finalizer = nil
            return unsafe (_region, finalizer)
        }
    }
#endif
