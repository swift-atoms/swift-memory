#if Cursor
import Iterator
import Memory
import Span
import Testing

@Suite
struct `Memory Cursor Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

private struct OwnedRegion: Span::__Span.`Protocol` {
    let storage: [Int]

    var span: Swift.Span<Int> {
        @_lifetime(borrow self) get { storage.span }
    }
}

private func withMemoryCursor<R>(
    over values: [Int],
    _ body: (consuming Memory.Cursor<OwnedRegion>) -> R
) -> R {
    body(Memory.Cursor(OwnedRegion(storage: values)))
}

extension `Memory Cursor Tests`.Unit {
    @Test
    func `next yields first element then advances`() {
        let first = withMemoryCursor(over: [10, 20, 30]) { cursor -> Int? in
            var iterator = cursor
            return iterator.next()
        }
        #expect(first == 10)
    }

    @Test
    func `next returns nil on empty region`() {
        let value = withMemoryCursor(over: []) { cursor -> Int? in
            var iterator = cursor
            return iterator.next()
        }
        #expect(value == nil)
    }
}

extension `Memory Cursor Tests`.`Edge Case` {
    @Test
    func `single element drains to nil`() {
        let collected = withMemoryCursor(over: [42]) { cursor -> [Int] in
            var iterator = cursor
            var out: [Int] = []
            while let x = iterator.next() { out.append(x) }
            return out
        }
        #expect(collected == [42])
    }
}

extension `Memory Cursor Tests`.Integration {

    @Test
    func `drains every element via next loop over an owned span region`() {
        let source = Array(0..<32)
        let collected = withMemoryCursor(over: source) { cursor -> [Int] in
            var iterator = cursor
            var out: [Int] = []
            while let x = iterator.next() { out.append(x) }
            return out
        }
        #expect(collected == source)
    }
}
#endif
