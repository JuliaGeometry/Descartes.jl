function GeometryTypes.HomogenousMesh{T}(primitive::AbstractPrimitive{3, T},
                                         resolution=0.1)
    # key based on resolution
    k = "HomogenousMesh:res:$resolution"
    # grab from cache if available
    if use_cache && cache_contains(primitive,k)
        return cache_load(primitive, k)
    end
    distancefield = SignedDistanceField(primitive, resolution)
    h = HomogenousMesh(distancefield.data, 0.0)
    # we got this far, might as well save it
    if use_cache
        cache_add(primitive, k, h)
    end
    h
end

function piped_mesh{VT,N,T,O}(m::AbstractMesh{VT, Face{N,T,O}},r)
    c = nothing
    for f in m.faces
        v1 = m.vertices[f[1]-O]
        v2 = m.vertices[f[2]-O]
        v3 = m.vertices[f[3]-O]
        c = CSGUnion(c, Piping(r, Point{3,Float64}[v1, v2, v3]))
    end
    c
end
