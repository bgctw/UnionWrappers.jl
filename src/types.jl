abstract type AbstractUnionWrapper{T} end
abstract type AbstractEltypeWrapper{E,T} <: AbstractUnionWrapper{T} end
abstract type AbstractLengthWrapper{N,E,T} <: AbstractEltypeWrapper{E,T} end

struct UnionWrapper{T} <: AbstractUnionWrapper{T}
    value::Any
end
unwrap(w::UnionWrapper) = w.value
wrapped_type(w::AbstractUnionWrapper{T}) where {T} = T


struct EltypeWrapper{E,T} <: AbstractEltypeWrapper{E,T}
    value::Any
end
unwrap(w::EltypeWrapper) = w.value

Base.eltype(w::AbstractEltypeWrapper{E,T}) where {T,E} = E

# already covered, because its immutable struct
# function setfield(w::AbstractEltypeWrapper, name) 
#   name == :value &&
#    error("Setting the value of a AbstractEltypeWrapper is not allowed, " * "because it could change the eltype. Construct a new wrapper.")
#   Core.setfield(w, name)
# end


struct LengthWrapper{N,E,T} <: AbstractLengthWrapper{N,E,T}
    value::Any
end
unwrap(w::LengthWrapper) = w.value

Base.length(w::AbstractLengthWrapper{N,E,T}) where {N,E,T} = N
