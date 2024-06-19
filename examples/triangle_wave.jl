using Revise
using Descartes: Descartes, TriangleWave, FRep, Grid, PolarWarp, Cuboid
using WGLMakie, Makie
using CoordinateTransformations
using StaticArrays
using ForwardDiff
using LinearAlgebra
t = TriangleWave(2.)

x = 1:0.1:10
y = [FRep(t, e) for e in x]

lines(x,y)

g = Grid(Square([10, 10]), 1.0)

x_vals = -10:0.1:10
y_vals = -10:0.1:10

# basic Grid
z = [FRep(g, (x, y)) for x in x_vals, y in y_vals]
extrema(z)
heatmap(x_vals, y_vals, z, alpha=0.6)


# Apply warp
g_polar = PolarWarp(g, 8)

z = [min(FRep(g_polar, (x, y))...) for x in x_vals, y in y_vals]
extrema(z)
heatmap(x_vals, y_vals, z, alpha=0.6)



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

