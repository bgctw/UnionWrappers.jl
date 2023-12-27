using UnionWrappers
using Test
using ComponentArrays

@testset "dispatch type" begin
  f_dispatch_type(w::UWrap{NTuple}) = "NTuple"
  f_dispatch_type(w::UWrap{NamedTuple}) = "NamedTuple"
  f_dispatch_type(w::UWrap) = "any other type"

  @test f_dispatch_type(wrap_union((a=1, b=2))) == "NamedTuple"
  @test f_dispatch_type(wrap_union((1,2))) == "NTuple"
  @test f_dispatch_type(wrap_union("Hello")) == "any other type"
end;

@testset "dispatch eltype" begin
  f_dispatch_eltype(w::EWrap{Int}) = "Int"
  f_dispatch_eltype(w::EWrap{<:AbstractFloat}) = "Float"
  
  @test f_dispatch_eltype(wrap_eltype((1,2))) == "Int"
  @test f_dispatch_eltype(wrap_eltype((1.0,2.0))) == "Float"
  @test_throws MethodError f_dispatch_eltype(wrap_union((1,2.0))) # not an NTuple but of mixed type -> Any
end;

@testset "dispatch dim" begin
  f_dispatch_dim(w::AbstractSizeWrapper{1}) = "vector"
  f_dispatch_dim(w::AbstractSizeWrapper) = "higher dimensions"
  
  @test f_dispatch_dim(wrap_size(ComponentVector(a=1.0,b=2.0))) == "vector"
end;


@testset "dispatch length" begin
  f_dispatch_length(w::AbstractSizeWrapper{1,(0,)}) = "zero items"
  f_dispatch_length(w::AbstractSizeWrapper{1}) = "nonempty vector"

  @test f_dispatch_length(wrap_size(ComponentVector(a=1.0,))) == "nonempty vector"
  @test f_dispatch_length(wrap_size(ComponentVector())) == "zero items"
end;

