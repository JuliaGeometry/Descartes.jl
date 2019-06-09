using Descartes,
      StaticArrays,
      Test,
      Combinatorics
import GeometryTypes

primitives_array = [Sphere(1), Cuboid([1,2,3]), Cylinder(3,4)]
operations_array = [CSGUnion, CSGIntersect, CSGDiff]

include("tranforms.jl")
include("operations.jl")
include("opencl.jl")
include("primitives.jl")
include("2d.jl")
include("hyperrectangles.jl")
include("distancefield.jl")
include("meshes.jl")
include("examples.jl")
