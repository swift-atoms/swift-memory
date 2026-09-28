#if Map
public import Byte
public import Span

extension Memory.Map: Span.`Protocol` {

    public typealias Element = Byte

    @inlinable
    public var span: Swift.Span<Byte> {
        @_lifetime(borrow self)
        borrowing get {
            guard let region else {
                preconditionFailure("Memory.Map.span accessed after unmap")
            }
            let start = unsafe (region.base.pointer + Int(bitPattern: offsetDelta))
                .assumingMemoryBound(to: Byte.self)
            let s = unsafe Swift.Span(_unsafeStart: start, count: Int(bitPattern: userLength))
            return unsafe _overrideLifetime(s, borrowing: self)
        }
    }
}
#endif
