# http://en.wikipedia.org/wiki/Function_representation

function _radius(a,b,r)
    if abs(a-b) >= r
        return min(a,b)
    else
        return b+r*sin(pi/4+asin((a-b)/(r*sqrt(2))))-r
    end
end

function FRep(p::MapContainer{3,T,P}, v) where {T,P}
    FRep(p.primitive, p.inv(v))
end


function FRep(p::MapContainer{2,T,P}, v) where {T,P}
    FRep(p.primitive, p.inv(SVector(v[1],v[2])))
end

function FRep(p::Sphere, v)
    x = v[1]
    y = v[2]
    z = v[3]
    sqrt(x*x + y*y + z*z) - p.radius
end

function FRep(p::Cylinder, v)
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
    r = FRep(p.primitive, v)
    max(max(-z,z-p.distance), r)
end
