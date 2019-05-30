@testset "Distance Fields" begin

    c = SignedDistanceField(translate([4,5,6])Cuboid([1,2,3]))

    @test size(c.data) == (11,21,31)
    @test c.bounds == HyperRectangle(Vec(4,5,6),Vec(1,2,3))

    @test_broken s = SignedDistanceField(translate([4,5,6])Sphere(3),0.1,true)

    @test_broken size(s.data)
    @test_broken s.bounds
    #@test size(s.data) == (11,21,31)
    #@test s.bounds == HyperRectangle(Vec(1,2,3),Vec(3,3,3))
end
