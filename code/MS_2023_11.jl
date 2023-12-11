#=
Created on 11/12/2023 09:00:46
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Day 11: counting galaxiies
=#

args=["data/input_2023_11.txt"]

data = read(args[1], String) |> rstrip


galaxy = vcat([[c=='#' for _ in 1:1, c in line] for line in split(data, "\n")]...)

function pairwise_distances(galaxy; expansion=2)
    row_exp = findall(==(0), sum(galaxy, dims=2)[:])
    col_exp = findall(==(0), sum(galaxy, dims=1)[:])
    locations = findall(galaxy) .|> Tuple
    N = length(locations)
    totaldist = 0
    for i in 1:N-1
        loci = locations[i]
        for j in (i+1):N
            locj = locations[j]
            (k, m), (l, n) = minmax(loci[1], locj[1]), minmax(loci[2], locj[2])
            totaldist += sum(abs, ((k-m), (l-n)))
            totaldist += length(row_exp ∩ (k:m)) * (expansion-1)
            totaldist += length(col_exp ∩ (l:n)) * (expansion-1)
        end
    end
    return totaldist
end

solution1 = pairwise_distances(galaxy)

solution2 = pairwise_distances(galaxy, expansion=1000_000)