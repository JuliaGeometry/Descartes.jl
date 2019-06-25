
@testset "Meshing" begin
    c = HomogenousMesh(translate([4,5,6])Cuboid([1,2,3]))
    @test_broken length(c.vertices) == 7638
    @test_broken length(c.faces) == 15272


    @testset "Radiused Shelled Box" begin
        c2 = Cuboid([4,4.0,4])
        cyl1 = rotate(pi/6, [1,0,0])translate([2,2,0])Cylinder(1.0,10.0)

        u = Shell(0.5)RadiusedCSGUnion(1,c2, cyl1)
        u2 = CSGDiff(u, Cuboid([2,2,2]))

        m = HomogenousMesh(u2)
        @test_broken length(m.vertices) == 86406
        @test_broken length(m.faces) == 172678
    end
end
