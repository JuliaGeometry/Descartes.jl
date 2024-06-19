
@testset "Operations" begin
    for p in permutations(primitives_array, 2)
        for op in operations_array
            op(p...)
        end
    end

    function looped_op(;ct = 5, op = diff)

        hole_interval = 10/(ct + 1)

        c = Square([10,10])

        for i = 1:ct
            h = translate([hole_interval*i, 10/2])Circle(1)
            c = op(c, h)
        end
    end

    # test type stability of setops in a loop
    @test typeof(looped_op(;ct=3, op=diff)) == typeof(looped_op(;ct=5, op=diff))
    @test typeof(looped_op(;ct=3, op=union)) == typeof(looped_op(;ct=5, op=union))
    @test typeof(looped_op(;ct=3, op=intersect)) == typeof(looped_op(;ct=5, op=intersect))

end
