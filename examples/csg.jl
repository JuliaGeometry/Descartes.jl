"""
translate([-24,0,0]) {
    union() {
        cube(15, center=true);
        sphere(10);
    }
}

intersection() {
    cube(15, center=true);
    sphere(10);
}

translate([24,0,0]) {
    difference() {
        cube(15, center=true);
        sphere(10);
    }
}
"""


using Descartes
using GeometryBasics

a = translate([-24,0,0])union(
        Cuboid([15,15,15], center=true),
        Descartes.Sphere(10))

b = intersect(
        Cuboid([15,15,15], center=true),
        Descartes.Sphere(10))

c = translate([24,0,0])diff(
        Cuboid([15,15,15], center=true),
        Descartes.Sphere(10))

m = Mesh(a,b,c)
@show typeof(m)
using WGLMakie

scene = WGLMakie.mesh(coordinates(m), faces(m); shading=true, color=:yellow)
