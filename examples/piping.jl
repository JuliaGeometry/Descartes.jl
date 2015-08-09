using Descartes
using Meshes
using Meshes.Files

p = Pipe(1, Vector{Int}[[0,0,0],[10,0,0],[10,10,0],[10,10,10],[5,5,5]])

@time m = Mesh(p)
@time m = Mesh(p)

exportAsciiPly(m, "piping.ply")
