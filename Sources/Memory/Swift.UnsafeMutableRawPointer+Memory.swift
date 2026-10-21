extension Swift::UnsafeMutableRawPointer {

    @inlinable
    public init(_ address: Memory.Address) {

        guard let pointer = unsafe UnsafeMutableRawPointer(bitPattern: address.bitPattern) else {
            preconditionFailure("the null address has no pointer representation")
        }
        unsafe self = pointer
    }

    @inlinable
    public init<Tag: ~Copyable & ~Escapable>(_ address: Tagged<Tag, Memory.Address>) {
        unsafe self.init(address.underlying)
    }
}
