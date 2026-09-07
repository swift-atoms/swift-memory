public import Memory

extension Swift.UnsafeRawPointer {

    @inlinable
    public init(_ address: Memory.Address) {

        unsafe self = UnsafeRawPointer(bitPattern: address.bitPattern)!
    }

    @inlinable
    public init<Tag: ~Copyable & ~Escapable>(_ address: Tagged<Tag, Memory.Address>) {
        unsafe self.init(address.underlying)
    }
}
