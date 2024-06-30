function GeometryBasics.mesh(primitives::AbstractPrimitive...;
                                         samples=(128,128,128),
                                         algorithm=MarchingCubes())

    f(x) = FRep(primitives[1], x)
    meshes = Vector{Mesh}(undef, length(primitives))
    for i = 1:length(primitives)
        b = HyperRectangle(primitives[i])
        rng = range.(b.origin, b.origin.+ b.widths)
        @show rng
        sdf(v) = FRep(primitives[i], SVector(v...))
        vts, fcs = isosurface(sdf, algorithm, rng[1], rng[2], rng[3]; samples)
        _points = map(GeometryBasics.Point, vts)
        _faces = map(v -> GeometryBasics.TriangleFace{GeometryBasics.OneIndex}(v), fcs)
        normals = map(v -> GeometryBasics.Vec3f(gradient(sdf, SVector(v...))...), vts) 
        meshes[i] = GeometryBasics.Mesh(GeometryBasics.meta(_points; normals=normals), _faces)
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
