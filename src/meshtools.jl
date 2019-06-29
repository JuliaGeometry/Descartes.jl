
invsignbit(x) = !signbit(x)

# merge vertices 
function fix_connectivity!(m::AbstractMesh)
    vts = vertices(m)
    fcs = faces(m)
    d = Dict{Int,Int}()
    i = 1
    n = length(vts)
    # store a deletion buffer
    del_buf = Int[]
    del_buf_len = 0
    while true
        j = i+1
        i >= n-1 && break
        buf_ind = 1
        # zero out the buffer
        for i in eachindex(del_buf)
            del_buf[i] = -1
        end
        for j = i+1:n
            if isapprox(vts[i],vts[j])
                # store the index mapping
                push!(d, j=>i)
                # prepare deletion in buffer
                if buf_ind > del_buf_len
                    push!(del_buf,j)
                    del_buf_len += 1
                else
                    del_buf[buf_ind] = j
                end
                buf_ind += 1
            end
        end
        deleteat!(vts, filter(invsignbit, del_buf))
        n = length(vts)
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