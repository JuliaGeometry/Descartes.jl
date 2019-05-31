@testset "HyperRectangles" begin
    c = translate([4,5,6])Cuboid([1,2,3])
    @test HyperRectangle(c) ==
          HyperRectangle{3,Float64}(SVector{3}(4,5,6),SVector{3}(1,2,3))
    s = Sphere(3)
    @show s
end
