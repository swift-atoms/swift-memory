#if TaggedMemory
import Cardinal
import Memory
import Ordinal
import Tagged
import Testing

@Suite("Memory × Tagged")
struct Memory_Tagged_Tests {

    static func count(_ value: UInt) -> Memory.Address.Count {
        Memory.Address.Count(_unchecked: Cardinal(value))
    }

    static func address(_ value: UInt) -> Memory.Address {
        Memory.Address(_unchecked: Ordinal(value))
    }

    @Test
    func `raw buffer accepts tagged Memory count and address`() {
        let bytes: [UInt8] = [10, 20, 30, 40]

        bytes.withUnsafeBytes { raw in
            let buffer = unsafe UnsafeRawBufferPointer(
                start: raw.baseAddress,
                count: Self.count(UInt(raw.count))
            )

            #expect(unsafe buffer[Self.address(2)] == 30)
        }
    }

    @Test
    func `mutable buffer writes through tagged Memory address`() {
        var bytes: [UInt8] = [1, 2, 3, 4]

        bytes.withUnsafeMutableBytes { raw in
            let buffer = unsafe UnsafeMutableRawBufferPointer(
                start: raw.baseAddress,
                count: Self.count(UInt(raw.count))
            )
            unsafe buffer[Self.address(1)] = 9
        }

        #expect(bytes == [1, 9, 3, 4])
    }

    @Test
    func `raw allocation accepts tagged Memory count`() {
        let byteCount = Self.count(UInt(MemoryLayout<UInt64>.size))
        let pointer = unsafe UnsafeMutableRawPointer.allocate(
            count: byteCount,
            alignment: .`8`
        )
        defer { unsafe pointer.deallocate() }

        unsafe pointer.storeBytes(of: UInt64(0xCAFE_BABE), as: UInt64.self)
        let value = unsafe pointer.load(as: UInt64.self)
        #expect(value == 0xCAFE_BABE)
    }

    @Test
    func `memory property initializes a native Cardinal count`() {
        let byteCount = MemoryLayout<Int>.stride * 3
        let pointer = UnsafeMutableRawPointer.allocate(
            byteCount: byteCount,
            alignment: MemoryLayout<Int>.alignment
        )
        defer { unsafe pointer.deallocate() }

        let initialized = unsafe pointer.memory.initialize(
            as: Int.self,
            repeating: 7,
            count: Cardinal(3)
        )
        defer { unsafe initialized.deinitialize(count: 3) }

        #expect(unsafe initialized[0] == 7)
        #expect(unsafe initialized[2] == 7)
    }

    @Test
    func `memory property copies a tagged byte count`() {
        let source: [UInt32] = [11, 22]
        let byteCount = Self.count(UInt(MemoryLayout<UInt32>.stride * source.count))
        let destination = unsafe UnsafeMutableRawPointer.allocate(
            count: byteCount,
            alignment: .`4`
        )
        defer { unsafe destination.deallocate() }

        source.withUnsafeBytes { sourceBytes in
            unsafe destination.memory.copy(
                from: sourceBytes.baseAddress!,
                count: byteCount
            )
        }

        let typed = unsafe destination.assumingMemoryBound(to: UInt32.self)
        #expect(unsafe typed[0] == 11)
        #expect(unsafe typed[1] == 22)
    }
}
#endif
