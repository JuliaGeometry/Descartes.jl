import HyperRectangles: HyperRectangle

function HyperRectangle{T}(cube::Cuboid{T})
    HyperRectangle{T,3}(cube.location, cube.location+cube.dimensions)
end

function HyperRectangle{T}(sphere::Sphere{T})
    HyperRectangle{T,3}(sphere.location-sphere.radius, sphere.location+sphere.radius)
end
