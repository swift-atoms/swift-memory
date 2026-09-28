#if TaggedMemory
public import Cardinal
public import Tagged

extension UnsafeMutableRawPointer {

    @inlinable
    public static func allocate(
        count: Memory.Address.Count,
        alignment: Memory.Alignment
    ) -> Self {
        Self.allocate(
            byteCount: Int(clamping: count.underlying.rawValue),
            alignment: alignment.magnitude()
        )
    }
}
#endif
