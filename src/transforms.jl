abstract AbstractTransform{N, T}

type Translation{N,T} <: AbstractTransform{N,T}
    location::NTuple{N, T}
end

function (*){N,T}(translation::Translation{N,T}, obj::AbstractPrimitive{N,T})
    translate(obj, translation.location)
end

function translate{T}(c::Cuboid{3,T}, loc::NTuple{3,T})
    new_loc = (c.location[1]+loc[1], c.location[2]+loc[2], c.location[3]+loc[3])
    Cuboid{3,T}(c.dimensions, new_loc)
end

function translate{T}(c::Sphere{3,T}, loc::NTuple{3,T})
    new_loc = (c.location[1]+loc[1], c.location[2]+loc[2], c.location[3]+loc[3])
    Sphere{3,T}(c.radius, new_loc)
end
