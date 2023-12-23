"""
    AnyWrapper = UnionWrapper{Val(:Any)}

Alias for the `UnionWrapper` that is created by `wrap` without a more specific method.  
"""
AnyWrapper = UnionWrapper{Val(:Any)}  
wrap(any::Any) = AnyWrapper(any)

# use a Val(Symbol) rather than Any, because a specific DataTime
# can be unknown until extension are loaded.

