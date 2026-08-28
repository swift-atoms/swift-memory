extension Memory {

    public struct Alignment: Sendable, Equatable, Hashable {

        public let shift: Memory.Shift
    }
}

extension Memory.Alignment {

    public init(
        _ magnitude: Int
    ) throws(Self.Error) {
        guard magnitude > 0, magnitude & (magnitude - 1) == 0 else {
            throw .notPowerOfTwo(magnitude)
        }

        self.shift = Memory.Shift(unchecked: UInt8(magnitude.trailingZeroBitCount))
    }
}

extension Memory.Alignment {

    @usableFromInline
    internal init(uncheckedShift: UInt8) {
        self.shift = Memory.Shift(unchecked: uncheckedShift)
    }
}

extension Memory.Alignment {

    public static let byte = Memory.Alignment(uncheckedShift: 0)

    public static let `1` = Memory.Alignment(uncheckedShift: 0)

    public static let `2` = Memory.Alignment(uncheckedShift: 1)

    public static let word = Memory.Alignment(uncheckedShift: 2)

    public static let `4` = Memory.Alignment(uncheckedShift: 2)

    public static let `8` = Memory.Alignment(uncheckedShift: 3)

    public static let `16` = Memory.Alignment(uncheckedShift: 4)

    public static let `512` = Memory.Alignment(uncheckedShift: 9)

    public static let `1024` = Memory.Alignment(uncheckedShift: 10)

    public static let `4096` = Memory.Alignment(uncheckedShift: 12)

    public static let `8192` = Memory.Alignment(uncheckedShift: 13)

    public static let `16384` = Memory.Alignment(uncheckedShift: 14)
}

extension Memory.Alignment {

    public func magnitude<Carrier: FixedWidthInteger>(
        as _: Carrier.Type = Carrier.self
    ) -> Carrier {
        shift.magnitude(as: Carrier.self)
    }

    public func mask<Carrier: FixedWidthInteger>(
        as _: Carrier.Type = Carrier.self
    ) -> Carrier {
        shift.mask(as: Carrier.self)
    }

    public func validated<Carrier: FixedWidthInteger>(
        for _: Carrier.Type
    ) throws(Self.Error) -> Self {

        let shiftCount = Int(bitPattern: shift.bitCount)
        guard shiftCount < Carrier.bitWidth else {

            throw .shiftExceedsBitWidth(shift: UInt8(shiftCount), bitWidth: Carrier.bitWidth)
        }
        return self
    }
}

extension Memory.Alignment {

    public func isAligned(_ pointer: UnsafeRawPointer) -> Bool {
        UInt(bitPattern: pointer) & shift.mask() == 0
    }

    public func isAligned(_ pointer: UnsafeMutableRawPointer) -> Bool {
        UInt(bitPattern: pointer) & shift.mask() == 0
    }
}

extension Memory.Alignment {

    @inlinable
    public func isAligned<Scalar: FixedWidthInteger>(_ value: Scalar) -> Bool {
        value & shift.mask() == 0
    }

    @inlinable
    public func alignUp<Scalar: FixedWidthInteger>(_ value: Scalar) -> Scalar {
        let mask: Scalar = shift.mask()
        return (value &+ mask) & ~mask
    }

    @inlinable
    public func alignDown<Scalar: FixedWidthInteger>(_ value: Scalar) -> Scalar {
        let mask: Scalar = shift.mask()
        return value & ~mask
    }
}
