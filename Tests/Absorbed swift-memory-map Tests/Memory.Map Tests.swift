#if Map
import Testing

@testable import Memory

extension Memory.Map {
    @Suite struct Tests {
        @Test func `namespace is available`() {

            #expect(Bool(true))
        }
    }
}
#endif
