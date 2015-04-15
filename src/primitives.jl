
abstract AbstractPrimitive{N, T} # dimensionality, numeric type

type Cuboid{T} <: AbstractPrimitive{3, T}
    dimensions::Vector{T}
    location::Vector{T}
end

type Cylinder{T} <: AbstractPrimitive{3, T}
    radius::T
    height::T
    location::Vector{T}
end

type Sphere{T} <: AbstractPrimitive{3, T}
    radius::T
    location::Vector{T}
end

type Ellipsoid{T} <: AbstractPrimitive{3, T}
    dimensions::Vector{T}
    location::Vector{T}
end

type EllipticCylinder{T} <: AbstractPrimitive{3, T}
    dimensions::Vector{T}
    height::T
    location::Vector{T}
end

type PrismaticCylinder{T} <: AbstractPrimitive{3, T}
    sides::Int
    height::T
    apothem::T
    location::Vector{T}
end
