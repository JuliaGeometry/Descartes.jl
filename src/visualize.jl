
function visualize(p::AbstractPrimitive, algorithm=MarchingCubes(),
                   res_start=1, res_scale=0.5, res_iterations=5)

    # first visual
    vis = Visualizer()
    m = HomogenousMesh(p, resolution=res_start, algorithm=algorithm)
    open(vis)
    delete!(vis) # clear visualizer
    setobject!(vis, m)
    res = res_start
    for i = 1:res_iterations
        res = res*res_scale
        m = HomogenousMesh(p, resolution=res, algorithm=algorithm)
        delete!(vis)
        setobject!(vis,m)
    end
end
