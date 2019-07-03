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

a = translate([-24,0,0])union(
        Cuboid([15,15,15], center=true),
        Sphere(10))

b = intersect( 
        Cuboid([15,15,15], center=true),
        Sphere(10))

c = translate([24,0,0])diff(
        Cuboid([15,15,15], center=true),
        Sphere(10))

m = HomogenousMesh(a,b,c)

#Descartes.visualize(m)
