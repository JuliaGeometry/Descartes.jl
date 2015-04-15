import HyperRectangles: HyperRectangle

function HyperRectangle{T}(cube::Cuboid{T})
    HyperRectangle{T,3}(cube.location, cube.location+cube.dimensions)
end
