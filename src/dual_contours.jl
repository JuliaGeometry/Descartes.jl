#import numpy as np
#import numpy.linalg as la
#import scipy.optimize as opt
#import itertools as it
using LinearAlgebra

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
function estimate_hermite(f, df, v0, v1)
    t0 = opt.brentq(t -> f((1.0-t)*v0 + t*v1), 0, 1)
    x0 = (1.0-t0)*v0 + t0*v1
    return (x0, df(x0))
end

#Input:
# f = implicit function
# df = gradient of f
# nc = resolution
function dual_contour(f, df, nc)

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
        h_data = [ estimate_hermite(f, df, o+cube_verts[e[1]+1], o+cube_verts[e[2]+1])
            for e in cube_edges if cube_signs[e[1]+1] != cube_signs[e[2]+1] ]

        #Solve qef to get vertex
        A = [ d[1] for d in h_data ]
        b = [ dot(d[1],d[2]) for d in h_data ]
        v = A\b

        #Throw out failed solutions
        if norm(v-o) > 2
            continue
        end

        #Emit one vertex per every cube that crosses
        vindex[ o ] = length(dc_verts)
        append(dc_verts, v)
    end

    #Construct faces
    dc_faces = []
    for x in 0:nc, y in 0:nc, z in 0:nc
        if !in((x,y,z),vindex)
            continue
        end

        #Emit one face per each edge that crosses
        o = [x,y,z]
        for i in (0,1,2)
            for j in 0:i
                if o + dirs[i] in vindex && o + dirs[j] in vindex && o + dirs[i] + dirs[j] in vindex
                    append(dc_faces, [vindex[tuple(o)], vindex[tuple(o+dirs[i])], vindex[tuple(o+dirs[j])]] )
                    append(dc_faces, [vindex[tuple(o+dirs[i]+dirs[j])], vindex[tuple(o+dirs[j])], vindex[tuple(o+dirs[i])]] )
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

function test_df(x)
    d = x-center
    return d / sqrt(dot(d,d))
end

verts, tris = dual_contour(test_f, test_df, 36)

m = HomogenousMesh(verts, tris)