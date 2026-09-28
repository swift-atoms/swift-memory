#if Carrier
import Cardinal
import Carrier
import Memory
import Property
import Testing

@Suite
struct `Memory Carrier Tests` {

    private struct Integer: Carrier.`Protocol`, Equatable {
        typealias Domain = Never

        let underlying: UInt

        init(_ underlying: UInt) {
            self.underlying = underlying
        }
    }

    private struct Count: Carrier.`Protocol` {
        typealias Domain = Never

        let underlying: Cardinal

        init(_ underlying: Cardinal) {
            self.underlying = underlying
        }
    }

    @Test
    func `alignment preserves integer carrier identity`() {
        let alignment = Memory.Alignment.`8`

        #expect(alignment.isAligned(Integer(16)))
        #expect(!alignment.isAligned(Integer(10)))
        #expect(alignment.alignUp(Integer(10)) == Integer(16))
        #expect(alignment.alignDown(Integer(10)) == Integer(8))
    }

    @Test
    func `alignment property operates on cardinal carriers`() {
        let value = Count(Cardinal(UInt(10)))

        #expect(Memory.Alignment.`8`.align.up(value).underlying.rawValue == UInt(16))
        #expect(Memory.Alignment.`8`.align.down(value).underlying.rawValue == UInt(8))
    }

    @Test
    func `memory shift is a cardinal carrier`() {
        let shift = Memory.Shift(Cardinal(UInt(4)))

        #expect(shift.underlying.rawValue == UInt(4))
        #expect(cardinalValue(shift).rawValue == UInt(4))
    }

    private func cardinalValue<C: Carrier.`Protocol`>(_ value: C) -> Cardinal
    where C.Underlying == Cardinal {
        value.underlying
    }
}
#endif
