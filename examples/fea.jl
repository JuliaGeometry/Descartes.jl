using Descartes
using DistMesh
using GeometryTypes
using StaticArrays
using Makie
#using Colors

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
                rotate(-pi/6, [0,1,0])* # adversarial case
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

b = beam([10,10,10],1, 3)
f(x) = FRep(b, x)
m = GLNormalMesh(b)
scene = mesh(m, color=:blue)
display(scene)
sleep(5)
h = HyperRectangle(b)
@show f(SVector(1,1,1))
p, t = distmeshnd(f, huniform, 0.7, origin=h.origin, widths=h.widths, vis=false)

VertType = eltype(p)
pair = Tuple{Int32,Int32}[] # edge indices (Int32 since we use Tetgen)

pair=resize!(pair, length(t)*6)
ls = Pair{VertType,VertType}[]

for i in eachindex(t)
    for ep in 1:6
        p1 = t[i][DistMesh.tetpairs[ep][1]]
        p2 = t[i][DistMesh.tetpairs[ep][2]]
        if p1 > p2
            pair[(i-1)*6+ep] = (p2,p1)
        else
            pair[(i-1)*6+ep] = (p1,p2)
        end
    end
end

sort!(pair)
unique!(pair)

# makie vis

resize!(ls, length(pair))
for i = 1:length(pair)
    ls[i] = p[pair[i][1]] => p[pair[i][2]]
end
scene = Makie.linesegments(ls)
display(scene)

#save("fea.ply",HomogenousMesh(c))
