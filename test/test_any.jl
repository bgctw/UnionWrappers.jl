using UnionWrappers
using Test, SafeTestsets

@testset "any: Int" begin
    a = 2
    tw = UnionWrapper(a)
    @test unwrap(tw) == a
end

