
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

abstract AbstractFRep{N,T} <: AbstractPrimitive{N, T}

immutable FRep{N, T} <: AbstractFRep{N,T}
    primitive::AbstractPrimitive{N,T}
    func::Function
end

call{T<:FRep}(f::T, x...) = f.func(x...)
