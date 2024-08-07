# http://en.wikipedia.org/wiki/Function_representation
#----------------------------------

function FRep(p::MapContainer, v)
    FRep(p.primitive, p.inv(v))
end

function FRep(u::CSGUnion, v)
    f = FRep(u.left, v)
    for p in u.right
        f = min(f, FRep(p, v))
    end
    f
end

function FRep(u::CSGDiff, v)
    f = FRep(u.left, v)
    for p in u.right
        f = max(f, -FRep(p, v))
    end
    f
end

function FRep(u::CSGIntersect, v)
    f = FRep(u.left, v)
    for p in u.right
        f = max(f, FRep(p, v))
    end
    f
end

_gyroid(v) = cos(v[1])*sin(v[2])+cos(v[2])*sin(v[3])+cos(v[3])*sin(v[1])

function FRep(p::Gyroid, v)
    max(_gyroid(v)-p.width,-_gyroid(v)-p.width)
end

function FRep(p::Sphere,v)
    norm(v) - p.radius
end

function FRep(p::Cylinder,v)
    x = v[1]
    y = v[2]
    z = v[3]
    max(-z+p.bottom, z-p.height-p.bottom, sqrt(x*x + y*y) - p.radius)
end

function FRep(p::Circle, v)
    norm(v) - p.radius
end

function FRep(p::Cuboid, v)
    x = v[1]
    y = v[2]
    z = v[3]
    dx, dy, dz = p.dimensions
    lbx, lby,lbz = p.lowercorner
    max(-x+lbx, x-dx-lbx,
        -y+lby, y-dy-lby,
        -z+lbz, z-dz-lbz)
end

function FRep(p::Square, v)
    x = v[1]
    y = v[2]
    dx, dy = p.dimensions
    lbx, lby = p.lowercorner
    max(-x+lbx, x-dx-lbx,
        -y+lby, y-dy-lby)
end

function FRep(s::Shell, v)
    r = FRep(s.primitive, v)
    max.(r, -r .- s.distance)
end

function _radius(a::Real,b::Real,r::Real)
    if abs(a-b) >= r
        return min(a,b)
    else
        return b+r*sin(pi/4+asin((a-b)/(r*sqrt(2))))-r
    end
end

function FRep(u::RadiusedCSGUnion, v)
    a = FRep(u.left, v)
    b = FRep(u.right, v)
    r = u.radius
    _radius(a,b,r)
end

function FRep(p::Piping{T}, v) where {T}
    num_pts = length(p.points)

    val = typemax(T)

    for i = 1:num_pts-1
        e1 = p.points[i]
        e2 = p.points[i+1]
        v = e2 - e1
        w = v - e1
        if dot(w,v) <= 0
            nv = norm(v - e1)
        elseif dot(v,v) <= dot(w,v)
            nv = norm(v - e2)
        else
            nv = norm(cross(v-e1,v-e2))/norm(e2-e1)
        end
        val = min(nv, val)
    end
    val - p.radius
end

function FRep(p::LinearExtrude, v)
    x = v[1]
    y = v[2]
    z = v[3]
    r = FRep(p.primitive, SVector(x,y))
    max(max(-z,z-p.distance), r)
end

function FRep(t::TriangleWave, v)
    abs(mod(v[t.direction], t.period) - t.period / 2)
end


function FRep(p::PolarWarp, v)
    inner_warp(p.primitive, p.w, v)
end

function inner_warp(p::AbstractPrimitive, w, v)
    T(a) = SVector(hypot(a[1], a[2]), atan(a[2], a[1])*w/2π, a[3]) #cartesian to polar
    hr = gradient(a -> FRep(p, T(a)), SVector(v...))
    mr, mt = T(v)
    FRep(p, SVector(mr, mt, v[3]))/norm(hr)
end

function inner_warp(p::CSGUnion, w, v)
    m = inner_warp(p.left, w, v)
    for r in p.right
        m = min(m, inner_warp(r, w, v))
    end
    m
end