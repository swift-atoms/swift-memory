extension Memory.Shift.Error: CustomStringConvertible {

    public var description: String {
        switch self {
        case .outOfRange(let value, let max):
            return "shift out of range (was \(value), valid: 0...\(max))"
        }
    }
}
