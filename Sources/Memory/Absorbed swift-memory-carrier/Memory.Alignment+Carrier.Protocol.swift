#if Carrier
public import Carrier
extension Memory.Alignment {

    @_disfavoredOverload
    @inlinable
    public func isAligned<C: Carrier.`Protocol`>(_ value: C) -> Bool
    where C.Underlying: FixedWidthInteger {
        isAligned(value.underlying)
    }

    @_disfavoredOverload
    @inlinable
    public func alignUp<C: Carrier.`Protocol`>(_ value: C) -> C
    where C.Underlying: FixedWidthInteger {
        C(alignUp(value.underlying))
    }

    @_disfavoredOverload
    @inlinable
    public func alignDown<C: Carrier.`Protocol`>(_ value: C) -> C
    where C.Underlying: FixedWidthInteger {
        C(alignDown(value.underlying))
    }
}
#endif
