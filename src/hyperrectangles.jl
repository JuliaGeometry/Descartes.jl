import HyperRectangles: HyperRectangle

function HyperRectangle{T}(cube::Cuboid{T})
    HyperRectangle{T,3}(cube.location, cube.location+cube.dimensions)
end

function HyperRectangle{T}(sphere::Sphere{T})
    HyperRectangle{T,3}(sphere.location-sphere.radius, sphere.location+sphere.radius)
end

function HyperRectangle{N, T, L, R}(csg::CSGUnion{N, T, L, R})
    union(HyperRectangle(csg.left), HyperRectangle(csg.right))
end

function HyperRectangle{N, T, L, R}(csg::CSGIntersect{N, T, L, R})
    intersect(HyperRectangle(csg.left), HyperRectangle(csg.right))
end

function HyperRectangle{N, T, L, R}(csg::CSGDiff{N, T, L, R})
    diff(HyperRectangle(csg.left), HyperRectangle(csg.right))
end
