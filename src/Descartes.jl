module Descartes

#using Meshes

include("primitives.jl")
include("csg.jl")
include("frep.jl")

# primitives
export Cuboid, Cylinder, Sphere

# CSG
export CSGUnion, CSGDiff, CSGIntersect

# frep
export FRep

end # module
