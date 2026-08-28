extension Memory.Alignment {

    public enum Error: Swift.Error, Sendable, Equatable {

        case notPowerOfTwo(Int)

        case shiftExceedsBitWidth(shift: UInt8, bitWidth: Int)
    }
}
