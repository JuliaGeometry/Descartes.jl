#
using Descartes

#----------------------------------
p  = Circle(1.0)
xy = rand(2,10)

@show f = FRep(p,xy[:,1]) |> size
@show f = FRep(p,xy) |> size
@show f = FRep(p,xy[1,:],xy[2,:]) |> size
#----------------------------------

p   = Sphere(1.0)
xyz = rand(3,10)

@show f = FRep(p,xyz[:,1]) |> size
@show f = FRep(p,xyz) |> size
@show f = FRep(p,xyz[1,:],xyz[2,:],xyz[3,:]) |> size
#----------------------------------

p   = Square([1.0,1.0],center=true)
xyz = rand(3,10)

@show f = FRep(p,xy[:,1]) |> size
@show f = FRep(p,xy) |> size
@show f = FRep(p,xy[1,:],xy[2,:]) |> size
#----------------------------------

p   = Cuboid([1.0,1.0,1.0],center=true)
xyz = rand(3,10)

@show f = FRep(p,xyz[:,1]) |> size
@show f = FRep(p,xyz) |> size
@show f = FRep(p,xyz[1,:],xyz[2,:],xyz[3,:]) |> size
#----------------------------------

p   = Cylinder(1.0,1.0,1.0)
xyz = rand(3,10)

@show f = FRep(p,xyz[:,1]) |> size
@show f = FRep(p,xyz) |> size
@show f = FRep(p,xyz[1,:],xyz[2,:],xyz[3,:]) |> size
#----------------------------------
return
