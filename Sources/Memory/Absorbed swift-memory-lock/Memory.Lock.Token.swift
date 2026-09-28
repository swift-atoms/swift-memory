#if Lock
extension Memory.Lock {

    public struct Token: ~Copyable {
        @usableFromInline
        var _release: (() -> Void)?

        @inlinable
        public init(release: @escaping () -> Void) {
            self._release = release
        }

        deinit {
            _release?()
        }
    }
}

extension Memory.Lock.Token {

    @inlinable
    public mutating func release() {
        _release?()
        _release = nil
    }
}
#endif
