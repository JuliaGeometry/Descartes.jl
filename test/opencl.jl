@testset "OpenCL" begin
    s = Descartes.Sphere(2)
    Descartes.opencl_sdf(s)

end
