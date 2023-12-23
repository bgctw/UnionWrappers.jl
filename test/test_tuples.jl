using UnionWrappers
using Test, SafeTestsets

@testset "ntuple" begin
    t = (:a, :b)
    t isa NTuple{2,Symbol}
    tw = UnionWrapper(t)
    @test length(tw) == 2
    @test eltype(tw) == Symbol
    @test unwrap(tw) == t
    @test_throws ErrorException tw.value = (:c,)
end

@testset "mixed tuple" begin
    @test_throws MethodError EltypeWrapper((:a, 2))
end;

@testset "one-length tuple" begin
    tw = UnionWrapper((:a,))
    @test length(tw) == 1
    @test eltype(tw) == Symbol
end

@testset "zero-length tuple" begin
    t = ()
    t isa NTuple
    eltype(t)
    tw = UnionWrapper(())
    @test length(tw) == 0
    @test eltype(tw) == eltype(t)
end

@testset "NamedTuple" begin
    t = (a = :a, b = :b)
    t isa NamedTuple
    tw = UnionWrapper(t)
    @test length(tw) == 2
    @test eltype(tw) == Symbol
end

@testset "mixed NamedTuple" begin
    @test_throws MethodError EltypeWrapper((a = :a, b = 2))
end;

@testset "one-length NamedTuple" begin
    tw = UnionWrapper((a = :a,))
    @test length(tw) == 1
    @test eltype(tw) == Symbol
end

@testset "zero-length tuple" begin
    t = NamedTuple{()}(())
    t isa NamedTuple
    eltype(t)
    tw = UnionWrapper(t)
    @test length(tw) == 0
    @test eltype(tw) == eltype(t)
end
