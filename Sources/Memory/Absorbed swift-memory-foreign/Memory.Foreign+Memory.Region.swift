#if Foreign
public import Span

extension Memory.Foreign: Memory.Region {

    @inlinable
    public var base: Memory.Address {

        unsafe Memory.Address(_region.base.nonNull.baseAddress!)
    }

    @inlinable
    public var capacity: Memory.Address.Count {
        Memory.Address.Count(UInt(unsafe _region.base.nonNull.count))
    }
}
#endif
