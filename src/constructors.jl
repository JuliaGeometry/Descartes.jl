function Cuboid{T}(dims::Vector{T})
    @assert length(dims) == 3
    Cuboid(dims, eye(4), eye(4))
end

function RoundedCuboid{T}(dims::Vector{T},axes::Vector{Bool},r)
    @assert length(dims) == 3
    RoundedCuboid(dims, axes, convert(T,r), eye(4), eye(4))
end

function Cylinder(r, h)
    rn, hn = promote(r,h)
    Cylinder(rn, hn, eye(4), eye(4))
end

function Sphere{T}(r::T)
    Sphere(r, eye(4), eye(4))
end

function PrismaticCylinder{T}(sides, height::T, radius::T)
    PrismaticCylinder(sides, height, radius, eye(4), eye(4))
end

function Piping(r, pts)
    Piping(r, pts, eye(4), eye(4))
end

# CSG

# Union
function CSGUnion{N1, N2, T1, T2}(l::AbstractPrimitive{N1,T1}, r::AbstractPrimitive{N2,T2})
    N1 == N2 || error("cannot create CSG between objects in R$N1 and R$N2")
    return CSGUnion{N1,T1, typeof(l), typeof(r)}(l,r)
end

function CSGUnion{N1, N2, T1, T2}(l::AbstractPrimitive{N1,T1}, r::AbstractPrimitive{N2,T2}...)
    N1 == N2 || error("cannot create CSG between objects in R$N1 and R$N2")
    return CSGUnion(l,CSGUnion(r[1], r[2:end]...))
end

CSGUnion(x::AbstractPrimitive) = x
CSGUnion(::Void, x::AbstractPrimitive) = x
CSGUnion(x::AbstractPrimitive, ::Void) = x


# Radiused Union
function RadiusedCSGUnion{N1, N2, T1, T2}(radius::Real, l::AbstractPrimitive{N1,T1}, r::AbstractPrimitive{N2,T2})
    N1 == N2 || error("cannot create CSG between objects in R$N1 and R$N2")
    return RadiusedCSGUnion{N1,T1, typeof(l), typeof(r)}(radius,l,r)
end

# diff
function CSGDiff{N1, N2, T1, T2}(l::AbstractPrimitive{N1,T1}, r::AbstractPrimitive{N2,T2})
    N1 == N2 || error("cannot create CSG between objects in R$N1 and R$N2")
    return CSGDiff{N1,T1, typeof(l), typeof(r)}(l,r)
end

function CSGDiff{N1, N2, T1, T2}(l::AbstractPrimitive{N1,T1}, r::AbstractPrimitive{N2,T2}...)
    N1 == N2 || error("cannot create CSG between objects in R$N1 and R$N2")
    return CSGDiff(l,CSGUnion(r[1], r[2:end]...))
end

CSGDiff(x::AbstractPrimitive) = x
CSGDiff(::Void, x::AbstractPrimitive) = x
CSGDiff(x::AbstractPrimitive, ::Void) = x


function CSGIntersect{N1, N2, T1, T2}(l::AbstractPrimitive{N1,T1}, r::AbstractPrimitive{N2,T2})
    N1 == N2 || error("cannot create CSG between objects in R$N1 and R$N2")
    return CSGIntersect{N1,T1, typeof(l), typeof(r)}(l,r)
end

CSGIntersect(x::AbstractPrimitive) = x
CSGIntersect(::Void, x::AbstractPrimitive) = x
CSGIntersect(x::AbstractPrimitive, ::Void) = x

# Shell

function Shell(r)
    Shell(nothing, r)
end
