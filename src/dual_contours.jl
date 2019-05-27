#import numpy as np
#import numpy.linalg as la
#import scipy.optimize as opt
#import itertools as it
using LinearAlgebra
using Roots
using GeometryTypes
using FileIO
using StaticArrays
using ForwardDiff

#Cardinal directions
dirs = [ [1,0,0], [0,1,0], [0,0,1] ]

#Vertices of cube
cube_verts = [[0, 0, 0], [0, 0, 1], [0, 1, 0], [0, 1, 1],
              [1, 0, 0], [1, 0, 1], [1, 1, 0], [1, 1, 1]]


#Edges of cube
cube_edges = [(0, 1), (0, 2), (0, 1), (0, 4), (0, 2), (0, 4), (2, 3), (1, 3),
              (4, 5), (1, 5), (4, 6), (2, 6), (4, 5), (4, 6), (2, 3), (2, 6),
              (1, 3), (1, 5), (6, 7), (5, 7), (6, 7), (3, 7), (5, 7), (3, 7)]


#Use non-linear root finding to compute intersection point
function estimate_hermite(f, v0, v1)
    l(t) = f((1.0-t)*v0 + t*v1)
    dl(t) = ForwardDiff.derivative(l,t)
    t0 = find_zero((l,dl),(0, 1))
    x0 = (1.0-t0)*v0 + t0*v1
    return (x0, ForwardDiff.gradient(f,x0))
end

#Input:
# f = implicit function
# df = gradient of f
# nc = resolution
function dual_contour(f, nc)

    #Compute vertices
    dc_verts = []
    vindex   = Dict()
    for x in 0:nc, y in 0:nc, z in 0:nc
        o = [x,y,z]

        #Get signs for cube
        cube_signs = [ f(o+v)>0 for v in cube_verts ]

        if all(cube_signs) || !any(cube_signs)
            continue
        end

        #Estimate hermite data
        h_data = [ estimate_hermite(f, o+cube_verts[e[1]+1], o+cube_verts[e[2]+1])
            for e in cube_edges if cube_signs[e[1]+1] != cube_signs[e[2]+1] ]

        #Solve qef to get vertex
        A = Array{Float64,2}(undef,length(h_data),3)
        for i in eachindex(h_data)
            A[i,:] = h_data[i][2]
        end
        b = [ dot(d[1],d[2]) for d in h_data ]
        v = A\b

        #Throw out failed solutions
        if norm(v-o) > 2
            continue
        end

        #Emit one vertex per every cube that crosses
        push!(vindex, o => length(dc_verts))
        push!(dc_verts, (v, ForwardDiff.gradient(f,v)))
    end

    #Construct faces
    dc_faces = []
    for x in 0:nc, y in 0:nc, z in 0:nc
        if !haskey(vindex,[x,y,z])
            continue
        end

        #Emit one face per each edge that crosses
        o = [x,y,z]
        for i in (1,2,3)
            for j in 1:i
                if haskey(vindex,o + dirs[i]) && haskey(vindex,o + dirs[j]) && haskey(vindex,o + dirs[i] + dirs[j])
                    # determine orientation of the face from the true normal
                    v1, tn1 = dc_verts[vindex[o]+1]
                    v2, tn2 = dc_verts[vindex[o+dirs[i]]+1]
                    v3, tn3 = dc_verts[vindex[o+dirs[j]]+1]
                    @show v1,v2, v3
                    e1 = v1-v2
                    e2 = v1-v3
                    c = cross(e1,e2)
                    if dot(c, tn1) > 0
                        push!(dc_faces, [vindex[o], vindex[o+dirs[i]], vindex[o+dirs[j]]] )
                        push!(dc_faces, [vindex[o+dirs[i]+dirs[j]], vindex[o+dirs[j]], vindex[o+dirs[i]]] )
                    else
                        push!(dc_faces, [vindex[o], vindex[o+dirs[j]], vindex[o+dirs[i]]] )
                        push!(dc_faces, [vindex[o+dirs[i]+dirs[j]], vindex[o+dirs[i]], vindex[o+dirs[j]]] )
                    end
                end
            end
        end

    end
    return dc_verts, dc_faces
end


center = [16,16,16]
radius = 10

function test_f(x)
    d = x-center
    return dot(d,d) - radius^2
end

function runion(x,y)
    x + y - sqrt(x*x + y*y)
end

function softmax(x,y)
    log(exp(3*x)+exp(3*y))/3
end

function test_sq(x)
    d = x-center
    softmax(softmax(-d[3], d[3]-5), d[1]*d[1] + d[2]*d[2] - radius )
end


verts, tris = dual_contour(test_sq, 36)

m = HomogenousMesh([Point(v[1]...) for v in verts], [Face(t[1]+1,t[2]+1,t[3]+1) for t in tris])

save("test2.ply",m)
