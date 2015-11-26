let

    c = SignedDistanceField(translate([4,5,6])Cuboid([1,2,3]))

    @test size(c.data) == (11,21,31)
    @test c.bounds == HyperRectangle(Vec(4,5,6),Vec(5,7,9))
end
