extension Memory.Alignment: Swift.Comparable {

    public static func < (lhs: Memory.Alignment, rhs: Memory.Alignment) -> Bool {
        lhs.shift < rhs.shift
    }
}
