function HyperRectangle{T}(cube::Cuboid{T})
    orig = HyperRectangle{3,T}(Vec(0,0,0), Vec(cube.dimensions))
    transform(cube.transform, orig)
end

function HyperRectangle{T}(sphere::Sphere{T})
    orig = HyperRectangle{3,T}(fill(-sphere.radius,3), fill(sphere.radius*2,3))
    transform(sphere.transform, orig)
end

function HyperRectangle{T}(p::Cylinder{T})
    orig = HyperRectangle{3,T}(Vec(-p.radius,-p.radius,0), Vec(p.radius*2,p.radius*2,p.height))
    transform(p.transform, orig)
end

function HyperRectangle{T}(p::Piping{T})
    maxx, maxy, maxz = typemin(Float64), typemin(Float64), typemin(Float64)
    minx, miny, minz = typemax(Float64), typemax(Float64), typemax(Float64)
    for pt in p.points
        newx, newy, newz = transform(p.transform, pt)
        maxx = max(newx,maxx)
        maxy = max(newy,maxy)
        maxz = max(newz,maxz)
        minx = min(newx,minx)
        miny = min(newy,miny)
        minz = min(newz,minz)
    end
    minv = Vec(minx,miny,minz) .- p.radius
    maxv = Vec(maxx,maxy,maxz) .+ p.radius
    HyperRectangle(minv, maxv-minv)
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
