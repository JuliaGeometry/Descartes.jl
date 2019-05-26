import numpy as np
import numpy.linalg as la
import scipy.optimize as opt
import itertools as it

#Cardinal directions
dirs = [ [1,0,0], [0,1,0], [0,0,1] ]

#Vertices of cube
cube_verts = [ np.array([x, y, z])
    for x in range(2)
    for y in range(2)
    for z in range(2) ]

#Edges of cube
cube_edges = [
    [ k for (k,v) in enumerate(cube_verts) if v[i] == a and v[j] == b ]
    for a in range(2)
    for b in range(2)
    for i in range(3)
    for j in range(3) if i != j ]

#Use non-linear root finding to compute intersection point
def estimate_hermite(f, df, v0, v1):
    t0 = opt.brentq(lambda t : f((1.-t)*v0 + t*v1), 0, 1)
    x0 = (1.-t0)*v0 + t0*v1
    return (x0, df(x0))

#Input:
# f = implicit function
# df = gradient of f
# nc = resolution
function dual_contour(f, df, nc):

    #Compute vertices
    dc_verts = []
    vindex   = {}
    for x,y,z in it.product(range(nc), range(nc), range(nc)):
        o = np.array([x,y,z])

        #Get signs for cube
        cube_signs = [ f(o+v)>0 for v in cube_verts ]

        if all(cube_signs) or not any(cube_signs):
            continue

        #Estimate hermite data
        h_data = [ estimate_hermite(f, df, o+cube_verts[e[0]], o+cube_verts[e[1]])
            for e in cube_edges if cube_signs[e[0]] != cube_signs[e[1]] ]

        #Solve qef to get vertex
        A = [ n for p,n in h_data ]
        b = [ np.dot(p,n) for p,n in h_data ]
        v, residue, rank, s = la.lstsq(A, b)

        #Throw out failed solutions
        if la.norm(v-o) > 2:
            continue

        #Emit one vertex per every cube that crosses
        vindex[ tuple(o) ] = len(dc_verts)
        dc_verts.append(v)

    #Construct faces
    dc_faces = []
    for x,y,z in it.product(range(nc), range(nc), range(nc)):
        if not (x,y,z) in vindex:
            continue

        #Emit one face per each edge that crosses
        o = np.array([x,y,z])
        for i in range(3):
            for j in range(i):
                if tuple(o + dirs[i]) in vindex and tuple(o + dirs[j]) in vindex and tuple(o + dirs[i] + dirs[j]) in vindex:
                    dc_faces.append( [vindex[tuple(o)], vindex[tuple(o+dirs[i])], vindex[tuple(o+dirs[j])]] )
                    dc_faces.append( [vindex[tuple(o+dirs[i]+dirs[j])], vindex[tuple(o+dirs[j])], vindex[tuple(o+dirs[i])]] )

    return dc_verts, dc_faces
end

import enthought.mayavi.mlab as mlab

center = np.array([16,16,16])
radius = 10

def test_f(x):
    d = x-center
    return np.dot(d,d) - radius**2

def test_df(x):
    d = x-center
    return d / sqrt(np.dot(d,d))

verts, tris = dual_contour(f, df, n)

mlab.triangular_mesh(
            [ v[0] for v in verts ],
            [ v[1] for v in verts ],
            [ v[2] for v in verts ],
            tris)
