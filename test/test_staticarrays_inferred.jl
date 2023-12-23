using UnionWrappers
using Test
using StaticArrays

@testset "StaticArrays" begin
  f_gen_static(w::AbstractLengthWrapper{N,E}) where {N,E} = SVector{N,E}(unwrap(w)...)::SVector{N,E}
  res = @inferred f_gen_static(wrap((a=1,b=2)))
  @test res isa SVector
end;