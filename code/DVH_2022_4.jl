#=
author: Daan Van Hauwermeiren
AoC 2022 day 4
=#

using Pkg
Pkg.activate(".", io=devnull)
using Pipe

# run via 
# julia ./code/DVH_2022_4.jl ./data/input_2022_4.txt

# this is an example on how to get command line arguments into the file
function main(args)
    # @show args
    fn = args[1]    
    raw = read(fn, String);
    
    # raw input to vector with a vector of strings
    sections_raw = @pipe rstrip(raw) |> split(_, "\n") |> split.(_, ",") 
    # split strings, parse each element into integers, combine each vector of integers into a ranges
    sections = @pipe sections_raw .|> split.(_, "-") .|> [parse.(Int, i) for i in _] .|> [_[1][1]:_[1][2], _[2][1]:_[2][2]]
    # find all ranges fully containing the other
    solution_1 = @pipe sections .|> (_[1] ⊆ _[2]) | (_[1] ⊇ _[2]) |> sum
    # overlaps = ranges are not disjoint
    solution_2 = @pipe sections .|> ~isdisjoint(_...) |> sum

    @show solution_1, solution_2
end
main(ARGS)

# args = ["./data/input_2022_4.txt"]
# args = ["./data/input_2022_4_small.txt"]
