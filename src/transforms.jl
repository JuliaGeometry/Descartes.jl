abstract AbstractTransform{N, T}

type Transform{N,T} <: AbstractTransform{N,T}
    transform::Matrix{T}
end

function translate(vect::Vector)
    n = length(vect)
    N = n + 1
    transform = eye(N)
    transform[1:n, N] = vect
    Transform{n, Float64}(transform)
end

function (*){N,T}(transform::Transform{N,Float64}, obj::AbstractPrimitive{N,T})
    obj.transform = obj.transform*transform.transform
    obj.inv_transform = inv(obj.transform)
    obj
end
