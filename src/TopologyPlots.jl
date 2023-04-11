module TopologyPlots

#import PGFPlotsX: Axis, Table, Plot3
#import PGFPlotsX.@pgf
using PGFPlotsX

export plot_cylinder, plot_cylinder_bb, plot_curve_bb

option_zerosection = PGFPlotsX.Options(:no_marks => nothing, :dotted => nothing, :thick => nothing, :color => "blue")
function build_options(color)
    option_back = PGFPlotsX.Options(:no_marks => nothing, :dashed => nothing, :thick => nothing, :color => color, :on_layer => "axis background")
    option_front = PGFPlotsX.Options(:no_marks => nothing, :thick => nothing, :color => color)
    (option_front, option_back)
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
    if length(indices) > 0
        push!(segments[end], indices[end])
    end
    for segement ∈ segments
        push!(axis, @pgf Plot3(options, Table(xs[segement], ys[segement], zs[segement])))
    end
end

function plot_curve_bb(xs,ys,zs, axis :: Axis; color = "black")
    option_front, option_back = build_options(color)

    front_indices = findall(<=(0), ys)
    back_indices = findall(>(0), ys)

    plot_curve_segmentized(axis, option_front, xs, ys, zs, front_indices)
    plot_curve_segmentized(axis, option_back, xs, ys, zs, back_indices)
end

function plot_cylinder_bb(half_height, axis :: Axis, vertical_frame = true, zero_section = false, color = "black")
    option_front, option_back = build_options(color)
    push!(axis, plot_circle_element(option_front, 0, π, half_height))
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

