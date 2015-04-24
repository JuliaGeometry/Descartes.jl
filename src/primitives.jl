
abstract AbstractPrimitive{N, T} # dimensionality, numeric type

type Cuboid{T} <: AbstractPrimitive{3, T}
    dimensions::Vector{T}
    transform::Matrix{Float64}
    inv_transform::Matrix{Float64}
end

function Cuboid{T}(dims::Vector{T})
    @assert length(dims) == 3
    Cuboid(dims, eye(4), eye(4))
end

type Cylinder{T} <: AbstractPrimitive{3, T}
    radius::T
    height::T
    transform::Matrix{Float64}
    inv_transform::Matrix{Float64}
end

function Cylinder{T}(r::T, h)
    Cylinder(r, h, eye(4), eye(4))
end


type Sphere{T} <: AbstractPrimitive{3, T}
    radius::T
    transform::Matrix{Float64}
    inv_transform::Matrix{Float64}
end

function Sphere{T}(r::T)
    Sphere(r, eye(4), eye(4))
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

function PrismaticCylinder{T}(sides, height::T, radius::T)
    PrismaticCylinder(sides, height, radius, eye(4), eye(4))
end

