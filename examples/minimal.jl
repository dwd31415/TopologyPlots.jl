using TopologyPlots
using PGFPlotsX

axis = @pgf  Axis({
    "view" = (0,30),
    axis_equal,
    "scale" = 2,
    axis_lines = "none"});

TopologyPlots.plot_cylinder_bb(2, axis)

ts = -2:1e-2:2
xs = cos.(π * ts)
ys = sin.(π * ts)
zs = ts

TopologyPlots.plot_curve_bb(xs,ys,zs,axis; color="red")
pgfsave("minimal_example.pdf", axis)