# http://en.wikipedia.org/wiki/Constructive_solid_geometry

abstract AbstractCSGTree{N,T} <: AbstractPrimitive{N, T}

immutable CSGUnion{N, T, L, R} <: AbstractCSGTree{N, T}
    left::L
    right::R
end

function CSGUnion{N1, N2, T1, T2}(l::AbstractPrimitive{N1,T1}, r::AbstractPrimitive{N2,T2})
    N1 == N2 || error("cannot create CSG between objects in R$N1 and R$N2")
    return CSGUnion{N1,T1, typeof(l), typeof(r)}(l,r)
end

immutable CSGDiff{N, T, L, R} <: AbstractCSGTree{N, T}
    left::L
    right::R
end

immutable CSGIntersect{N, T, L, R} <: AbstractCSGTree{N, T}
    left::L
    right::R
end
