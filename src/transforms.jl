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

@inline function transform{T}(it::Array{T,2}, _x, _y, _z)
    @inbounds x = _x*it[1,1]+_y*it[1,2]+_z*it[1,3]+it[1,4]
    @inbounds y = _x*it[2,1]+_y*it[2,2]+_z*it[2,3]+it[2,4]
    @inbounds z = _x*it[3,1]+_y*it[3,2]+_z*it[3,3]+it[3,4]
    x, y, z
end
