abstract AbstractTransform{N, T}

type Translation{N,T} <: AbstractTransform{N,T}
    location::NTuple{N, T}
end

function translate(x,y,z)
    Translation((x,y,z))
end

function (*){N,T}(translation::Translation{N,T}, obj::AbstractPrimitive{N,T})
    translate(obj, translation.location)
end
