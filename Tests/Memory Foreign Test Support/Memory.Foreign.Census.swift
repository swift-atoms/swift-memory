#if Foreign
public import Memory
import Synchronization

extension Memory.Foreign {

    public final class Census: Sendable {
        private let _invocations = Atomic<Int>(0)

        public init() {}
    }
}

extension Memory.Foreign.Census {

    public var invocations: Int {
        _invocations.load(ordering: .sequentiallyConsistent)
    }

    public func record() {
        _invocations.wrappingAdd(1, ordering: .relaxed)
    }
}
#endif
