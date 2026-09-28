#if TaggedMemory
public import Cardinal
public import Property
public import Tagged

extension UnsafeMutableRawPointer {

    @inlinable
    public var memory: Property<Memory, Self> {
        unsafe Property<Memory, Self>(self)
    }
}

extension Property
where Tag == Memory, Base == UnsafeMutableRawPointer {

    @inlinable
    @discardableResult
    public func initialize<T>(
        as type: T.Type,
        repeating value: T,
        count: Cardinal
    ) -> UnsafeMutablePointer<T> {
        unsafe base.initializeMemory(
            as: type,
            repeating: value,
            count: Int(clamping: count.rawValue)
        )
    }

    @inlinable
    @discardableResult
    public func initialize<T>(
        as type: T.Type,
        from source: UnsafePointer<T>,
        count: Cardinal
    ) -> UnsafeMutablePointer<T> {
        unsafe base.initializeMemory(
            as: type,
            from: source,
            count: Int(clamping: count.rawValue)
        )
    }

    @inlinable
    @discardableResult
    public func bind<T: ~Copyable>(
        to type: T.Type,
        capacity: Cardinal
    ) -> UnsafeMutablePointer<T> {
        unsafe base.bindMemory(to: type, capacity: Int(clamping: capacity.rawValue))
    }

    @inlinable
    public func copy(
        from source: UnsafeRawPointer,
        count: Memory.Address.Count
    ) {
        unsafe base.copyMemory(
            from: source,
            byteCount: Int(clamping: count.underlying.rawValue)
        )
    }

    @inlinable
    public var move: Property<Memory.Move, Base> {
        unsafe Property<Memory.Move, Base>(base)
    }
}
#endif
