module TopologyPlots

#import PGFPlotsX: Axis, Table, Plot3
#import PGFPlotsX.@pgf
using PGFPlotsX

export plot_cylinder, plot_cylinder_bb

option_back = PGFPlotsX.Options(:no_marks => nothing, :dashed => nothing, :thick => nothing, :color => "black")
option_front = PGFPlotsX.Options(:no_marks => nothing, :thick => nothing, :color => "black")
option_zerosection = PGFPlotsX.Options(:no_marks => nothing, :dotted => nothing, :thick => nothing, :color => "blue")

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

function plot_circle_element(options :: PGFPlotsX.Options, angle_start, angle_end, z)
    p2 = angle_start:1e-2:angle_end
    angles = @. 0.0 * z + 1.0 * p2
    x = vec(@. cos(angles))
    y = vec(@. sin(angles))
    z = vec(@. [z]' + 0.0 * p2)
    return @pgf Plot3(options, Table(x,y,z))
end

function plot_curve_segmentized(axis::Axis, options :: PGFPlotsX.Options, xs, ys, zs, indices)
    segments = [[]]
    for idx = eachindex(indices)
        if idx > 1
            push!(segments[end], indices[idx-1])
            if abs(indices[idx] - indices[idx-1]) ≥ 2
                push!(segments, [])
            end
        end
    end
    push!(segments[end], indices[end])
    for segement ∈ segments
        push!(axis, @pgf Plot3(options, Table(xs[segement], ys[segement], zs[segement])))
    end
end

function plot_curve_bb(xs,ys,zs, axis :: Axis)
    front_indices = findall(<=(0), ys)
    back_indices = findall(>(0), ys)

    xs_front = xs[front_indices]
    ys_front = ys[front_indices]
    zs_front = zs[front_indices]

    xs_back = xs[back_indices]
    ys_back = ys[back_indices]
    zs_back = zs[back_indices]

    plot_curve_segmentized(axis, option_front, xs, ys, zs, front_indices)
    plot_curve_segmentized(axis, option_back, xs, ys, zs, back_indices)
end

function plot_cylinder_bb(half_height, axis :: Axis, vertical_frame = true, zero_section = false)
    push!(axis, plot_circle_element(option_back, 0, π, half_height))
    push!(axis, plot_circle_element(option_front,π,2π, half_height))
    push!(axis, plot_circle_element(option_back, 0, π, -half_height))
    push!(axis, plot_circle_element(option_front,π,2π, -half_height))

    if vertical_frame
        vertical_frame_left = @pgf Plot3(option_front, Table([-1,-1], [0,0], [half_height,-half_height]))
        push!(axis, vertical_frame_left)
        vertical_frame_left = @pgf Plot3(option_front, Table([1,1], [0,0], [half_height,-half_height]))
        push!(axis, vertical_frame_left)
    end
    
    if zero_section
        push!(axis, plot_circle_element(option_zerosection,0,2π, 0))
    end 
end

end # module TopologyPlots

