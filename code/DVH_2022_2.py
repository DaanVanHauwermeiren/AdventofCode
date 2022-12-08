#!.venv/bin/python3
# %%

"""
author: Daan Van Hauwermeiren
AoC 2022 day 2
"""
import sys

def main() -> tuple[int, int]:
    fn = sys.argv[1]

    with open(fn, mode="r") as f:
        raw = [i.strip() for i in f.readlines()]

    # A for Rock, B for Paper, and C for Scissors.
    # X for Rock, Y for Paper, and Z for Scissors.
    # The score for a single round is the score for the shape you selected (1 for Rock, 2 for Paper, and 3 for Scissors) plus the score for the outcome of the round (0 if you lost, 3 if the round was a draw, and 6 if you won).
    win = 6
    draw = 3
    lose = 0
    shape_score = {"X": 1, "Y": 2, "Z": 3}
    solution_1 = 0
    for entry in raw:
        match entry:
            case 'A X':
                solution_1 += 1 + draw
            case 'A Y':
                solution_1 += 2 + win
            case 'A Z':
                solution_1 += 3 + lose
            case 'B X':
                solution_1 += 1 + lose
            case 'B Y':
                solution_1 += 2 + draw
            case 'B Z':
                solution_1 += 3 + win
            case 'C X':
                solution_1 += 1 + win
            case 'C Y':
                solution_1 += 2 + lose
            case 'C Z':
                solution_1 += 3 + draw

    shape_selector = {
        "Z": { # win
            "A": 2, #"Y",
            "B": 3, #"Z",
            "C": 1, #"X",
        },
        "X": { #"lose"
            "A": 3, #"Z",
            "B": 1, #"X",
            "C": 2, #"Y",
        },
        "Y": { # draw
            "A": 1, #"X",
            "B": 2, #"Y",
            "C": 3, #"Z",
        }
    }
    gameendpoints = {
        "Z": 6,
        "X": 0,
        "Y": 3
    }
    solution_2 = 0
    for entry in raw:
        firstletter, winlosedraw = entry.split(' ')
        solution_2 += shape_selector[winlosedraw][firstletter] + gameendpoints[winlosedraw]

    return solution_1, solution_2


if __name__ == '__main__':
    solutions = main()
    print(solutions)
