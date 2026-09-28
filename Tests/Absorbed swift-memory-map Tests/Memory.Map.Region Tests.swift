#if Map
import Testing

@testable import Memory

extension Memory.Map.Region {
    @Suite struct Tests {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
    }
}

extension Memory.Map.Region.Tests.Unit {

    @Test func `region exposes only base, length, and derived count`() {
        let byteCount = 32
        let buffer = UnsafeMutableRawBufferPointer.allocate(byteCount: byteCount, alignment: 1)
        defer { unsafe buffer.deallocate() }

        let region = Memory.Map.Region(
            base: unsafe Memory.Address(buffer.baseAddress!),
            length: Memory.Address.Count(UInt(byteCount))
        )

        #expect(region.count == byteCount)
        #expect(Int(bitPattern: region.length) == byteCount)
    }
}

extension Memory.Map.Region.Tests.`Edge Case` {

    @Test func `region copied out before unmap outlives the map as inert metadata only`() throws {
        let byteCount = 16
        let buffer = UnsafeMutableRawBufferPointer.allocate(byteCount: byteCount, alignment: 1)
        unsafe buffer.initializeMemory(as: UInt8.self, repeating: 0)

        var unmapCount = 0
        var map: Memory.Map? = Memory.Map(
            region: Memory.Map.Region(
                base: unsafe Memory.Address(buffer.baseAddress!),
                length: Memory.Address.Count(UInt(byteCount))
            ),
            offsetDelta: Memory.Address.Count(0),
            userLength: Memory.Address.Count(UInt(byteCount)),
            access: [.read, .write],
            sharing: .private,
            safety: .unchecked,
            lockToken: nil,
            unmap: { _ in
                unsafe buffer.deallocate()
                unmapCount += 1
            }
        )

        let escapedRegion = map?.region

        map = nil
        #expect(unmapCount == 1)

        let region = try #require(escapedRegion)
        #expect(region.count == byteCount)
        #expect(Int(bitPattern: region.length) == byteCount)
    }
}
#endif
