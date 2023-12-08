#!.venv/bin/python3

"""
author: Daan Van Hauwermeiren
AoC: 2023 day 8
"""
from math import lcm
import sys


def loop_instructions(curval: str, n_steps: int, instruction: str, dd: dict[str, list[str]]) -> tuple[str, int]:
    for ii in instruction:
        if ii == "L":
            curval = dd[curval][0]
            n_steps += 1
        else:
            curval = dd[curval][1]
            n_steps += 1
    return curval, n_steps


def main() -> tuple[int, int]:
    fn: str = sys.argv[1]

    with open(fn, mode="r") as f:
        raw: str = f.read()
    instruction, raw_map = raw.split("\n\n")

    raw_map: list[str] = raw_map.splitlines()
    dd: dict[str, list[str]] = {}

    for line in raw_map:
        key, value = line.split(" = ")
        value = value[1:-1].split(", ")
        dd[key] = value

    curval = "AAA"
    n_steps = 0
    while curval != "ZZZ":
        curval, n_steps = loop_instructions(curval, n_steps, instruction, dd)
    solution_1: int = n_steps


    # this never converges in sufficient time
    # def loop_instructions_v2(curvals: list[str], n_steps: int, instruction: str=instruction):
    #     for ii in instruction:
    #         if ii == "L":
    #             curvals = [dd[ii][0] for ii in curvals]
    #             n_steps += 1
    #         else:
    #             curvals = [dd[ii][1] for ii in curvals]
    #             n_steps += 1
    #     return curvals, n_steps

    # curvals = [ii for ii in list(dd.keys()) if ii[-1] == "A"]
    # n_steps = 0
    # while any([ii[-1] != "Z" for ii in curvals]):
    #     curvals, n_steps = loop_instructions_v2(curvals, n_steps)
    # solution_2 = n_steps


    # create a mapping with the start and end values for each key after the instructions
    dd_afterinstructions: dict[str, str] = {}
    for k in dd.keys():
        curval = k
        for ii in instruction:
            if ii == "L":
                curval: str = dd[curval][0]
            else:
                curval = dd[curval][1]
        endval: str = curval
        dd_afterinstructions[k] = endval
        
    # again, this never converges in sufficient time
    # curvals = [ii for ii in list(dd.keys()) if ii[-1] == "A"]
    # n_loops = 0
    # while any([ii[-1] != "Z" for ii in curvals]):
    #     curvals = [dd_afterinstructions[ii] for ii in curvals]
    #     n_loops += 1
    # solution_2 = n_loops


    # The actual solution that runs fast is to find the LCM of the cycle lengths of the keys
    startvals = [ii for ii in list(dd.keys()) if ii[-1] == "A"]
    dd_startnloops: dict[str, int] = {}
    for val in startvals:
        n_loops = 0
        curval = val
        while curval[-1] != "Z":
            curval = dd_afterinstructions[curval]
            n_loops += 1
        dd_startnloops[val] = n_loops

    solution_2: int = lcm(*dd_startnloops.values()) * len(instruction)


    return solution_1, solution_2


if __name__ == '__main__':
    solutions: tuple[int, int] = main()
    print(solutions)