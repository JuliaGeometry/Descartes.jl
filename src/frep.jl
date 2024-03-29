# http://en.wikipedia.org/wiki/Function_representation
#----------------------------------

"""
 Overloading CoordinateTransformations.Translation for vectorized implementation.
"""
function (trans::Translation{V})(x::AbstractMatrix) where {V}
    x .+ trans.translation
end

#function FRep(p::MapContainer{N,T,P}, v) where {N,T,P}
#    FRep(p.primitive, p.inv(v))
#end

function FRep(p::MapContainer{N,T,P}, v...) where {N,T,P}
    FRep(p.primitive, p.inv(vcat(v...)))
end
#----------------------------------

function FRep(u::CSGUnion, v...)
    min.(FRep(u.left, v...),FRep(u.right, v...))
end

function FRep(u::CSGDiff, v...)
    max.(FRep(u.left, v...), -FRep(u.right, v...))
end

function FRep(u::CSGIntersect, v...)
    max.(FRep(u.left, v...), FRep(u.right, v...))
end
#----------------------------------

function FRep(p::Sphere,v::AbstractVector)
    norm(v) - p.radius
end

function FRep(p::Sphere,x::AbstractMatrix,y::AbstractMatrix,z::AbstractMatrix)
    @assert size(x) == size(y) == size(z)
    @. sqrt(x*x + y*y + z*z) - p.radius
end

function FRep(p::Sphere,xyz::AbstractMatrix)
    @assert size(xyz)[1] == 3
    r2 = sum(xyz .* xyz,dims=1)
    @. sqrt(r2) - p.radius
end
#----------------------------------

function FRep(p::Cylinder,v::AbstractVector)
    x = v[1]
    y = v[2]
    z = v[3]
    max(-z+p.bottom, z-p.height-p.bottom, sqrt(x*x + y*y) - p.radius)
end

function FRep(p::Cylinder,x::AbstractMatrix,y::AbstractMatrix,z::AbstractMatrix)
    @assert size(x) == size(y) == size(z)
    r = @. sqrt(x*x + y*y) - p.radius
    a = @. -z+p.bottom
    b = @.  z-(p.height+p.bottom)
    max.(a, b, r)
end

function FRep(p::Cylinder,xyz::AbstractMatrix)
    @assert size(xyz)[1] == 3

    x = xyz[1,:]'
    y = xyz[2,:]'
    z = xyz[3,:]'
    fr = FRep(p,x,y,z)
end
#----------------------------------

function FRep(p::Circle, v::AbstractVector)
    norm(v) - p.radius
end

function FRep(p::Circle,x::AbstractMatrix,y::AbstractMatrix)
    @assert size(x) == size(y)
    @. sqrt(x*x + y*y) - p.radius
end

function FRep(p::Circle,xy::AbstractMatrix)
    @assert size(xy)[1] == 2
    r2 = sum(xy .* xy,dims=1)
    @. sqrt(r2) - p.radius
end
#----------------------------------

function FRep(p::Cuboid, v::AbstractVector)
    x = v[1]
    y = v[2]
    z = v[3]
    dx, dy, dz = p.dimensions
    lbx, lby,lbz = p.lowercorner
    max(-x+lbx, x-dx-lbx,
        -y+lby, y-dy-lby,
        -z+lbz, z-dz-lbz)
end

function FRep(p::Cuboid,x::AbstractMatrix,y::AbstractMatrix,z::AbstractMatrix)
    @assert size(x) == size(y) == size(z)
    dx, dy, dz = p.dimensions
    lbx, lby,lbz = p.lowercorner
    a = @. -x + lbx
    b = @.  x - (dx+lbx)
    c = @. -y + lby
    d = @.  y - (dy+lby)
    e = @. -z + lbz
    f = @.  z - (dz+lbz)
    max.(a,b,c,d,e,f)
end

