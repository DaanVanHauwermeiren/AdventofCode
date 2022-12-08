#=
author: Daan Van Hauwermeiren
AoC: 2021 day 1
=#
using Pkg
Pkg.activate(".")
using DelimitedFiles

function main(args)
    @show args
    fn = args[1]
        
    # read data to vector
    data = vec(readdlm(fn, Int64))

    # function to get the number of positive values in a vector 
    get_n_positive(a::Vector) = a .|> (x -> x>0) |> sum

    solution_1 = get_n_positive(diff(data)) 

    window_3_sum(x::Vector) = [sum(x[i-2:i]) for i in 3:length(x)]
    solution_2 = get_n_positive(diff(window_3_sum(data))) 
    @show solution_1, solution_2
end
main(ARGS)

