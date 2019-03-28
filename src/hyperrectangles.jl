function HyperRectangle(cube::Cuboid{T}) where {T}
    orig = HyperRectangle{3,T}(SVector{3}(0,0,0), SVector{3}(cube.dimensions))
    transform(cube.transform, orig)
end

function HyperRectangle(sphere::Sphere{T}) where {T}
    orig = HyperRectangle{3,T}(fill(-sphere.radius,3), fill(sphere.radius*2,3))
    transform(sphere.transform, orig)
end

function HyperRectangle(p::Cylinder{T}) where {T}
    orig = HyperRectangle{3,T}(Vec(-p.radius,-p.radius,0), Vec(p.radius*2,p.radius*2,p.height))
    transform(p.transform, orig)
end

function HyperRectangle(p::Piping{T}) where {T}
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

function HyperRectangle(csg::CSGUnion)
    union(HyperRectangle(csg.left), HyperRectangle(csg.right))
end

function HyperRectangle(csg::RadiusedCSGUnion)
    union(HyperRectangle(csg.left), HyperRectangle(csg.right))
end

function HyperRectangle(csg::CSGIntersect)
    intersect(HyperRectangle(csg.left), HyperRectangle(csg.right))
end

function HyperRectangle(csg::CSGDiff{N, T, L, R}) where {N, T, L, R}
    diff(HyperRectangle(csg.left), HyperRectangle(csg.right))
end

function HyperRectangle(s::Shell)
    HyperRectangle(s.primitive)
end
