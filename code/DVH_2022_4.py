#!.venv/bin/python3
# %%

"""
author: Daan Van Hauwermeiren
AoC 2022 day 4
"""
import sys
from typing import List
from dataclasses import dataclass, field

@dataclass
class Pair:
    start: int
    end: int


def is_fully_contained(pair1: Pair, pair2: Pair) -> bool:
    # case 1: first pair withing second:
    if (pair2.start <= pair1.start) & (pair1.end <= pair2.end):
        return True
    # case 2: second pair within first
    elif (pair1.start <= pair2.start) & (pair2.end <= pair1.end):
        return True
    else:
        return False

def is_overlap(pair1: Pair, pair2: Pair) -> bool:
    if (pair2.start <= pair1.end) & (pair2.start >= pair1.start):
        return True
    elif (pair2.end >= pair1.start) & (pair2.end <= pair1.end):
        return True
    elif (pair1.end <= pair2.end) & (pair1.end >= pair2.start):
        return True
    elif (pair1.end >= pair2.start) & (pair1.end <= pair2.end):
        return True
    else:
        return False

@dataclass
class Sectionpair:
    pair1: Pair = field(init=False)
    pair2: Pair = field(init=False)
    fully_contained: bool = field(init=False)
    overlap: bool = field(init=False)

    def __init__(self, raw: str) -> None:
        pair1, pair2 = raw.split(",")
        self.pair1 = Pair(*[int(k) for k in pair1.split('-')])
        self.pair2 = Pair(*[int(k) for k in pair2.split('-')])
        self.fully_contained = is_fully_contained(self.pair1, self.pair2)
        if self.fully_contained:
            self.overlap = True
        else:
            self.overlap = is_overlap(self.pair1, self.pair2)

def main() -> tuple[int, int]:
    fn = sys.argv[1]

    with open(fn, mode="r") as f:
        raw = [i.strip() for i in f.readlines()]

    l_pairs = [Sectionpair(i) for i in raw]

    solution_1 = sum(i.fully_contained for i in l_pairs)
    solution_2 = sum(i.overlap for i in l_pairs)

    return solution_1, solution_2


if __name__ == '__main__':
    solutions = main()
    print(solutions)
# %%
