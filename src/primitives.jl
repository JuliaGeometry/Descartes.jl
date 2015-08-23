
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

type RoundedCuboid{T} <: AbstractPrimitive{3, T}
    dimensions::Vector{T}
    axes::Vector{Bool}
    radius::T
    transform::Matrix{Float64}
    inv_transform::Matrix{Float64}
end

function RoundedCuboid{T}(dims::Vector{T},axes::Vector{Bool},r)
    @assert length(dims) == 3
    RoundedCuboid(dims, axes, convert(T,r), eye(4), eye(4))
end

type Cylinder{T} <: AbstractPrimitive{3, T}
    radius::T
    height::T
    transform::Matrix{Float64}
    inv_transform::Matrix{Float64}
end

function Cylinder(r, h)
    rn, hn = promote(r,h)
    Cylinder(rn, hn, eye(4), eye(4))
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

type Pipe{T} <: AbstractPrimitive{3, T}
    radius::T
    points::Vector{Vector{T}}
    transform::Matrix{Float64}
    inv_transform::Matrix{Float64}
end

function Pipe(r, pts)
    Pipe(r, pts, eye(4), eye(4))
end

type Polygon{T} <: AbstractPrimitive{2, T}
    points::Vector{Vector{T}}
    transform::Matrix{Float64}
    inv_transform::Matrix{Float64}
end
