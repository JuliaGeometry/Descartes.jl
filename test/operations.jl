
@testset "Operations" begin
    for p in permutations(primitives_array, 2)
        for op in operations_array
            op(p...)
        end
    end
end
