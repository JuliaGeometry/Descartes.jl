let
    c = translate([4,5,6])Cuboid([1,2,3])
    @test HyperRectangle(c) == HyperRectangle{Int64,3}([4,5,6],[5,7,9])
end
