module Descartes

import Base: *
import GeometryTypes: HyperRectangle,
                      HomogenousMesh,
                      SignedDistanceField

using GeometryTypes,
      FileIO,
      FixedSizeArrays,
      JLD,
      Meshing,
      MeshIO

include("types.jl")
include("constructors.jl")
include("operations.jl")
include("frep.jl")
include("hyperrectangles.jl")
include("distancefield.jl")
include("meshes.jl")
include("hashing.jl")
include("cache.jl")

# GeometryTypes
export Point

# primitives
export Cuboid, Cylinder, Sphere, PrismaticCylinder, Piping, RoundedCuboid

# transforms
export Translation, translate, rotate

# operations
export Shell

# CSG
export CSGUnion, RadiusedCSGUnion, CSGDiff, CSGIntersect

# frep
export FRep

# mesh
export HomogenousMesh

# FileIO
export load, save


# Init
function __init__()
    cache_init()
end

end # module
