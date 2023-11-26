#=
author: Daan Van Hauwermeiren
AoC 2022 day 12
=#
using Pkg
Pkg.activate(".", io=devnull)
using Pipe

# run via 
# julia ./code/DVH_2022_12.jl ./data/input_2022_12.txt

function perform_mixing!(numbers, order)
    N = length(numbers)
    for ii in 1:length(numbers)
        # @show numbers
        idx = findfirst(order.==ii)
        element = popat!(numbers, idx)
        popat!(order, idx);
        # @show idx, element
        # double check this for bounds
        # new_idx = mod(idx + element, eachindex(IndexLinear(), numbers))
        new_idx = mod(idx + element, 1:(N-1))
        new_idx = (new_idx==1) ? N : new_idx
        insert!(numbers, new_idx, element)
        insert!(order, new_idx, ii)
        # @show numbers
    end
end

function main(args)
    fn = args[1]
    numbers = @pipe readlines(fn) |> parse.(Int, _) #|> CircularArray
    order = collect(1:length(numbers))
    perform_mixing!(numbers, order)
    solution_1 = @pipe findfirst(numbers.==0) .+ [1000, 2000, 3000]  .|> mod(_, length(numbers)) |> numbers[_] |> sum

    numbers = @pipe readlines(fn) |> parse.(Int, _) |> (811589153 .* _) 
    order = collect(1:length(numbers))
    [perform_mixing!(numbers, order) for ii in 1:10]
    solution_2 = @pipe findfirst(numbers.==0) .+ [1000, 2000, 3000]  .|> mod(_, length(numbers)) |> numbers[_] |> sum
    
    @show solution_1, solution_2
end
main(ARGS)



