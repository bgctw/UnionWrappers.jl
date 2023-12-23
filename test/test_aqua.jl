using UnionWrappers
using Test
using Aqua

@testset "UnionWrappers.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(
            UnionWrappers;
            unbound_args = false, # does not recognize NamedTuple{K, NTuple{N,E}}
            stale_deps=(ignore=[:Requires],),
        )
    end
end
