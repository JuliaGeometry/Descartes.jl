# http://en.wikipedia.org/wiki/Function_representation


function FRep(s::Sphere, x, y, z)
    sqrt((x-s.location[1])^2 + (y-s.location[2])^2 + (z-s.location[3])^2) - s.radius
end

function FRep(u::CSGUnion, x, y, z)
    min(FRep(u.left, x,y,z),FRep(u.right, x,y,z))
end

function FRep(u::CSGDiff, x, y, z)
    max(FRep(u.left, x,y,z), -FRep(u.right, x,y,z))
end

function FRep(u::CSGIntersect, x, y, z)
    max(FRep(u.left, x,y,z), FRep(u.right, x,y,z))
end
