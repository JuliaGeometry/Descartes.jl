# http://en.wikipedia.org/wiki/Function_representation


@inline function FRep(s::Sphere, x, y, z)
    x,y,z,h = s.inv_transform*[x,y,z,1]
    sqrt(x*x + y*y + z*z) - s.radius
end

@inline function FRep(c::Cylinder, x, y, z)
    x,y,z,h = c.inv_transform*[x,y,z,1]
    max(max(-z,z-c.height), sqrt(x*x + y*y) - s.radius)
end

@inline function FRep(c::Cuboid, x, y, z)
    x,y,z,h = c.inv_transform*[x,y,z,1]
    max(max(-x, x-c.dimensions[1]),
        max(-y, y-c.dimensions[2]),
        max(-z, z-c.dimensions[3]))
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
