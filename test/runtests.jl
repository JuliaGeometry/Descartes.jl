using Descartes: Sphere, Cuboid, Cylinder, CSGUnion, CSGIntersect, CSGDiff, MapContainer, Piping, FRep, Square, translate, rotate, Shell, RadiusedCSGUnion
using StaticArrays
using Test
using Combinatorics
using FileIO
using MeshIO

import GeometryBasics: Mesh, HyperRectangle

primitives_array = [Sphere(1), Cuboid([1,2,3]), Cylinder(3,4)]
operations_array = [CSGUnion, CSGIntersect, CSGDiff]

include("tranforms.jl")
include("operations.jl")
include("primitives.jl")
include("2d.jl")
include("hyperrectangles.jl")
include("meshes.jl")
include("examples.jl")
include("frep.jl")
