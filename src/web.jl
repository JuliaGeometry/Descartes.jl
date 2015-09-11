import ThreeJS 

main(window) =  begin
    push!(window.assets,("ThreeJS","threejs"))
    push!(window.assets,"widgets")
    w = Input(1.0)
    h = Input(1.0)
    d = Input(1.0)
    hbox(
        lift(w, h, d) do w, h, d
        ThreeJS.outerdiv() << 
            (ThreeJS.initscene() <<
                [
                    ThreeJS.mesh(0.0, 0.0, 0.0) << 
                    [
                        ThreeJS.sphere(w), ThreeJS.material(Dict(:kind=>"normal",:color=>"red"))
                    ],
                    ThreeJS.pointlight(10.0, 10.0, 10.0),
                    ThreeJS.camera(0.0, 0.0, 10.0)
                ]
            )
        end,
        vbox(
            hbox("width",slider(1.0:5.0) >>> w),
            hbox("height",slider(1.0:5.0) >>> h),
            hbox("depth",slider(1.0:5.0) >>> d),
        )
    ) |> pad(2em)
end
