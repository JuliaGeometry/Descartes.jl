global vis = nothing

function init_vis()
    global vis
    if vis == nothing
        vis = Visualizer()
        open(vis)
    end
    vis
end


function visualize(m::AbstractMesh...)

    # first visual
    vis = init_vis()
    delete!(vis) # clear visualizer
    for mesh in m
        setobject!(vis, mesh)
    end
end

visualize(m::AbstractVector) = visualize(m...)
