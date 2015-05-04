type Shell{T} <: AbstractPrimitive{3,T}
    primitive::T
    distance
end

function Shell(r)
    Shell(nothing, r)
end

function (*){N,T}(s::Shell{Void}, obj::AbstractPrimitive{N,T})
    Shell(obj, s.distance)
end

