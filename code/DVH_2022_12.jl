#=
author: Daan Van Hauwermeiren
AoC 2022 day 12
=#
using Pkg
Pkg.activate(".", io=devnull)
using Pipe

# run via 
# julia ./code/DVH_2022_12.jl ./data/input_2022_12.txt


function main(args)
    fn = args[1]
    # heightmap as a matrix of Chars
    # the call using only is a hacky way of getting the first element of a collection
    # in this case the first element of a string with one character is the character
    heightmap = @pipe readlines(fn) |> split.(_, "") |> hcat(_...) |> only.(_)
    # locating start and end indices
    # NOTE: using instances of type CartesianIndex for all lookups in the script
    idx_start = findfirst(heightmap .== 'S')
    idx_end = findfirst(heightmap .== 'E')
    # replacing 'S' with 'a' and 'E' with 'z' so that the comparison on chars works nicely
    heightmap[idx_start] = 'a'
    heightmap[idx_end] = 'z'
    # fill a matrix with a large number (used for checking the current number of steps below), not using Inf because of type stability
    steps = fill(100_000, size(heightmap))
    # only up, down, left, right
    neighbourbood = [CartesianIndex(1, 0), CartesianIndex(-1, 0), CartesianIndex(0, 1), CartesianIndex(0, -1)]

    function traverse!(idx::CartesianIndex, cur_steps::Int)::Nothing
        # if the number of steps at the current index is lower that cur_steps, than there
        # exists a shorter path here, so returning and stopping the search
        steps[idx] <= cur_steps && return nothing
        steps[idx] = cur_steps
        # loop over neighbourbood
        for δ ∈ neighbourbood
            # I think these two lines below can be merged with some && statements
            # check if the candidate index is inbounds.
            # this might be faster with the inbounds method?
            (idx + δ) ∈ CartesianIndices(heightmap) ? nothing : continue
            # this makes use of the handy fact that you can compare Chars:
            # 'a' < 'b'
            # if a good new candidate is found, go deeper in the recursion.
            heightmap[idx+δ] <= heightmap[idx]+1 ? traverse!(idx+δ, cur_steps+1) : continue
        end
    end

    # the solutions
    traverse!(idx_start, 0)
    solution_1 = steps[idx_end]
    # same but now for all indices that start `at the bottom`, aka 'a'
    traverse!.(findall(heightmap.=='a'), 0)
    solution_2 = steps[idx_end]
    @show solution_1, solution_2
end
main(ARGS)
