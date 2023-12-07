#!.venv/bin/python3

"""
author: Daan Van Hauwermeiren
AoC: 2023 day 3
"""
from collections import defaultdict
from math import prod
import re
import sys

import numpy as np

def main() -> tuple[int, int]:
    fn: str = sys.argv[1]

    with open(fn, mode="r") as f:
        raw: list[str] = f.read().split("\n")

    # get dimensions
    width: int = len(raw[0].strip())
    height: int = len(raw)

    # preallocate the symbols grid
    issymbol = np.zeros((width, height), dtype=bool)

    # building symbols grid
    for ii, line in enumerate(raw):
        for jj, cc in enumerate(line):
            # match the symbols: not a number nor a dot
            if cc not in "1234567890.":
                issymbol[ii, jj] = True

    l_numbers: list[int] = []
    # now look in the rectangular neighborhood of each symbol
    for ii, line in enumerate(raw):
        # match all the numbers in the string
        for matched in re.finditer(r'\d+', line):
            start = matched.start()
            end = matched.end()
            # look in the neighborhood of each number
            rowmin = max(0, ii-1)
            rowmax = min(height, ii+2)
            colmin = max(0, start-1)
            colmax = min(width, end+1)
            print(rowmin, rowmax, colmin, colmax)
            print(issymbol[rowmin:rowmax, colmin:colmax])
            if any(issymbol[rowmin:rowmax, colmin:colmax].flatten()):
                l_numbers.append(int(matched.group()))

    solution_1 = sum(l_numbers)

    # preallocate the symbols grid
    isstar = np.zeros((width, height), dtype=bool)

    for ii, line in enumerate(raw):
        for jj, cc in enumerate(line):
            # match the symbols: not a number nor a dot
            if cc == "*":
                isstar[ii, jj] = True

    counted_stars = defaultdict(list)

    for ii, line in enumerate(raw):
        # match all the numbers in the string
        for matched in re.finditer(r'\d+', line):
            start = matched.start()
            end = matched.end()
            # look in the neighborhood of each number
            rowmin = max(0, ii-1)
            rowmax = min(height, ii+2)
            colmin = max(0, start-1)
            colmax = min(width, end+1)
            if any(isstar[rowmin:rowmax, colmin:colmax].flatten()):
                print(rowmin, rowmax, colmin, colmax)
                print(isstar[rowmin:rowmax, colmin:colmax])

                indices = np.where(isstar[rowmin:rowmax, colmin:colmax])
                # assuming just 1 match
                ii_star = range(rowmin, rowmax)[indices[0][0]]
                jj_star = range(colmin, colmax)[indices[1][0]]

                counted_stars[(ii_star, jj_star)].append(int(matched.group()))


    solution_2 = 0
    for key, value in counted_stars.items():
        if len(value) == 2:
            solution_2 += prod(value)
    
    return solution_1, solution_2


if __name__ == '__main__':
    solutions: tuple[int, int] = main()
    print(solutions)