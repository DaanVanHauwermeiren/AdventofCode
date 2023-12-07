#!.venv/bin/python3

"""
author: Daan Van Hauwermeiren
AoC: 2023 day 6
"""
from math import prod
import sys

def compute_distance(thold:int, tmax:int, v0:int=0) -> int:
    assert thold <= tmax, "thold must be less than tmax"
    v = v0 + thold
    distance = v * (tmax - thold)
    return distance

# assert [compute_distance(ii, 7) for ii in range(7+1)] == [0, 6,10,12,12,10,6,0]

def compute_scenarios(time: int) -> list[int]:
    scenarios: list[int] = []
    for thold in range(time+1):
        scenarios.append(compute_distance(thold, time))
    return scenarios


def main() -> tuple[int, int]:
    fn: str = sys.argv[1]

    with open(fn, mode="r") as f:
        raw: str = f.read().strip()
    
    l_times, l_distances = [[int(jj) for jj in ii.split()[1:]] for ii in raw.splitlines()]
    solution_1 = 1
    for tt, dd in zip(l_times, l_distances):
        n_wins = sum([ii > dd for ii in compute_scenarios(tt)])
        solution_1 *= n_wins

    tt, dd = [int("".join(ii.split(":")[1:]).replace(" ", "")) for ii in raw.splitlines()]
    solution_2 = sum([ii > dd for ii in compute_scenarios(tt)])
    
    return solution_1, solution_2


if __name__ == '__main__':
    solutions: tuple[int, int] = main()
    print(solutions)