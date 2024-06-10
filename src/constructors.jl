function Square(dims;center=false)
    x = dims[1]
    y = dims[2]
    lb = SVector(0.,0.)
    center && (lb = -SVector{2,Float64}(x,y)/2)
    Square(SVector{2,Float64}(x,y), lb)
end

Square(x,y,z;center=false) = Square([x,y],center=center)

function Cuboid(dims::Union{AbstractVector,Tuple};center=false)
    @assert length(dims) == 3
    lb = SVector(0.,0.,0.)
    center && (lb = -SVector{3,Float64}(dims...)/2)
    Cuboid(SVector{3,Float64}(dims...), lb)
end

Cuboid(x,y,z;center=false) = Cuboid([x,y,z],center=center)

Cuboid(d;kwargs) = Cuboid((d,d,d);kwargs...)

#= function RoundedCuboid{T}(dims::Vector{T},axes::Vector{Bool},r)
    @assert length(dims) == 3
    RoundedCuboid(dims, axes, convert(T,r), eye(4), eye(4))
end =#

function Cylinder(r=1, h=1; center=false)
    rn, hn = Float64(r), Float64(h)
    b = 0.0
    center && (b = -h/2)
    Cylinder(rn, hn, b)
end

#function PrismaticCylinder(sides, height::T, radius::T) where {T}
#    PrismaticCylinder(sides, height, radius, Matrix(1.0*I,4,4), Matrix(1.0*I,4,4))
#end

function Piping(r, pts)
    ptsc = [SVector{3,Float64}(pt...) for pt in pts]
    Piping(Float64(r), ptsc)
end

#
# CSG Operations
#


function (::Type{CSGOp})(l::AbstractPrimitive{N,T}, right::AbstractPrimitive...) where {N, T, CSGOp <: AbstractCSGSetOp}
    for r in right
        if dim(l) !== dim(r)
            error("cannot create CSG between objects in R$N1 and R$N2")
        end
    end
    # This improves type stability if the CSG Type Tree is contructed by a loop
    if l isa AbstractCSGSetOp && eltype(l.right) == typeof(right[1])
        push!(l.right, right[1])
        if length(right) > 1
            return CSGOp(l, right[2:end]...)
        else
            return l
        end
    else
        return CSGOp(CSGOp{N, T, typeof(l), typeof(right[1])}(l, [right[1]]), right[2:end]...)
    end
end

function (::Type{CSGOp})(x::AbstractPrimitive) where {CSGOp <: AbstractCSGSetOp}
    x
end

function (::Type{CSGOp})(::Nothing, x::AbstractPrimitive) where {CSGOp <: AbstractCSGSetOp}
    x
end

function (::Type{CSGOp})(x::AbstractPrimitive, ::Nothing) where {CSGOp <: AbstractCSGSetOp}
    x
end

union(l::AbstractPrimitive, r::AbstractPrimitive...) = CSGUnion(l,r...)

union(x::AbstractPrimitive) = x
union(::Nothing, x::AbstractPrimitive) = x
union(x::AbstractPrimitive, ::Nothing) = x

# Radiused Union
function RadiusedCSGUnion(radius::Real, l::AbstractPrimitive{N1,T1}, r::AbstractPrimitive{N2,T2}) where {N1, N2, T1, T2}
    N1 == N2 || error("cannot create CSG between objects in R$N1 and R$N2")
    return RadiusedCSGUnion{N1,T1, typeof(l), typeof(r)}(radius,l,r)
end

diff(l::AbstractPrimitive, r::AbstractPrimitive...) = CSGDiff(l,r...)

diff(x::AbstractPrimitive) = x
diff(::Nothing, x::AbstractPrimitive) = x
diff(x::AbstractPrimitive, ::Nothing) = x

# Intersect

intersect(l::AbstractPrimitive, r::AbstractPrimitive...) = CSGIntersect(l,r...)

intersect(x::AbstractPrimitive) = x
intersect(::Nothing, x::AbstractPrimitive) = x
intersect(x::AbstractPrimitive, ::Nothing) = x

# Shell

function Shell(r)
    Shell(nothing, r)
end

function LinearExtrude(p::AbstractPrimitive{2,T}, d) where {T}
    #TODO promote type
    LinearExtrude{3, T, typeof(p)}(p, convert(T, d))
end
