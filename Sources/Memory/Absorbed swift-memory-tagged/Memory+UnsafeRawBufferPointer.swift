#if TaggedMemory
public import Cardinal
public import Ordinal
public import Tagged

extension UnsafeRawBufferPointer {

    @inlinable
    @_disfavoredOverload
    public init(
        start: UnsafeRawPointer?,
        count: Memory.Address.Count
    ) {
        unsafe self.init(
            start: start,
            count: Int(clamping: count.underlying.rawValue)
        )
    }

    @inlinable
    public subscript(
        _ index: Memory.Address
    ) -> UInt8 {
        unsafe self[Int(clamping: index.underlying.rawValue)]
    }
}
#endif
