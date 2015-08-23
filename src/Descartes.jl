module Descartes

import Base: *

using Meshes
using GeometryTypes
using GeometryTypes.HyperRectangles
using GeometryTypes.HyperRectangles.Operations # lol

include("primitives.jl")
include("transforms.jl")
include("operations.jl")
include("csg.jl")
include("frep.jl")
include("hyperrectangles.jl")
include("distancefield.jl")
include("meshes.jl")

# primitives
export Cuboid, Cylinder, Sphere, PrismaticCylinder, Pipe, RoundedCuboid

# transforms
export Translation, translate, rotate

# operations
export Shell

# CSG
export CSGUnion, RadiusedCSGUnion, CSGDiff, CSGIntersect

# frep
export FRep

# distance fields
export DistanceField

end # module
