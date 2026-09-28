#if TaggedMemory
public import Cardinal
public import Property

extension Memory {

    public enum Move {}
}

extension Property
where Tag == Memory.Move, Base == UnsafeMutableRawPointer {

    @inlinable
    @discardableResult
    public func initialize<T>(
        as type: T.Type,
        from source: UnsafeMutablePointer<T>,
        count: Cardinal
    ) -> UnsafeMutablePointer<T> {
        unsafe base.moveInitializeMemory(
            as: type,
            from: source,
            count: Int(clamping: count.rawValue)
        )
    }
}
#endif
