extension Memory.Shift {

    public enum Error: Swift.Error, Sendable, Equatable {

        case outOfRange(value: Int, max: UInt8)
    }
}
