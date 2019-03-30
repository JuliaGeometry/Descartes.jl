
@testset "Meshing" begin
    c = HomogenousMesh(translate([4,5,6])Cuboid([1,2,3]))
    @test length(vertices(c)) == 7638
    @test length(faces(c)) == 15272
end
