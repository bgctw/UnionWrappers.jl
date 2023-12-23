"""
    AbstractUnionWrapper{T}

Basic Wrapper that stores a single type parameter to distinguish different
wrapped types for dispatch.
For instance, see `AnyWrapper`.
"""    
abstract type AbstractUnionWrapper{T} end


"""
    AbstractEltypeWrapper{E,T} <: AbstractUnionWrapper{T}

Wrapper that stores an additional element type as a type parameter.
The element type can be queried using `eltype(w)`.
For instance, see `ComponentArrayWrapper`.
"""    
abstract type AbstractEltypeWrapper{E,T} <: AbstractUnionWrapper{T} end
Base.eltype(w::AbstractEltypeWrapper{E,T}) where {T,E} = E


"""
    AbstractLengthWrapper{N,E,T} <: AbstractEltypeWrapper{E,T}

Wrapper that stores an additional number of elements as a type parameter.
The number of elements can be queried using `length(w)`.
For instance, see `NTupleWrapper`.
"""    
abstract type AbstractLengthWrapper{N,E,T} <: AbstractEltypeWrapper{E,T} end
Base.length(w::AbstractLengthWrapper{N,E,T}) where {N,E,T} = N


struct UnionWrapper{T} <: AbstractUnionWrapper{T}
    value::Any
end

"""
    wrap(x)

Wraps into a AbstractUnionWrapper type to aovid compilation for types with
much information in type parameters.

Specific methods create different Wrappers with a small amount of  information on the type
and its properties preserved in type parameters.

The default produces as `UnionWrapper{Val{:Any}()}`.

See `unwrap(w)` and `wrapped_type(w)` to extract the original value or its type.
"""
function wrap end,
function unwrap(w::UnionWrapper) 
    w.value
end,
function wrapped_type(w::AbstractUnionWrapper{T}) where {T} 
    T
end


struct EltypeWrapper{E,T} <: AbstractEltypeWrapper{E,T}
    value::Any
end
unwrap(w::EltypeWrapper) = w.value


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


