using UnionWrappers
using Test, SafeTestsets

@testset "ntuple" begin
    t = (:a, :b)
    t isa NTuple{2,Symbol}
    ta = wrap_union(t)
    @test wrapped_union(ta) == NTuple
    tw = wrap_eltype(t)
    #@test length(tw) == 2
    @test eltype(tw) == Symbol
    @test unwrap(tw) == t
    @test wrapped_union(tw) == NTuple
    # changing the wrapped object is not allowed
    @test_throws ErrorException tw.value = (:c,) 
    # type T and wrapped object must match
    @test_throws MethodError UnionWrapper{NamedTuple}(t)
end

@testset "mixed tuple" begin
    @test_throws MethodError EltypeWrapper((:a, 2))
end;

@testset "one-length tuple" begin
    tw = wrap_eltype((:a,))
    @test eltype(tw) == Symbol
end

@testset "zero-length tuple" begin
    t = ()
    t isa NTuple
    eltype(t)
    tw = wrap_eltype(())
    @test eltype(tw) == eltype(t)
end

@testset "NamedTuple" begin
    t = (a = :a, b = :b)
    t isa NamedTuple
    tw = wrap_eltype(t)
    @test eltype(tw) == Symbol
    @test wrapped_union(tw) == NamedTuple
end

@testset "mixed NamedTuple" begin
    @test_throws MethodError EltypeWrapper((a = :a, b = 2))
end;

@testset "one-length NamedTuple" begin
    tw = wrap_eltype((a = :a,))
    @test eltype(tw) == Symbol
end

@testset "zero-length tuple" begin
    t = NamedTuple{()}(())
    t isa NamedTuple
    eltype(t)
    tw = wrap_eltype(t)
    @test eltype(tw) == eltype(t)
end
