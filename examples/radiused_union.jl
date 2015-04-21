using Descartes
using Meshes

c1 = translate([-3,-3,-4])Cuboid([4,4,4])
c2 = Cuboid([4,4,4])
p1 = PrismaticCylinder(6, 10, 5)
p2 = PrismaticCylinder(8, 5, 20)

u = RadiusedCSGUnion(1, p1,p2)

m = Mesh(u)

exportAsciiPly(m, "test2.ply")
