extension Memory.Shift: Swift.Comparable {

    @inlinable
    public static func < (lhs: Memory.Shift, rhs: Memory.Shift) -> Bool {
        lhs.bitCount < rhs.bitCount
    }
}
