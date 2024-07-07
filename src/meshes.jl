function GeometryBasics.mesh(primitives::AbstractPrimitive...;
                                         samples=(128,128,128),
                                         algorithm=MarchingCubes())

    f(x) = FRep(primitives[1], x)
    meshes = Vector{GeometryBasics.Mesh}(undef, length(primitives))
    sdf_arr = Array{Float64}(undef, samples)

    for i = 1:length(primitives)
        b = HyperRectangle(primitives[i])
        rng = range.(b.origin, b.origin.+ b.widths)

        @info "Sampling SDF"
        xp = LinRange(first(rng[1]), last(rng[1]), samples[1])
        yp = LinRange(first(rng[2]), last(rng[2]), samples[2])
        zp = LinRange(first(rng[3]), last(rng[3]), samples[3])        
        sdf(v) = FRep(primitives[i], SVector(v...))
        sdf_normal(v) = gradient(sdf, SVector(v...))

        @time Threads.@threads for x in eachindex(xp)
            for y in eachindex(yp), z in eachindex(zp)
                sdf_arr[x,y,z] = sdf((xp[x],yp[y],zp[z]))
            end
        end

        @info "generating mesh"
        @time vts, fcs = isosurface(sdf_arr, algorithm, rng[1], rng[2], rng[3])
        @info "remapping data types"
        @time _points = map(GeometryBasics.Point, vts)
        @time _faces = map(v -> GeometryBasics.TriangleFace{GeometryBasics.OneIndex}(v), fcs)
        @info "evaluating normals"
        @time normals = map(v -> GeometryBasics.Vec3f(sdf_normal(v)), vts) 
        @info "remapping mesh"
        @time meshes[i] = GeometryBasics.Mesh(GeometryBasics.meta(_points; normals=normals), _faces)
    end
    return merge(meshes)
end

function piped_mesh(m::AbstractMesh,r)
    c = nothing
    for f in m.faces
        v1 = m.vertices[f[1]-O]
        v2 = m.vertices[f[2]-O]
        v3 = m.vertices[f[3]-O]
        c = CSGUnion(c, Piping(r, Point{3,Float64}[v1, v2, v3]))
    end
    c
end
