global vis = nothing

function init_vis()
    if vis == nothing
        vis = Visualizer()
    end
    vis
end


function visualize(m::AbstractMesh, algorithm=MarchingCubes(),
                   resolution=1)

    # first visual
    vis = init_vis()
    open(vis)
    delete!(vis) # clear visualizer
    setobject!(vis, m)
end
