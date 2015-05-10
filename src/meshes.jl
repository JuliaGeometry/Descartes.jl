import Meshes: Mesh

function Mesh{T}(primitive::AbstractPrimitive{3, T}, resolution=0.1)
    bounds = HyperRectangle(primitive)
    x_min, y_min, z_min = bounds.min
    x_max, y_max, z_max = bounds.max

    x_rng, y_rng, z_rng = bounds.max - bounds.min

    nx = ceil(Int, x_rng/resolution)
    ny = ceil(Int, y_rng/resolution)
    nz = ceil(Int, z_rng/resolution)

    vol = Array{Float64}(nx+1, ny+1, nz+1)

    @show size(vol)

    @fastmath for i = 0:nx, j = 0:ny, k = 0:nz
        x = x_min + resolution*i
        y = y_min + resolution*j
        z = z_min + resolution*k
        @inbounds vol[i+1,j+1,k+1] = FRep(primitive,x,y,z)
    end
    Meshes.isosurface(vol, 0.0)
end
