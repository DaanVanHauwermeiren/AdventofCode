#=
Created on 05/12/2023 13:38:25
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Day 5: Gardening
=#

using Pkg
Pkg.activate(".", io=devnull)
using ProgressBars
function main(args=["data/input_2023_5.txt"])

pint(string) = parse(Int, string)

data = "seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4"

data = read(args[1], String) |> rstrip

parts = split(data, "\n\n")

seeds = [pint(m.match) for m in eachmatch(r"\d+", parts[1])]

metamaps = [[Tuple(pint(m.match) for m in eachmatch(r"\d+", l))
                for l in split(p, "\n")[2:end]] for p in parts[2:end]]

function map_source(source, maps)
    for (dest_range_start, source_range_start, rl) in maps
        if source ∈ range(start=source_range_start, length=rl)
            return dest_range_start + (source - source_range_start)
        end
    end
    return source
end

function seed2soil(source, metamaps)
    for maps in metamaps
        source = map_source(source, maps)
    end
    return source
end

maps=[(50, 98, 2),(52,50,48)]

map_source.([79,14,55,13], Ref(maps))

@show solution1 = minimum(seed->seed2soil(seed, metamaps), seeds)




function find_sol2(seeds, metamaps)
    solution2 = 2^60

    for (seedstart, seedrange) in ProgressBar(zip(seeds[1:2:end], seeds[2:2:end]))
        solution2 = min(minimum(seed->seed2soil(seed, metamaps),
                        range(start=seedstart, length=seedrange)), solution2)
        @show solution2
    end
    return solution2
end
    
solution2 = find_sol2(seeds, metamaps)
@show solution1, solution2

return solution1, solution2
end

main(ARGS)