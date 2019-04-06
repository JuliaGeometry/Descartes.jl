using Descartes,
      StaticArrays,
      Test
import GeometryTypes

@testset "Descartes Core" begin
      include("opencl.jl")
      include("primitives.jl")
      include("hyperrectangles.jl")
      include("distancefield.jl")
      include("meshes.jl")
end
