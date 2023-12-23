# UnionWrappers

[![Build Status](https://github.com/bgctw/UnionWrappers.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/bgctw/UnionWrappers.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/bgctw/UnionWrappers.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/bgctw/UnionWrappers.jl)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

Reduces recompilation by wrapping type-parameter rich components.

# Problem

Julia recompiles functions for new types of inputs and input types change 
with type parameters. This leads to many recompilations, when using Types
that store much informationin their type parameters.

E.g. When a function takes a NamedTuple argument, it will be recompiled
for each new value with different names.

This package allows to pass arguments around at higher-level functions by wrapping
them into types with fewer type information. 
Only when specific dispatch or runtime-performa is required at the lower-level
functions, pass the unwrapped argument to the respective function.

# Example

```
using UnionWrappers
function f_higher(w)
  # main functionality and dispatch independent of w
  sum(unwrap(w))  # need to unwrap to actually use it
end

f_higher(UnionWrapper((a=1, b=2)))
f_higher(UnionWrapper((a=1, c=2)))
f_higher(UnionWrapper((a=1, d=2)))
methods(f_higher)           # only one method compiled
```

In the given simple example, its recommend to alternatively pass the unwrapped
w by using named arguments to avoid specializing on it. 
However, using named arguments is not always a viable solution.

Moreover, some information is required on dispatch sometimes as in the
cases below.

# Dispatching on wrapped type

The AbstractUnionWrapper type has a type parameter that can be used
to dispatch on different wrapped types.
There are several aliases: (`AnyWrapper`, `NTupleWrapper`, `NamedTupleWrapper`, ...)
to help with dispatch.

```
f_dispatch_type(w::NTupleWrapper) = "NTuple"
f_dispatch_type(w::NamedTupleWrapper) = "NamedTuple"
f_dispatch_type(w::AbstractUnionWrapper) = "any other type"

f_dispatch_type(UnionWrapper((a=1, b=2)))
f_dispatch_type(UnionWrapper((1,2)))
f_dispatch_type(UnionWrapper("Hello"))
```

The user can just define more of those aliases and repestice constructors.
An example can be found in `src/tuples.jl`.

# Dispatching on element type of wrapped objects

When wrapping collections of the same element type, such as NTuple or
a NamedTuple of NTupe, the element type is stored with the wrapper
and can be used for dispatch.

```
f_dispatch_eltype(w::AbstractEltypeWrapper{Float64}) = "Float"
f_dispatch_eltype(w::AbstractEltypeWrapper{Int}) = "Int"

f_dispatch_eltype(UnionWrapper((1,2)))
f_dispatch_eltype(UnionWrapper((1.0,2.0)))
f_dispatch_eltype(UnionWrapper((1,2.0))) # error because of mixed type -> Any
```

# Using Length information

For NTuples and plain ComponentVectors, the length of the object is known
and can be used to dispatch

```
f_dispatch_length(w::AbstractLengthWrapper{2}) = "two items"
f_dispatch_length(w::AbstractLengthWrapper{0}) = "zero items"

f_dispatch_length(UnionWrapper((1.0,2.0)))
f_dispatch_length(UnionWrapper(()))
```

Or it can be used to create StaticVectors.

```
using StaticArrays, Test
f_gen_static(w::AbstractLengthWrapper{N,E}) where {N,E} = SVector{N,E}(unwrap(w)...)::SVector{N,E}
@inferred f_gen_static(UnionWrapper((a=1,b=2)))
```







