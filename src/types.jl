"""
    AbstractUnionWrapper{T}

Basic Wrapper that stores a single type parameter to distinguish different
wrapped types for dispatch. 
The default `wrap_union` creates a wrapper for uniontype `Any`.
The abbreviation alias `UWrap{T}` can shorten function signatures.
"""    
abstract type AbstractUnionWrapper{T} end
UWrap{T} = AbstractUnionWrapper{T}


"""
    AbstractEltypeWrapper{E,T} <: AbstractUnionWrapper{T}

Wrapper that stores an additional element type as a type parameter.
The element type can be queried using `eltype(w)`.
There are implementations of `wrap_eltype` for `NTuple` and `NamedTuple`
The abbreviation alias `EWrap{T}` can shorten function signatures.
"""    
abstract type AbstractEltypeWrapper{E,T} <: AbstractUnionWrapper{T} end,
function wrap_eltype end

Base.eltype(w::AbstractEltypeWrapper{E,T}) where {T,E} = E

EWrap{E,T} = AbstractEltypeWrapper{E,T}

"""
    AbstractSizeWrapper{D,E,T} <: AbstractEltypeWrapper{E,T}

Wrapper that stores an additional sizes of dimensions as a type parameter.
The size can be queried by `size(w)` and the number of elements can be queried using `length(w)`.
There are implementations of `wrap_size` for ComponentArray.
"""    
abstract type AbstractSizeWrapper{D,E,T} <: AbstractEltypeWrapper{E,T} end,
function wrap_size end
Base.length(w::AbstractSizeWrapper{D,E,T}) where {D,E,T} = prod(D)
Base.size(w::AbstractSizeWrapper{D,E,T}) where {D,E,T} = D


struct UnionWrapper{T} <: AbstractUnionWrapper{T}
    value::T
end

"""
    wrap_union(x)

Wraps into a AbstractUnionWrapper type to avoid compilation for types with
much information in type parameters.

Specific methods create different Wrappers with a small amount of  information on the type
and its properties preserved in type parameters.

The default produces as `UnionWrapper{Val{:Any}()}`.

See `unwrap(w)` and `wrapped_union(w)` to extract the original value or the 
uniontype of the wrapped object.
"""
function wrap_union end,
function unwrap(w::UnionWrapper) 
    w.value
end,
function wrapped_union(w::AbstractUnionWrapper{T}) where {T} 
    T
end


struct EltypeWrapper{E,T} <: AbstractEltypeWrapper{E,T}
    value::T
end
unwrap(w::EltypeWrapper) = w.value


# already covered, because its immutable struct
# function setfield(w::AbstractEltypeWrapper, name) 
#   name == :value &&
#    error("Setting the value of a AbstractEltypeWrapper is not allowed, " * "because it could change the eltype. Construct a new wrapper.")
#   Core.setfield(w, name)
# end


struct SizeWrapper{D,E,T} <: AbstractSizeWrapper{D,E,T}
    value::T
end
unwrap(w::SizeWrapper) = w.value


