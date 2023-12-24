using UnionWrappers
using Test
using ComponentArrays
using StaticArrays

@testset "StaticArrays" begin
  function f_gen_static(w::AbstractSizeWrapper{D,E}) where {D,E} 
    S = Tuple{D...}; L = prod(D); N = length(D)
    SArray{S,E,N,L}(unwrap(w)...)::SArray{S,E,N,L}
  end
  w = wrap_size(ComponentVector(a=1,b=2))
  res = @inferred f_gen_static(w)
  @test res isa SVector
end;
