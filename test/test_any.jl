using UnionWrappers
using Test, SafeTestsets

@testset "any: Int" begin
    a = 2
    tw = wrap_union(a)
    @test unwrap(tw) == a
    @test wrapped_union(tw) == Any
end

