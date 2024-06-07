function HyperRectangle(square::Square{T}) where {T}
    HyperRectangle{2,T}(square.lowercorner, square.dimensions)
end

function HyperRectangle(cube::Cuboid{T}) where {T}
    HyperRectangle{3,T}(cube.lowercorner, cube.dimensions)
end

function HyperRectangle(sphere::Sphere{T}) where {T}
    HyperRectangle{3,T}(fill(-sphere.radius,3), fill(sphere.radius*2,3))
end

function HyperRectangle(p::Cylinder{T}) where {T}
    HyperRectangle{3,T}(Vec(-p.radius,-p.radius,0), Vec(p.radius*2,p.radius*2,p.height))
end

function HyperRectangle(p::Circle{T}) where {T}
    HyperRectangle{2,T}(Vec(-p.radius,-p.radius), Vec(p.radius*2,p.radius*2))
end

function HyperRectangle(p::Piping{T}) where {T}
    maxx, maxy, maxz = typemin(Float64), typemin(Float64), typemin(Float64)
    minx, miny, minz = typemax(Float64), typemax(Float64), typemax(Float64)
    for pt in p.points
        newx, newy, newz = pt
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

function HyperRectangle(m::MapContainer)
    transform(m.map, HyperRectangle(m.primitive))
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

function HyperRectangle(csg::CSGDiff)
    HyperRectangle(csg.left)
end

function HyperRectangle(s::Shell)
    HyperRectangle(s.primitive)
end

function HyperRectangle(s::LinearExtrude)
    h = HyperRectangle(s.primitive)
    HyperRectangle(Vec(h.origin[1], h.origin[2], 0), Vec(h.widths[1], h.widths[2], s.distance))
end

"""
Perform a union between two HyperRectangles.
"""
function union(h1::HyperRectangle, h2::HyperRectangle)
    m = min.(minimum(h1), minimum(h2))
    mm = max.(maximum(h1), maximum(h2))
    HyperRectangle(m, mm - m)
end


"""
Perform a difference between two HyperRectangles.
"""
diff(h1::HyperRectangle, h2::HyperRectangle) = h1


"""
Perform a intersection between two HyperRectangles.
"""
function intersect(h1::HyperRectangle, h2::HyperRectangle)
    m = max.(minimum(h1), minimum(h2))
    mm = min.(maximum(h1), maximum(h2))
    HyperRectangle(m, mm - m)
end
