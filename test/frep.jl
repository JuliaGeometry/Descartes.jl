#
@testset "FReps" begin
    N = 10
    xy  = rand(2,N)
    xyz = rand(3,N)

    x = rand(1,N)
    y = rand(1,N)
    z = rand(1,N)
    #----------------------------------

    p  = Circle(1.0)
    
    #@test FRep(p,xy[:,1]) |> size == ()
    #@test FRep(p,xy)      |> size == (1,N)
    #@test FRep(p,x,y)     |> size == (1,N)
    #----------------------------------
    
    p = Square([1.0,1.0],center=true)
    
    #@test FRep(p,xy[:,1]) |> size == ()
    #@test FRep(p,xy)      |> size == (1,N)
    #@test FRep(p,x,y)     |> size == (1,N)
    #----------------------------------
    
    p = Sphere(1.0)
    
    #@test FRep(p,xyz[:,1]) |> size == ()
    #@test FRep(p,xyz)      |> size == (1,N)
    #@test FRep(p,x,y,z)    |> size == (1,N)
    #----------------------------------
    
    p = Cuboid([1.0,1.0,1.0],center=true)
    
    #@test FRep(p,xyz[:,1]) |> size == ()
    #@test FRep(p,xyz)      |> size == (1,N)
    #@test FRep(p,x,y,z)    |> size == (1,N)
    #----------------------------------
    
    p = Cylinder(1.0,1.0,1.0)
    
    #@test FRep(p,xyz[:,1]) |> size == ()
    #@test FRep(p,xyz)      |> size == (1,N)
    #@test FRep(p,x,y,z)    |> size == (1,N)
    #----------------------------------
    
    p = LinearExtrude(Circle(1.0),2.0)
    
    #@test FRep(p,xyz[:,1]) |> size == ()
    #@test FRep(p,xyz)      |> size == (1,N)
    #@test FRep(p,x,y,z)    |> size == (1,N)
    #----------------------------------
    c = translate([1.0,0.0])Circle(1.0)
    s = translate([0.0,1.0])Square([3.0,3.0];center=true)
    p = diff(s,c)
    
    #@test FRep(p,xy[:,1]) |> size == ()
    #@test FRep(p,xy)      |> size == (1,N)
    #@test FRep(p,x,y)     |> size == (1,N)
    #----------------------------------
    p = Piping(1.0, [[0,0,0],[10,0,0],[10,10,0],[10,10,10],[5,5,5]])
    
    #@test FRep(p,xyz[:,1]) |> size == ()
    #@test FRep(p,xyz)      |> size == (1,N)
    #@test FRep(p,x,y,z)    |> size == (1,N)
    #----------------------------------
end
