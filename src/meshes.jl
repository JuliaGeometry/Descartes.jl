import Meshes: Mesh

function Mesh{T}(primitive::AbstractPrimitive{3, T}, points=(100,100,100))
    bounds = HyperRectangle(primitive)
    x_min, y_min, z_min = bounds.min-1
    x_max, y_max, z_max = bounds.max+1

    x_rng, y_rng, z_rng = bounds.max - bounds.min+2

    vol = Array{Float64}(points)

    nx = points[1]
    ny = points[2]
    nz = points[3]

    @fastmath for i = 1:nx, j = 1:ny, k = 1:nz
        x = x_min + x_rng*(i/nx)
        y = y_min + y_rng*(j/ny)
        z = z_min + z_rng*(k/nz)
        @inbounds vol[i,j,k] = FRep(primitive,x,y,z)
    end
    Meshes.isosurface(vol, 0.0)
end
