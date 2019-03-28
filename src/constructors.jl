function Cuboid(dims)
    @assert length(dims) == 3
    Cuboid(SVector{3}(dims), SMatrix{4,4}(one(dims[1])*I), SMatrix{4,4}(one(dims[1])*I))
end

#= function RoundedCuboid{T}(dims::Vector{T},axes::Vector{Bool},r)
    @assert length(dims) == 3
    RoundedCuboid(dims, axes, convert(T,r), eye(4), eye(4))
end =#

function Cylinder(r, h)
    rn, hn = promote(r,h)
    Cylinder(rn, hn, SMatrix{4,4}(one(rn)*I), SMatrix{4,4}(one(rn)*I))
end

function Sphere(r::T) where {T}
    Sphere(r, SMatrix{4,4}(one(r)*I), SMatrix{4,4}(one(r)*I))
end

#function PrismaticCylinder(sides, height::T, radius::T) where {T}
#    PrismaticCylinder(sides, height, radius, Matrix(1.0*I,4,4), Matrix(1.0*I,4,4))
#end

function Piping(r, pts)
    Piping(r, pts, SMatrix{4,4}(one(r)*I), SMatrix{4,4}(one(r)*I))
end

# CSG

# Union
function CSGUnion(l::AbstractPrimitive{N1,T1}, r::AbstractPrimitive{N2,T2}) where {N1, N2, T1, T2}
    N1 == N2 || error("cannot create CSG between objects in R$N1 and R$N2")
    return CSGUnion{N1,T1, typeof(l), typeof(r)}(l,r)
end

function CSGUnion(l::AbstractPrimitive{N1,T1}, r::AbstractPrimitive{N2,T2}...) where {N1, N2, T1, T2}
    N1 == N2 || error("cannot create CSG between objects in R$N1 and R$N2")
    return CSGUnion(l,CSGUnion(r[1], r[2:end]...))
end

CSGUnion(x::AbstractPrimitive) = x
CSGUnion(::Nothing, x::AbstractPrimitive) = x
CSGUnion(x::AbstractPrimitive, ::Nothing) = x


# Radiused Union
function RadiusedCSGUnion(radius::Real, l::AbstractPrimitive{N1,T1}, r::AbstractPrimitive{N2,T2}) where {N1, N2, T1, T2}
    N1 == N2 || error("cannot create CSG between objects in R$N1 and R$N2")
    return RadiusedCSGUnion{N1,T1, typeof(l), typeof(r)}(radius,l,r)
end

# diff
function CSGDiff(l::AbstractPrimitive{N1,T1}, r::AbstractPrimitive{N2,T2}) where {N1, N2, T1, T2}
    N1 == N2 || error("cannot create CSG between objects in R$N1 and R$N2")
    return CSGDiff{N1,T1, typeof(l), typeof(r)}(l,r)
end

function CSGDiff(l::AbstractPrimitive{N1,T1}, r::AbstractPrimitive{N2,T2}...) where {N1, N2, T1, T2}
    N1 == N2 || error("cannot create CSG between objects in R$N1 and R$N2")
    return CSGDiff(l,CSGUnion(r[1], r[2:end]...))
end

CSGDiff(x::AbstractPrimitive) = x
CSGDiff(::Nothing, x::AbstractPrimitive) = x
CSGDiff(x::AbstractPrimitive, ::Nothing) = x


function CSGIntersect(l::AbstractPrimitive{N1,T1}, r::AbstractPrimitive{N2,T2}) where {N1, N2, T1, T2}
    N1 == N2 || error("cannot create CSG between objects in R$N1 and R$N2")
    return CSGIntersect{N1,T1, typeof(l), typeof(r)}(l,r)
end

CSGIntersect(x::AbstractPrimitive) = x
CSGIntersect(::Nothing, x::AbstractPrimitive) = x
CSGIntersect(x::AbstractPrimitive, ::Nothing) = x

# Shell

function Shell(r)
    Shell(nothing, r)
end
