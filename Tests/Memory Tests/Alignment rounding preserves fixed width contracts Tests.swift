import Memory
import Testing

@Suite(.timeLimit(.minutes(1)))
struct `Alignment rounding preserves fixed width contracts` {
    @Test(arguments: Array(0..<8))
    func `every narrow signed and unsigned value follows mathematical rounding`(exponent: Int) throws {
        let magnitude = 1 << exponent
        let alignment = try Memory.Alignment(magnitude)
        for value in Int(Int8.min)...Int(Int8.max) {
            verify(Int8(value), alignment: alignment, magnitude: magnitude)
        }
        for value in Int(UInt8.min)...Int(UInt8.max) {
            verify(UInt8(value), alignment: alignment, magnitude: magnitude)
        }
    }

    @Test(arguments: Array(0...(Int.bitWidth - 2)))
    func `wider boundaries report exactly the unrepresentable rounded values`(exponent: Int) throws {
        let magnitude = 1 << exponent
        let alignment = try Memory.Alignment(magnitude)
        if exponent < 16 {
            verifyBoundaries(Int16.self, alignment: alignment, magnitude: magnitude)
            verifyBoundaries(UInt16.self, alignment: alignment, magnitude: magnitude)
        }
        if exponent < 32 {
            verifyBoundaries(Int32.self, alignment: alignment, magnitude: magnitude)
            verifyBoundaries(UInt32.self, alignment: alignment, magnitude: magnitude)
        }
        verifyBoundaries(Int64.self, alignment: alignment, magnitude: magnitude)
        verifyBoundaries(UInt64.self, alignment: alignment, magnitude: magnitude)
    }

    @Test
    func `signed sign bit alignments retain their magnitude and mask semantics`() throws {
        let alignment = try Memory.Alignment(128)
        _ = try alignment.validated(for: Int8.self)
        #expect(alignment.magnitude(as: Int8.self) == Int8.min)
        #expect(alignment.mask(as: Int8.self) == Int8.max)

        let negative = alignment.alignUpReportingOverflow(Int8(-1))
        #expect(negative.partialValue == 0)
        #expect(!negative.overflow)
        let positive = alignment.alignUpReportingOverflow(Int8(1))
        #expect(positive.partialValue == Int8.min)
        #expect(positive.overflow)
        #expect(alignment.alignUp(Int8(1)) == Int8.min)
    }

    @Test(arguments: [8, 16, 32], [false, true])
    func `over width alignments reject both rounding operations`(width: Int, reporting: Bool) async throws {
        for signed in [false, true] {
            let result = try await #require(
                processExitsWith: .failure,
                observing: [\.standardErrorContent]
            ) { [width = width as Int, reporting = reporting as Bool, signed = signed as Bool] in
                let alignment = try Memory.Alignment(1 << width)
                switch width {
                case 8:
                    if signed { round(Int8.zero, alignment: alignment, reporting: reporting) }
                    else { round(UInt8.zero, alignment: alignment, reporting: reporting) }
                case 16:
                    if signed { round(Int16.zero, alignment: alignment, reporting: reporting) }
                    else { round(UInt16.zero, alignment: alignment, reporting: reporting) }
                case 32:
                    if signed { round(Int32.zero, alignment: alignment, reporting: reporting) }
                    else { round(UInt32.zero, alignment: alignment, reporting: reporting) }
                default: preconditionFailure("Unexpected carrier width")
                }
            }
            #if DEBUG
            let diagnostic = String(decoding: result.standardErrorContent, as: UTF8.self)
            #expect(diagnostic.contains("Memory.Shift \(width) exceeds \(width)-bit carrier width"), "\(diagnostic)")
            #else
            _ = result
            #endif
        }
    }
}

private func verify<Value: FixedWidthInteger>(
    _ value: Value, alignment: Memory.Alignment, magnitude: Int
) {
    let wide = Int128(value)
    let modulus = Int128(magnitude)
    let remainder = (wide % modulus + modulus) % modulus
    let upper = wide + (modulus - remainder) % modulus
    let lower = wide - remainder
    let result = alignment.alignUpReportingOverflow(value)

    #expect(result.partialValue == Value(truncatingIfNeeded: upper))
    #expect(result.overflow == (upper > Int128(Value.max)))
    #expect(alignment.alignUp(value) == result.partialValue)
    #expect(alignment.alignDown(value) == Value(lower))
    #expect(alignment.isAligned(value) == (remainder == 0))
    #expect(alignment.isAligned(result.partialValue))
}

private func verifyBoundaries<Value: FixedWidthInteger>(
    _: Value.Type, alignment: Memory.Alignment, magnitude: Int
) {
    let minimum = Int128(Value.min)
    let maximum = Int128(Value.max)
    let modulus = Int128(magnitude)
    let lastAligned = maximum - maximum % modulus
    let candidates: Set<Int128> = [
        minimum, minimum + 1, -modulus, -modulus + 1, -1, 0, 1,
        modulus - 1, modulus, modulus + 1,
        lastAligned - 1, lastAligned, lastAligned + 1, maximum,
    ]
    for wide in candidates.sorted() where minimum <= wide && wide <= maximum {
        verify(Value(wide), alignment: alignment, magnitude: magnitude)
    }
}

private func round<Value: FixedWidthInteger>(
    _ value: Value, alignment: Memory.Alignment, reporting: Bool
) {
    if reporting { _ = alignment.alignUpReportingOverflow(value) }
    else { _ = alignment.alignUp(value) }
}
