import HyperRectangles: HyperRectangle

function HyperRectangle{T}(cube::Cuboid{T})
    orig = HyperRectangle{T,3}(fill(zero(T), 3), cube.dimensions[1:3])
    pts = copy(points(orig))
    hrect_new = HyperRectangle{T,3}()
    for pt in pts
        _pt = transform(cube.transform, pt...)
        update!(hrect_new, pt)
    end
    hrect_new
end

function HyperRectangle{T}(sphere::Sphere{T})
    orig = HyperRectangle{T,3}(fill(-sphere.radius,3), fill(sphere.radius,3))
    pts = points(orig)
    hrect_new = HyperRectangle{T,3}()
    for pt in pts
        push!(pt, one(T))
        pt = sphere.transform*pt
        update!(hrect_new, pt)
    end
    hrect_new
end

function HyperRectangle{T}(p::PrismaticCylinder{T})
    orig = HyperRectangle{T,3}([-p.radius,-p.radius,0], [p.radius,p.radius,p.height])
    pts = points(orig)
    hrect_new = HyperRectangle{T,3}()
    for pt in pts
        push!(pt, one(T))
        pt = p.transform*pt
        update!(hrect_new, pt)
    end
    hrect_new
end

function HyperRectangle{T}(p::Cylinder{T})
    orig = HyperRectangle{T,3}([-p.radius,-p.radius,0], [p.radius,p.radius,p.height])
    pts = points(orig)
    hrect_new = HyperRectangle{T,3}()
    for pt in pts
        push!(pt, one(T))
        pt = p.transform*pt
        update!(hrect_new, pt)
    end
    hrect_new
end

function HyperRectangle{T}(p::Pipe{T})
    hrect_new = HyperRectangle{T,3}()
    for pt in p.points
        push!(pt, one(T))
        update!(hrect_new, p.transform*pt)
        pop!(pt) # this is the worst, but im too tired to give a shit
    end
    hrect_new.min -= p.radius
    hrect_new.max += p.radius
    hrect_new
end

function HyperRectangle{N, T, L, R}(csg::CSGUnion{N, T, L, R})
    union(HyperRectangle(csg.left), HyperRectangle(csg.right))
end

function HyperRectangle{N, T, L, R}(csg::RadiusedCSGUnion{N, T, L, R})
    union(HyperRectangle(csg.left), HyperRectangle(csg.right))
end

function HyperRectangle{N, T, L, R}(csg::CSGIntersect{N, T, L, R})
    intersect(HyperRectangle(csg.left), HyperRectangle(csg.right))
end

function HyperRectangle{N, T, L, R}(csg::CSGDiff{N, T, L, R})
    diff(HyperRectangle(csg.left), HyperRectangle(csg.right))
end

function HyperRectangle(s::Shell)
    HyperRectangle(s.primitive)
end
