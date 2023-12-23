using UnionWrappers
using Test
using Aqua

@testset "UnionWrappers.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(UnionWrappers)
    end
    # Write your tests here.
end
