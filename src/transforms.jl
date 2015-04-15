abstract AbstractTransform{N, T}

type Translation{N,T} <: AbstractTransform{N,T}
    location::Vector{T}
end

function (*){N,T}(translation::Translation{N,T}, obj::AbstractPrimitive{N,T})
    translate(obj, translation.location)
end

function translate{T}(c::Cuboid{T}, loc::Vector)
    Cuboid{T}(c.dimensions, c.location+loc)
end

function translate{T}(s::Sphere{T}, loc::Vector)
    Sphere{T}(s.radius, s.location+loc)
end
