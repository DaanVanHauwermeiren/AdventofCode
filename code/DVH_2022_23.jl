#=
author: Daan Van Hauwermeiren
AoC 2022 day 23
=#

using Pkg
Pkg.activate(".", io=devnull)
using Pipe

# run via 
# julia ./code/DVH_2022_23.jl ./data/input_2022_23.txt




fn = "./data/input_2022_23.txt"
fn = "./data/input_2022_23_small.txt";
grove = @pipe readlines(fn) |> split.(_, "") |> hcat(_...) |> permutedims


grove[3,1]

# define unit offsets in each dimension
unitOffset_i = CartesianIndex(1, 0)
unitOffset_j = CartesianIndex(0, 1)

S = unitOffset_i # S
N = -unitOffset_i # N
E = unitOffset_j # E
W = -unitOffset_j # W
SE = unitOffset_i + unitOffset_j # SE
SW = unitOffset_i - unitOffset_j # SW
NE = -unitOffset_i + unitOffset_j # NE
NW = -unitOffset_i - unitOffset_j # NW

neighbourhood = [S, N, E, W, SE, SW, NE, NW]
neighbourhood_N = [NW, N, NE]
neighbourhood_E = [NE, E, SE]
neighbourhood_S = [SE, S, SW]
neighbourhood_W = [SW, W, NW]


directions = [neighbourhood_N, neighbourhood_S, neighbourhood_W, neighbourhood_E]
elves = findall(grove .== "#")

function get_proposal(elf::CartesianIndex{2}, elves::Vector{CartesianIndex{2}}, neighbourhood::Vector{CartesianIndex{2}}, directions::Vector{Vector{CartesianIndex{2}}})::CartesianIndex{2}
    elves_in_neighbourhood = @pipe neighbourhood .|> (_ + elf) .|> (_ in elves) |> any
    # no elves in neighbourhood: do nothing
    if !elves_in_neighbourhood
        # println("no elves in neighbourhood")
        return elf
    end
    # loop over directions
    for dd in directions
        elves_in_neighbourhood = @pipe dd .|> (elf + _) .|>  (_ in elves) |> any
        # @show elves_in_neighbourhood
        if !elves_in_neighbourhood
            # println("proposed in direction, ", dd[2])
            # the middle position is the own they should move to
            return elf + dd[2]
        end
    end
    # if nothing in the directions return original
    # println("nothing found")
    return elf
end

# for one elf
# get_proposal(elf, neighbourhood, directions)
# for all elves
# proposed_elves = @pipe elves .|> get_proposal(_, elves, neighbourhood, directions)

function update_elves(elves::Vector{CartesianIndex{2}}, proposed_elves::Vector{CartesianIndex{2}})::Vector{CartesianIndex{2}}
    new_elves = zeros(CartesianIndex{2}, size(elves))
    for ii in eachindex(elves)
        # more than 1 elf proposes this location => do not move
        # just 1: move by updating list of elves
        if count(@pipe proposed_elves .|> (_ == proposed_elves[ii])) == 1
            new_elves[ii] = proposed_elves[ii]
        else
            new_elves[ii] = elves[ii]
        end
    end
    return new_elves
end


# update_elves(elves, proposed_elves)
# elves


function round(elves::Vector{CartesianIndex{2}}, neighbourhood::Vector{CartesianIndex{2}}, directions::Vector{Vector{CartesianIndex{2}}})
    # get new elves
    proposed_elves = @pipe elves .|> get_proposal(_, elves, neighbourhood, directions)
    # check their position and update
    new_elves = update_elves(elves, proposed_elves)
    # update the directions : pop first and move to last place
    directions = [directions[2:end]..., directions[1]]
    return new_elves, directions
end


function find_stable_config(elves::Vector{CartesianIndex{2}}, neighbourhood::Vector{CartesianIndex{2}}, directions::Vector{Vector{CartesianIndex{2}}})::Int
    for ii in 1:10_000
        new_elves, directions = round(elves, neighbourhood, directions)
        # println(new_elves)
        # println(elves)
        if all(new_elves .== elves)
            println("stopped after round ", ii)
            return ii
        else
            elves = new_elves
        end
    end
    println("no stability found after iteration ", ii)
    return ii
end


function main(args)
    fn = args[1]

    grove = @pipe readlines(fn) |> split.(_, "") |> hcat(_...) |> permutedims
    elves = findall(grove .== "#")
    directions = [neighbourhood_N, neighbourhood_S, neighbourhood_W, neighbourhood_E]
    
    for ii in 1:10
        elves, directions = round(elves, neighbourhood, directions)
    end
    empty_tiles = ((maximum(elves) - minimum(elves) + CartesianIndex(1, 1)).I |> prod) - length(elves)
    solution_1 = empty_tiles
    
    grove = @pipe readlines(fn) |> split.(_, "") |> hcat(_...) |> permutedims
    elves = findall(grove .== "#")
    directions = [neighbourhood_N, neighbourhood_S, neighbourhood_W, neighbourhood_E]
    solution_2 = find_stable_config(elves, neighbourhood, directions)


    @show solution_1, solution_2
end
main(ARGS)

