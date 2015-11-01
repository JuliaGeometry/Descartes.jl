using Descartes

pt3 = Point{3,Float64}

p = Piping(1.0, [pt3(0,0,0),
                         pt3(10,0,0),
                         pt3(10,10,0),
                         pt3(10,10,10),
                         pt3(5,5,5)])

save("piping.ply", HomogenousMesh(p))
