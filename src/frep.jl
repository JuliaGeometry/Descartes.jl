# http://en.wikipedia.org/wiki/Function_representation

function _radius(a,b,r)
    if abs(a-b) >= r
        return min(a,b)
    else
        return b+r*sin(pi/4+asin((a-b)/(r*sqrt(2))))-r
    end
end

function FRep(p::Sphere, v)
    x,y,z,_ = p.inv_transform*v
    sqrt(x*x + y*y + z*z) - p.radius
end

function FRep(p::Cylinder, v)
    x,y,z,_ = p.inv_transform*v
    max(max(-z+p.bottom,z-p.height-p.bottom), sqrt(x*x + y*y) - p.radius)
end

function FRep(p::Cuboid, v)
    x,y,z,_ = p.inv_transform*v
    dx, dy, dz = p.dimensions
    lbx, lby,lbz = p.lowercorner
    max(max(-x+lbx, x-dx-lbx),
        max(-y+lby, y-dy-lby),
        max(-z+lbz, z-dz-lbz))
end

function FRep(u::CSGUnion, v)
    min(FRep(u.left, v),FRep(u.right, v))
end

function FRep(u::CSGDiff, v)
    max(FRep(u.left, v), -FRep(u.right, v))
end

function FRep(u::CSGIntersect, v)
    max(FRep(u.left, v), FRep(u.right, v))
end

function FRep(s::Shell, v)
    r = FRep(s.primitive, v)
    max(r, -r-s.distance)
end

function FRep(u::RadiusedCSGUnion, v)
    a = FRep(u.left, v)
    b = FRep(u.right, v)
    r = u.radius
    _radius(a,b,r)
end

function FRep(p::Piping{T}, v) where {T}
    num_pts = length(p.points)
    pt = Point(v[1],v[2],v[3])

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

function FRep(p::LinearExtrude, v)
    r = FRep(s.primitive, v)
    max(max(-z,z-p.height), r)
end
