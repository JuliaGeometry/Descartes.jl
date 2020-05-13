function (::Type{MT})(primitives::AbstractPrimitive{3, T}...;
                                         samples=(128,128,128),
                                         algorithm=MarchingCubes(),
                                         adf=false) where {T, MT <: AbstractMesh}

    f(x) = FRep(primitives[1], x)
    meshes = Vector{MT}(undef, length(primitives))
    for i = 1:length(primitives)
        b = HyperRectangle(primitives[i])
        meshes[i] = MT(x -> FRep(primitives[i], x), b, samples, algorithm)
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
