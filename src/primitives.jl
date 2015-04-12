
abstract AbstractPrimitive{N, T} # dimensionality, numeric type

type Cuboid{T} <: AbstractPrimitive{3, T}
    dimensions::NTuple{3, T}
    location::NTuple{3, T}
end

type Cylinder{T} <: AbstractPrimitive{3, T}
    radius::T
    height::T
    location::NTuple{3, T}
end

type Sphere{T} <: AbstractPrimitive{3, T}
    radius::T
    location::NTuple{3, T}
end

type Ellipsoid{T} <: AbstractPrimitive{3, T}
    dimensions::NTuple{3, T}
    location::NTuple{3, T}
end

type EllipticCylinder{T} <: AbstractPrimitive{3, T}
    dimensions::NTuple{2, T}
    height::T
    location::NTuple{3, T}
end

type PrismaticCylinder{T} <: AbstractPrimitive{3, T}
    sides::Int
    height::T
    apothem::T
    location::NTuple{3, T}
end
