#=
author: Daan Van Hauwermeiren
AoC 2022 day 9
=#
using Pkg
Pkg.activate(".")
using Pipe

# run via 
# julia ./code/DVH_2022_9.jl ./data/input_2022_9.txt

"""
function to compute a new tail given some head and tail.
This assumes that H and T and not in the neighbourhood.
In fact, if the coordinates are computed ok, than:
1) Δ is matched and T is updated
2) Δ is not matched, ergo H and T are in the same neighbourhood and the old T is returned.
"""
function move_tail_2_head(H::CartesianIndex, T::CartesianIndex)::CartesianIndex
    # define H and T
    # H += step
    Δ = H - T
    # first the four horizontal or vertical moves
    if Δ == CartesianIndex(2, 0)
        # move one to right
        T += CartesianIndex(1, 0)
    elseif Δ == CartesianIndex(-2, 0)
        # move one to left
        T += CartesianIndex(-1, 0)
    elseif Δ == CartesianIndex(0, 2)
        # move one to top
        T += CartesianIndex(0, 1)
    elseif Δ == CartesianIndex(0, -2)
        # move one to bottom
        T += CartesianIndex(0, -1)
    # now moves where the start was diagonally
    # e.e. (1U+1R) + 1U
    elseif (Δ == CartesianIndex(1, 2)) | (Δ == CartesianIndex(2, 1)) | (Δ == CartesianIndex(2, 2))
        # move one up and right
        T += CartesianIndex(1, 1)
    elseif (Δ == CartesianIndex(-1, -2)) | (Δ == CartesianIndex(-2, -1)) | (Δ == CartesianIndex(-2, -2))
        # move one down and left
        T += CartesianIndex(-1, -1)
    elseif (Δ == CartesianIndex(-1, 2)) | (Δ == CartesianIndex(-2, 1)) | (Δ == CartesianIndex(-2, 2))
        # move one up and left
        T += CartesianIndex(-1, 1)
    elseif (Δ == CartesianIndex(1, -2)) | (Δ == CartesianIndex(2, -1)) | (Δ == CartesianIndex(2, -2))
        # move one down and right
        T += CartesianIndex(1, -1)
    end
    return T
end

"""
update from other function using multiple dispatch,
first check whether they are in the neighbourhood, if so return old T, else, return adjusted T
"""
move_tail_2_head(H::CartesianIndex, T::CartesianIndex, neighbourhood::CartesianIndices)::CartesianIndex = (H-T) ∈ neighbourhood ? T : move_tail_2_head(H, T)

function main(args)
    # @show args
    fn = args[1]

    # define unit offsets in each dimension
    unitOffset_i = CartesianIndex(1, 0)
    unitOffset_j = CartesianIndex(0, 1)
    # parse input to vector of unit offsets
    directions, sizes = @pipe read(fn, String) |> rstrip |> split(_, "\n") |> split.(_, " ") |> hcat(_...) |> [_[1,:], parse.(Int, _[2,:])]
    replacements = Dict("R" => unitOffset_i, "L" => -unitOffset_i, "U" => unitOffset_j, "D" => -unitOffset_j)
    # instead of CartesianIndex(-3, 0), now we have
    # CartesianIndex(-1, 0), CartesianIndex(-1, 0), CartesianIndex(-1, 0)
    coordinates = @pipe [repeat([replacements[d]], s) for (d, s) in zip(directions, sizes)] |> vcat(_...)
    # define the relative indices where no update is required, note that this includes the position itself
    neighbourhood = CartesianIndices((-1:1, -1:1))

    # start at the same point
    H = CartesianIndex(0,0)
    T = CartesianIndex(0,0)
    # difference between head and tail
    Δ = H - T
    # store all unique positions of T
    positions = Set()
    # add initial position
    push!(positions, T)
    for step in coordinates
        H += step
        if (H-T) ∉ neighbourhood
            # H is moving out of the neighbourhood, update location of T
            T += Δ
            push!(positions, T)
        end
        # adjust delta
        Δ = H - T
    end
    solution_1 = length(positions)

    # similar, but for a number of heads and tails
    rope = repeat([CartesianIndex(0,0)], 10)
    positions = Set()
    # add initial position
    push!(positions, rope[end])
    for step in coordinates
        # update first knot
        rope[begin] += step
        # loop over other knots
        for i in 1:9
            # if (rope[i] - rope[i+1]) ∉ neighbourhood
            # rope[i+1] = move_tail_2_head(rope[i], rope[i+1])
            rope[i+1] = move_tail_2_head(rope[i], rope[i+1], neighbourhood)    
        end
        push!(positions, rope[10])
    end
    solution_2 = length(positions)

    @show solution_1, solution_2
end
main(ARGS)

# args = ["./data/input_2022_9_small.txt"]
# args = ["./data/input_2022_9_small_v2.txt"]
# args = ["./data/input_2022_9.txt"]
# fn = args[1]


