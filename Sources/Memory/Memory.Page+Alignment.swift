public import Tagged

extension Memory.Alignment {

    @inlinable
    public init(_ pageSize: Memory.Page.Size) {

        self = try! Memory.Alignment(Int(bitPattern: pageSize.underlying.rawValue))
    }
}

extension Memory.Page.Size {

    @inlinable
    public var alignment: Memory.Alignment {
        Memory.Alignment(self)
    }
}
