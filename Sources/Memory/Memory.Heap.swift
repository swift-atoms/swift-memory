public import Cardinal
import Ordinal
public import Tagged

extension Memory {

    @frozen
    @safe
    public struct Heap: ~Copyable {

        @usableFromInline
        internal let _base: UnsafeMutableRawPointer

        @usableFromInline
        internal let _capacity: Memory.Address.Count

        @unsafe
        @inlinable
        public init(adopting base: UnsafeMutableRawPointer, capacity: Memory.Address.Count) {
            precondition(
                capacity.underlying.rawValue <= UInt(Int.max),
                "Memory.Heap capacity exceeds Int.max"
            )
            unsafe self._base = base
            self._capacity = capacity
        }

        @inlinable
        deinit {

            unsafe _base.deallocate()
        }
    }
}

extension Memory.Heap {

    @unsafe
    @inlinable
    public consuming func take() -> (base: UnsafeMutableRawPointer, capacity: Memory.Address.Count) {

        let result = unsafe (_base, _capacity)
        discard self
        return unsafe result
    }

    @unsafe
    @inlinable
    public var unsafeBaseAddress: UnsafeRawPointer {

        unsafe UnsafeRawPointer(_base)
    }

    @unsafe
    @inlinable
    public borrowing func withUnsafeBytes<R: ~Copyable, E: Swift::Error>(
        _ body: (UnsafeRawBufferPointer) throws(E) -> R
    ) throws(E) -> R {

        try unsafe body(
            unsafe UnsafeRawBufferPointer(
                start: _base,
                count: Int(bitPattern: _capacity.underlying.rawValue)
            )
        )
    }
}

extension Memory.Heap: @unchecked Swift::Sendable {}
