using Descartes

p = Descartes.Pipe(1.0, Point{3,Float64}[[0,0,0],[10,0,0],[10,10,0],[10,10,10],[5,5,5]])

@time m = HomogenousMesh(p)
@profile @time m = HomogenousMesh(p)

#using ProfileView
#
#ProfileView.view()

save("piping.ply", m)
