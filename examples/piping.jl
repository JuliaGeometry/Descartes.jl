using Descartes

p = Descartes.Pipe(1, Vector{Int}[[0,0,0],[10,0,0],[10,10,0],[10,10,10],[5,5,5]])

@time m = HomogenousMesh(p)
@time m = HomogenousMesh(p)

save("piping.ply", m)
