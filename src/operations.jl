function *(s::Shell{Nothing}, obj::AbstractPrimitive{N,T}) where {N,T}
    Shell(obj, s.distance)
end

function translate(vect::AbstractVector)
    Translation(vect...)
end

function *(transform::AbstractAffineMap, obj::PT) where {PT<:AbstractPrimitive}
    MapContainer(transform, inv(transform), obj)
end

function *(t::AbstractAffineMap, obj::MapContainer)
    c = compose(obj.map, t)
    MapContainer(c, inv(c), obj.primitive)
end

function *(a::AbstractAffineMap, b::AbstractAffineMap)
    compose(a,b)
end

function transform(t::AbstractAffineMap, h::HyperRectangle{3,T}) where {T}
    p_1 = t(h.origin)
    p_2 = t(h.widths)
    p_3 = t(SVector(h.origin[1]+h.widths[1],h.origin[2],h.origin[3]))
    p_4 = t(SVector(h.origin[1],h.origin[2]+h.widths[2],h.origin[3]))
    p_5 = t(SVector(h.origin[1],h.origin[2],h.origin[3]+h.widths[3]))
    p_6 = t(SVector(h.origin[1]+h.widths[1],h.origin[2],h.origin[3]+h.widths[3]))
    p_7 = t(SVector(h.origin[1],h.origin[2]+h.widths[2],h.origin[3]+h.widths[3]))
    p_8 = t(SVector(h.origin[1]+h.widths[1],h.origin[2]+h.widths[2],h.origin[3]))
    x_o = min(p_1[1],p_2[1],p_3[1],p_4[1],p_5[1],p_6[1],p_7[1],p_8[1])
    y_o = min(p_1[2],p_2[2],p_3[2],p_4[2],p_5[2],p_6[2],p_7[2],p_8[2])
    z_o = min(p_1[3],p_2[3],p_3[3],p_4[3],p_5[3],p_6[3],p_7[3],p_8[3])
    x_w = max(p_1[1],p_2[1],p_3[1],p_4[1],p_5[1],p_6[1],p_7[1],p_8[1])
    y_w = max(p_1[2],p_2[2],p_3[2],p_4[2],p_5[2],p_6[2],p_7[2],p_8[2])
    z_w = max(p_1[3],p_2[3],p_3[3],p_4[3],p_5[3],p_6[3],p_7[3],p_8[3])
    HyperRectangle(x_o, y_o, z_o, x_w-x_o, y_w-y_o, z_w-z_o)
end

function rotate(ang, axis::Vector)
    if !iszero(axis[1])
        return LinearMap(RotX(ang))
    elseif !iszero(axis[2])
        return LinearMap(RotY(ang))
    elseif !iszero(axis[3])
        return LinearMap(RotZ(ang))
    else
        return LinearMap(RotX(ang)) # default to X? TODO: What does OpenSCAD use?
    end
end

function transform(t::AbstractAffineMap, h::HyperRectangle{2,T}) where {T}
    p_1 = t(h.origin)
    p_2 = t(h.widths)
    p_3 = t(SVector(h.origin[1]+h.widths[1],h.origin[2]))
    p_4 = t(SVector(h.origin[1],h.origin[2]+h.widths[2]))
    x_o = min(p_1[1],p_2[1],p_3[1],p_4[1])
    y_o = min(p_1[2],p_2[2],p_3[2],p_4[2])
    x_w = max(p_1[1],p_2[1],p_3[1],p_4[1])
    y_w = max(p_1[2],p_2[2],p_3[2],p_4[2])
    HyperRectangle(x_o, y_o, x_w-x_o, y_w-y_o)
end

#function clarkcatmull!(n::Integer, pipe::Pipe{Float64})
#    length(pipe.points) < 3 && return
#    num_pts = length(pipe.points)
#    num_new_pts = num_pts + num_pts*(2^n-1)
#
#    for _ = 1:n
#        i = 1
#        while i < length(p.points)
#            e1 = pipe.points[i]
#            e2 = pipe.points[i+1]
#            e3 = pipe.points[i+2]
#            fp1 = e1 + (e2-e1)/2
#            fp2 = e2 + (e3-e2)/2
#        end
#    end
#end
