#if Map
extension Memory.Map {

    public enum Sharing: Sendable, Equatable {

        case shared

        case `private`
    }
}
#endif
