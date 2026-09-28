#if Cursor
public import Iterator

extension Memory.Snapshot {

    @frozen
    public struct Cursor<Element: Copyable & Escapable> {
        @usableFromInline
        var elements: [Element]

        @usableFromInline
        var index: Int

        @inlinable
        public init(_ elements: consuming [Element]) {
            self.elements = elements
            self.index = 0
        }
    }
}

extension Memory.Snapshot.Cursor: Iterator.`Protocol` {

    public typealias Failure = Never

    @inlinable
    public mutating func next() -> Element? {
        guard index < elements.count else { return nil }
        defer { index += 1 }
        return elements[index]
    }
}
#endif
