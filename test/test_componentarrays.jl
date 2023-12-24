using UnionWrappers
using Test, SafeTestsets
using ComponentArrays

@testset "ComponentVector" begin
    cv = ComponentVector(a = 1.0, b = [2.1, 2.2])
    length(cv)
    cvw = @inferred wrap_size(cv)
    @test length(cvw) == length(cv)
    @test eltype(cvw) == eltype(cv)
    @test wrapped_union(cvw) == ComponentArray
    @test unwrap(cvw) == cv
end
