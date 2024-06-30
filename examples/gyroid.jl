using Revise
using Descartes: Gyroid, Cuboid, PolarWarp, Cylinder, FRep
using GeometryBasics: GeometryBasics, mesh, HyperRectangle
using Meshing
using StaticArrays

holes = [[0,0,0], [15, 0, 0], [7.5, 7.5, 0]]


p = intersect(PolarWarp(Gyroid(0.5), 200), Cuboid([50,50,50]))

h = HyperRectangle(p)

@time m = mesh(p; samples=(200,200,200))

using WGLMakie
WGLMakie.activate!(resize_to=:body)
WGLMakie.mesh(m)
