@testset "Tranformations" begin

@testset "Rotations" begin

r1 = rotate(pi/6,[1.2,0,0])
r2 = rotate(pi/6,[0,3,0])
r3 = rotate(pi/6,[0,0,5.6])

sp = sin(pi/6)
cp = cos(pi/6)
@test all(r1.transform .≈ [1.0 0.0 0.0 0.0; 0.0 cp -sp 0.0; 0.0 sp cp 0.0; 0.0 0.0 0.0 1.0])
@test all(r2.transform .≈ [cp 0.0 sp 0.0; 0.0 1.0 0.0 0.0; -sp 0.0 cp 0.0; 0.0 0.0 0.0 1.0])
@test all(r3.transform .≈ [cp -sp 0.0 0.0; 0.5 cp 0.0 0.0; 0.0 0.0 1.0 0.0; 0.0 0.0 0.0 1.0])
end


end
