using UnionWrappers
using Test

@testset "dispatch type" begin
  f_dispatch_type(w::NTupleWrapper) = "NTuple"
  f_dispatch_type(w::NamedTupleWrapper) = "NamedTuple"
  f_dispatch_type(w::AbstractUnionWrapper) = "any other type"

  @test f_dispatch_type(wrap((a=1, b=2))) == "NamedTuple"
  @test f_dispatch_type(wrap((1,2))) == "NTuple"
  @test f_dispatch_type(wrap("Hello")) == "any other type"
end;

@testset "dispatch eltype" begin
  f_dispatch_eltype(w::AbstractEltypeWrapper{Int}) = "Int"
  f_dispatch_eltype(w::AbstractEltypeWrapper{<:AbstractFloat}) = "Float"
  
  @test f_dispatch_eltype(wrap((1,2))) == "Int"
  @test f_dispatch_eltype(wrap((1.0,2.0))) == "Float"
  @test_throws MethodError f_dispatch_eltype(wrap((1,2.0))) # not an NTuple but of mixed type -> Any
end;

@testset "dispatch length" begin
  f_dispatch_length(w::AbstractLengthWrapper{2}) = "two items"
  f_dispatch_length(w::AbstractLengthWrapper{0}) = "zero items"
  
  @test f_dispatch_length(wrap((1.0,2.0))) == "two items"
  @test f_dispatch_length(wrap(())) == "zero items"
end;

