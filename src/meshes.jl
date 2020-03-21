function (::Type{MT})(primitives::AbstractPrimitive{3, T}...;
                                         samples=(128,128,128),
                                         algorithm=MarchingCubes(),
                                         adf=false) where {T, MT <: AbstractMesh}

    f(x) = FRep(primitives[1], x)
    mesh = MT(f, HyperRectangle(primitives[1]), samples, algorithm)
    for i = 2:length(primitives)
        b = HyperRectangle(primitives[i])
        lm = MT(x -> FRep(primitives[i], x), b, samples, algorithm)
        mesh = merge(mesh, lm)
    end
    return mesh
end

function f(primitive)
    x -> FRep(primitive, x)::eltype(x)
end

function (::Type{MT})(primitive::AbstractPrimitive{3, T},
                      algorithm=Meshing.AdaptiveMarchingCubes(0.0,1e-3,0.05,0.05,true,false)
                      ) where {T, MT <: AbstractMesh}

    h = HyperRectangle(primitive)
    m = ntuple(_->maximum(h.widths),3)
    @show m
    vts, fcs = isosurface(f(primitive), algorithm, origin=SVector{3,Float64}(h.origin...), widths=SVector{3,Float64}(m...))

    return MT(Point.(vts), Face.(fcs))
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
