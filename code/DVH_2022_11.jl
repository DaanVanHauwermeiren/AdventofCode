#=
author: Daan Van Hauwermeiren
AoC 2022 day 11
=#

using Pkg
Pkg.activate(".", io=devnull)
using Pipe

# run via 
# julia ./code/DVH_2022_11.jl ./data/input_2022_11.txt

    
mutable struct Monkey
    items :: Vector{Int}
    operation :: Function
    testmodulo :: Int
    throw_to :: Dict{Bool, Int}
    inspection :: Int
end

parse_throw_to(l) = @pipe l |> lstrip(_) |> _[4:end] |> split(_, ": throw to monkey ") |> Pair(parse(Bool, _[1]), parse(Int, _[2]))

function round!(monkeys::Dict{Int, Monkey}, worry_reduction::Int)
    numbers = sort(collect(keys(monkeys)))
    for i in numbers
        for item in monkeys[i].items
            # inspecting an item
            monkeys[i].inspection += 1
            # increasing worry level,gets bored, and reduce worry level
            # solution 1
            if worry_reduction == 3
                item_ = monkeys[i].operation(item) ÷ worry_reduction
                # solution 2
            else
                # this is the modulo trick:
                # modulo the item by the product of all modulos
                item_ = monkeys[i].operation(item) % worry_reduction
            end
            destination = monkeys[i].throw_to[item_ % monkeys[i].testmodulo == 0]
            push!(monkeys[destination].items, item_)
        end
        # no more items for monkey i
        monkeys[i].items = []
    end
end

function generate_monkey(s::AbstractString)::Tuple{Int, Monkey}
    splits = @pipe s |> split(_, "\n")
    id = @pipe splits[1] |> split(_, " ")[2][1:end-1] |> parse(Int, _)
    items = @pipe splits[2] |> split(_, ": ")[2] |> split(_, ", ") |> parse.(Int, _)
    # operation = @pipe splits[3] |> split(_, " old ")[2] |> eval(Meta.parse("x -> x $_"))
    raw_operation = @pipe splits[3] |> lstrip(_) |> split(_, "Operation: ")[2] 
    operation_string = replace(raw_operation, "new"=>"x", "="=>"->", "old"=>"x")
    operation = eval(Meta.parse(operation_string))
    # NOTE: tests are all of the form: "divisible by ..."
    test = @pipe splits[4] |> split(_, "by ")[2] |> parse(Int, _)#eval(Meta.parse("x -> x % $_ == 0"))
    throw_to = parse_throw_to.(splits[5:end]) |> Dict
    return id, Monkey(items, operation, test, throw_to, 0)
end

parse_input(fn::String)::Dict{Int,Monkey} = @pipe read(fn, String) |> rstrip |> split(_, "\n\n") |> generate_monkey.(_) |> Dict


  
# function main(args)
#     # @show args
#     fn = args[1]
#     @show solution_1, solution_2
# end
# main(ARGS)

args = ["./data/input_2022_11.txt"]
# args = ["./data/input_2022_11_small.txt"]
fn = args[1]

monkeys = parse_input(fn)
for _ in 1:20
    round!(monkeys, 3)
end
solution_1 = @pipe values(monkeys) .|> _.inspection |> sort |> _[end-1:end] |> prod


monkeys = parse_input(fn)
numbers = sort(collect(keys(monkeys)))
# this is the modulo trick
worry_reduction = @pipe values(monkeys) .|> _.testmodulo |> prod
for _ in 1:10000
    round!(monkeys, worry_reduction)
end
solution_2 = @pipe values(monkeys) .|> _.inspection |> sort |> _[end-1:end] |> prod  

@show solution_1, solution_2