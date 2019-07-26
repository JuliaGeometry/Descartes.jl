
function correct_verts!(m, res=0.021)
    vrts = vertices(m)
    fcs = faces(m)
    everts = sort(collect(enumerate(vrts)), by = x-> x[2][1])
    #@show everts
    #@show sort!(collect(enumerate(vrts)), by = x-> x[1])
    d = Dict{Int,Int}() # map equal verts to one
    sizehint!(d,length(vrts))
    to_remove = Int[]
    n = 2
    for (idxl, eltl) in everts
        for i = n:length(everts)
            idxr, eltr = everts[i]
            if eltr[1] - eltl[1] <= res
                if isapprox(eltl, eltr)
                    if !haskey(d, idxr)
                        d[idxr] = idxl
                        push!(to_remove, i)
                    end
                else
                    continue
                end
            else
                break
            end
        end
        n += 1
    end
    deleteat!(everts, unique!(sort!(to_remove)))
    svm = Dict{Int,Int}() # map old index to new
    #@show sort(everts, by = x-> x[1])
    for i in eachindex(everts)
        svm[everts[i][1]] = i
    end
    # copy vertices
    resize!(m.vertices, length(everts))
    for i in eachindex(everts)
        m.vertices[i] = everts[i][2]
    end
    # correct faces
    for i = 1:length(fcs)
        f = fcs[i]
        xi = haskey(d, f[1]) ? svm[d[f[1]]] : svm[f[1]]
        yi = haskey(d, f[2]) ? svm[d[f[2]]] : svm[f[2]]
        zi = haskey(d, f[3]) ? svm[d[f[3]]] : svm[f[3]]
        fcs[i] = Face{3,Int}(xi,yi,zi)
    end
    m
end