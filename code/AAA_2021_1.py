#!.venv/bin/python3

"""
author: Daan Van Hauwermeiren
AoC: day 1
"""
import sys

import numpy as np

def main() -> tuple[int, int]:
    fn = sys.argv[1]

    with open(fn, mode="r") as f:
        raw = f.readlines()

    def parse_input(data):
        return np.array([int(i.strip()) for i in data])

    data = parse_input(raw)

    solution_1 = sum(np.diff(data) > 0)

    rolling_mean_3 = np.sum(
        np.vstack((
            np.roll(data, 0), 
            np.roll(data, 1), 
            np.roll(data, 2))),
        axis=0)[2:]
    solution_2 = sum(np.diff(rolling_mean_3) > 0)

    return solution_1, solution_2


if __name__ == '__main__':
    solutions = main()
    print(solutions)