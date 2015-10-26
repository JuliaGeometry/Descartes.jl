function shader_visualize(shaderpath,
                          additional_uniforms::Dict{Symbol, Any}=Dict{Symbol, Any}();
                          templates=Dict{ASCIIString, ASCIIString}())
    screen, renderloop = glscreen()
    HERE = dirname(@__FILE__)

    # package code goes here
    data = merge(Dict(
        :iResolution => lift(Vec2f0, screen.inputs[:framebuffer_size]),
        :iMouse => dropwhen(lift(isempty, screen.inputs[:mousebuttonspressed]), Vec2f0(0), lift(Vec2f0, screen.inputs[:mouseposition])),
        :iGlobalTime => bounce(0f0:0.016f0:2000f0),
        :preferred_camera => :nothing
    ), collect_for_gl(GLMesh2D(Rectangle{Float32}(-1f0,-1f0,2f0,2f0))), additional_uniforms)
    templates = merge(templates, Dict("SHADERTOY_INPUTS" => """
        uniform vec2 iResolution;
        uniform vec2 iMouse;
        uniform float iGlobalTime;
    """
    ))
    program = TemplateProgram(
        load(joinpath(HERE, "shaders", "fullscreen.vert")), 
        load(joinpath(HERE, "shaders", "shadertoy.frag")), 
        load(shaderpath),
        view=templates
    )
    robj = std_renderobject(data, program)
    view(robj)

    isinteractive() ? @async(renderloop()) : renderloop()

    robj
end
