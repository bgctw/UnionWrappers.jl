using UnionWrappers
using Test
using ComponentArrays
using StaticArrays

@testset "StaticVector" begin
    function f_gen_svector(w::AbstractSizeWrapper{1,D,E}) where {D,E}
        N = first(D)
        SVector{N,E}(unwrap(w)...)::SVector{N,E}
    end
    w = wrap_size(ComponentVector(a = 1, b = 2))
    res = @inferred f_gen_svector(w)
    @test res isa SVector
end;

@testset "StaticArrays" begin
    function f_gen_static(w::AbstractSizeWrapper{ND,D,E}) where {ND,D,E}
        S = Tuple{D...}
        L = prod(D)
        N = ND
        SArray{S,E,N,L}(unwrap(w)...)::SArray{S,E,N,L}
    end
    w = wrap_size(ComponentVector(a = 1, b = 2))
    res = @inferred f_gen_static(w)
    @test res isa SVector
end;
