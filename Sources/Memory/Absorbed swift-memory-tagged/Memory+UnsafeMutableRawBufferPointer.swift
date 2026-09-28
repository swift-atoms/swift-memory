#if TaggedMemory
public import Cardinal
public import Ordinal
public import Tagged

extension UnsafeMutableRawBufferPointer {

    @inlinable
    @_disfavoredOverload
    public init(
        start: UnsafeMutableRawPointer?,
        count: Memory.Address.Count
    ) {
        unsafe self.init(
            start: start,
            count: Int(clamping: count.underlying.rawValue)
        )
    }

    @inlinable
    @_disfavoredOverload
    public static func allocate(
        count: Memory.Address.Count,
        alignment: Memory.Alignment
    ) -> Self {
        Self.allocate(
            byteCount: Int(clamping: count.underlying.rawValue),
            alignment: alignment.magnitude()
        )
    }

    @inlinable
    public subscript(
        _ index: Memory.Address
    ) -> UInt8 {
        get {
            unsafe self[Int(clamping: index.underlying.rawValue)]
        }
        nonmutating set {
            unsafe self[Int(clamping: index.underlying.rawValue)] = newValue
        }
    }

}
#endif
