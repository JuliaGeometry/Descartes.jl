using Descartes
using GeometryTypes
using Meshing
using StaticArrays
using OpenCL
using BenchmarkTools
# Test if we can sample an SDF of a sphere
# take this output and mesh it

sphere_source = "
#pragma OPENCL EXTENSION cl_khr_byte_addressable_store : enable
__kernel void sphere_test(__global double *output,
                         long3 const size,
                         float3 const mins,
                         float const resolution)
{
    int gid = get_global_id(0);
    float nreal, real = 0;
    float imag = 0;
    output[gid] = gid;

    float x_v = mins.x + resolution*(gid%size.x);
    float y_v = mins.y + resolution*(convert_int_rtz(gid/size.x)%size.y);
    float z_v = mins.z + resolution*convert_int_rtz(gid/(size.x*size.y));
    output[gid] = sqrt(pow(x_v,2) + pow(y_v,2) + pow(z_v,2)) -1;
}";


function descartes_opencl(resolution=0.01)

    bounds = HyperRectangle(-1.,-1.,-1.,2.,2.,2.)
    x_min, y_min, z_min = minimum(bounds)
    x_max, y_max, z_max = maximum(bounds)

    x_rng, y_rng, z_rng = maximum(bounds) - minimum(bounds)

    nx = ceil(Int, x_rng/resolution) + 1
    ny = ceil(Int, y_rng/resolution) + 1
    nz = ceil(Int, z_rng/resolution) + 1

    b_max = SVector(x_min + resolution*nx, y_min + resolution*ny, z_min + resolution*nz)

    # re-adjust bounding box
    o = SVector{3,Float32}(origin(bounds)...)
    w = b_max-o
    bounds = HyperRectangle(o..., w...)

    # Setup OpenCL
    device, ctx, queue = cl.create_compute_context()

    out = Array{Float64}(undef, nx*ny*nz)

    o_buff = cl.Buffer(Float64, ctx, :w, length(out))

    # TODO
    prg = cl.Program(ctx, source=sphere_source) |> cl.build!

    # # TODO this seem like the dimensions will be off a little since
    # # e resize the bounds and do not update the resolution
    # for i = 0:nx, j = 0:ny, k = 0:nz
    #     x = x_min + resolution*i
    #     y = y_min + resolution*j
    #     z = z_min + resolution*k
    #     @inbounds vol[i+1,j+1,k+1] = FRep(primitive,x,y,z)
    # end

    k = cl.Kernel(prg, "sphere_test")
    cl.wait(queue(k, length(out), nothing, o_buff,
            (nx,ny,nz), (Float32(x_min), Float32(y_min), Float32(z_min)), Float32(resolution)))
    cl.wait(cl.copy!(queue, out, o_buff))

    #@show out
    SignedDistanceField{3,Float64,Float64}(bounds, reshape(out, (nx,ny,nz)))
end

m = HomogenousMesh(descartes_opencl(),NaiveSurfaceNets())


#@show m
Descartes.save("sphere.ply",m)
