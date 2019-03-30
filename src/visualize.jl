
function visualize(p::AbstractPrimitive, res_start=1, res_scale=0.5, res_iterations=5)

    # first visual
    vis = Visualizer()
    m = HomogenousMesh(p, res_start)
    open(vis)
    delete!(vis) # clear visualizer
    setobject!(vis, m)
    res = res_start
    for i = 1:res_iterations
        sleep(3)
        res = res*res_scale
        m = HomogenousMesh(p, res)
        delete!(vis)
        setobject!(vis,m)
    end
end
