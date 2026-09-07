import Memory
import Testing

@Suite
struct `Heap region ownership` {
    @Test(arguments: [1, 2, 4, 8, 16, 512, 4096])
    func `allocation satisfies its requested alignment`(_ magnitude: Int) throws {
        let alignment = try Memory.Alignment(magnitude)
        let heap = Memory.Heap(byteCount: 37, alignment: alignment)
        #expect(alignment.isAligned(heap.base.bitPattern))
        #expect(heap.capacity == 37)
        let count = unsafe heap.withUnsafeBytes { $0.count }
        #expect(count == 37)
    }

    @Test
    func `zero length allocation remains an owned empty region`() {
        let heap = Memory.Heap(byteCount: 0, alignment: .byte)
        #expect(heap.capacity == .zero)
        let count = unsafe heap.withUnsafeBytes { $0.count }
        #expect(count == 0)
    }

    @Test
    func `taking an allocation transfers its bytes and capacity without freeing them`() {
        let heap = Memory.Heap(byteCount: 4, alignment: .byte)
        let address = heap.base
        unsafe address.mutablePointer.storeBytes(of: UInt32(0x12345678), as: UInt32.self)
        let region = unsafe heap.take()
        defer { unsafe region.base.deallocate() }
        #expect(unsafe Memory.Address(region.base) == address)
        #expect(unsafe region.capacity == 4)
        #expect(unsafe region.base.loadUnaligned(as: UInt32.self) == 0x12345678)
    }

    @Test
    func `adoption retains the original allocation and capacity`() {
        let pointer = UnsafeMutableRawPointer.allocate(byteCount: 8, alignment: 8)
        unsafe pointer.storeBytes(of: UInt64(42), as: UInt64.self)
        let heap = unsafe Memory.Heap(adopting: pointer, capacity: 8)
        #expect(unsafe heap.base == Memory.Address(pointer))
        let value = unsafe heap.withUnsafeBytes { bytes in
            unsafe bytes.load(as: UInt64.self)
        }
        #expect(value == 42)
    }

    @Test
    func `a throwing borrow preserves ownership and propagates its typed error`() {
        enum Failure: Error { case expected }
        let heap = Memory.Heap(byteCount: 8, alignment: .`8`)
        let original = heap.base
        #expect(throws: Failure.expected) {
            try unsafe heap.withUnsafeBytes { _ throws(Failure) -> Void in
                throw .expected
            }
        }
        #expect(heap.base == original)
        #expect(heap.capacity == 8)
    }

    @Test
    func `allocation rejects capacities beyond the signed pointer extent`() async {
        await #expect(processExitsWith: .failure) {
            let capacity = Memory.Address.Count(_unchecked: Cardinal(UInt(Int.max) + 1))
            _ = Memory.Heap(byteCount: capacity, alignment: .byte)
        }
    }

    @Test
    func `adoption rejects capacities beyond the signed pointer extent`() async {
        await #expect(processExitsWith: .failure) {
            let pointer = UnsafeMutableRawPointer.allocate(byteCount: 1, alignment: 1)
            let capacity = Memory.Address.Count(_unchecked: Cardinal(UInt.max))
            _ = unsafe Memory.Heap(adopting: pointer, capacity: capacity)
        }
    }
}

@Suite
struct `Address and alignment values` {
    @Test
    func `optional pointer conversion rejects null with the owning address error`() {
        let pointer: UnsafeRawPointer? = nil
        #expect(throws: Memory.Address.Error.null) {
            _ = try unsafe Memory.Address(pointer)
        }
    }

    @Test
    func `address conversions preserve pointer bits`() {
        let pointer = UnsafeMutableRawPointer.allocate(byteCount: 8, alignment: 8)
        defer { unsafe pointer.deallocate() }
        let address = unsafe Memory.Address(pointer)
        #expect(address.bitPattern == UInt(bitPattern: pointer))
        #expect(unsafe address.mutablePointer == pointer)
        #expect(unsafe address.pointer == UnsafeRawPointer(pointer))
        #expect(unsafe UnsafeMutableRawPointer(address) == pointer)
        #expect(unsafe UnsafeRawPointer(address) == UnsafeRawPointer(pointer))
    }

    @Test(arguments: [0, -1, 3, 6, Int.min, Int.max])
    func `alignment rejects nonpositive values and nonpowers of two`(_ magnitude: Int) {
        #expect(throws: Memory.Alignment.Error.notPowerOfTwo(magnitude)) {
            _ = try Memory.Alignment(magnitude)
        }
    }

    @Test
    func `rounding preserves aligned values and brackets ordinary values`() {
        let alignment = Memory.Alignment.`16`
        for value: UInt in 0..<256 {
            let lower = alignment.alignDown(value)
            let upper = alignment.alignUp(value)
            #expect(lower <= value && value <= upper)
            #expect(alignment.isAligned(lower) && alignment.isAligned(upper))
            #expect(upper - lower < 32)
        }
    }

    @Test
    func `rounding retains fixed width wrapping at the unsigned boundary`() {
        let alignment = Memory.Alignment.`16`
        #expect(alignment.alignUp(UInt8.max) == 0)
        #expect(alignment.alignDown(UInt8.max) == 240)
        #expect(alignment.alignUp(Int8(-17)) == -16)
        #expect(alignment.alignDown(Int8(-17)) == -32)
    }
}

extension `Address and alignment values` {
    @Test
    func `typed pointer conversion accepts noncopyable pointees`() throws {
        struct Payload: ~Copyable { let value: Int }
        var payload = Payload(value: 42)
        try withUnsafeMutablePointer(to: &payload) { mutable in
            let immutable = unsafe UnsafePointer(mutable)
            let address = unsafe Memory.Address(mutable)
            #expect(unsafe Memory.Address(immutable) == address)
            let optionalMutable = try unsafe Memory.Address(Optional(mutable))
            let optionalImmutable = try unsafe Memory.Address(Optional(immutable))
            #expect(optionalMutable == address)
            #expect(optionalImmutable == address)
            #expect(unsafe mutable.pointee.value == 42)
        }
    }
}
