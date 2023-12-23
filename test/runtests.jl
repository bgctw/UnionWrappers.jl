tmpf = () -> begin
    push!(LOAD_PATH, expanduser("~/julia/devtools/")) # access local pack
    push!(LOAD_PATH, joinpath(pwd(), "test/")) # access local pack
end


using Test, SafeTestsets
const GROUP = get(ENV, "GROUP", "All") # defined in in CI.yml
@show GROUP

@time begin
    if GROUP == "All" || GROUP == "Basic"
        #@safetestset "Tests" include("test/test_any.jl")
        @time @safetestset "test_any" include("test_any.jl")
        #@safetestset "Tests" include("test/test_tuples.jl")
        @time @safetestset "test_tuples" include("test_tuples.jl")
        #@safetestset "Tests" include("test/test_componentarrays.jl")
        @time @safetestset "test_componentarrays" include("test_componentarrays.jl")
        #@safetestset "Tests" include("test/test_dispatch.jl")
        @time @safetestset "test_dispatch" include("test_dispatch.jl")
        #@safetestset "Tests" include("test/test_staticarrays_inferred.jl")
        @time @safetestset "test_staticarrays_inferred" include("test_staticarrays_inferred.jl")
    end
    if GROUP == "All" || GROUP == "JET"
        #@safetestset "Tests" include("test/test_JET.jl")
        @time @safetestset "test_JET" include("test_JET.jl")
        #@safetestset "Tests" include("test/test_aqua.jl")
        @time @safetestset "test_Aqua" include("test_aqua.jl")
    end
end
