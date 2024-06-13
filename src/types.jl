abstract type AbstractPrimitive{N, T} end # dimensionality, numeric type
abstract type AbstractCSGSetOp{N,T} <: AbstractPrimitive{N, T} end

# 2D Geometric Primitives

struct Square{T} <: AbstractPrimitive{2, T}
    dimensions::SVector{2,T}
    lowercorner::SVector{2,T}
end

struct Circle{T} <: AbstractPrimitive{2, T}
    radius::T
end

# 3D Geometric Primitives

struct Cuboid{T} <: AbstractPrimitive{3, T}
    dimensions::SVector{3,T}
    lowercorner::SVector{3,T}
end

struct Cylinder{T} <: AbstractPrimitive{3, T}
    radius::T
    height::T
    bottom::T
end

struct Sphere{T} <: AbstractPrimitive{3, T}
    radius::T
end

struct Piping{T} <: AbstractPrimitive{3, T}
    radius::T
    points::Vector{SVector{3,T}}
end

# transforms

struct MapContainer{N, T, M, P<:AbstractPrimitive{N,T}} <: AbstractPrimitive{N,T}
    map::M
    inv::M
    primitive::P
end


# CSG
# http://en.wikipedia.org/wiki/Constructive_solid_geometry

struct CSGUnion{N, T, L, R} <: AbstractCSGSetOp{N, T}
    left::L
    right::Vector{R}
end

struct RadiusedCSGUnion{N, T, L, R} <: AbstractCSGSetOp{N, T}
    radius::T
    left::L
    right::R
end

"""
    CSGDiff{N, T, L, R} <: AbstractCSGSetOp{N, T}

A node in a Constructive Solid Geometry (CSG) tree representing the difference between two CSG objects.

The `left` and `right` fields represent the two CSG objects that are being subtracted.
"""
struct CSGDiff{N,T,L,R} <: AbstractCSGSetOp{N,T}
    left::L
    right::Vector{R}
end

struct CSGIntersect{N, T, L, R} <: AbstractCSGSetOp{N, T}
    left::L
    right::Vector{R}
end

# Operations

struct Shell{T} <: AbstractPrimitive{3,T}
    primitive::T
    distance
end

struct LinearExtrude{N, T, P} <: AbstractPrimitive{3,T}
    primitive::P
    distance::T
end

struct TriangleWave{T}
    period::T
end

"""
    Grid{T}

A simple grid structure with a `period` field of type `T`.
"""
struct Grid{T} <: AbstractPrimitive{2, T}
    period::T
end

struct PolarWarp{T} <: AbstractPrimitive{2, T}
    primitive
    w::T
end