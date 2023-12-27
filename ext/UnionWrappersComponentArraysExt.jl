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

CP.wrap_eltype(cv::ComponentArray) = CP.EltypeWrapper{eltype(cv),ComponentArray}(cv)

function CP.wrap_size(cv::ComponentArray)
    #CP.SizeWrapper{eltype(cv),ComponentArray}(cv) # does not infer size
    size_cv = axis_length.(getaxes(cv)) # type-stable length
    CP.SizeWrapper{length(size_cv),size_cv,eltype(cv),ComponentArray}(cv)
end

end
