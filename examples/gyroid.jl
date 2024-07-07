using Revise
using Descartes: Gyroid, Cuboid, PolarWarp, Cylinder, FRep
using GeometryBasics: GeometryBasics, mesh
using Meshing: MarchingTetrahedra

p = intersect(PolarWarp(Gyroid(0.5), 200), Cuboid([50,50,50]))

@time m = mesh(p; samples=(100,100,100), algorithm=MarchingTetrahedra());

using WGLMakie
WGLMakie.activate!(resize_to=:body)
WGLMakie.mesh(m)
