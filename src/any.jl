# """
#     AnyWrapper = UnionWrapper{Val(:Any)}

# Alias for the `UnionWrapper` that is created by `wrap_union` without a more specific method.  
# """
wrap_union(any::Any) = UnionWrapper{Any}(any)
