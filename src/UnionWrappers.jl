module UnionWrappers

export AbstractUnionWrapper, AbstractEltypeWrapper, AbstractSizeWrapper
export UnionWrapper, EltypeWrapper, SizeWrapper # to allow user define own wrappers
export wrap_union, wrap_eltype, wrap_size, unwrap, wrapped_union
include("types.jl")

#export AnyWrapper
include("any.jl")

#export NTupleWrapper, NamedTupleWrapper
include("tuples.jl")

#export ComponentArrayWrapper, ComponentVectorWrapper
include("componentarrays.jl")

if !isdefined(Base, :get_extension)
    using Requires
end

@static if !isdefined(Base, :get_extension)
    function __init__()
        @require ComponentArrays = "b0b7db55-cfe3-40fc-9ded-d10e2dbeff66" begin
            include("../ext/UnionWrappersComponentArraysExt.jl")
        end
    end
end


end
