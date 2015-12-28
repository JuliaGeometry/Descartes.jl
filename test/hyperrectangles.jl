let
    c = translate([4,5,6])Cuboid([1,2,3])
    @test HyperRectangle(c) == HyperRectangle{3,Float64}(Vec(4,5,6),Vec(1,2,3))
end
