using UnionWrappers
using Test, SafeTestsets
using ComponentArrays

@testset "ComponentVector" begin
    cv = ComponentVector(a = 1.0, b = [2.1, 2.2])
    length(cv)
    cvw = @inferred UnionWrapper(cv)
    @test length(cvw) == length(cv)
    @test eltype(cvw) == eltype(cv)
    @test unwrap(cvw) == cv
end
