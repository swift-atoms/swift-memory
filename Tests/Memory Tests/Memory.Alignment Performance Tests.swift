import Memory
import Testing

@Suite(.serialized)
struct `Memory alignments support repeated checks rounding and derived value access` {

    @Test
    func `Alignment checks can be repeated across one hundred thousand values`() {
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
    func `Rounding up to alignment sixteen supports one hundred thousand values`() {
        let alignment: Memory.Alignment = .`16`
        var sum: UInt = 0
        for i: UInt in 0..<100_000 {
            sum &+= alignment.alignUp(i)
        }
        _ = sum
    }

    @Test
    func `Rounding up to alignment 4096 supports one hundred thousand values`() {
        let alignment: Memory.Alignment = .`4096`
        var sum: UInt = 0
        for i: UInt in 0..<100_000 {
            sum &+= alignment.alignUp(i)
        }
        _ = sum
    }

    @Test
    func `Rounding down to alignment sixteen supports one hundred thousand values`() {
        let alignment: Memory.Alignment = .`16`
        var sum: UInt = 0
        for i: UInt in 1...100_000 {
            sum &+= alignment.alignDown(i)
        }
        _ = sum
    }

    @Test
    func `Alignment masks can be computed one hundred thousand times`() {
        let alignments: [Memory.Alignment] = [.`1`, .`2`, .`4`, .`8`, .`16`, .`4096`]

        var sum: UInt = 0
        for i in 0..<100_000 {
            let alignment = alignments[i % alignments.count]
            sum &+= alignment.mask(as: UInt.self)
        }
        _ = sum
    }

    @Test
    func `Alignment magnitudes can be computed one hundred thousand times`() {
        let alignments: [Memory.Alignment] = [.`1`, .`2`, .`4`, .`8`, .`16`, .`4096`]

        var sum: UInt = 0
        for i in 0..<100_000 {
            let alignment = alignments[i % alignments.count]
            sum &+= alignment.magnitude(as: UInt.self)
        }
        _ = sum
    }
}
