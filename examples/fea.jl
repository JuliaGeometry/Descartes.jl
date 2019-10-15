using Descartes
using DistMesh
using StaticArrays
using Makie

# params
function beam(beam_size = [50,10,10],
                hole_ct = 5,
                hole_d = 3)

    # computations
    hole_interval = beam_size[1]/(hole_ct + 1)

    c = Cuboid(beam_size)

    for i = 1:hole_ct
        h = translate([hole_interval*i, -1, beam_size[3]/2])*
                rotate(-pi/2, [1,0,0])*
                    Cylinder(hole_d/2, beam_size[2]+2, center=false)
        c = diff(c, h)
    end
    c
end

function deadmau5()
    diff(union(Descartes.Sphere(5),
                translate([4,2,0])Descartes.Sphere(4),
                translate([-4,2,0])Descartes.Sphere(4)),
        translate([5,2,3])Descartes.Sphere(3),
        translate([-5,2,3])Descartes.Sphere(3))
end

b = deadmau5()
f(x) = FRep(b, x)
h = HyperRectangle(b)
@show f(SVector(1,1,1))
p, t = distmeshnd(f, huniform, 1.5, origin=h.origin, widths=h.widths)

#save("fea.ply",HomogenousMesh(c))
