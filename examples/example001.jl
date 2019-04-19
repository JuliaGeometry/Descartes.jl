
"""
module example001()
{
    function r_from_dia(d) = d / 2;

    module rotcy(rot, r, h) {
        rotate(90, rot)
            cylinder(r = r, h = h, center = true);
    }

    difference() {
        sphere(r = r_from_dia(size));
        rotcy([0, 0, 0], cy_r, cy_h);
        rotcy([1, 0, 0], cy_r, cy_h);
        rotcy([0, 1, 0], cy_r, cy_h);
    }

    size = 50;
    hole = 25;

    cy_r = r_from_dia(hole);
    cy_h = r_from_dia(size * 2.5);
}

example001();


"""

using Descartes


function example001()

    r_from_dia(d) = d / 2;

    size = 50
    hole = 25

    cy_r = r_from_dia(hole)
    cy_h = r_from_dia(size * 2.5)

    function rotcy(rot, r, h)
        rotate(pi/2, rot)Cylinder(r, h, center=true)
    end

    CSGDiff(
        Sphere(r_from_dia(size)),
        rotcy([0, 0, 0], cy_r, cy_h),
        rotcy([1, 0, 0], cy_r, cy_h),
        rotcy([0, 1, 0], cy_r, cy_h))
end

m = HomogenousMesh(example001(),resolution=1)
save("example001.ply", m)
Descartes.visualize(m)
