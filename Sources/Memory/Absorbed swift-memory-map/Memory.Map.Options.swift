#if Map
    extension Memory.Map {

        public struct Options: Sendable, Equatable, Hashable {

            public let rawValue: Int32

            @inlinable
            public init(rawValue: Int32) {
                self.rawValue = rawValue
            }
        }
    }

    extension Memory.Map.Options {
        @inlinable
        public static func | (lhs: Self, rhs: Self) -> Self {
            Self(rawValue: lhs.rawValue | rhs.rawValue)
        }
    }
#endif
