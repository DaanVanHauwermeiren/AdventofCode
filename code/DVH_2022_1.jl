#=
author: Daan Van Hauwermeiren
AoC 2022 day 1
=#
using Pkg
Pkg.activate(".", io=devnull)
using Pipe

# run via 
# julia ./code/DVH_2022_1.jl ./data/input_2022_1.txt

function main(args)
    fn = args[1]
    
    raw = read(fn, String);
    # NOTE: these two lines might be merged for a nice one-liner.
    inventory_raw = @pipe rstrip(raw) |> split(_, "\n\n")
    calories_summed = @pipe split.(inventory_raw, "\n") .|> parse.(Int, _) .|> sum |> sort
    
    solution_1 = calories_summed[end]
    solution_2 = sum(calories_summed[end-2:end])
    @show solution_1, solution_2
end
main(ARGS)

