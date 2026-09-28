#if Shared
import Testing

import Memory

@Suite
struct `Shared memory errors preserve operation and payload` {
    @Test
    func `Open errors preserve POSIX codes and compare payloads`() {
        let error = Memory.Shared.Error.open(.posix(13))
        guard case .open(let code) = error else {
            Issue.record("Expected an open error")
            return
        }
        #expect(code == .posix(13))
        #expect(error == .open(.posix(13)))
        #expect(error != .open(.posix(2)))
        #expect(error != .unlink(.posix(13)))
        #expect(error.description == "shm_open failed: posix(13)")
    }

    @Test
    func `Unlink errors preserve the full Windows code`() {
        let error = Memory.Shared.Error.unlink(.win32(.max))
        guard case .unlink(let code) = error else {
            Issue.record("Expected an unlink error")
            return
        }
        #expect(code == .win32(UInt32.max))
        #expect(error == .unlink(.win32(.max)))
        #expect(error != .unlink(.posix(-1)))
        #expect(error.description == "shm_unlink failed: win32(4294967295)")
    }

    @Test
    func `Exhaustion remains distinct from operation failures`() {
        let error = Memory.Shared.Error.exhausted
        #expect(error == .exhausted)
        #expect(error != .open(.posix(12)))
        #expect(error != .unlink(.posix(12)))
        #expect(error.description == "out of memory")
    }
}
#endif
