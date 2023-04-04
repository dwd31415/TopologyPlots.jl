module TopologyPlots

#import PGFPlotsX: Axis, Table, Plot3
#import PGFPlotsX.@pgf
using PGFPlotsX

export plot_cylinder

function plot_cylinder(half_height, axis :: Axis)
    p1 = range(-half_height,half_height,length=2)'
    p2 = 0:0.1:2π+1e-1
    angles = @. 0.0 * p1 + 1.0 * p2
    x = vec(@. cos(angles))
    y = vec(@. sin(angles))
    z = vec(@. p1 + 0.0 * p2)
    body = @pgf Plot3({
                surf,
                z_buffer = "sort",
                opacity = 0.5,
                color = "gray", 
                colormap = "{Julia}{$(join(map(c -> "rgb255=(128,128,128)", p1'), ", "))}", 
                "mesh/rows" = length(p1)
            },
            Table(x, y, z))
    push!(axis, body)
    upper_frame = @pgf Plot3({no_marks, dotted, thick, color = "black"}, Table(cos.(angles[:,1]),sin.(angles[:,2]),@. half_height + 0 * angles[:,1]))
    lower_frame = @pgf Plot3({no_marks, dotted, thick, color = "black"}, Table(cos.(angles[:,1]),sin.(angles[:,2]),@. -half_height + 0 * angles[:,1]))
    zero_section = @pgf Plot3({no_marks, dashed, opacity = 0.7, thick, color = "blue"}, Table(cos.(angles[:,1]),sin.(angles[:,2]),@. 0 * angles[:,1]))
    push!(axis, upper_frame)
    push!(axis, lower_frame)
    push!(axis, zero_section)
end

end # module TopologyPlots