function FRep(p::Cuboid,xyz::AbstractMatrix)
    @assert size(xyz)[1] == 3

    x = xyz[1,:]'
    y = xyz[2,:]'
    z = xyz[3,:]'
    fr = FRep(p,x,y,z)
end
#----------------------------------

function FRep(p::Square, v::AbstractVector)
    x = v[1]
    y = v[2]
    dx, dy = p.dimensions
    lbx, lby = p.lowercorner
    max(-x+lbx, x-dx-lbx,
        -y+lby, y-dy-lby)
end

function FRep(p::Square,x::AbstractMatrix,y::AbstractMatrix)
    @assert size(x) == size(y)
    dx, dy = p.dimensions
    lbx, lby = p.lowercorner
    a = @. -x + lbx
    b = @.  x - (dx+lbx)
    c = @. -y + lby
    d = @.  y - (dy+lby)

    max.(a,b,c,d)
end

function FRep(p::Square,xy::AbstractMatrix)
    @assert size(xy)[1] == 2

    x = xy[1,:]'
    y = xy[2,:]'
    fr = FRep(p,x,y)
end
#----------------------------------

function FRep(s::Shell, v)
    r = FRep(s.primitive, v)
    max.(r, -r .- s.distance)
end

#----------------------------------
function _radius(a::Real,b::Real,r::Real)
    if abs(a-b) >= r
        return min(a,b)
    else
        return b+r*sin(pi/4+asin((a-b)/(r*sqrt(2))))-r
    end
end

function _radius(a::AbstractVector,b::AbstractVector,c::AbstractVector)
    cond = @. (abs(a-b) >= r) # bit-vector
    ans1 = @. min(a,b)
    ans2 = @. b+r*sin(pi/4+asin((a-b)/(r*sqrt(2))))-r

    @. cond*ans1 + (1-cond)*ans2
end

function FRep(u::RadiusedCSGUnion, v)
    a = FRep(u.left, v)
    b = FRep(u.right, v)
    r = u.radius
    _radius(a,b,r)
end
#----------------------------------

function FRep(p::Piping{T}, v::AbstractVector) where {T}
    num_pts = length(p.points)

    val = typemax(T)

    for i = 1:num_pts-1
        e1 = p.points[i]
        e2 = p.points[i+1]
        v = e2 - e1
        w = v - e1
        if dot(w,v) <= 0
            nv = norm(v - e1)
        elseif dot(v,v) <= dot(w,v)
            nv = norm(v - e2)
        else
            nv = norm(cross(v-e1,v-e2))/norm(e2-e1)
        end
        val = min(nv, val)
    end
    val - p.radius
end

function FRep(p::Piping{T}, x::AbstractMatrix, y::AbstractMatrix, z::AbstractMatrix) where {T}

    xyz = vcat(x,y,z)
    collect(FRep(p,xyz[:,i]) for i in 1:size(xyz)[2])'
end

function FRep(p::Piping{T}, xyz::AbstractMatrix) where {T}
    @warn "F-Reps for Piping is not vectorized. switching to non-vectorized implementation" 

    collect(FRep(p,xyz[:,i]) for i in 1:size(xyz)[2])'
end
#----------------------------------

function FRep(p::LinearExtrude, v::AbstractVector)
    x = v[1]
    y = v[2]
    z = v[3]
    r = FRep(p.primitive, [x,y])
    max.(max.(-z,z-p.distance), r)
end

function FRep(p::LinearExtrude,x::AbstractMatrix,y::AbstractMatrix,z::AbstractMatrix)
    @assert size(x) == size(y) == size(z)

    xy = vcat(x,y)
    r = FRep(p.primitive,xy)
    @. max(max(-z,z-p.distance), r)
end

function FRep(p::LinearExtrude,xyz::AbstractMatrix)
    @assert size(xyz)[1] == 3

    x = xyz[1,:]'
    y = xyz[2,:]'
    z = xyz[3,:]'
    fr = FRep(p,x,y,z)

end
#----------------------------------
