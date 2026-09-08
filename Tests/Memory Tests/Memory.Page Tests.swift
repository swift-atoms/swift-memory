import Memory
import Testing

@Suite struct `Memory page sizes expose alignment and capacities retain the unsigned range` {
    @Test func `page Size Produces Its Alignment`() {
        let size = Memory.Page.Size(_unchecked: Cardinal(4096 as UInt))
        #expect(size.alignment == .`4096`)
        #expect(size.alignment.isAligned(8192))
        #expect(!size.alignment.isAligned(4097))
    }

    @Test func `capacity Retains Unsigned Range`() {
        let capacity = Memory.Capacity(_unchecked: Cardinal(UInt.max))
        #expect(UInt64(capacity) == UInt64(UInt.max))
    }
}
