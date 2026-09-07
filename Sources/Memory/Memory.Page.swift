public import Cardinal
public import Tagged

extension Memory {

    public enum Page {}
}

extension Memory.Page {

    public typealias Size = Tagged<Memory.Page, Cardinal>
}
