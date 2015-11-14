module Descartes

import Base: *
import GeometryTypes: HyperRectangle,
                      HomogenousMesh,
                      SignedDistanceField

using GeometryTypes,
      FileIO,
      FixedSizeArrays,
      Meshing,
      MeshIO

include("types.jl")
include("constructors.jl")
include("operations.jl")
include("frep.jl")
include("hyperrectangles.jl")
include("distancefield.jl")
include("meshes.jl")

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

end # module
