#=
author: Daan Van Hauwermeiren
AoC 2022 day 10
=#

using Pkg
Pkg.activate(".", io=devnull)
using Pipe

# run via 
# julia ./code/DVH_2022_9.jl ./data/input_2022_9.txt

function main(args)
    # @show args
    fn = args[1]

    lines = @pipe read(fn, String) |> rstrip |> split(_, "\n")

    function parse_line(s::AbstractString)::Union{Int, Vector{Int}}
        s == "noop" ? (return 0) : nothing 
        return @pipe s |> split(_, " ")[2] |> [0, parse(Int, _)]
    end

    # these are the values during each cycle
    cycles_of_interest = [20, 60, 100, 140, 180, 220]
    X = @pipe parse_line.(lines) |> vcat(_...) |> accumulate(+, _; init=1) |> [1, _...]
    cycles = 1:length(X)
    signal_strength = cycles .* X
    solution_1 = signal_strength[cycles_of_interest] |> sum

    make_sprite(i::Int)::UnitRange = i-1:i+1
    sprites = make_sprite.(X)
    crt = repeat(0:39, 6)
    screen = @pipe zip(crt, sprites[1:end-1]) .|> (_[1] ∈ _[2]) |> reshape(_, (40,6)) |> permutedims
    # and look at the letters, should be FBURHZCH
    solution_2 = "FBURHZCH"

    @show solution_1, solution_2
end
main(ARGS)

# args = ["./data/input_2022_10_small.txt"]
# args = ["./data/input_2022_10_smaller.txt"]
# args = ["./data/input_2022_10.txt"]
# fn = args[1]

