# see ext/UnionWrappersComponentArraysExt.jl

ComponentArrayWrapper{E} = EltypeWrapper{E,Val(:ComponentArray)}

ComponentVectorWrapper{N,E} = LengthWrapper{N,E,Val(:ComponentArray)}
