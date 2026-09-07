extension Swift.UInt64 {

    @inlinable
    public init(_ capacity: Memory.Capacity) {
        self = UInt64(capacity.underlying.rawValue)
    }
}
