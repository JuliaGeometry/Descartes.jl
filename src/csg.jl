# http://en.wikipedia.org/wiki/Constructive_solid_geometry

function Base.union{T<:Real}(primitives::AbstractPrimitive{3,T}...)
    if length(primitives) == 1
        return primitives[1]
    elseif length(primitives) == 2
        return CSGUnion(primitives[1], primitives[2])
    else
        return CSGUnion(primitives[1], union(primitives[2:end]...))
    end
end

function Base.diff{T<:Real}(primitives::AbstractPrimitive{3,T}...)
    @show primitives
end

function Base.intersect{T<:Real}(primitives::AbstractPrimitive{3,T}...)
    @show primitives
end

