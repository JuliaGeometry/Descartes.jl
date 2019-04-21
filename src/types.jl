abstract type AbstractPrimitive{N, T} end # dimensionality, numeric type
abstract type AbstractCSGTree{N,T} <: AbstractPrimitive{N, T} end
abstract type AbstractOperation{N,T} <: AbstractPrimitive{N,T} end
abstract type AbstractTransform{N,T} end

# Geometric Primitives

mutable struct Cuboid{T} <: AbstractPrimitive{3, T}
    dimensions::SVector{3,T}
    lowercorner::SVector{3,T}
    transform::SMatrix{4,4,T,16}
    inv_transform::SMatrix{4,4,T,16}
end

mutable struct Cylinder{T} <: AbstractPrimitive{3, T}
    radius::T
    height::T
    bottom::T
    transform::SMatrix{4,4,T,16}
    inv_transform::SMatrix{4,4,T,16}
end

mutable struct Sphere{T} <: AbstractPrimitive{3, T}
    radius::T
    transform::SMatrix{4,4,T,16}
    inv_transform::SMatrix{4,4,T,16}
end

mutable struct Piping{T} <: AbstractPrimitive{3, T}
    radius::T
    points::Vector{SVector{3,T}}
    transform::SMatrix{4,4,T,16}
    inv_transform::SMatrix{4,4,T,16}
end

# transforms

mutable struct Transform{N,T} <: AbstractTransform{N,T}
    transform::SMatrix{N,N,T} #TODO: where L?
end


# CSG
# http://en.wikipedia.org/wiki/Constructive_solid_geometry

struct CSGUnion{N, T, L, R} <: AbstractCSGTree{N, T}
    left::L
    right::R
end

struct RadiusedCSGUnion{N, T, L, R} <: AbstractCSGTree{N, T}
    radius::T
    left::L
    right::R
end

struct CSGDiff{N, T, L, R} <: AbstractCSGTree{N, T}
    left::L
    right::R
end

struct CSGIntersect{N, T, L, R} <: AbstractCSGTree{N, T}
    left::L
    right::R
end

# Operations

mutable struct Shell{T} <: AbstractPrimitive{3,T}
    primitive::T
    distance
end
