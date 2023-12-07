#=
Created on 01/12/2023 12:11:58
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

AoC day 1: Calibration!
=#
using Pkg
Pkg.activate(".", io=devnull)

pint(string) = parse(Int, string)

example = """
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet"""

function get_calibaration_value(line)
    f = line[findfirst(c->c ∈ "0123456789", line)] |> pint
    l = line[findlast(c->c ∈ "0123456789", line)] |> pint
    return 10f + l
end

function main(args)
    fn = args[1]
    data = read(fn, String) |> rstrip

    solution1 = split(data, "\n") .|> rstrip .|> get_calibaration_value |> sum 


    denumber!(line) =  replace(line, 
    "one"=>1,
    "two"=>2,
    "three"=>3,
    "four"=>4,
    "five"=>5,
    "six"=>6,
    "seven"=>7,
    "eight"=>8,
    "nine"=>9,
    )

    denumber(line) =  replace(line, 
    "one"=>"o1e",
    "two"=>"t2o",
    "three"=>"t3e",
    "four"=>"f4fr",
    "five"=>"f5e",
    "six"=>"s6x",
    "seven"=>"s7n",
    "eight"=>"e8t",
    "nine"=>"n9e",
    )

    solution2 = split(data, "\n") .|> rstrip .|> denumber .|> denumber .|> get_calibaration_value |> sum 

    @show solution1, solution2
end
main(ARGS)