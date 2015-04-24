# http://en.wikipedia.org/wiki/Function_representation


@inline function FRep(s::Sphere, x, y, z)
    x,y,z,h = s.inv_transform*[x,y,z,1]
    sqrt(x*x + y*y + z*z) - s.radius
end

@inline function FRep(c::Cylinder, x, y, z)
    x,y,z,h = c.inv_transform*[x,y,z,1]
    max(max(-z,z-c.height), sqrt(x*x + y*y) - c.radius)
end

@inline function FRep(c::Cuboid, x, y, z)
    x,y,z,h = c.inv_transform*[x,y,z,1]
    max(max(-x, x-c.dimensions[1]),
        max(-y, y-c.dimensions[2]),
        max(-z, z-c.dimensions[3]))
end

@inline function FRep(p::PrismaticCylinder, x, y, z)
    # http://math.stackexchange.com/questions/41940/is-there-an-equation-to-describe-regular-polygons
    x,y,z,h = p.inv_transform*[x,y,z,1]
    sn = sin(pi/p.sides)
    cn = cos(pi/p.sides)
    r = p.radius
    b = max(max(r*sn, max(-y, y-r)),max(r*sn,max(-y, y-r)),(x-r*cn))
    max(max(-z, z-p.height), b)
end

@inline function FRep(u::CSGUnion, x, y, z)
    min(FRep(u.left, x,y,z),FRep(u.right, x,y,z))
end

@inline function FRep(u::CSGDiff, x, y, z)
    max(FRep(u.left, x,y,z), -FRep(u.right, x,y,z))
end

@inline function FRep(u::CSGIntersect, x, y, z)
    max(FRep(u.left, x,y,z), FRep(u.right, x,y,z))
end

@inline function FRep(u::RadiusedCSGUnion, x, y, z)
    a = FRep(u.left, x,y,z)
    b = FRep(u.right, x,y,z)
    r = u.radius
    if abs(a-b) >= r
        return min(a,b)
    else
        return b+r*sin(pi/4+asin((a-b)/(r*sqrt(2))))-r
    end
end
