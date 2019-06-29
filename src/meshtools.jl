
# merge vertices 
function fix_connectivity!(m::AbstractMesh)
    vts = vertices(m)
    fcs = faces(m)
    d = Dict{Int,Int}()
    n = length(vts)
    # store a deletion buffer
    del_buf = Int[]
    for i = 1:n
        for j = i+1:n
            if isapprox(vts[i],vts[j])
                push!(d,j => i)
                push!(del_buf, j)
            end
        end
    end
    unique!(sort!(del_buf))
    # for i = 1:length(fcs)
    #     f = fcs[i]
    #     v1, v2, v3 = f[1], f[2], f[3]
    #     if haskey(d, v1)
    #         findfirst(i->i >  )
    #     v_1 = haskey(d, f[1]) ? d[f[1]] : f[1]
    #     v_2 = haskey(d, f[2]) ? d[f[2]] : f[2]
    #     v_3 = haskey(d, f[3]) ? d[f[3]] : f[3]
    #     fcs[i] = Face(v_1,v_2,v_3)
    # end
    deleteat!(vts, del_buf)
    nothing
end