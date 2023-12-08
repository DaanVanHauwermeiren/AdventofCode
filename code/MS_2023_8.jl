#=
Created on 08/12/2023 08:28:41
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Day 8: navigating 
=#

using Base.Iterators: cycle

data = "RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)"

data = read("data/input_2023_8.txt", String) |> rstrip

function parse_input(data)
    direction, splits = split(data, "\n\n")
    direction = [c=='L' ? 1 : 2 for c in direction]
    splits_dict = Dict{String,NTuple{2,String}}()
    for l in split(splits, "\n")
        m = match(r"(...) = \((...), (...)\)", l)
        splits_dict[m[1]] = (m[2], m[3])
    end
    return direction, splits_dict
end

directions, splits = parse_input(data)

function find_way(directions, splits, start="AAA", goal=isequal("ZZZ"))
    pos = start
    for (i, d) in enumerate(cycle(directions))
        l, r = splits[pos]
        pos = d==1 ? l : r
        goal(pos) && return i
    end
end

solution1 = find_way(directions, splits)

A_ending_nodes = filter(n->last(n)=='A', keys(splits)) |> collect

function all_converge(directions, splits, starts)
    positions = starts
    for (i, d) in enumerate(cycle(directions))
        for (k, p) in enumerate(positions)
            positions[k] = splits[p][d]
        end
        all(p->last(p)=='Z', positions) && return i
    end
end

solution2 = lcm([find_way(directions, splits, start, pos->last(pos)=='Z') for start in A_ending_nodes]...)
        