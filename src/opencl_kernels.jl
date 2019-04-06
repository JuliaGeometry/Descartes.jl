# http://en.wikipedia.org/wiki/Function_representation

# These functions return OpenCL code for building a compute kernel.
# at present all transform parameters are static in the kernel.
# In the future it may be good to make these allow for parameter passing,
# to allow for the kernel to avoid recompilation. Before this happens we will
# need to perform some static analysis of the geometry tree

########
#
# INTERFACE
#
# Current point: x_v, y_v, z_v
#
# Return String(<inner cl kernel>), String(<SDF return sig>)
#

function _radius(a,b,r)
    if abs(a-b) >= r
        return min(a,b)
    else
        return b+r*sin(pi/4+asin((a-b)/(r*sqrt(2))))-r
    end
end

function cl_kernel_inner(p::Sphere)
    it = p.inv_transform
    sig = rand(UInt8)
    ret_sig = rand(UInt8)
    return """
    float x_$sig = x_v*$(it[1,1])+y_v*$(it[1,2])+z_v*$(it[1,3])+$(it[1,4]);
    float y_$sig = x_v*$(it[2,1])+y_v*$(it[2,2])+z_v*$(it[2,3])+$(it[2,4]);
    float z_$sig = x_v*$(it[3,1])+y_v*$(it[3,2])+z_v*$(it[3,3])+$(it[3,4]);
    float sphere_$ret_sig = sqrt(x_$sig*x_$sig + y_$sig*y_$sig + z_$sig*z_$sig) - $(p.radius);
    """,
    "sphere_$ret_sig"
end

function cl_kernel_inner(p::Cylinder, _x, _y, _z)
    it = p.inv_transform
    x = _x*it[1,1]+_y*it[1,2]+_z*it[1,3]+it[1,4]
    y = _x*it[2,1]+_y*it[2,2]+_z*it[2,3]+it[2,4]
    z = _x*it[3,1]+_y*it[3,2]+_z*it[3,3]+it[3,4]
    max(max(-z,z-p.height), sqrt(x*x + y*y) - p.radius)
end

function cl_kernel_inner(p::Cuboid, _x, _y, _z)
    it = p.inv_transform
    x = _x*it[1,1]+_y*it[1,2]+_z*it[1,3]+it[1,4]
    y = _x*it[2,1]+_y*it[2,2]+_z*it[2,3]+it[2,4]
    z = _x*it[3,1]+_y*it[3,2]+_z*it[3,3]+it[3,4]
    dx, dy, dz = p.dimensions
    max(max(-x, x-dx),
        max(-y, y-dy),
        max(-z, z-dz))
end

function cl_kernel_inner(u::CSGUnion)

    min(FRep(u.left, x,y,z),FRep(u.right, x,y,z))
end

function cl_kernel_inner(u::CSGDiff, x, y, z)
    max(FRep(u.left, x,y,z), -FRep(u.right, x,y,z))
end

function cl_kernel_inner(u::CSGIntersect, x, y, z)
    max(FRep(u.left, x,y,z), FRep(u.right, x,y,z))
end

function cl_kernel_inner(s::Shell, x, y, z)
    r = FRep(s.primitive, x, y, z)
    max(r, -r-s.distance)
end

function cl_kernel_inner(u::RadiusedCSGUnion, x, y, z)
    a = FRep(u.left, x,y,z)
    b = FRep(u.right, x,y,z)
    r = u.radius
    _radius(a,b,r)
end

function cl_kernel_inner(p::Piping{T}, x, y, z) where {T}
    num_pts = length(p.points)
    pt = Point(x,y,z)

    val = typemax(T)

    for i = 1:num_pts-1
        e1 = p.points[i]
        e2 = p.points[i+1]
        v = e2 - e1
        w = pt - e1
        if dot(w,v) <= 0
            nv = norm(pt - e1)
        elseif dot(v,v) <= dot(w,v)
            nv = norm(pt - e2)
        else
            nv = norm(cross(pt-e1,pt-e2))/norm(e2-e1)
        end
        val = min(nv, val)
    end
    val - p.radius
end
