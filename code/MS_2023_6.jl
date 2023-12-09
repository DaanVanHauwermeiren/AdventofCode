#=
Created on 06/12/2023 08:59:56
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Day six: boat race
=#

using Pkg
Pkg.activate(".", io=devnull)
# using ...
function main(args=["data/input_2023_6.txt"])

pint(string) = parse(Int, string)

data = read(args[1], String) |> rstrip

lines = split(data, "\n")

times = split(lines[1], r"\W+")[2:end] .|> pint
distances = split(lines[2], r"\W+")[2:end] .|> pint

time = split(lines[1], r"\W+")[2:end] |> join |> pint
distance = split(lines[2], r"\W+")[2:end] |> join |> pint

function button_times(t, d)
    # find roots
    ϵ = 1e-6  # margin to win
    t^2 - 4d < 0 && return 0
    α₁ = ceil(Int, (t - √(t^2 - 4d)) / 2 + ϵ)
    α₂ = floor(Int, (t + √(t^2 - 4d)) / 2 - ϵ)
    return length(α₁:α₂)
end


solution1 = button_times.(times, distances) |> prod

solution2 = button_times(time, distance)

@show solution1, solution2
return solution1,solution2
end

main(ARGS)