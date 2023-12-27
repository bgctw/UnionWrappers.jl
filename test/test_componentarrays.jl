using UnionWrappers
using Test, SafeTestsets
using ComponentArrays

@testset "ComponentVector" begin
    cv = ComponentVector(a = 1.0, b = [2.1, 2.2])
    length(cv)
    cvw = @inferred wrap_size(cv)
    @test length(cvw) == length(cv)
    @test size(cvw) == size(cv)
    @test eltype(cvw) == eltype(cv)
    @test wrapped_union(cvw) == ComponentArray
    @test unwrap(cvw) == cv
    #
    # test shorthand constructor
    cvw1 = SizeWrapper{eltype(cv),ComponentArray}(cv) # size not inferred
    @test cvw1 == cvw
end;

@testset "error on non-matching dimensions" begin
    cv = ComponentVector(a = 1.0, b = [2.1, 2.2])
    @test_throws ErrorException SizeWrapper{7,(length(cv),),eltype(cv),ComponentArray}(cv)
end
