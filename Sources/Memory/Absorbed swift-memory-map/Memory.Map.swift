#if Map
extension Memory {

    public struct Map: ~Copyable {

        @_spi(MemoryInternal)
        public var _region: Memory.Map.Region?

        @_spi(MemoryInternal)
        public let _offsetDelta: Memory.Address.Count

        @_spi(MemoryInternal)
        public let _userLength: Memory.Address.Count

        @_spi(MemoryInternal)
        public var access: Access

        public let sharing: Sharing

        public let safety: Safety

        @_spi(MemoryInternal)
        public var _lockToken: Memory.Lock.Token?

        @_spi(MemoryInternal)
        public let _unmap: (Memory.Map.Region) -> Void

        public init(
            region: Memory.Map.Region?,
            offsetDelta: Memory.Address.Count,
            userLength: Memory.Address.Count,
            access: Access,
            sharing: Sharing,
            safety: Safety,
            lockToken: consuming Memory.Lock.Token?,
            unmap: @escaping (Memory.Map.Region) -> Void
        ) {
            self._region = region
            self._offsetDelta = offsetDelta
            self._userLength = userLength
            self.access = access
            self.sharing = sharing
            self.safety = safety
            self._lockToken = lockToken
            self._unmap = unmap
        }

        deinit {
            guard let region = _region else { return }
            _unmap(region)
        }
    }
}

extension Memory.Map {

    public var region: Memory.Map.Region? { _region }

    public var offsetDelta: Memory.Address.Count { _offsetDelta }

    public var userLength: Memory.Address.Count { _userLength }
}
#endif
