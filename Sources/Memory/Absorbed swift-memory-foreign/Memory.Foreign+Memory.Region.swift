#if Foreign
    public import Span

    extension Memory.Foreign: Memory.Region {

        @inlinable
        public var base: Memory.Address {

            guard let base = unsafe _region.base.nonNull.baseAddress else {
                preconditionFailure("a foreign memory region has a base address")
            }
            return unsafe Memory.Address(base)
        }

        @inlinable
        public var capacity: Memory.Address.Count {
            Memory.Address.Count(UInt(unsafe _region.base.nonNull.count))
        }
    }
#endif
