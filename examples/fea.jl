using Descartes
using DistMesh
using GeometryTypes
using StaticArrays
using Makie
#using Colors

Cylinder=Descartes.Cylinder

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

#b = beam([10,10,10],1, 3)
b = Descartes.Sphere(5)
f(x) = FRep(b, x)
m = GLNormalMesh(b)
scene = mesh(m, color=:blue)
display(scene)
sleep(5)
h = HyperRectangle(b)
@show f(SVector(1,1,1))
statsdata = DistMesh.DistMeshStatistics()
@time p, t = distmesh(f, huniform, 1, origin=h.origin, widths=h.widths, stats=true, statsdata=statsdata, distribution=:regular)

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

qualities = DistMesh.triangle_qualities(p,t)

statsdata
using Plots

qual_hist = Plots.histogram(qualities, title = "Quality", legend=false)
avg_plt = Plots.plot(statsdata.average_qual, title = "Average Quality", legend=false, ylabel="Quality")
vline!(statsdata.retriangulations, line=(0.2, :dot, [:red]))
med_plt = Plots.plot(statsdata.median_qual, title = "Median Quality", legend=false, ylabel="Quality")
vline!(statsdata.retriangulations, line=(0.2, :dot, [:red]))
maxdp_plt = Plots.plot(statsdata.maxdp, title = "Max Displacement", legend=false, ylabel="Edge Displacement")
vline!(statsdata.retriangulations, line=(0.2, :dot, [:red]))
maxmove_plt = Plots.plot(statsdata.maxmove, title = "Max Move", legend=false, ylabel="Point Displacement")
vline!(statsdata.retriangulations, line=(0.2, :dot, [:red]))
plt = Plots.plot(avg_plt, med_plt,maxdp_plt,maxmove_plt,layout=(2,2), xlabel="Iteration", )
savefig(plt, "result_stat.svg")
savefig(qual_hist, "result_qual.svg")



#save("fea.ply",HomogenousMesh(c))
