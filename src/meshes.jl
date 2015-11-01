function GeometryTypes.HomogenousMesh{T}(primitive::AbstractPrimitive{3, T},
                                         resolution=0.1)
    distancefield = SignedDistanceField(primitive, resolution)
    HomogenousMesh(distancefield.data, 0.0)
end
