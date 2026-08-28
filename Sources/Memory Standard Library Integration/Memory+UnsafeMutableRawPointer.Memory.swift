public import Index
public import Memory_Address
import Property

extension UnsafeMutableRawPointer {

    @inlinable
    public var memory: Property.Property<Memory, Self> {
        unsafe Property.Property(self)
    }
}

extension Property.Property
where Tag == Memory, Base == UnsafeMutableRawPointer {

    @inlinable
    @discardableResult
    public func initialize<T>(
        as type: T.Type,
        repeating value: T,
        count: Index.Index<T>.Count
    ) -> UnsafeMutablePointer<T> {
        unsafe base.initializeMemory(as: type, repeating: value, count: Int(bitPattern: count))
    }

    @inlinable
    @discardableResult
    public func initialize<T>(
        as type: T.Type,
        from source: UnsafePointer<T>,
        count: Index.Index<T>.Count
    ) -> UnsafeMutablePointer<T> {
        unsafe base.initializeMemory(as: type, from: source, count: Int(bitPattern: count))
    }

    @inlinable
    @discardableResult
    public func bind<T: ~Copyable>(
        to type: T.Type,
        capacity: Index.Index<T>.Count
    ) -> UnsafeMutablePointer<T> {
        unsafe base.bindMemory(to: type, capacity: Int(bitPattern: capacity))
    }

    @inlinable
    public func copy(
        from source: UnsafeRawPointer,
        count: Memory.Address.Count
    ) {
        unsafe base.copyMemory(from: source, byteCount: Int(bitPattern: count))
    }

    @inlinable
    public var move: Property.Property<Memory.Move, Base> {
        unsafe Property.Property(base)
    }
}
