#if Map
extension Memory.Map {

    public enum Safety: Sendable, Equatable {

        case coordinated(Memory.Lock.Kind, scope: Scope)

        case unchecked
    }
}

extension Memory.Map.Safety {

    public enum Scope: Sendable, Equatable {

        case file

        case mapped
    }
}

extension Memory.Map.Safety {

    public static var `default`: Default.Type { Default.self }

    public enum Default {

        public static var read: Memory.Map.Safety {
            .coordinated(.shared, scope: .mapped)
        }

        public static var write: Memory.Map.Safety {
            .coordinated(.exclusive, scope: .mapped)
        }
    }
}
#endif
