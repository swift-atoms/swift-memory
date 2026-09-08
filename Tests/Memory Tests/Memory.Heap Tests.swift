import Cardinal
import Ordinal
import Tagged
import Testing

@testable import Memory

extension Memory.Heap {
    @Suite
    struct `Heap allocation preserves byte capacity and stable base addresses` {
        @Suite struct `Heap construction retains requested capacities and stable base addresses` {}
        @Suite struct `A single byte heap allocation retains its requested capacity` {}
    }
}

extension Memory.Heap.`Heap allocation preserves byte capacity and stable base addresses`.`Heap construction retains requested capacities and stable base addresses` {
    @Test
    func `fresh allocation reports the requested byte capacity`() {
        let heap = Memory.Heap(byteCount: 1024, alignment: .`8`)
        #expect(heap.capacity.underlying == 1024)
    }

    @Test
    func `byte capacity tracks the requested size across sizes and alignments`() {
        #expect(Memory.Heap(byteCount: 16, alignment: .byte).capacity.underlying == 16)
        #expect(Memory.Heap(byteCount: 256, alignment: .`16`).capacity.underlying == 256)
        #expect(Memory.Heap(byteCount: 4096, alignment: .`4096`).capacity.underlying == 4096)
    }

    @Test
    func `base address is reachable and stable across reads`() {
        let heap = Memory.Heap(byteCount: 512, alignment: .`8`)
        let first = heap.base
        let second = heap.base
        #expect(first.underlying == second.underlying)
    }

    @Test
    func `drop frees the owned region without a crash or double free`() {
        do {
            let heap = Memory.Heap(byteCount: 512, alignment: .`8`)
            #expect(heap.capacity.underlying == 512)
            _ = heap.base
        }

        #expect(Bool(true))
    }
}

extension Memory.Heap.`Heap allocation preserves byte capacity and stable base addresses`.`A single byte heap allocation retains its requested capacity` {
    @Test
    func `single-byte region is valid`() {
        let heap = Memory.Heap(byteCount: 1, alignment: .byte)
        #expect(heap.capacity.underlying == 1)
    }
}
