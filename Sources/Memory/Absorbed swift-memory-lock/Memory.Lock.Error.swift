#if Lock
public import Error
extension Memory.Lock {

    public enum Error: Swift.Error, Sendable, Equatable {

        case lock(Error::Error.Code)

        case unlock(Error::Error.Code)

        case lockAll(Error::Error.Code)

        case unlockAll(Error::Error.Code)
    }
}

extension Memory.Lock.Error: CustomStringConvertible {

    public var description: Swift.String {
        switch self {
        case .lock(let code):
            return "mlock failed: \(code)"

        case .unlock(let code):
            return "munlock failed: \(code)"

        case .lockAll(let code):
            return "mlockall failed: \(code)"

        case .unlockAll(let code):
            return "munlockall failed: \(code)"
        }
    }
}
#endif
