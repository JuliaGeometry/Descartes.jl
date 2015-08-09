type Shell{T} <: AbstractPrimitive{3,T}
    primitive::T
    distance
end

function Shell(r)
    Shell(nothing, r)
end

function *{N,T}(s::Shell{Void}, obj::AbstractPrimitive{N,T})
    Shell(obj, s.distance)
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
