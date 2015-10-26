abstract AbstractPrimitive{N, T} # dimensionality, numeric type
abstract AbstractCSGTree{N,T} <: AbstractPrimitive{N, T}
abstract AbstractOperation{N,T} <: AbstractPrimitive{N,T}
abstract AbstractTransform{N,T}

# Geometric Primitives

type Cuboid{T} <: AbstractPrimitive{3, T}
    dimensions::Vector{T}
    transform::Matrix{Float64}
    inv_transform::Matrix{Float64}
end

type RoundedCuboid{T} <: AbstractPrimitive{3, T}
    dimensions::Vector{T}
    axes::Vector{Bool}
    radius::T
    transform::Matrix{Float64}
    inv_transform::Matrix{Float64}
end

type Cylinder{T} <: AbstractPrimitive{3, T}
    radius::T
    height::T
    transform::Matrix{Float64}
    inv_transform::Matrix{Float64}
end

type Sphere{T} <: AbstractPrimitive{3, T}
    radius::T
    transform::Matrix{Float64}
    inv_transform::Matrix{Float64}
end

type Ellipsoid{T} <: AbstractPrimitive{3, T}
    dimensions::Vector{T}
    transform::Matrix{Float64}
    inv_transform::Matrix{Float64}
end

type EllipticCylinder{T} <: AbstractPrimitive{3, T}
    dimensions::Vector{T}
    height::T
    transform::Matrix{Float64}
    inv_transform::Matrix{Float64}
end

type PrismaticCylinder{T} <: AbstractPrimitive{3, T}
    sides::Int
    height::T
    radius::T
    transform::Matrix{Float64}
    inv_transform::Matrix{Float64}
end

type Pipe{T} <: AbstractPrimitive{3, T}
    radius::T
    points::Vector{Point{3,T}}
    transform::Matrix{Float64}
    inv_transform::Matrix{Float64}
end

type Polygon{T} <: AbstractPrimitive{2, T}
    points::Vector{Vector{T}}
    transform::Matrix{Float64}
    inv_transform::Matrix{Float64}
end

# transforms

type Transform{N,T} <: AbstractTransform{N,T}
    transform::Matrix{T}
end


# CSG
# http://en.wikipedia.org/wiki/Constructive_solid_geometry

immutable CSGUnion{N, T, L, R} <: AbstractCSGTree{N, T}
    left::L
    right::R
end

immutable RadiusedCSGUnion{N, T, L, R} <: AbstractCSGTree{N, T}
    radius::T
    left::L
    right::R
end

immutable CSGDiff{N, T, L, R} <: AbstractCSGTree{N, T}
    left::L
    right::R
end

immutable CSGIntersect{N, T, L, R} <: AbstractCSGTree{N, T}
    left::L
    right::R
end

# Operations

type Shell{T} <: AbstractPrimitive{3,T}
    primitive::T
    distance
end
