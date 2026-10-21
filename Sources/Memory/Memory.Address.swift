import Cardinal
public import Ordinal
public import Tagged

extension Memory {

    public typealias Address = Tagged<Memory, Ordinal>
}

extension Tagged where Tag == Memory, Underlying == Ordinal {

    @inlinable
    public init(_ pointer: UnsafeRawPointer) {
        self.init(_unchecked: Ordinal(UInt(bitPattern: pointer)))
    }

    @inlinable
    public init<T: ~Copyable>(_ pointer: UnsafePointer<T>) {
        unsafe self.init(UnsafeRawPointer(pointer))
    }

    @inlinable
    public init<T: ~Copyable>(_ pointer: UnsafeMutablePointer<T>) {
        unsafe self.init(UnsafeRawPointer(pointer))
    }

    @inlinable
    public init(_ pointer: UnsafeMutableRawPointer) {
        unsafe self.init(UnsafeRawPointer(pointer))
    }
}

extension Tagged where Tag == Memory, Underlying == Ordinal {

    @inlinable
    public init(_ pointer: UnsafeRawPointer?) throws(Self.Error) {
        guard let pointer = unsafe pointer else { throw .null }
        unsafe self.init(pointer)
    }

    @inlinable
    public init<T: ~Copyable>(_ pointer: UnsafePointer<T>?) throws(Self.Error) {
        guard let pointer = unsafe pointer else { throw .null }
        unsafe self.init(pointer)
    }

    @inlinable
    public init<T: ~Copyable>(_ pointer: UnsafeMutablePointer<T>?) throws(Self.Error) {
        guard let pointer = unsafe pointer else { throw .null }
        unsafe self.init(pointer)
    }

    @inlinable
    public init(_ pointer: UnsafeMutableRawPointer?) throws(Self.Error) {
        guard let pointer = unsafe pointer else { throw .null }
        unsafe self.init(pointer)
    }
}

extension Tagged where Tag == Memory, Underlying == Ordinal {

    @inlinable
    public var bitPattern: UInt { underlying.rawValue }
}

extension Tagged where Tag == Memory, Underlying == Ordinal {

    @inlinable
    public var mutablePointer: UnsafeMutableRawPointer {
        guard let pointer = unsafe UnsafeMutableRawPointer(bitPattern: bitPattern) else {
            preconditionFailure("the null address has no pointer representation")
        }
        return unsafe pointer
    }

    @inlinable
    public var pointer: UnsafeRawPointer {
        guard let pointer = unsafe UnsafeRawPointer(bitPattern: bitPattern) else {
            preconditionFailure("the null address has no pointer representation")
        }
        return unsafe pointer
    }
}
