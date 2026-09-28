#if Cursor
public import Iterator
public import struct Ordinal.Ordinal
public import Span
public import struct Tagged.Tagged

extension Memory {

    @frozen
    public struct Cursor<Base: Span::__Span.`Protocol` & ~Copyable>: ~Copyable
    where Base.Element: Copyable & Escapable {

        public var base: Base

        public var position: Tagged<Base, Ordinal>

        @inlinable
        public init(_ base: consuming Base) {
            self.base = base
            self.position = Tagged<Base, Ordinal>(_unchecked: Ordinal(0))
        }
    }
}

extension Memory.Cursor: Iterator.`Protocol` where Base: ~Copyable {

    public typealias Element = Base.Element

    public typealias Failure = Never

    @inlinable
    public mutating func next() -> Base.Element? {
        let span = base.span
        guard let index = Int(exactly: position.underlying.rawValue),
              index < span.count else { return nil }
        defer {
            position = Tagged(
                _unchecked: Ordinal(position.underlying.rawValue + 1)
            )
        }
        return span[index]
    }
}
#endif
