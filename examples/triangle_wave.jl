using Revise
using Descartes: Descartes, TriangleWave, FRep, Grid, PolarWarp, Cuboid, union
using WGLMakie
using CoordinateTransformations
using StaticArrays
using ForwardDiff
using LinearAlgebra
using Symbolics

WGLMakie.activate!(resize_to=:body)


t1 = TriangleWave(2., 1)
t2 = TriangleWave(2., 2)

x = 1:0.1:10
y1 = [FRep(t1, e) for e in x]
y2 = [FRep(t2, e) for e in x]

lines(x,y2)

g = union(TriangleWave(1., 1), TriangleWave(2., 2))

x_vals = -10:0.1:10
y_vals = -10:0.1:10

# basic Grid
z = [FRep(g, (x, y)) for x in x_vals, y in y_vals]
extrema(z)
heatmap(x_vals, y_vals, z, alpha=0.6)

@variables x y
FRep(g, (x, y))

# Apply warp
g_polar = PolarWarp(g, 8)

#FRep(g_polar, (x, y))

z = [FRep(g_polar, (x, y)) for x in x_vals, y in y_vals]

extrema(z)

fig, ax, hm = heatmap(x_vals, y_vals, z, alpha=0.6)
Colorbar(fig[:, end+1], hm)


polar_f(v) = FRep(g_polar, v)
polar_f([1,2])
polar_f_min(v) = min(polar_f(v)...)
polar_f_min([1,2])

polar_f_jac(v) = ForwardDiff.jacobian(polar_f, v)
z = [polar_f_jac([x, y]) for x in x_vals, y in y_vals]

# TODO : Correction factor
exper1(v) = norm(inv(polar_f_jac(v))*ForwardDiff.gradient(polar_f_min, v))

z = [exper1([x, y]) for x in x_vals, y in y_vals]
extrema(z)
heatmap(x_vals, y_vals, z, alpha=0.6)

