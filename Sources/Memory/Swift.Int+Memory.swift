extension Swift.Int {

    @inlinable
    public init(_ size: Memory.Page.Size) {
        self = Int(bitPattern: size.underlying.rawValue)
    }
}

extension Swift.Int {

    @inlinable
    public init(_ capacity: Memory.Capacity) {
        self = Int(bitPattern: capacity.underlying.rawValue)
    }
}
