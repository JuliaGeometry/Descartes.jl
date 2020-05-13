module Descartes

import Base: *, union, diff, intersect
import GeometryBasics: HyperRectangle,
                       Mesh

using GeometryBasics,
      FileIO,
      StaticArrays,
      Meshing,
      MeshIO,
      LinearAlgebra

include("types.jl")
include("constructors.jl")
include("operations.jl")
include("frep.jl")
include("hyperrectangles.jl")
include("meshes.jl")
#include("hashing.jl")
include("cache.jl")
include("visualize.jl")

# GeometryTypes
export Point

# 3d primitives
export Cuboid, Cylinder, Sphere, Piping

# 2d primitives

export Square, Circle

# transforms
export Transform, Translation, translate, rotate

# operations
export Shell, LinearExtrude

# CSG
export CSGUnion, RadiusedCSGUnion, CSGDiff, CSGIntersect

# frep
export FRep

# FileIO
export load, save


end # module
