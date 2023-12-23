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
function f_higher(info)
  # main functionality and dispatch independent of info
  sum(unwrap(info))  # need to unwrap to actually use it
end

f_higher(UnionWrapper((a=1, b=2)))
f_higher(UnionWrapper((a=1, c=2)))
f_higher(UnionWrapper((a=1, d=2)))
methods(f_higher)           # only one method compiled
```

# Storing information about eltype and vector length

Two of the most used type parameters of collections are
- the element type
- the length 

UnionTypes provides overloads for NTuple, NamedTuple, and more types with
extensions to store this information in the wrapper to allow 
dispatching and constructing properly typed derived results.

TODO examples






