# http://en.wikipedia.org/wiki/Constructive_solid_geometry

abstract AbstractCSGTree{N,T} <: AbstractPrimitive{N, T}


#
# CSGUnion
#

immutable CSGUnion{N, T, L, R} <: AbstractCSGTree{N, T}
    left::L
    right::R
end

function CSGUnion{N1, N2, T1, T2}(l::AbstractPrimitive{N1,T1}, r::AbstractPrimitive{N2,T2})
    N1 == N2 || error("cannot create CSG between objects in R$N1 and R$N2")
    return CSGUnion{N1,T1, typeof(l), typeof(r)}(l,r)
end

function CSGUnion{N1, N2, T1, T2}(l::AbstractPrimitive{N1,T1}, r::AbstractPrimitive{N2,T2}...)
    N1 == N2 || error("cannot create CSG between objects in R$N1 and R$N2")
    return CSGUnion(l,CSGUnion(r[1], r[2:end]...))
end

CSGUnion(x::AbstractPrimitive) = x

#
# RadiusedCSGUnion
#

immutable RadiusedCSGUnion{N, T, L, R} <: AbstractCSGTree{N, T}
    radius::T
    left::L
    right::R
end

function RadiusedCSGUnion{N1, N2, T1, T2}(radius::Real, l::AbstractPrimitive{N1,T1}, r::AbstractPrimitive{N2,T2})
    N1 == N2 || error("cannot create CSG between objects in R$N1 and R$N2")
    return RadiusedCSGUnion{N1,T1, typeof(l), typeof(r)}(radius,l,r)
end

#
# CSGDiff
#

immutable CSGDiff{N, T, L, R} <: AbstractCSGTree{N, T}
    left::L
    right::R
end

function CSGDiff{N1, N2, T1, T2}(l::AbstractPrimitive{N1,T1}, r::AbstractPrimitive{N2,T2})
    N1 == N2 || error("cannot create CSG between objects in R$N1 and R$N2")
    return CSGDiff{N1,T1, typeof(l), typeof(r)}(l,r)
end

function CSGDiff{N1, N2, T1, T2}(l::AbstractPrimitive{N1,T1}, r::AbstractPrimitive{N2,T2}...)
    N1 == N2 || error("cannot create CSG between objects in R$N1 and R$N2")
    return CSGDiff(l,CSGUnion(r[1], r[2:end]...))
end

CSGDiff(x::AbstractPrimitive) = x

#
# CSGIntersect
#

immutable CSGIntersect{N, T, L, R} <: AbstractCSGTree{N, T}
    left::L
    right::R
end

function CSGIntersect{N1, N2, T1, T2}(l::AbstractPrimitive{N1,T1}, r::AbstractPrimitive{N2,T2})
    N1 == N2 || error("cannot create CSG between objects in R$N1 and R$N2")
    return CSGIntersect{N1,T1, typeof(l), typeof(r)}(l,r)
end

