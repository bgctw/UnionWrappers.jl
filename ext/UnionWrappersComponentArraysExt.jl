module UnionWrappersComponentArraysExt

function __init__()
    @info "UnionWrappers: loading UnionWrappersComponentArraysExt"
end

isdefined(Base, :get_extension) ? (using ComponentArrays) : (using ..ComponentArrays)
import UnionWrappers as CP
using UnionWrappers

# move to ComponentArrays?
axis_length(ax::AbstractAxis) = lastindex(ax) - firstindex(ax) + 1
axis_length(::FlatAxis) = 0

CP.wrap(cv::ComponentArray) = ComponentArrayWrapper{eltype(cv)}(cv)

function CP.wrap(cv::ComponentVector)
    length_cv = axis_length(first(getaxes(cv))) # type-stable length
    ComponentVectorWrapper{length_cv,eltype(cv)}(cv)
end

end
