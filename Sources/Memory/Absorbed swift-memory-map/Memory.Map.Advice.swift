#if Map
extension Memory.Map {

    public struct Advice: Sendable, Equatable, Hashable {

        public let rawValue: Int32

        @inlinable
        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }
    }
}
#endif
