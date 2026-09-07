public import Memory

extension Swift.Int {

    @inlinable
    public init(_ capacity: Memory.Capacity) {
        self = Int(bitPattern: capacity.underlying.rawValue)
    }
}
