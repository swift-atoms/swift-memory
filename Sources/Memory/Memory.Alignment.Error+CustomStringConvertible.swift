extension Memory.Alignment.Error: CustomStringConvertible {

    public var description: String {
        switch self {
        case .notPowerOfTwo(let value):
            return "alignment must be a power of 2 (was \(value))"

        case .shiftExceedsBitWidth(let shift, let bitWidth):
            return "shift \(shift) exceeds carrier bit width \(bitWidth)"
        }
    }
}
