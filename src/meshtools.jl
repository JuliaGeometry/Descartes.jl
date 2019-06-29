
# merge vertices 
function fix_connectivity!(m::AbstractMesh)
    vts = vertices(m)
    fcs = faces(m)
    d = Dict{Int,Int}()
    i = 1
    n = length(vts)
    while true
        j = i+1
        i >= n-1 && break
        while true
            j >= n && break
            if isapprox(vts[i],vts[j])
                # store the index mapping
                push!(d, j=>i)
                deleteat!(vts,j)
                n -= 1
            end
            j += 1
        end
        i += 1
    end
    for i = 1:length(fcs)
        f = fcs[i]
        v_1 = haskey(d, f[1]) ? d[f[1]] : f[1]
        v_2 = haskey(d, f[2]) ? d[f[2]] : f[2]
        v_3 = haskey(d, f[3]) ? d[f[3]] : f[3]
        fcs[i] = Face(v_1,v_2,v_3)
    end
end