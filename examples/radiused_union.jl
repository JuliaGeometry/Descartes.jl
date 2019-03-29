using Descartes

#Descartes.cache_enabled(false)

#c1 = translate([-1,-1,-4])Cuboid([4,4,4])
c2 = Cuboid([4,4.0,4])
cyl1 = rotate(pi/6, [1,0,0])translate([2,2,0])Cylinder(1.0,10.0)

u = Shell(0.5)RadiusedCSGUnion(1,c2, cyl1)
u2 = CSGDiff(u, Cuboid([2,2,2]))

@show u2

@time m = HomogenousMesh(u2)

#Profile.clear()

@time m = HomogenousMesh(u2)

#using ProfileView

#ProfileView.view()

save("test3.ply",m)
