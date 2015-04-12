# http://en.wikipedia.org/wiki/Function_representation


function frep(s::Sphere)
    function sphere_frep(x,y,z)
        sqrt((x-s.location[1])^2 + (y-s.location[2])^2 + (z-s.location[3])^2) - s.radius
    end
end

function frep(u::CSGUnion)
    function csgunion_frep(x,y,z)
        min(frep(u.left)(x,y,z),frep(u.right)(x,y,z))
    end
end

function frep(u::CSGDiff)
    function csgdiff_frep(x,y,z)
        max(frep(u.left)(x,y,z), -frep(u.right)(x,y,z))
    end
end

function frep(u::CSGIntersect)
    function csgintersect_frep(x,y,z)
        max(frep(u.left)(x,y,z), frep(u.right)(x,y,z))
    end
end
