public import Memory

extension Memory.Alignment: CustomStringConvertible {

    public var description: String {
        "\(magnitude() as Int)"
    }
}
