public import Memory_Address
import Property

extension UnsafeMutableRawPointer {

    public enum Store {}
}

extension UnsafeMutableRawPointer {

    @inlinable
    public var store: Property.Property<Store, Self> {
        unsafe Property.Property(self)
    }
}

extension Property.Property
where Tag == UnsafeMutableRawPointer.Store, Base == UnsafeMutableRawPointer {

    @inlinable
    public func bytes<T>(
        of value: T,
        at offset: Memory.Address.Offset,
        as type: T.Type
    ) {
        unsafe base.storeBytes(of: value, toByteOffset: offset.vector.rawValue, as: type)
    }
}
