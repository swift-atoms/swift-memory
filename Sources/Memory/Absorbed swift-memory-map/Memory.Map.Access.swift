#if Map
extension Memory.Map {

    public struct Access: OptionSet, Sendable, Hashable {

        public let rawValue: Int

        @inlinable
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}

extension Memory.Map.Access {

    public static let read = Self(rawValue: 1 << 0)

    public static let write = Self(rawValue: 1 << 1)
}

extension Memory.Map.Access {

    public var allows: Allows { Allows(access: self) }
}

extension Memory.Map.Access {

    public struct Allows: Sendable {
        @usableFromInline
        let access: Memory.Map.Access

        @inlinable
        package init(access: Memory.Map.Access) {
            self.access = access
        }

        @inlinable
        public var read: Bool { access.contains(.read) }

        @inlinable
        public var write: Bool { access.contains(.write) }
    }
}
#endif
