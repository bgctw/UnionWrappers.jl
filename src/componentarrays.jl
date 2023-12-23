# see ext/UnionWrappersComponentArraysExt.jl
"""
  ComponentArrayWrapper{E} = EltypeWrapper{E,Val(:ComponentArray)}

Alias for the `EltypeWrapper` that is created by `wrap` on a `ComponentArray`.
For a `ComponentVector` the more specific type `ComponentVectorWrapper{N,E}` is created.  
"""
ComponentArrayWrapper{E} = EltypeWrapper{E,Val(:ComponentArray)}

"""
  ComponentVectorWrapper{N,E} = LengthWrapper{N,E,Val(:ComponentVector)}

Alias for the `LengthWrapper` that is created by `wrap` for a `ComponentVector`.  
"""
ComponentVectorWrapper{N,E} = LengthWrapper{N,E,Val(:ComponentVector)}
