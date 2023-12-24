using UnionWrappers
using Test
using ComponentArrays
using StaticArrays

@testset "StaticArrays" begin
  f_gen_static(w::AbstractSizeWrapper{N,E}) where {N,E} = SVector{N,E}(unwrap(w)...)::SVector{N,E}
  w = wrap_size(ComponentVector(a=1,b=2))
  res = @inferred f_gen_static(w)
  @test res isa SVector
end;