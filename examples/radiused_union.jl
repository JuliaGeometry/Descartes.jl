using Descartes
using GeometryBasics: Mesh

c2 = Cuboid([4,4.0,4])
cyl1 = rotate(pi/6, [1,0,0])translate([2,2,0])Cylinder(1.0,10.0)

u = Shell(0.5)RadiusedCSGUnion(1,c2, cyl1)
u2 = diff(u, Cuboid([2,2,2]))

m = Mesh(u2)

#Descartes.visualize(u2)

save("radiused_union.ply",m)
