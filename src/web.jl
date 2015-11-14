import ThreeJS
using Descartes

main(window) =  begin
    push!(window.assets,("ThreeJS","threejs"))
    push!(window.assets,"widgets")
    r = Input(1.0)
    vbox(
        "ThreeJS Example",
        vskip(2em),
        hbox("r",slider(0.1:0.1:1.0) >>> r),
        vskip(2em),
        lift(r) do r
            c = Cuboid([1,1,1])
            s = Sphere(r)
            m = HomogenousMesh(CSGUnion(c,s), 0.5)
            ThreeJS.outerdiv() << 
                (ThreeJS.initscene() <<
                    [
                        ThreeJS.mesh(0.0, 0.0, 0.0) << 
                        [
                            ThreeJS.geometry(m), ThreeJS.material(Dict(:kind=>"lambert",:color=>"red"))
                        ],
                        ThreeJS.pointlight(10.0, 10.0, 10.0),
                        ThreeJS.camera(2.0, 2.0, 2.0)
                    ]
                )
        end
    ) |> pad(2em)
end
