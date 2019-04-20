global vis = nothing

function init_vis()
    global vis
    if vis == nothing
        vis = Visualizer()
        open(vis)
    end
    vis
end


function visualize(m::AbstractMesh, algorithm=MarchingCubes(),
                   resolution=1)

    # first visual
    vis = init_vis()
    delete!(vis) # clear visualizer
    setobject!(vis, m)
end
