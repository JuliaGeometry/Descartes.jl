
# test cube
let
    c1 = Cuboid([1,1,1])
    c2 = Cuboid([1,1,1])
    c3 = Cuboid([0,1,1])
    @test isequal(c1, c2)
    @test !isequal(c1,c3)
end
