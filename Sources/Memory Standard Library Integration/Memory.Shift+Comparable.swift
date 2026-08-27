public import Memory

extension Memory.Shift: Comparable {

    @inlinable
    public static func < (lhs: Memory.Shift, rhs: Memory.Shift) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
