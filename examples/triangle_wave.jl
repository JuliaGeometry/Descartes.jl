using Revise
using Descartes: Descartes, TriangleWave, FRep, Grid
using WGLMakie

t = TriangleWave(2.)

x = 1:0.1:10
y = [FRep(t, e) for e in x]

lines(x,y)

g = Grid(1.0)

x_vals = 1:0.1:10
y_vals = 1:0.1:10

z = [FRep(g, (x, y)) for x in x_vals, y in y_vals]
heatmap(x_vals, y_vals, z, alpha=0.6)

