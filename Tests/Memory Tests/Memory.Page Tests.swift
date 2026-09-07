import Memory
import Memory_Standard_Library_Integration
import Testing

@Suite struct MemoryPageTests {
    @Test func pageSizeProducesItsAlignment() {
        let size = Memory.Page.Size(_unchecked: Cardinal(4096 as UInt))
        #expect(size.alignment == .`4096`)
        #expect(size.alignment.isAligned(8192))
        #expect(!size.alignment.isAligned(4097))
    }

    @Test func capacityRetainsUnsignedRange() {
        let capacity = Memory.Capacity(_unchecked: Cardinal(UInt.max))
        #expect(UInt64(capacity) == UInt64(UInt.max))
    }
}
