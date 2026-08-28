public import Cardinal
public import Ordinal
public import Tagged

extension Memory {

    public protocol Region: ~Copyable {

        var base: Memory.Address { get }

        var capacity: Memory.Address.Count { get }
    }
}
