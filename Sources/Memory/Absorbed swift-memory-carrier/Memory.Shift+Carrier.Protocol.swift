#if Carrier
public import Cardinal
public import Carrier
public import Tagged

extension Memory.Shift: Carrier.`Protocol` {

    public typealias Underlying = Cardinal

    public typealias Domain = Never

    @inlinable
    public var underlying: Cardinal {
        rawValue.underlying
    }

    @inlinable
    public init(_ underlying: Cardinal) {
        precondition(
            underlying.rawValue <= UInt(Self.maxValue),
            "Memory.Shift carrier value exceeds the supported shift range"
        )
        do {
            self = try Self(UInt8(underlying.rawValue))
        } catch {
            preconditionFailure("Memory.Shift rejected a prevalidated carrier value")
        }
    }
}
#endif
