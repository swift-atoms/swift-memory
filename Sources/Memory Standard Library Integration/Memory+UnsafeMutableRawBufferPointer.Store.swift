public import Memory_Address
import Property

extension UnsafeMutableRawBufferPointer {

    public enum Store {}
}

extension UnsafeMutableRawBufferPointer {

    @inlinable
    public var store: Property.Property<Store, Self> {
        unsafe Property.Property(self)
    }
}

extension Property.Property
where Tag == UnsafeMutableRawBufferPointer.Store, Base == UnsafeMutableRawBufferPointer {

    @inlinable
    public func bytes<T>(
        of value: T,
        at offset: Memory.Address.Offset,
        as type: T.Type
    ) {
        unsafe base.storeBytes(of: value, toByteOffset: offset.vector.rawValue, as: type)
    }
}
