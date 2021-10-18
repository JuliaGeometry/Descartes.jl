#
@testset "FReps" begin
    N = 10
    xy  = rand(2,N)
    xyz = rand(3,N)

    x = rand(N,N,N)
    y = rand(N,N,N)
    z = rand(N,N,N)
    #----------------------------------

    p  = Circle(1.0)
    
    @test FRep(p,xy[:,1]) |> size == ()
    @test FRep(p,xy)      |> size == (1,N)
    @test FRep(p,x,y)     |> size == (N,N,N)
    #----------------------------------
    
    p = Square([1.0,1.0],center=true)
    
    @test FRep(p,xy[:,1]) |> size == ()
    @test FRep(p,xy)      |> size == (1,N)
    @test FRep(p,x,y)     |> size == (N,N,N)
    #----------------------------------
    
    p = Sphere(1.0)
    
    @test FRep(p,xyz[:,1]) |> size == ()
    @test FRep(p,xyz)      |> size == (1,N)
    @test FRep(p,x,y,z)    |> size == (N,N,N)
    #----------------------------------
    
    p = Cuboid([1.0,1.0,1.0],center=true)
    
    @test FRep(p,xyz[:,1]) |> size == ()
    @test FRep(p,xyz)      |> size == (1,N)
    @test FRep(p,x,y,z)    |> size == (N,N,N)
    #----------------------------------
    
    p = Cylinder(1.0,1.0,1.0)
    
    @test FRep(p,xyz[:,1]) |> size == ()
    @test FRep(p,xyz)      |> size == (1,N)
    @test FRep(p,x,y,z)    |> size == (N,N,N)
    #----------------------------------
end
