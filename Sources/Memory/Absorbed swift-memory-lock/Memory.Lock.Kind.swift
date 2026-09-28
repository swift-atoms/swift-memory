#if Lock
extension Memory.Lock {

    public enum Kind: Sendable, Equatable, Hashable {

        case shared

        case exclusive
    }
}
#endif
