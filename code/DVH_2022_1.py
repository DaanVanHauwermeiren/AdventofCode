#!.venv/bin/python3
# %%

"""
author: Daan Van Hauwermeiren
AoC 2022 day 1
"""
import sys

def main() -> tuple[int, int]:
    fn = sys.argv[1]

    calories = [0,]
    with open(fn, mode="r") as f:
        raw = [i.strip() for i in f.readlines()]

    idx = 0
    for line in raw:
        if len(line) == 0:
            idx += 1
            calories.append(0)
            continue
        else:
            calories[idx] += int(line)

    calories_top3 = sorted(calories)[-3:]

    solution_1 = calories[0]
    solution_2 = sum(calories_top3)

    return solution_1, solution_2


if __name__ == '__main__':
    solutions = main()
    print(solutions)
# %%


# %%
