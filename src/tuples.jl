# """
#     NTupleWrapper{N,E} = SizeWrapper{N,E,Val(:NTuple)}

# Alias for the `SizeWrapper` that is created by `wrap_union` for an `NTuple`.  
# """
wrap_union(nt::NTuple{N,E}) where {N,E} = UnionWrapper{NTuple}(nt)
wrap_eltype(nt::NTuple{N,E}) where {N,E} = EltypeWrapper{eltype(nt),NTuple}(nt)
#wrap_size(nt::NTuple{N,E}) where {N,E} = SizeWrapper{N,eltype(nt),NTuple}(nt)

# """
#     NamedTupleWrapper{N,E} = SizeWrapper{N,E,Val(:NamedTuple)}

# Alias for the `SizeWrapper` that is created by `wrap_union` for a 
# `NamedTuple{K,NTuple{N,E}}`.  
# """
#NamedTupleWrapper{N,E} = SizeWrapper{N,E,Val(:NamedTuple)}
# wrap_size(nt::NamedTuple{K,NTuple{N,E}}) where {K,N,E} =
#     SizeWrapper{N,eltype(nt),NamedTuple}(nt)
wrap_union(nt::NamedTuple{K,NTuple{N,E}}) where {K,N,E} = UnionWrapper{NamedTuple}(nt)
wrap_eltype(nt::NamedTuple{K,NTuple{N,E}}) where {K,N,E} =
    EltypeWrapper{eltype(nt),NamedTuple}(nt)
