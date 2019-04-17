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

#
# At present this is very hacky and should either be a macro or use other
# direct compilation methods
#

function _inv_transform(it, sig)
    return """
    float x_$sig = x_v*$(it[1,1])+y_v*$(it[1,2])+z_v*$(it[1,3])+$(it[1,4]);
    float y_$sig = x_v*$(it[2,1])+y_v*$(it[2,2])+z_v*$(it[2,3])+$(it[2,4]);
    float z_$sig = x_v*$(it[3,1])+y_v*$(it[3,2])+z_v*$(it[3,3])+$(it[3,4]);
    """
end

function cl_kernel_inner(p::Sphere)
    it = p.inv_transform
    sig = string(rand(UInt8),"s")

    return """
    $(_inv_transform(it,sig))
    float sphere_$sig = sqrt(x_$sig*x_$sig + y_$sig*y_$sig + z_$sig*z_$sig) - $(p.radius);
    """,
    "sphere_$sig"
end

function cl_kernel_inner(p::Cylinder)
    it = p.inv_transform
    sig = string(rand(UInt8),"c")

    return """
    $(_inv_transform(it,sig))
    float cylinder_$sig = max((float)(max((float)(-z_$sig+$(p.bottom)),(float)(z_$sig-$(p.height)-($(p.bottom))))), (float)(sqrt(x_$sig*x_$sig + y_$sig*y_$sig) - $(p.radius)));
    """,
    "cylinder_$sig"
end

function cl_kernel_inner(p::Cuboid)
    it = p.inv_transform
    sig = string(rand(UInt8),"cube")
    dx, dy, dz = p.dimensions

    return """
    $(_inv_transform(it,sig))
    float xs_$sig = max((float)(-x_$sig), (float)(x_$sig-$dx));
    float ys_$sig = max((float)(-y_$sig), (float)(y_$sig-$dy));
    float zs_$sig = max((float)(-z_$sig), (float)(z_$sig-$dz));

    float cuboid_$sig = max(max(xs_$sig,ys_$sig),zs_$sig);
    """,
    "cuboid_$sig"

end

function cl_kernel_inner(u::CSGUnion)
    r_body, r_ret = cl_kernel_inner(u.right)
    l_body, l_ret = cl_kernel_inner(u.left)
    sig = string(rand(UInt8),"union")
    return """
    $(r_body)

    $(l_body)

    float union_$sig = min((float)($l_ret),(float)($r_ret));
    """,
    "union_$sig"
end

function cl_kernel_inner(u::CSGDiff)
    r_body, r_ret = cl_kernel_inner(u.right)
    l_body, l_ret = cl_kernel_inner(u.left)
    sig = string(rand(UInt8),"diff")
    return """
    $(r_body)

    $(l_body)

    float diff_$sig = max((float)($l_ret),(float)(-$r_ret));
    """,
    "diff_$sig"
end

function cl_kernel_inner(u::CSGIntersect)
    r_body, r_ret = cl_kernel_inner(u.right)
    l_body, l_ret = cl_kernel_inner(u.left)
    sig = string(rand(UInt8),"intersect")
    return """
    $(r_body)

    $(l_body)

    float intersect_$sig = max((float)$l_ret,(float)$r_ret);
    """,
    "intersect_$sig"
end

function cl_kernel_inner(s::Shell)
    body, ret = cl_kernel_inner(s.primitive)
    sig = string(rand(UInt8),"shell")
    return """
    $(body)

    float shell_$sig = max((float)$ret,(float)(-$ret-$(s.distance)));
    """,
    "shell_$sig"
end

function cl_kernel_inner(u::RadiusedCSGUnion)
    r_body, r_ret = cl_kernel_inner(u.right)
    l_body, l_ret = cl_kernel_inner(u.left)
    r = u.radius
    sig = string(rand(UInt8),"radunion")
    return """
    $(r_body)

    $(l_body)

    float radunion_$sig;
    if (fabs((float)($(l_ret)-$(r_ret))) >= $r) {
        radunion_$sig = min($l_ret,$r_ret);
    } else {
        float diff = ($l_ret-$r_ret);
        radunion_$sig = $(r_ret)+$r * sin((float)(M_PI_4 + asin((float)(diff/($r*SQRT2)))))-$r;
        }
    """,
    "radunion_$sig"
end


# function cl_kernel_inner(p::Piping{T}, x, y, z) where {T}
#     num_pts = length(p.points)
#     pt = Point(x,y,z)
#
#     val = typemax(T)
#
#     for i = 1:num_pts-1
#         e1 = p.points[i]
#         e2 = p.points[i+1]
#         v = e2 - e1
#         w = pt - e1
#         if dot(w,v) <= 0
#             nv = norm(pt - e1)
#         elseif dot(v,v) <= dot(w,v)
#             nv = norm(pt - e2)
#         else
#             nv = norm(cross(pt-e1,pt-e2))/norm(e2-e1)
#         end
#         val = min(nv, val)
#     end
#     val - p.radius
# end
