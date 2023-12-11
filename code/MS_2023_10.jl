#=
Created on 10/12/2023 10:32:17
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Day 10: pipes
=#

args=["data/input_2023_10.txt"]

data = read(args[1], String) |> rstrip

blueprint = vcat([[c for _ in 1:1, c in line] for line in split(data, "\n")]...)

#=
| is a vertical pipe connecting north and south.
- is a horizontal pipe connecting east and west.
L is a 90-degree bend connecting north and east.
J is a 90-degree bend connecting north and west.
7 is a 90-degree bend connecting south and west.
F is a 90-degree bend connecting south and east.
. is ground; there is no pipe in this tile.
S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.
=#

pipe2vec = Dict('|'=>(0,1),
                '-'=>(1,0),
                'L'=>(1,-1),
                'J'=>(-1,-1),
                '7'=>(1, 1))

function follow_path(blueprint, (i, j), (di, dj))
    start = (i, j)
    n, m = size(blueprint)
    dist = 0
    D = zeros(Int, n, m)
    while true
        i, j = i + di, j + dj
        (i,j) == start && break
        # check in bound
        (1 ≤ i ≤ n && 1 ≤ j ≤ m) || break
        S = blueprint[i, j]
        S == '.' && break
        if S=='|' && di != 0
            # mark right
            k, l = i, j - di
            D[k,l] > 0 || (D[k,l] = -1)
        elseif S=='-' && dj != 0
            # mark right
            k, l = i + dj, j
            D[k,l] > 0 || (D[k,l] = -1)
        elseif S=='L' && (di==1 || dj==-1)
            di, dj = dj, di
        elseif S=='J' && (di==1 || dj==1)
            di, dj = -dj, -di
        elseif S=='7' && (di==-1 || dj==1)
            di, dj = dj, di
        elseif S=='F' && (di==-1 || dj==-1)
            di, dj = -dj, -di
        else
            break
        end
        dist += 1
        D[i, j] = dist
    end
    return dist, D
end

S = findfirst(==('S'), blueprint) |> Tuple

blueprint[20:30,70:85]

l, D = follow_path(blueprint, S, (-1, 0))

solution1 = l ÷ 2 + 1

# close D
function find_inside!(D)
    n, m = size(D)
    changed = -1
    contour = zeros(Int, 9)
    indices = [1, 4, 7, 8, 9, 6, 3, 2, 1]

    for t in 1:140
        changed = 0
        for i in 2:(n-1)
            for j in 2:(m-1)
                D[i,j] != 0 && continue
                Dss = @view D[(i-1):(i+1),(j-1):(j+1)]
                all(==(0), Dss) && continue
                contour .= Dss[indices]
                if Dss[1,2] < 0 || Dss[2,1] < 0 || Dss[2,3] < 0 || Dss[3,2] < 0 
                    D[i,j] = -1
                elseif any(==(1), diff(contour))
                    D[i,j] = -1
                end
            end
        end
    end
    return D
end

find_inside!(D)

solution2 = count(<(0), D) - 1