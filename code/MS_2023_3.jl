#=
Created on 03/12/2023 15:41:39
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Day 3: machine schematics and gear grinding
=#

pint(string) = parse(Int, string)

data = rstrip(read("data/input_2023_3.txt", String))


lines = split(data, "\n")

n, m = length(lines), length(lines[1])

symbols = zeros(Bool, n, m)
symbols_neighborhood = zero(symbols)

gear_locations = Tuple{Int,Int}[]

for (i, l) in enumerate(lines)
    for (j, c) in enumerate(l)
        (c == '.' || occursin(c, "1234567890")) && continue
        symbols[i,j] = true
        c == '*' && push!(gear_locations, (i,j))
        for k in max(1,i-1):min(n,i+1)
            for l in max(1,j-1):min(m,j+1)
                symbols_neighborhood[k,l] = true
            end
        end
    end
end


numbers =  Tuple{Tuple{Int,UnitRange{Int64}},Int}[]
symbols = Tuple{Tuple{Int,Int},Char}[]

solution1 = 0

for (i, l) in enumerate(lines)
    for pos in findall(r"\d+", l)
        num = pint(l[pos])
        push!(numbers, ((i, pos), num))
        for j in pos
            if symbols_neighborhood[i,j]
                solution1 += num
                break
            end
        end
    end
end

solution1

solution2 = 0

in_nb((i,j), (k, pos)) = any(l-> max(abs(i-k), abs(j-l)) ≤ 1,  pos)

for (i, j) in gear_locations
    sol_part = 1
    for ((k, pos), num) in numbers
        if in_nb((i,j), (k, pos))
            if sol_part > 1
                sol_part = 0
            end
            sol_part *= -num
        end
    end
    sol_part > 0 && (solution2 += sol_part)
end

solution2
