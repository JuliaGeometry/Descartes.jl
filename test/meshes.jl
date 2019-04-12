
@testset "Meshing" begin
    c = HomogenousMesh(translate([4,5,6])Cuboid([1,2,3]))
    @test length(c.vertices) == 7638
    @test length(c.faces) == 15272
end
