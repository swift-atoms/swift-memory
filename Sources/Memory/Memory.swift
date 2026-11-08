public import Cardinal
public import Tagged

public enum Memory {}

extension Memory {

    public typealias Capacity = Tagged<Memory, Cardinal>
}
