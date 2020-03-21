# http://en.wikipedia.org/wiki/Function_representation

function _radius(a,b,r)
    if abs(a-b) >= r
        return min(a,b)
    else
        return b+r*sin(pi/4+asin((a-b)/(r*sqrt(2))))-r
    end
end

function fmax(x::T1,y::T2) where {T1, T2}
    if x > zero(T1) && y > zero(T2)
        return sqrt(x^2+y^2)
    end
    return max(x,y)
end

function fmax(x::T1,y::T2, z::T3) where {T1, T2, T3}
    if x > zero(T1) && y > zero(T2) && z > zero(T3)
        return sqrt(x^2+y^2+z^2)
    elseif x > zero(T1) && y > zero(T2)
        return sqrt(x^2+y^2)
    elseif x > zero(T1) && z > zero(T2)
        return sqrt(x^2+z^2)
    elseif z > zero(T1) && y > zero(T2)
        return sqrt(z^2+y^2)
    else
        return max(x,y,z)
    end
end

fnorm(v) = sqrt(sum(v.*v))

@inline function apply_transform(it, v::V) where V
    @inbounds V(v[1]*it[1,1]+v[2]*it[1,2]+v[3]*it[1,3]+it[1,4],
                v[1]*it[2,1]+v[2]*it[2,2]+v[3]*it[2,3]+it[2,4],
                v[1]*it[3,1]+v[2]*it[3,2]+v[3]*it[3,3]+it[3,4])
end

function FRep(p::Sphere, v)
    it = p.inv_transform
    itv = apply_transform(it, v)
    x = itv[1]
    y = itv[2]
    z = itv[3]
    sqrt(x*x + y*y + z*z) - p.radius
end

function FRep(p::Cylinder, v)
    it = p.inv_transform
    itv = apply_transform(it, v)
    x = itv[1]
    y = itv[2]
    z = itv[3]
    max(-z+p.bottom, z-p.height-p.bottom, sqrt(x*x + y*y) - p.radius)
end

function FRep(p::Circle, v)
    it = p.inv_transform
    x = v[1]*it[1,1]+v[2]*it[1,2]+it[1,3]
    y = v[1]*it[2,1]+v[2]*it[2,2]+it[2,3]
    sqrt(x*x + y*y) - p.radius
end


function FRep(p::Cuboid, v::VT) where VT
    it = p.inv_transform
    x = v[1]*it[1,1]+v[2]*it[1,2]+v[3]*it[1,3]+it[1,4]
    y = v[1]*it[2,1]+v[2]*it[2,2]+v[3]*it[2,3]+it[2,4]
    z = v[1]*it[3,1]+v[2]*it[3,2]+v[3]*it[3,3]+it[3,4]
    dx, dy, dz = p.dimensions
    lbx, lby,lbz = p.lowercorner
    fmax(max(-x+lbx, x-dx-lbx),
         max(-y+lby, y-dy-lby),
         max(-z+lbz, z-dz-lbz))
end

function FRep(p::Square, v)
    it = p.inv_transform
    x = v[1]*it[1,1]+v[2]*it[1,2]+it[1,3]
    y = v[1]*it[2,1]+v[2]*it[2,2]+it[2,3]
    dx, dy = p.dimensions
    lbx, lby = p.lowercorner
    fmax(max(-x+lbx, x-dx-lbx),
         max(-y+lby, y-dy-lby))
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
    it = p.inv_transform
    itv = apply_transform(it, v)
    x = itv[1]
    y = itv[2]
    z = itv[3]
    r = FRep(p.primitive, v)
    fmax(max(-z,z-p.distance), r)
end
