using Descartes

c2 = Cuboid([4,4.0,4])
cyl1 = rotate(pi/6, [1,0,0])translate([2,2,0])Cylinder(1.0,10.0)

u = Shell(0.5)RadiusedCSGUnion(1,c2, cyl1)
u2 = CSGDiff(u, Cuboid([2,2,2]))

@time m = HomogenousMesh(u2)

#Descartes.visualize(u2)

save("test3.ply",m)
