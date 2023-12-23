AnyWrapper = UnionWrapper{Val(:Any)}
UnionWrapper(any::Any) = AnyWrapper(any)
