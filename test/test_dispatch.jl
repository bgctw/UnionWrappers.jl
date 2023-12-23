using UnionWrappers
using Test

@testset "dispatch type" begin
  f_dispatch_type(w::NTupleWrapper) = "NTuple"
  f_dispatch_type(w::NamedTupleWrapper) = "NamedTuple"
  f_dispatch_type(w::AbstractUnionWrapper) = "any other type"

  @test f_dispatch_type(UnionWrapper((a=1, b=2))) == "NamedTuple"
  @test f_dispatch_type(UnionWrapper((1,2))) == "NTuple"
  @test f_dispatch_type(UnionWrapper("Hello")) == "any other type"
end;

@testset "dispatch eltype" begin
  f_dispatch_eltype(w::AbstractEltypeWrapper{Int}) = "Int"
  f_dispatch_eltype(w::AbstractEltypeWrapper{<:AbstractFloat}) = "Float"
  
  @test f_dispatch_eltype(UnionWrapper((1,2))) == "Int"
  @test f_dispatch_eltype(UnionWrapper((1.0,2.0))) == "Float"
  @test_throws MethodError f_dispatch_eltype(UnionWrapper((1,2.0))) # not an NTuple but of mixed type -> Any
end;

@testset "dispatch length" begin
  f_dispatch_length(w::AbstractLengthWrapper{2}) = "two items"
  f_dispatch_length(w::AbstractLengthWrapper{0}) = "zero items"
  
  @test f_dispatch_length(UnionWrapper((1.0,2.0))) == "two items"
  @test f_dispatch_length(UnionWrapper(())) == "zero items"
end;

