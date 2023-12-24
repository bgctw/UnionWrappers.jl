# UnionWrappers

[![Build Status](https://github.com/bgctw/UnionWrappers.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/bgctw/UnionWrappers.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/bgctw/UnionWrappers.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/bgctw/UnionWrappers.jl)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

Reduces compilation by wrapping type-parameter-rich components.
For help see the docstring of `wrap_union`.

# Problem

Julia recompiles functions for new argument types, and argument types change 
with type parameters. This results in compiling many method instances when using types
that store much informationin in their type parameters.

For example, when a function takes a `NamedTuple` argument, it will be recompiled
for each new value with different names.

This package aovids compilation by at higher-level functions by passing around arguments that are wrapped into types with fewer type information. 
Only when specific dispatch or runtime-performa is required at the lower-level
functions, pass the unwrapped argument can be passed.

# Example

```
using MethodAnalysis # to show compiled method instances

using UnionWrappers
function f_higher(w)
  # main functionality and dispatch independent of w
  sum(unwrap(w))  # unwrap to actually use it in lower-level functions
end

f_higher(wrap_union((a=1, b=2)))
f_higher(wrap_union((a=1, c=2)))
f_higher(wrap_union((a=1, d=2)))
methodinstances(f_higher)           # only one method compiled

# Without wrapper:
foo(x) = sum(x)
foo((a=1, b=2))
foo((a=1, c=2))
foo((a=1, d=2))
methodinstances(foo)           # 3 new instances compiled
```

In the given simple example, its recommend to alternatively pass the unwrapped
w by using named arguments to avoid specializing on it. 
However, using named arguments is not always a viable solution.

Sometimes, some dispatch information is required on the wrapper type as in
cases below.

# Dispatching on wrapped type parameter

The AbstractUnionWrapper type has a type parameter that can be used
to dispatch on different wrapped types.
There are several aliases: (`AnyWrapper`, `NTupleWrapper`, `NamedTupleWrapper`, ...)
to help with dispatch.

```
f_dispatch_type(w::AbstractUnionWrapper{NTuple}) = "NTuple"
f_dispatch_type(w::AbstractUnionWrapper{NamedTuple}) = "NamedTuple"
f_dispatch_type(w::AbstractUnionWrapper) = "any other type"

f_dispatch_type(wrap_union((a=1, b=2)))
f_dispatch_type(wrap_union((1,2)))
f_dispatch_type(wrap_union("Hello"))
```

The user can define own wrapper-type aliases to dispatch on, and then 
extend the wrap_union method.
```
# define user-define wrapper type
UnionWrappers.wrap_union(s::AbstractString) = UnionWrapper{AbstractString}(s)

f_dispatch_type(w::AbstractUnionWrapper{AbstractString}) = "String"
f_dispatch_type(wrap_union("Hello"))
```

# Dispatching on element type of wrapped objects

When wrapping collections of the same element type, such as NTuple or
a NamedTuple of NTupe, the element type is stored with the wrapper
and can be used for dispatch.

```
f_dispatch_eltype(w::AbstractEltypeWrapper{Float64}) = "Float"
f_dispatch_eltype(w::AbstractEltypeWrapper{Int}) = "Int"
f_dispatch_eltype(w::AbstractUnionWrapper) = "Any other type"

f_dispatch_eltype(wrap_eltype((1,2)))
f_dispatch_eltype(wrap_eltype((1.0,2.0)))
f_dispatch_eltype(wrap_eltype((1,2.0))) # error because of mixed type -> Any
f_dispatch_eltype(wrap_union((1,2.0))) # without storingn eltype
```

# Using Length information

For NTuples and plain ComponentVectors, the length of the object is known
and can be used to dispatch

```
f_dispatch_length(w::AbstractSizeWrapper{2}) = "two items"
f_dispatch_length(w::AbstractSizeWrapper{0}) = "zero items"

using ComponentArrays
f_dispatch_length(wrap_size(ComponentVector(a=1.0,b=2.0)))
f_dispatch_length(wrap_size(ComponentVector()))
```

Or it can be used to create StaticVectors in a type-inferred manner.

```
using StaticArrays, Test
using ComponentArrays
f_gen_static(w::AbstractSizeWrapper{N,E}) where {N,E} = SVector{N,E}(unwrap(w)...)::SVector{N,E}
@inferred f_gen_static(wrap_size(ComponentVector(a=1,b=2)))
```







