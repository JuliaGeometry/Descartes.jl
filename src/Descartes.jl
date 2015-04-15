module Descartes

using Meshes
using HyperRectangles

include("primitives.jl")
include("transforms.jl")
include("csg.jl")
include("frep.jl")
include("hyperrectangles.jl")
include("meshes.jl")

# primitives
export Cuboid, Cylinder, Sphere

# transforms
export Translation, translate

# CSG
export CSGUnion, CSGDiff, CSGIntersect

# frep
export FRep

end # module
