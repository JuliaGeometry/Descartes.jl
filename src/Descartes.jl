module Descartes

import Base: *, union, diff, intersect
import GeometryBasics: AbstractMesh,
                       HyperRectangle,
                       Vec,
                       Mesh

using StaticArrays,
      Meshing,
      LinearAlgebra,
      CoordinateTransformations,
      Rotations

include("types.jl")
include("utils.jl")
include("constructors.jl")
include("operations.jl")
include("frep.jl")
include("hyperrectangles.jl")
include("meshes.jl")

end # module
