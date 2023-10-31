using TopologyPlots
using PGFPlotsX

axis = @pgf Axis({
    axis_equal,
    axis_lines = "none"});

ts = -2:1e-3:2

options = PGFPlotsX.Options(:no_marks => nothing, :thick => nothing)
push!(axis, @pgf Plot(options, Table([-π,-π], [-2,2])))
push!(axis, @pgf Plot(options, Table([π,π], [-2,2])))
TopologyPlots.plot_curve_cut_cylinder(18*exp.(-ts.^2), ts, axis)

pgfsave("minimal_example_2d.pdf", axis)