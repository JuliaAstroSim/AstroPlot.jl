scene = plot_peano(3)
Makie.save("peano.png", scene)

d = randn_pvector(15)
t = octree(d)
scene = plot_makie(t)
Makie.save("tree.png", scene)