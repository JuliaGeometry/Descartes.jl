using Descartes,
      GeometryTypes,
      StaticArrays,
      Test

@testset "Descartes Core" begin
      include("primitives.jl")
      include("hyperrectangles.jl")
      include("distancefield.jl")
      include("meshes.jl")
end
