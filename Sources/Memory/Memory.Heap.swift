public import Cardinal
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
