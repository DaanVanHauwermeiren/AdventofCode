#=
author: Daan Van Hauwermeiren
AoC 2022 day 6
=#
using Pkg
Pkg.activate(".")
using Pipe
# using Test

# run via 
# julia ./code/DVH_2022_6.jl ./data/input_2022_6.txt

function find_first_unique_subset(datastream::AbstractString, no_chars::Int)::Int
    for i in no_chars:1:length(datastream)-1
        no_unique_chars = datastream[i-(no_chars-1):i] |> Set |> length
        if no_unique_chars == no_chars
            return i
        end
    end
    return -1
end

find_first_marker(datastream::AbstractString) = find_first_unique_subset(datastream, 4)
find_first_message(datastream::AbstractString) = find_first_unique_subset(datastream, 14)

#=
@testset "small streams" begin
    @test find_first_marker("bvwbjplbgvbhsrlpgdmjqwftvncz") == 5
    @test find_first_marker("nppdvjthqldpwncqszvftbrmjlhg") == 6
    @test find_first_marker("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 10
    @test find_first_marker("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 11
end

@testset "small streams" begin
    @test find_first_message("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 19
    @test find_first_message("bvwbjplbgvbhsrlpgdmjqwftvncz") == 23
    @test find_first_message("nppdvjthqldpwncqszvftbrmjlhg") == 23
    @test find_first_message("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 29
    @test find_first_message("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 26
end
=#

function main(args)
    @show args
    fn = args[1]
    
    datastream = read(fn, String) |> rstrip
    
    solution_1 = find_first_marker(datastream)
    solution_2 = find_first_message(datastream)

    @show solution_1, solution_2
end
main(ARGS)

# args = ["./data/input_2022_6.txt"]
# fn = args[1]

