"""
    NTupleWrapper{N,E} = LengthWrapper{N,E,Val(:NTuple)}

Alias for the `LengthWrapper` that is created by `wrap` for an `NTuple`.  
"""
NTupleWrapper{N,E} = LengthWrapper{N,E,Val(:NTuple)}
wrap(nt::NTuple{N,E}) where {N,E} = NTupleWrapper{N,eltype(nt)}(nt)

"""
    NamedTupleWrapper{N,E} = LengthWrapper{N,E,Val(:NamedTuple)}

Alias for the `LengthWrapper` that is created by `wrap` for a 
`NamedTuple{K,NTuple{N,E}}`.  
"""
NamedTupleWrapper{N,E} = LengthWrapper{N,E,Val(:NamedTuple)}
wrap(nt::NamedTuple{K,NTuple{N,E}}) where {K,N,E} =
    NamedTupleWrapper{N,eltype(nt)}(nt)
