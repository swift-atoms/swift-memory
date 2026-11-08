extension Swift::UnsafeRawPointer {

    @inlinable
    public init(_ address: Memory.Address) {

        guard let pointer = unsafe UnsafeRawPointer(bitPattern: address.bitPattern) else {
            preconditionFailure("the null address has no pointer representation")
        }
        unsafe self = pointer
    }

    @inlinable
    public init<Tag: ~Copyable & ~Escapable>(_ address: Tagged<Tag, Memory.Address>) {
        unsafe self.init(address.underlying)
    }
}
