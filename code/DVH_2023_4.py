#!.venv/bin/python3

"""
author: Daan Van Hauwermeiren
AoC: 2023 day 4
"""
import sys

def main() -> tuple[int, int]:
    fn: str = sys.argv[1]

    with open(fn, mode="r") as f:
        raw: list[str] = f.readlines()

    solution_1 = 0
    for line in raw:
        part_1, part_2 = line.split(" | ")
        # making two sets of numbers
        winning_no = set([int(ii) for ii in part_1.split(": ")[1].split()])
        your_no = set([int(ii) for ii in part_2.split()])
        # set intersection
        common_numbers: set[int] = your_no & winning_no
        if len(common_numbers) > 0:
            solution_1 += 2**(len(common_numbers)-1)

    # dicts are ordered in python>3.7
    no_winning_no: dict[int, int] = {}
    for ii, line in enumerate(raw, start=1):
        part_1, part_2 = line.split(" | ")
        # making two sets of numbers
        winning_no = set([int(ii) for ii in part_1.split(": ")[1].split()])
        your_no = set([int(ii) for ii in part_2.split()])
        # set intersection
        common_numbers = your_no.intersection(winning_no)
        no_winning_no[ii] = len(common_numbers)

    # dicts are ordered in python>3.7
    # card numbers: number of cards you have
    no_cards: dict[int, int] = {ii:1 for ii in range(1, len(raw)+1)}
    # looping over the card collection starting from the first card
    for card_no, N in no_cards.items():
        # looping over the number of winning numbers for each card
        # and updating the number of cards you have (the following cards)
        for jj in range(1, no_winning_no[card_no]+1):
            no_cards[card_no+jj] += N
    solution_2: int = sum(no_cards.values())    
    
    return solution_1, solution_2


if __name__ == '__main__':
    solutions: list[int] = main()
    print(solutions)