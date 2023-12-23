abstract type AbstractUnionWrapper end
abstract type AbstractEltypeWrapper <: AbstractUnionWrapper end
abstract type AbstractLengthWrapper <: AbstractEltypeWrapper end

struct UnionWrapper{T} <: AbstractUnionWrapper
    value::Any
end
unwrap(w::UnionWrapper) = w.value
wrapped_type(w::UnionWrapper{T}) where {T} = T


struct EltypeWrapper{E,T} <: AbstractEltypeWrapper
    value::Any
end
unwrap(w::EltypeWrapper) = w.value
wrapped_type(w::EltypeWrapper{E,T}) where {T,E} = T

Base.eltype(w::EltypeWrapper{E,T}) where {T,E} = E

# already covered, because its immutable struct
# function setfield(w::AbstractEltypeWrapper, name) 
#   name == :value &&
#    error("Setting the value of a AbstractEltypeWrapper is not allowed, " * "because it could change the eltype. Construct a new wrapper.")
#   Core.setfield(w, name)
# end


struct LengthWrapper{N,E,T} <: AbstractLengthWrapper
    value::Any
end
unwrap(w::LengthWrapper) = w.value
wrapped_type(w::LengthWrapper{N,E,T}) where {N,E,T} = T
Base.eltype(w::LengthWrapper{N,E,T}) where {N,E,T} = E

Base.length(w::LengthWrapper{N,E,T}) where {N,E,T} = N
