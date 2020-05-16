module Descartes

import Base: *, union, diff, intersect
import GeometryBasics: AbstractMesh,
                       HyperRectangle,
                       Vec,
                       Mesh

using FileIO,
      StaticArrays,
      Meshing,
      MeshIO,
      LinearAlgebra,
      CoordinateTransformations,
      Rotations

include("types.jl")
include("constructors.jl")
include("operations.jl")
include("frep.jl")
include("hyperrectangles.jl")
include("meshes.jl")

# 3d primitives
export Cuboid, Cylinder, Sphere, Piping

# 2d primitives
export Square, Circle

# transforms
export translate, rotate

# operations
export Shell, LinearExtrude

# CSG
export CSGUnion, RadiusedCSGUnion, CSGDiff, CSGIntersect

# frep
export FRep

# FileIO
export load, save


end # module
