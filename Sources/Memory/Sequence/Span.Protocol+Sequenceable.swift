#if Sequence
public import Sequence
public import Span

extension Span.`Protocol`
where Self: Sequenceable, Self: ~Copyable, Element: Copyable & Escapable {

    @inlinable
    public consuming func makeIterator() -> Memory.Cursor<Self> {
        Memory.Cursor(self)
    }
}

extension Span.`Protocol`
where Self: ~Copyable, Element: Copyable & Escapable {

    @inlinable
    public consuming func makeSnapshotIterator() -> Memory.Snapshot.Cursor<Element> {
        let snapshot = span.withUnsafeBufferPointer { unsafe Array($0) }
        return Memory.Snapshot.Cursor(snapshot)
    }
}
#endif
