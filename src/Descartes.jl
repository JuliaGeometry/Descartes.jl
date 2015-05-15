module Descartes

using Meshes
using HyperRectangles
using HyperRectangles.Operations

include("primitives.jl")
include("transforms.jl")
include("operations.jl")
include("csg.jl")
include("frep.jl")
include("hyperrectangles.jl")
include("meshes.jl")

# primitives
export Cuboid, Cylinder, Sphere, PrismaticCylinder

# transforms
export Translation, translate, rotate

# operations
export Shell

# CSG
export CSGUnion, RadiusedCSGUnion, CSGDiff, CSGIntersect

# frep
export FRep

end # module
