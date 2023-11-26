#=
author: Daan Van Hauwermeiren
AoC 2022 day 8
=#

using Pkg
Pkg.activate(".", io=devnull)
using Pipe

# this is wrong because it ignores larger trees after repeated smaller trees
# e.g.
# [2 3 3 5 6]
# will return
# [1 1 0 0 0]
# when the correct answer is
# [1 1 0 1 0]
# line_of_sight(arr::AbstractArray{Int})::AbstractArray{Bool} = @pipe arr |> ([-1, _[begin:end-1]...] .< _) |> accumulate(&, _, init=true)

# for each element in the array, check if it is strictly larger than all elements before that element
line_of_sight(arr::AbstractArray{Int})::AbstractArray{Bool} = [all(arr[i] .> arr[1:i-1]) for i in 1:length(arr)]

function line_of_sight(mat::Matrix{Int}, direction::Symbol)::Matrix{Bool}
    if direction == :l2r
        # loop over each row and compute line of sight, cat back into a matrix in the correct form
        return @pipe eachrow(mat) .|> line_of_sight(_) |> hcat(_...) |> permutedims(_)
    elseif direction == :r2l
        # same but reverse the matrix
        return @pipe eachrow(reverse(mat, dims=2)) .|> line_of_sight(_) |> hcat(_...) |> permutedims(_) |> reverse(_, dims=2)
    elseif direction == :t2b
        # loop over columns instead of rows
        return @pipe eachcol(mat) .|> line_of_sight(_) |> hcat(_...)
    elseif direction == :b2t
        # same same but reversed columns
        return @pipe eachcol(reverse(mat, dims=1)) .|> line_of_sight(_) |> hcat(_...) |> reverse(_, dims=1)
    else
        throw(DomainError(direction, "Only use of these for direction: :l2r, :r2f, :t2b, :b2t"))
    end
end

line_of_sight(mat::Matrix{Int})::Matrix{Bool} = line_of_sight(mat, :l2r) .| line_of_sight(mat, :r2l) .| line_of_sight(mat, :t2b) .| line_of_sight(mat, :b2t)

# this function name is stupid and crappy
# cannot find a good name for one
# suggestions welcome
# use something function to return the first value that is not nothing
# if none of the elements of arr are larger or equal to value, than nothing is returned
# in that case, the correct answer is the length of the array
strictly_larger_or_full_length(arr::AbstractArray{Int}, val::Int)::Int = something(findfirst(arr .>= val), length(arr))

"""
get the line of sight from an element within the matrix
"""
function line_of_sight(mat::Matrix{Int}, idx::CartesianIndex)::Int
    x, y = idx.I
    return @pipe [
        # from the index, get the view from:
        reverse(mat[1:x-1, y]), # top
        mat[x+1:end, y], # bottom
        reverse(mat[x, 1:y-1]), # left
        mat[x, y+1:end] # right
    ] .|> strictly_larger_or_full_length(_, mat[idx]) |> prod
end

# run via 
# julia ./code/DVH_2022_8.jl ./data/input_2022_8.txt

function main(args)
    # @show args
    fn = args[1]

    trees = @pipe read(fn, String) |> rstrip |> split(_, "\n") |> split.(_, "") |> hcat(_...) |> permutedims |> parse.(Int, _)

    solution_1 = line_of_sight(trees) |> sum

    # cartesian indices of the matrix
    # CartesianIndices(trees)
    # cartesian indices of the "inner" part of the matrix
    # CartesianIndices(size(trees) .- 2)
    # now for each of these inner coordinates, we need to offset by (1,1)
    # so that the indices are e.g. CartesianIndices((2:4, 2:4)) for a matrix with size (5,5)
    # NOTE:
    # not 100% sure that this is required, I'm kinda assuming that they want trees in each direction, so no treehouse at the border.
    # EDIT: 
    # I misread, "(If a tree is right on the edge, at least one of its viewing distances will be zero.)" so nothing on the border!
    indices = CartesianIndices(size(trees) .- 2) .+ CartesianIndex( (1, 1) )

    solution_2 = @pipe indices .|> line_of_sight(trees, _) |> maximum

    @show solution_1, solution_2
end
main(ARGS)

# args = ["./data/input_2022_8_small.txt"]
# args = ["./data/input_2022_8.txt"]
# fn = args[1]

