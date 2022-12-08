#=
author: Daan Van Hauwermeiren
AoC 2022 day 5
=#
using Pkg
Pkg.activate(".")
using Pipe

# run via 
# julia ./code/DVH_2022_1.jl ./data/input_2022_1.txt

# create a struct so that we can define pop and push on this type
mutable struct Cratestack
    # n stacks of a vector of strings
    # do not need to be of same length
    stack::Vector{Vector{String}}
end
function Base.pop!(c::Cratestack, i::Int)::String
    return pop!(c.stack[i])
end
Base.push!(c::Cratestack, el::String, i::Int) = push!(c.stack[i], el)

"""
Operate the crane by popping and pushing elements from one stack to another
"""
function operate!(c::Cratestack, n::Int, source::Int, dest::Int)
    # for each repetition:
    for _ in 1:n
        # remove from source stack and get crate
        el = pop!(c, source)
        # push crate on top of the destination stack
        push!(c, el, dest)
    end
end

function Base.popat!(c::Cratestack, i::Int, loc::Int)::String
    return popat!(c.stack[i], loc)
end
"""
instead of simply popping and pushing, multiple crates are moved at once.
This means that the order on the destination stack is reversed compared to part 1.
Instead of working with an intermediate stack, I choose to keep the pop and push operations,
but instead of popping the top of the stack, I always pop at top-n with n the number of crates moved at onces.
This results in the correct order at the destination stack
"""
function operatev2!(c::Cratestack, n::Int, source::Int, dest::Int)
    loc = size(c.stack[source],1) - (n -1)
    for i in 1:n
        el = popat!(c, source, loc)
        push!(c, el, dest)
    end
end

# this is an example on how to get command line arguments into the file
function main(args)
    @show args
    fn = args[1]
    
    raw = read(fn, String) |> rstrip;
    # split on the empty row
    layout, operations = @pipe raw |> split(_, "\n\n")
    # each operation in the pipe:
    # split into rows
    # split string in to vector of single char strings
    # vector of vectors to matrix
    # slice matrix to get only vectors the crate letters and none of the other characters
    # reverse order on the vectors (to make pop and push work later on)
    # remove the empty strings from the vectors
    layout = @pipe layout |> split(_, "\n") |> split.(_, "") |> hcat(_...) |> [_[j,1:end-1] for j in 2:4:size(_, 1)] |> reverse.(_) |> filter.(i->i!=" ", _)
    # each operation in the pipe:
    # split into rows
    # remove first part of the row
    # split on " from "
    # concatenate into matrix
    # take first element as is, split second element on " to "
    # cast to matrix by hcat, nested hcat and permutedims is needed because element 1 is a vector, element 2 is a vector of vectors
    # parse all strings to integers
    # result: matrix of integers, with each row:
    # [the number of items to move, source stack, end stack]
    operations = @pipe operations |> split(_, "\n") |> replace.(_, "move "=>"") |> split.(_, " from ") |> hcat(_...) |> [_[1,:], split.(_[2, :], " to ")] |> hcat(_[1], permutedims(hcat(_[2]...))) |> parse.(Int, _)

    c = Cratestack(layout)
    @pipe eachrow(operations) .|> operate!(c, _...) ;
    # top elements of each stack as a message
    solution_1 = last.(c.stack) |> prod



    # create the stack once again
    c = Cratestack(layout)
    # apply the operations on the stack
    @pipe eachrow(operations) .|> operatev2!(c, _...) ;
    # top elements of each stack as a message
    solution_2 = last.(c.stack) |> prod

    @show solution_1, solution_2
end
main(ARGS)

# args = ["./data/input_2022_5.txt"]
# args = ["./data/input_2022_5_small.txt"]
# fn = args[1]

