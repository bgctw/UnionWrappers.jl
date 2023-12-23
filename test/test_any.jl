using UnionWrappers
using Test, SafeTestsets

@testset "any: Int" begin
    a = 2
    tw = wrap(a)
    @test unwrap(tw) == a
    @test wrapped_T(tw) == Val(:Any)
end

