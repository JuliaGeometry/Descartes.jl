
abstract AbstractPrimitive{N, T} # dimensionality, numeric type

type Cuboid{N, T} <: AbstractPrimitive{N, T}
    dimensions::NTuple{N, T}
    location::NTuple{N, T}
end

type Cylinder{N, T} <: AbstractPrimitive{N, T}
    radius::T
    height::T
    location::NTuple{N, T}
end

type Sphere{N, T} <: AbstractPrimitive{N, T}
    radius::T
    location::NTuple{N, T}
end

abstract AbstractCSGTree{N,T} <: AbstractPrimitive{N, T}

immutable CSGUnion{N, T} <: AbstractCSGTree{N, T}
    left::AbstractPrimitive{N, T}
    right::AbstractPrimitive{N, T}
end

immutable CSGDiff{N, T} <: AbstractCSGTree{N, T}
    left::AbstractPrimitive{N, T}
    right::AbstractPrimitive{N, T}
end

immutable CSGIntersect{N, T} <: AbstractCSGTree{N, T}
    left::AbstractPrimitive{N, T}
    right::AbstractPrimitive{N, T}
end
