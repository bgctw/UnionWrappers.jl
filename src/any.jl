AnyWrapper = UnionWrapper{Val(:Any)}
wrap(any::Any) = AnyWrapper(any)
