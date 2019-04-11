# Test if we can sample an SDF of a sphere
# take this output and mesh it


function opencl_sdf(p::AbstractPrimitive, resolution=0.1)

    # setup bounding boxes
    bounds = HyperRectangle(p)
    x_min, y_min, z_min = minimum(bounds)
    x_max, y_max, z_max = maximum(bounds)

    x_rng, y_rng, z_rng = maximum(bounds) - minimum(bounds)

    nx = ceil(Int, x_rng/resolution) + 1
    ny = ceil(Int, y_rng/resolution) + 1
    nz = ceil(Int, z_rng/resolution) + 1

    b_max = SVector{3,Float32}(x_min + resolution*nx, y_min + resolution*ny, z_min + resolution*nz)

    # re-adjust bounding box
    o = SVector{3,Float32}(origin(bounds)...)
    w = b_max-o
    bounds = HyperRectangle(o..., w...)

    # Setup OpenCL
    device, ctx, queue = cl.create_compute_context()

    # setup output and output buffers
    out = Array{Float32}(undef, nx*ny*nz)
    o_buff = cl.Buffer(Float32, ctx, :w, length(out))

    ## basic kernel template we will fill in with primitive sdf computations
    cl_source = "
    #pragma OPENCL EXTENSION cl_khr_byte_addressable_store : enable
    __kernel void descartes_kernel(__global float *output,
                             long3 const size,
                             float3 const mins,
                             float const resolution)
    {
        int gid = get_global_id(0);

        float x_v = mins.x + resolution*(gid%size.x);
        float y_v = mins.y + resolution*(convert_int_rtz(gid/size.x)%size.y);
        float z_v = mins.z + resolution*convert_int_rtz(gid/(size.x*size.y));
        ";

    # construct new kernel based on primitve data
    inner_src, ret_sig = cl_kernel_inner(p)
    cl_source = cl_source * inner_src * "output[gid]=$ret_sig;}"

    @show cl_source
    prg = cl.Program(ctx, source=cl_source) |> cl.build!

    k = cl.Kernel(prg, "descartes_kernel")
    cl.wait(queue(k, length(out), nothing, o_buff,
            (nx,ny,nz), (Float32(x_min), Float32(y_min), Float32(z_min)), Float32(resolution)))
    cl.wait(cl.copy!(queue, out, o_buff))

    #@show out
    # TODO change to float32
    SignedDistanceField{3,Float32,Float32}(bounds, reshape(out, (nx,ny,nz)))
end
