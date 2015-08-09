import Meshes: Mesh

function Mesh{T}(primitive::AbstractPrimitive{3, T}, resolution=0.1)
    distancefield = DistanceField(primitive, resolution)
    Meshes.Mesh(distancefield.array, 0.0)
end
