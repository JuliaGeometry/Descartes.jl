using Descartes: Piping
using GeometryBasics: mesh

p = Piping(1.0, [[0,0,0],
                 [10,0,0],
                 [10,10,0],
                 [10,10,10],
                 [5,5,5]])

m = mesh(p)

using WGLMakie
mesh(m)

#Descartes.visualize(m)

#save("piping.ply", m)
