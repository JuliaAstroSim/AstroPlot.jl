scene = plot_makie(Cube(PVector(0.0,0.0,0.0), PVector(1.0,1.0,1.0)), nothing)
Makie.save("cube.png", scene)