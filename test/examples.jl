@testset "examples" begin
    dir = "../examples"
    files = [ #"csg.jl",
             "example001.jl",
             "piping.jl",
             "radiused_union.jl",
             "fea.jl",
             "2d.jl"]
    for file in files
        @testset "$file" begin
                include("$dir/$file")
        end
    end
end
