#=
Created on 04/12/2023 09:11:39
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Day 5: scratching
=#

using Pkg
Pkg.activate(".", io=devnull)
# using ...
function main(args=["data/input_2023_4.txt"])

    data = "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"

    data = read(args[1], String) |> rstrip

    pint(string) = parse(Int, string)

    function parse_data(data)
        lines = split(rstrip(data), "\n")
        mynumbers = Vector{Int}[]
        outcomes = Vector{Int}[]
        for l in lines
            outs, nums = split(l, r"\W+\|\W+")
            outs = split(outs, r":\W+")[2]
            outcome = split(outs, r"\W+") .|> pint
            push!(mynumbers, split(nums, r"\W+") .|> pint)
            push!(outcomes, outcome)
        end
        return outcomes, mynumbers
    end

    outcomes, mynumbers = parse_data(data)

    function get_score(outcomes, mynumbers)
        solution1 = 0
        n_cards = ones(Int, length(outcomes))
        for (i, (outcome, mynums)) in enumerate(zip(outcomes, mynumbers))
            n_match = length(intersect(outcome, mynums))
            solution1 += n_match > 0 ? 2^(n_match-1) : 0
            for j in (i+1):(i+n_match)
                n_cards[j] += n_cards[i]
            end

        end
        return solution1, sum(n_cards)
    end

    solution1, solution2 = get_score(outcomes, mynumbers)

    @show solution1, solution2

    return solution1,solution2
end

main(ARGS)