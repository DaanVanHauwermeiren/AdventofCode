#=
Created on 02/12/2023 13:00:17
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Day 2: Colorgame!
=#

using Pkg
Pkg.activate(".", io=devnull)
# using ...
function main(args=["data/input_2023_2.txt"])

    parse_line(line) = split(match(r"Game \d+: (.+)", rstrip(line))[1], ";")

    function parse_draw(draw)
        count_cols = m -> isnothing(m) ? 0 : parse(Int, m[1])
        red = match(r"(\d+) red", draw) |> count_cols
        blue = match(r"(\d+) blue", draw) |> count_cols
        green = match(r"(\d+) green", draw) |> count_cols
        return (red, green, blue)
    end

    data = read(args[1], String) |> rstrip

    game_results = [parse_draw.(draws) for draws in parse_line.(split(data, "\n"))]

    game = (12, 13, 14)

    solution1 = sum(id for (id, draws) in enumerate(game_results)
                    if all(all(draw .≤ game) for draw in draws))

    min_cols(draws) = reduce((d1, d2)->max.(d1,d2), draws)


    solution2 = min_cols.(game_results) .|> prod |> sum

    @show solution1, solution2
    
    return solution1, solution2
end

main(ARGS)