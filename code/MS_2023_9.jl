#=
Created on 09/12/2023 13:06:03
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Day 9: oasis
=#

using Pkg
Pkg.activate(".", io=devnull)

function main(args=["data/input_2023_9.txt"])

    pint(string) = parse(Int, string)

    history = [10 13 16 21 30 45] |> vec

    data = read(args[1], String) |> rstrip

    histories = [pint.(split(l, r"\s")) for l in split(data, "\n")]

    function predict_next(history)
        pred = last(history)
        while !all(==(0), history)
            history = diff(history)
            pred += last(history)
        end
        return pred
    end

    solution1 = sum(predict_next, histories)

    function predict_prev(history)
        firsts = [first(history)]
        while !all(==(0), history)
            history = diff(history)
            push!(firsts, first(history))
        end
        return reduce((a, b)->b-a , reverse!(firsts))
    end

    solution2 = sum(predict_prev, histories)

    @show solution1, solution2
end

main(ARGS)