public import Index
public import Memory_Address
import Property

extension Memory {

    public enum Move {}
}

extension Property.Property
where Tag == Memory.Move, Base == UnsafeMutableRawPointer {

    @inlinable
    @discardableResult
    public func initialize<T>(
        as type: T.Type,
        from source: UnsafeMutablePointer<T>,
        count: Index.Index<T>.Count
    ) -> UnsafeMutablePointer<T> {
        unsafe base.moveInitializeMemory(as: type, from: source, count: Int(bitPattern: count))
    }
}
