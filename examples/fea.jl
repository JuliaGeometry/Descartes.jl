using Descartes

function cube_with_holes(beam_size = [50,10,10], hole_ct = 5, hole_d = 3)
    # computations
    hole_interval = beam_size[1]/(hole_ct + 1)

    c = Cuboid(beam_size)

    for i = 1:hole_ct
        h = translate([hole_interval*i, -1, beam_size[3]/2])*
                rotate(-pi/2, [1,0,0])*
                    Cylinder(hole_d/2, beam_size[2]+2, center=false)
        c = CSGDiff(c, h)
    end
    c
end

c = cube_with_holes()
m = HomogenousMesh(c, samples = (40,40,40))

# merge vertices
h = HyperRectangle(c)
Descartes.correct_verts!(m, maximum(h.widths)/40+0.001)

save("fea.ply",m)
