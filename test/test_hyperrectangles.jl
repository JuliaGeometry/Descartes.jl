
let
    c = Cuboid([1,2,3], [4,5,6])
    @test HyperRectangle(c) == HyperRectangles.HyperRectangle{Int64,3}([4,5,6],[5,7,9])
end
