module Descartes

using Meshes
using HyperRectangles
using HyperRectangles.Operations

include("primitives.jl")
include("transforms.jl")
include("csg.jl")
include("frep.jl")
include("hyperrectangles.jl")
include("meshes.jl")

# primitives
export Cuboid, Cylinder, Sphere, PrismaticCylinder

# transforms
export Translation, translate

# CSG
export CSGUnion, RadiusedCSGUnion, CSGDiff, CSGIntersect

# frep
export FRep

end # module
