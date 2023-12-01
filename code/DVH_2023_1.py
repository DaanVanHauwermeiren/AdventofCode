#!.venv/bin/python3

"""
author: Daan Van Hauwermeiren
AoC: 2023 day 1
"""
import sys
import re

def main() -> list[int]:
    fn: str = sys.argv[1]

    with open(fn, mode="r") as f:
        raw: list[str] = f.readlines()

    pattern = r"\d"
    total = 0
    for ii in raw:
        matches: list[str] = re.findall(pattern, ii)
        total += int(matches[0] + matches[-1])
    solution_1: int = total

    # since I need to do the str replacements for every entry, I am doing a different processing
    # of the input data: only split the lines after the replacement, this is a wee bit more
    # efficient.
    with open(fn, mode="r") as f:
        raw: str = f.read().strip()
    # why     "nine":  "nine9nine",
    # and not     "nine":  "9",
    # Well, I tried that first, but then found out that it is possible that two numbers are 
    # connected, e.g. "eightwo", this only capture either one or the other.
    # Hence the weird ordering below, I first thought that I needed to reverse order it, but
    # that does not matter

    lines: list[str] = (
        raw.replace("nine", "nine_9_nine")
        .replace("eight", "eight_8_eight")
        .replace("seven", "seven_7_seven")
        .replace("six", "six_6_six")
        .replace("five", "five_5_five")
        .replace("four", "four_4_four")
        .replace("three", "three_3_three")
        .replace("two", "two_2_two")
        .replace("one", "one_1_one")
    ).split("\n")

    matches: list[list[str]] = [re.findall(pattern, ii) for ii in lines]
    solution_2: int = sum(int(n[0] + n[-1]) for n in matches)
    
    return solution_1, solution_2


if __name__ == '__main__':
    solutions: list[int] = main()
    print(solutions)