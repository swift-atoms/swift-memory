#if Shared
public import Error

extension Memory.Shared {

    public enum Error: Swift.Error, Sendable, Equatable {

        case open(Error::Error.Code)

        case unlink(Error::Error.Code)

        case exhausted
    }
}

extension Memory.Shared.Error: CustomStringConvertible {

    public var description: Swift.String {
        switch self {
        case .open(let code):
            return "shm_open failed: \(code)"

        case .unlink(let code):
            return "shm_unlink failed: \(code)"

        case .exhausted:
            return "out of memory"
        }
    }
}
#endif
