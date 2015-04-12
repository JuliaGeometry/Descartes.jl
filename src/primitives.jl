
abstract AbstractPrimitive{N, T} # dimensionality, numeric type

type Cuboid{N, T} <: AbstractPrimitive{N, T}
    dimensions::NTuple{N, T}
    location::NTuple{N, T}
end

function translate{T}(c::Cuboid{3,T}, loc::NTuple{3,T})
    new_loc = (c.location[1]+loc[1], c.location[2]+loc[2], c.location[3]+loc[3])
    Cuboid{3,T}(c.dimensions, new_loc)
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
