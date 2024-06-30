using Revise
using Descartes: Gyroid, Cuboid, PolarWarp, Cylinder
using GeometryBasics: Mesh, HyperRectangle

holes = [[0,0,0], [15, 0, 0], [7.5, 7.5, 0]]


p = intersect(PolarWarp(Gyroid(0.5), 200), Cuboid([50,50,50]))

h = HyperRectangle(p)

m = Mesh(p)

using WGLMakie
WGLMakie.activate!(resize_to=:body)
mesh(m)
