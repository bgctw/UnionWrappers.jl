# UnionWrappers

[![Build Status](https://github.com/bgctw/UnionWrappers.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/bgctw/UnionWrappers.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/bgctw/UnionWrappers.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/bgctw/UnionWrappers.jl)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

Reduces compilation by wrapping type-parameter-rich components.
For help see the docstring of `wrap_union`.

# Problem

Julia recompiles functions for new argument types, and argument types change 
with type parameters. This results in compiling many method instances when using types
that store much information in their type parameters.

For example, when a function takes a `NamedTuple` argument, it will be recompiled
for each new value with different names.

This package avoids compilation by passing around arguments 
that are wrapped into types with fewer type information. 
Only when specific dispatch or runtime-performance is required at the lower-level
functions, pass the unwrapped argument can be passed.

# Example

```
using UnionWrappers
function f_higher(w)
  # main functionality and dispatch independent of w
  sum(unwrap(w))  # unwrap to actually use it in lower-level functions
end

f_higher(wrap_union((a=1, b=2)))
f_higher(wrap_union((a=1, c=2)))
f_higher(wrap_union((a=1, d=2)))

using MethodAnalysis            # to show compiled method instances
methodinstances(f_higher)       # only one method compiled

# Without wrapper:
foo(x) = sum(x)
foo((a=1, b=2))
foo((a=1, c=2))
foo((a=1, d=2))
methodinstances(foo)            # 3 new instances compiled
```

In the given simple example, its recommend to alternatively simply pass the unwrapped
argument as a named argument to avoid specializing on it. 
However, using named arguments is not always a viable solution.

Sometimes, some dispatch information is required on the wrapper type as in
cases below.

# Dispatching on wrapped type parameter

The `AbstractUnionWrapper` type, which has an alias `UWrap`,
has a type parameter that can be used
to dispatch on different wrapped types.

```
f_dispatch_type(w::UWrap{NTuple}) = "NTuple"
f_dispatch_type(w::UWrap{NamedTuple}) = "NamedTuple"
f_dispatch_type(w::UWrap) = "any other type"

f_dispatch_type(wrap_union((a=1, b=2)))
f_dispatch_type(wrap_union((1,2)))
f_dispatch_type(wrap_union("Hello"))
```

The user can extend the `wrap_union` method to define her own types to dispatch on.
```
# define user-define wrapper type
UnionWrappers.wrap_union(s::AbstractString) = UnionWrapper{AbstractString}(s)

f_dispatch_type(w::UWrap{AbstractString}) = "String"
f_dispatch_type(wrap_union("Hello"))   # now uses the String-method instead of Any
```

# Dispatching on element type of wrapped objects

When wrapping collections of the same element type, such as NTuple or
a NamedTuple of NTupel, the element type is stored with the wrapper
and can be used for dispatch.

The corresponding wrappers are constructed using `wrap_eltype`.

```
f_dispatch_eltype(w::EWrap{Int}) = "Int elements"
f_dispatch_eltype(w::EWrap{<:Number}) = "Number subtype elements"
f_dispatch_eltype(w::EWrap) = "Any other element type"

f_dispatch_eltype(wrap_eltype((1,2)))
f_dispatch_eltype(wrap_eltype((1.0,2.0)))
f_dispatch_eltype(wrap_eltype(("Hello",)))
f_dispatch_eltype(wrap_eltype((1,2.0))) # error because of mixed type
```

# Dispatching on Dimesnion of arrays

For simple ComponentArrays, the size of the array dimensions are known.
The number of dimensions and their sizes can be stored in the wrapper in addition 
to the element type using `wrap_size`.
Then, they can be used in dispatch.

```
f_dispatch_dim(w::AbstractSizeWrapper{1}) = "vector"
f_dispatch_dim(w::AbstractSizeWrapper) = "higher dimensions"

f_dispatch_length(w::AbstractSizeWrapper{1,(0,)}) = "empty vector"
f_dispatch_length(w::AbstractSizeWrapper{1}) = "nonempty vector"

using ComponentArrays
f_dispatch_dim(wrap_size(ComponentVector(a=1.0,b=2.0))) == "vector"
f_dispatch_length(wrap_size(ComponentVector())) == "emtpy vector"
f_dispatch_length(wrap_size(ComponentVector(a=1.0,))) == "nonempty vector"
```

# Using Length information for stack allocation

The size can also be used create StaticVectors in a stable type-inferred manner.

```
using StaticArrays, Test
using ComponentArrays
function f_gen_svector(w::AbstractSizeWrapper{1,D,E}) where {D,E} 
  N = first(D)
  SVector{N,E}(unwrap(w)...)::SVector{N,E}
end
w = wrap_size(ComponentVector(a=1,b=2))
@inferred f_gen_svector(w)
```
