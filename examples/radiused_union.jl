using Descartes
using Meshes

#c1 = translate([-1,-1,-4])Cuboid([4,4,4])
c2 = Cuboid([4,4,4])
cyl1 = translate([2,2,0])Cylinder(1,10)
p1 = PrismaticCylinder(6, 10, 5)
p2 = PrismaticCylinder(8, 5, 20)

u = Shell(0.5)RadiusedCSGUnion(1,c2, cyl1)
u2 = CSGDiff(u, Cuboid([2,2,2]))

@show u2

@time m = Mesh(u2)

Profile.clear()

@time @profile m = Mesh(u2, (200,200,200))

using ProfileView

ProfileView.view()

exportAsciiPly(m, "test3.ply")
