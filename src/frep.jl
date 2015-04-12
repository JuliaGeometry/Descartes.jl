# http://en.wikipedia.org/wiki/Function_representation


function FRep(s::Sphere)
    FRep(s,
    function sphere_frep(x,y,z)
        sqrt((x-s.location[1])^2 + (y-s.location[2])^2 + (z-s.location[3])^2) - s.radius
    end
    )
end

function FRep(u::CSGUnion)
    FRep(u,
    function csgunion_frep(x,y,z)
        min(FRep(u.left)(x,y,z),FRep(u.right)(x,y,z))
    end
    )
end

function FRep(u::CSGDiff)
    FRep(u,
    function csgdiff_frep(x,y,z)
        max(FRep(u.left)(x,y,z), -FRep(u.right)(x,y,z))
    end
    )
end

function FRep(u::CSGIntersect)
    Frep(u,
    function csgintersect_frep(x,y,z)
        max(FRep(u.left)(x,y,z), FRep(u.right)(x,y,z))
    end
    )
end
