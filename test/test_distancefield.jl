let

    c = DistanceField(translate([4,5,6])Cuboid([1,2,3]))

    @test c.size == (11,21,31)
    @test c.bounds == HyperRectangle{Int64,3}([4,5,6],[5,7,9])
end
