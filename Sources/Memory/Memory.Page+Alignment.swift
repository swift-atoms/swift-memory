public import Tagged

extension Memory.Alignment {

    @inlinable
    public init(_ pageSize: Memory.Page.Size) {

        do {
            self = try Memory.Alignment(Int(bitPattern: pageSize.underlying.rawValue))
        } catch {
            preconditionFailure("a page size is a valid alignment: \(error)")
        }
    }
}

extension Memory.Page.Size {

    @inlinable
    public var alignment: Memory.Alignment {
        Memory.Alignment(self)
    }
}
