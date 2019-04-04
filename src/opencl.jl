# Test if we can sample an SDF of a sphere
# take this output and mesh it

mandel_source = "
#pragma OPENCL EXTENSION cl_khr_byte_addressable_store : enable
__kernel void mandelbrot(__global ushort *output,
                         float3 const size,
                         float3 const mins,
                         float const resolution)
{
    int gid = get_global_id(0);
    float nreal, real = 0;
    float imag = 0;
    output[gid] = 0;

    x_v = mins.x + resolution*gid
    y_v = mins.y + resolution*gid*
}";


function descartes_opencl(primitive::AbstractPrimitive, resolution=0.1) where {T}

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
    w = b_max-o
    bounds = HyperRectangle(o..., w...)

    # Setup OpenCL
    device, ctx, queue = cl.create_compute_context()

    out = Array(Float32, size(q))

    o_buff = cl.Buffer(Float32, ctx, :w, length(out))

    # TODO
    prg = cl.Program(ctx, source=mandel_source) |> cl.build!

    # # TODO this seem like the dimensions will be off a little since
    # # e resize the bounds and do not update the resolution
    # for i = 0:nx, j = 0:ny, k = 0:nz
    #     x = x_min + resolution*i
    #     y = y_min + resolution*j
    #     z = z_min + resolution*k
    #     @inbounds vol[i+1,j+1,k+1] = FRep(primitive,x,y,z)
    # end

    k = cl.Kernel(prg, "descartes")
    cl.call(queue, k, length(out), nothing, q_buff,
            (nx,ny,nz), (x_min, y_min, z_min), resolution)
    cl.copy!(queue, out, o_buff)

    SignedDistanceField{3,Float32,Float32}(bounds, out)
end
