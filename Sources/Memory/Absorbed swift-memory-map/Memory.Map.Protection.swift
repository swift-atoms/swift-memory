#if Map
extension Memory.Map {

    public struct Protection: Sendable, Equatable, Hashable, ExpressibleByArrayLiteral {

        public let rawValue: Int32

        @inlinable
        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }

        public static let none = Self(rawValue: 0)

        @inlinable
        public static func | (lhs: Self, rhs: Self) -> Self {
            Self(rawValue: lhs.rawValue | rhs.rawValue)
        }

        @inlinable
        public func contains(_ other: Self) -> Bool {
            (rawValue & other.rawValue) == other.rawValue
        }

        @inlinable
        public init(arrayLiteral elements: Self...) {
            self.rawValue = elements.reduce(0) { $0 | $1.rawValue }
        }
    }
}
#endif
