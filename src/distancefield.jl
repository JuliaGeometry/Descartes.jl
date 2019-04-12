function SignedDistanceField(primitive::AbstractPrimitive{3,T},
                                resolution=0.1) where {T}
    bounds = HyperRectangle(primitive)
    x_min, y_min, z_min = minimum(bounds)
    x_max, y_max, z_max = maximum(bounds)

    x_rng, y_rng, z_rng = maximum(bounds) - minimum(bounds)

    nx = ceil(Int, x_rng/resolution)
    ny = ceil(Int, y_rng/resolution)
    nz = ceil(Int, z_rng/resolution)

    vol = Array{Float32}(undef,nx+1, ny+1, nz+1)

    b_max = SVector(x_min + resolution*nx, y_min + resolution*ny, z_min + resolution*nz)

    # re-adjust bounding box
    o = SVector{3,Float32}(origin(bounds)...)
    w = SVector{3,Float32}(b_max-o)
    bounds = HyperRectangle(o..., w...)

    # TODO this seem like the dimensions will be off a little since
    # e resize the bounds and do not update the resolution
    for i = 0:nx, j = 0:ny, k = 0:nz
        x = x_min + resolution*i
        y = y_min + resolution*j
        z = z_min + resolution*k
        @inbounds vol[i+1,j+1,k+1] = FRep(primitive,x,y,z)
    end

    SignedDistanceField{3,Float32,Float32}(bounds, vol)
end
