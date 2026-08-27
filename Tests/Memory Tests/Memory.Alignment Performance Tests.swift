import Memory
import Testing

@Suite(.serialized)
struct `Memory.Alignment - Performance` {

    @Test
    func `isAligned check 100_000 values`() {
        let alignment: Memory.Alignment = .`16`
        var count = 0
        for i: UInt in 0..<100_000 {
            if alignment.isAligned(i) {
                count &+= 1
            }
        }
        _ = count
    }

    @Test
    func `align up 100_000 values to 16`() {
        let alignment: Memory.Alignment = .`16`
        var sum: UInt = 0
        for i: UInt in 0..<100_000 {
            sum &+= alignment.alignUp(i)
        }
        _ = sum
    }

    @Test
    func `align up 100_000 values to 4096`() {
        let alignment: Memory.Alignment = .`4096`
        var sum: UInt = 0
        for i: UInt in 0..<100_000 {
            sum &+= alignment.alignUp(i)
        }
        _ = sum
    }

    @Test
    func `align down 100_000 values to 16`() {
        let alignment: Memory.Alignment = .`16`
        var sum: UInt = 0
        for i: UInt in 1...100_000 {
            sum &+= alignment.alignDown(i)
        }
        _ = sum
    }

    @Test
    func `mask computation 100_000 times`() {
        let alignments: [Memory.Alignment] = [.`1`, .`2`, .`4`, .`8`, .`16`, .`4096`]

        var sum: UInt = 0
        for i in 0..<100_000 {
            let alignment = alignments[i % alignments.count]
            sum &+= alignment.mask(as: UInt.self)
        }
        _ = sum
    }

    @Test
    func `magnitude computation 100_000 times`() {
        let alignments: [Memory.Alignment] = [.`1`, .`2`, .`4`, .`8`, .`16`, .`4096`]

        var sum: UInt = 0
        for i in 0..<100_000 {
            let alignment = alignments[i % alignments.count]
            sum &+= alignment.magnitude(as: UInt.self)
        }
        _ = sum
    }
}
