#if Map
extension Memory.Map.Error {

    public enum Validation: Sendable, Equatable, Hashable {

        case length

        case alignment

        case offset
    }
}

extension Memory.Map.Error.Validation: CustomStringConvertible {

    public var description: Swift.String {
        switch self {
        case .length: return "length must be greater than zero"
        case .alignment: return "address alignment is invalid"
        case .offset: return "offset is invalid"
        }
    }
}
#endif
