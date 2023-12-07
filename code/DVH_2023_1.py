#!.venv/bin/python3

"""
author: Daan Van Hauwermeiren
AoC: 2023 day 1
"""
import sys
import re

def main() -> tuple[int, int]:
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
    # EDIT: actually, if you look a bit closer, there are only a couple of combinations
    # possible:
    # nineight
    # fiveight
    # threeight
    # oneight
    # sevenine
    # eighthree
    # eightwo
    # it is just the first and last letter overlapping, so I could have just done:
    # .replace("eight", "e8t")
    # overengineered, but still works!

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

    import re

    # solution adapted from hyper-neutrino:
    # https://github.com/hyper-neutrino/advent-of-code/blob/main/2023/day01p2.py
    n: list[str] = "one two three four five six seven eight nine".split()
    # |.join(n): This joins all the elements in the list n into a single string, with each 
    # element separated by the pipe character |. The pipe character in regex is used to 
    # denote "OR", so this part of the pattern will match any string that is an element of n
    # |\\d: This adds an OR condition to the pattern to also match any digit. The \\d in 
    # regex stands for any digit from 0-9.
    # (?=...): This is a positive lookahead assertion. This means the regex engine will test
    #  that the assertion (everything inside the parentheses) is true, but won't actually 
    # consume any characters. In other words, it checks that the pattern is there, but 
    # doesn't include it in the match.
    # So, the entire pattern "(?=(" + "|".join(n) + "|\\d))" will match any location in a 
    # string that is immediately followed by a string from n or a digit, without including 
    # the following string or digit in the match.
    pattern = "(?=(" + "|".join(n) + "|\\d))"


    def parse_match(match: str):
        if match in n:
            # adding 1 because python is zero-based
            # conversion for e.g. `two` to `2`
            return str(n.index(match) + 1)
        return match
    
    with open(fn, mode="r") as f:
        raw: str = f.read().strip()

    solution_2: int = 0
    for line in raw:
        digits = [*map(parse_match, re.findall(pattern, line))]
        solution_2 += int(digits[0] + digits[-1])

    return solution_1, solution_2


if __name__ == '__main__':
    solutions = main()
    print(solutions)