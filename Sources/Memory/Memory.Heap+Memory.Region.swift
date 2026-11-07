public import Cardinal
public import Ordinal
public import Tagged

extension Memory.Heap {

    @inlinable
    public init(byteCount: Memory.Address.Count, alignment: Memory.Alignment) {
        guard let count = Int(exactly: byteCount.underlying.rawValue) else {
            preconditionFailure("Memory.Heap byte count exceeds Int.max")
        }
        let raw = UnsafeMutableRawPointer.allocate(
            byteCount: count,
            alignment: alignment.magnitude(as: Int.self)
        )
        unsafe self.init(adopting: raw, capacity: byteCount)
    }
}

extension Memory.Heap: Memory.Region {

    @inlinable
    public var base: Memory.Address {

        unsafe Memory.Address(_base)
    }

    @inlinable
    public var capacity: Memory.Address.Count {
        _capacity
    }
}
