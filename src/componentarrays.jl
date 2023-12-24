# see ext/UnionWrappersComponentArraysExt.jl
# """
#   ComponentArrayWrapper{E} = EltypeWrapper{E,Val(:ComponentArray)}

# Alias for the `EltypeWrapper` that is created by `wrap_union` on a `ComponentArray`.
# For a `ComponentVector` the more specific type `ComponentVectorWrapper{N,E}` is created.  
# """
# ComponentArrayWrapper{E} = EltypeWrapper{E,Val(:ComponentArray)}

# """
#   ComponentVectorWrapper{N,E} = SizeWrapper{N,E,Val(:ComponentVector)}

# Alias for the `SizeWrapper` that is created by `wrap_union` for a `ComponentVector`.  
# """
# ComponentVectorWrapper{N,E} = SizeWrapper{N,E,Val(:ComponentVector)}
