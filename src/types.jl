"""
    AbstractUnionWrapper{U}

Basic Wrapper that stores a single type parameter to distinguish different
wrapped types for dispatch. 
The default `wrap_union` creates a wrapper for uniontype `Any`.
The abbreviation alias `UWrap{U}` can shorten function signatures.
"""    
abstract type AbstractUnionWrapper{U} end
UWrap{U} = AbstractUnionWrapper{U}


"""
    AbstractEltypeWrapper{E,U} <: AbstractUnionWrapper{U}

Wrapper that stores an additional element type as a type parameter.
The element type can be queried using `eltype(w)`.
There are implementations of `wrap_eltype` for `NTuple` and `NamedTuple`
The abbreviation alias `EWrap{U}` can shorten function signatures.
"""    
abstract type AbstractEltypeWrapper{E,U} <: AbstractUnionWrapper{U} end,
function wrap_eltype end

Base.eltype(w::AbstractEltypeWrapper{E,U}) where {U,E} = E

EWrap{E,U} = AbstractEltypeWrapper{E,U}

"""
    AbstractSizeWrapper{ND,D,E,U} <: AbstractEltypeWrapper{E,U}

Wrapper that stores an additional number of dimensions, `ND == length(D)`, 
and sizes of dimensions, `D`, as type parameters.
The size can be queried by `size(w)` and the number of elements `= prod(D)` can be queried 
using `length(w)`.
Although `ND` is redundant to `D`, it is stored to allow dispatch on number of dimensions.
There are implementations of `wrap_size` for ComponentArray.
"""    
abstract type AbstractSizeWrapper{ND,D,E,U} <: AbstractEltypeWrapper{E,U} end,
function wrap_size end
Base.length(w::AbstractSizeWrapper{ND,D,E,U}) where {ND,D,E,U} = prod(D)
Base.size(w::AbstractSizeWrapper{ND,D,E,U}) where {ND,D,E,U} = D


struct UnionWrapper{U} <: AbstractUnionWrapper{U}
    value::U
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
function wrapped_union(w::AbstractUnionWrapper{U}) where {U} 
    U
end


struct EltypeWrapper{E,U} <: AbstractEltypeWrapper{E,U}
    value::U
end
unwrap(w::EltypeWrapper) = w.value


# already covered, because its immutable struct
# function setfield(w::AbstractEltypeWrapper, name) 
#   name == :value &&
#    error("Setting the value of a AbstractEltypeWrapper is not allowed, " * "because it could change the eltype. Construct a new wrapper.")
#   Core.setfield(w, name)
# end


struct SizeWrapper{ND,D,E,U} <: AbstractSizeWrapper{ND,D,E,U}
    value::U
end
SizeWrapper(D, E, U, v) = SizeWrapper{length(D),D,E,U}(v)
unwrap(w::SizeWrapper) = w.value


