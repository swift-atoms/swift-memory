#if Map
extension Memory.Map {

    @safe
    public struct Region: Sendable {

        public let base: Memory.Address

        public let length: Memory.Address.Count

        @inlinable
        public init(base: Memory.Address, length: Memory.Address.Count) {
            self.base = base
            self.length = length
        }
    }
}

extension Memory.Map.Region {

    @inlinable
    public var count: Int { Int(bitPattern: length) }
}
#endif
