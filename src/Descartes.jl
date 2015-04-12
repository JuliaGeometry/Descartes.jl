module Descartes

using Meshes

include("primitives.jl")
include("csg.jl")
include("frep.jl")

# primitives
export Cuboid, Cylinder, Sphere

# frep
export frep

end # module
