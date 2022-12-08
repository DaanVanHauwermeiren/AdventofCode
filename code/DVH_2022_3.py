#!.venv/bin/python3
# %%

"""
author: Daan Van Hauwermeiren
AoC 2022 day 3
"""
import sys

def main() -> tuple[int, int]:
    fn = sys.argv[1]

    with open(fn, mode="r") as f:
        raw = [i.strip() for i in f.readlines()]

    alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    def get_priority(i:str) -> int:
        # find element in the alphabet string, add one because of zero-based indexing
        return alphabet.find(i) + 1

    l_priority = []
    for entry in raw:
        # first compartment
        comp1 = set(entry[:len(entry)//2])
        # second compartment
        comp2 = set(entry[len(entry)//2:])
        # element in both compartments
        shared_item = list(comp1.intersection(comp2))[0]
        l_priority.append(get_priority(shared_item))
    solution_1 = sum(l_priority)

    l_priority = []
    for i in range(0, len(raw), 3):
        rucksack1 = set(raw[i])
        rucksack2 = set(raw[i+1])
        rucksack3 = set(raw[i+2])
        shared_item = list(rucksack1.intersection(rucksack2, rucksack3))[0]
        l_priority.append(get_priority(shared_item))
    solution_2 = sum(l_priority)
    return solution_1, solution_2


if __name__ == '__main__':
    solutions = main()
    print(solutions)
# %%

