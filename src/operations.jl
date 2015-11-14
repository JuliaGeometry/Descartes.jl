function *{N,T}(s::Shell{Void}, obj::AbstractPrimitive{N,T})
    Shell(obj, s.distance)
end

function rotate(ang, vect::Vector)
    n = length(vect)
    N = n + 1
    transform = eye(N)
    sin_ang = sin(ang)
    cos_ang = cos(ang)

    # axis rotations
    if vect[1] != 0
        transform[2,2] = transform[3,3] = cos_ang
        transform[2,3] = -sin_ang
        transform[3,2] = sin_ang
    elseif vect[2] != 0
        transform[1,1] = transform[3,3] = cos_ang
        transform[1,3] = sin_ang
        transform[3,1] = -sin_ang
    elseif vect[3] != 0
        transform[1,1] = transform[2,2] = cos_ang
        transform[1,2] = -sin_ang
        transform[2,1] = sin_ang
    else
        throw(ArgumentError("rotation underspecified!"))
    end

    Transform{n, Float64}(transform)
end

function translate(vect::Vector)
    n = length(vect)
    N = n + 1
    transform = eye(N)
    transform[1:n, N] = vect
    Transform{n, Float64}(transform)
end

function translate(vect::FixedVector)
    n = length(vect)
    N = n + 1
    transform = eye(N)
    for i = 1:n
        transform[i, N] = vect[i]
    end
    Transform{n, Float64}(transform)
end

function *{N,T}(transform::Transform{N,Float64}, obj::AbstractPrimitive{N,T})
    obj.transform = obj.transform*transform.transform
    obj.inv_transform = inv(obj.transform)
    obj
end

"""
Apply a homogenous tranform matrix to the points x, y, z
"""
function transform{T}(it::Array{T,2}, _x, _y, _z)
    @inbounds x = _x*it[1,1]+_y*it[1,2]+_z*it[1,3]+it[1,4]
    @inbounds y = _x*it[2,1]+_y*it[2,2]+_z*it[2,3]+it[2,4]
    @inbounds z = _x*it[3,1]+_y*it[3,2]+_z*it[3,3]+it[3,4]
    x, y, z
end

function transform{T}(it::Array{T,2}, x::Vector)
    transform(it, x...)
end

function transform{T}(it::Array{T,2}, x::Point)
    transform(it, x...)
end

function transform{T1,T2}(t::Array{T1,2},
                            h::HyperRectangle{3,T2})
    pts = decompose(Point{3,T2}, (h))
    maxx, maxy, maxz = typemin(T1), typemin(T1), typemin(T1)
    minx, miny, minz = typemax(T1), typemax(T1), typemax(T1)
    for pt in pts
        newx, newy, newz = transform(t, pt)
        maxx = max(newx,maxx)
        maxy = max(newy,maxy)
        maxz = max(newz,maxz)
        minx = min(newx,minx)
        miny = min(newy,miny)
        minz = min(newz,minz)
    end
    HyperRectangle(Vec(minx,miny,minz),Vec(maxx,maxy,maxz))
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
