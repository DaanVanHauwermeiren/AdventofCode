#!.venv/bin/python3

"""
author: Daan Van Hauwermeiren
AoC: 2023 day 5
"""
import sys

# first attempt: this overflows memory

# with open(fn, mode="r") as f:
#     raw: str = f.read().strip()
# seeds, seed2soil, soil2fert, fert2water, water2light, light2temp, temp2humid, humid2loc = source.split("\n\n")
# seeds = [int(x) for x in seeds.split(": ")[1].split(" ")]
# def parse_map(map_str) -> list[list[int]]:
#     return [[int(x) for x in y.split(" ")] for y in map_str.split("\n")[1:]]
# def get_mapper_dict(derp: list[list[int]]) -> dict[int, int]:
#     dd:dict[int, int] = dict()
#     for (end_node, start_node, step) in derp:
#         # print(start_node, end_node, step)
#         for ii, jj in zip(range(start_node, start_node+step), range(end_node, end_node+step)):
#             # print(ii, jj)
#             dd[ii] = jj
#     return dd
# seed2soil = get_mapper_dict(parse_map(seed2soil))
# soil2fert = get_mapper_dict(parse_map(soil2fert))
# fert2water = get_mapper_dict(parse_map(fert2water))
# water2light = get_mapper_dict(parse_map(water2light))
# light2temp = get_mapper_dict(parse_map(light2temp))
# temp2humid = get_mapper_dict(parse_map(temp2humid))
# humid2loc = get_mapper_dict(parse_map(humid2loc))
# def map2loc(seed: int,
#             seed2soil=seed2soil,
#             soil2fert=soil2fert,
#             fert2water=fert2water,
#             water2light=water2light,
#             light2temp=light2temp,
#             temp2humid=temp2humid,
#             humid2loc=humid2loc):
#     # this is a horrible way to do recursion
#     # print("seed", seed)
#     ii = seed2soil.get(seed, seed)
#     # print("soil", ii)
#     jj = soil2fert.get(ii, ii)
#     # print("fert", jj)
#     kk = fert2water.get(jj, jj)
#     # print("water", kk)
#     ll = water2light.get(kk, kk)
#     # print("light", ll)
#     mm = light2temp.get(ll, ll)
#     # print("humid", mm)
#     nn = temp2humid.get(mm, mm)
#     # print("humid", nn)
#     oo = humid2loc.get(nn, nn)
#     # print("loc", oo)
#     return oo
# seeds, [map2loc(ii) for ii in seeds]


# second iteration: this works but only for solution 1
# def parse_map(map_str) -> list[list[int]]:
#     return [[int(x) for x in y.split(" ")] for y in map_str.split("\n")[1:]]

# def get_ranges(derp: list[list[int]]) -> list[tuple[int, int, int]]:
#     ranges: list[tuple[int, int, int]] = []
#     for (end_node, start_node, step) in derp:
#         ranges.append((start_node, start_node+step, end_node))
#     return ranges

# def parse_single_mapping(seed: int, ranges: list[tuple[int, int, int]]) -> int:
#     for (start, end, end_node) in ranges:
#         if start <= seed < end:
#             return end_node + (seed - start)
#     return seed

# def map2loc(seed: int)->int:
#     # this is a horrible way to do recursion
#     ii = parse_single_mapping(seed, seed2soil)
#     jj = parse_single_mapping(ii, soil2fert)
#     kk = parse_single_mapping(jj, fert2water)
#     ll = parse_single_mapping(kk, water2light)
#     mm = parse_single_mapping(ll, light2temp)
#     nn = parse_single_mapping(mm, temp2humid)
#     oo = parse_single_mapping(nn, humid2loc)
#     return oo

# def main():
#     seeds_raw, seed2soil, soil2fert, fert2water, water2light, light2temp, temp2humid, humid2loc = source.split("\n\n")
#     seeds: list[int] = [int(x) for x in seeds_raw.split(": ")[1].split(" ")]
#     solution_1 = min([map2loc(ii) for ii in seeds])




# now the actual good solution

def parse_map(map_str) -> list[list[int]]:
    return [[int(x) for x in y.split(" ")] for y in map_str.split("\n")[1:]]

def get_ranges(derp: list[list[int]]) -> list[tuple[int, int, int]]:
    ranges: list[tuple[int, int, int]] = []
    for (end_node, start_node, step) in derp:
        ranges.append((start_node, start_node+step, end_node))
    return ranges

def main() -> tuple[int, int]:
    fn: str = sys.argv[1]

    with open(fn, mode="r") as f:
        raw: str = f.read().strip()

    seeds_raw, *maps_raw = raw.split("\n\n")
    seeds_v1: list[int] = [int(x) for x in seeds_raw.split(": ")[1].split(" ")]

    maps: list[list[tuple[int, int, int]]] = [get_ranges(parse_map(x)) for x in maps_raw]

    values: list[int] = seeds_v1
    for ranges in maps:
        new_values: list[int] = []
        for vv in values:
            for (start, end, end_node) in ranges:
                if start <= vv < end:
                    new_values.append(end_node + (vv - start))
                    break
            else:
                new_values.append(vv)
        values = new_values

    solution_1 = min(values)



    seeds_v2 = [int(ii) for ii in raw.split("\n\n")[0].split(": ")[1].split(" ")]
    seeds_v2: list[tuple[int, int]] = [(seeds_v2[ii], seeds_v2[ii]+seeds_v2[ii+1]) for ii in range(0, int(len(seeds_v2)/2)+1, 2)]

    for ranges in maps:
        new_seeds: list[tuple[int, int]] = []
        while len(seeds_v2) > 0:
            ss, ee = seeds_v2.pop(0)
            for (start, end, end_node) in ranges:      
                interval_start = max(ss, start)
                interval_end = min(ee, end)
                if interval_start < interval_end:
                    new_seeds.append((interval_start - start + end_node, interval_end - start + end_node))
                    if interval_start > ss:
                        seeds_v2.append((ss, interval_start))
                    if ee > interval_end:
                        seeds_v2.append((interval_end, ee))
                    break
            else:
                new_seeds.append((ss, ee))
        seeds_v2 = new_seeds
    
    solution_2 = min(seeds_v2)[0]
    
    return solution_1, solution_2


if __name__ == '__main__':
    solutions: list[int] = main()
    print(solutions)