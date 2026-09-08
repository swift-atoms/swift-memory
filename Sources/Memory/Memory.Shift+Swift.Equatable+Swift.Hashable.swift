import Bit
import Cardinal
import Tagged

extension Memory.Shift: Swift.Equatable, Swift.Hashable {

    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.bitCount == rhs.bitCount
    }

    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(bitCount)
    }
}
