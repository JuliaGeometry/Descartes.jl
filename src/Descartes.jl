module Descartes

import Base: *, union, diff, intersect
using GeometryBasics: GeometryBasics
import GeometryBasics: AbstractMesh,
                       HyperRectangle,
                       Vec,
                       mesh


using StaticArrays,
      Meshing,
      LinearAlgebra,
      CoordinateTransformations,
      Rotations

using ForwardDiff: gradient, jacobian

include("types.jl")
include("utils.jl")
include("constructors.jl")
include("operations.jl")
include("frep.jl")
include("hyperrectangles.jl")
include("meshes.jl")

end # module
