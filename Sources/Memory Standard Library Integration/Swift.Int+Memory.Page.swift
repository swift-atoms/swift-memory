public import Memory

extension Swift.Int {

    @inlinable
    public init(_ size: Memory.Page.Size) {
        self = Int(bitPattern: size.underlying.rawValue)
    }
}
