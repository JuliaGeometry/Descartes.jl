abstract type AbstractPrimitive{N, T} end # dimensionality, numeric type
abstract type AbstractCSGTree{N,T} <: AbstractPrimitive{N, T} end
abstract type AbstractOperation{N,T} <: AbstractPrimitive{N,T} end
abstract type AbstractTransform{N,T} end

# Geometric Primitives

mutable struct Cuboid{T} <: AbstractPrimitive{3, T}
    dimensions::Vector{T}
    transform::Matrix{Float64}
    inv_transform::Matrix{Float64}
end

mutable struct Cylinder{T} <: AbstractPrimitive{3, T}
    radius::T
    height::T
    transform::Matrix{Float64}
    inv_transform::Matrix{Float64}
end

mutable struct Sphere{T} <: AbstractPrimitive{3, T}
    radius::T
    transform::Matrix{Float64}
    inv_transform::Matrix{Float64}
end

mutable struct Piping{T} <: AbstractPrimitive{3, T}
    radius::T
    points::Vector{Point{3,T}}
    transform::Matrix{Float64}
    inv_transform::Matrix{Float64}
end

# transforms

mutable struct Transform{N,T} <: AbstractTransform{N,T}
    transform::Matrix{T}
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
