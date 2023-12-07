#!.venv/bin/python3

"""
author: Daan Van Hauwermeiren
AoC: 2023 day 7
"""
from collections import Counter
import sys

def count_cards(hand: str) -> list[int]:
    # no straits, so just count the occurences of the rank
    return sorted(Counter(hand).values(), reverse=True)

def parse_line_v1(line: str): 
    hand, bid = line.split()
    # translate T, J, Q, K, A to ABCDE so that we can sort nicely
    hand: str = hand.translate(str.maketrans("TJQKA", "ABCDE"))
    # sort hand: this is NOT needed. Could not figure out why at first: it seems that I read
    # the instructions too quickly and thought that we had to sort the hand
    # hand = "".join(sorted(hand))
    return (count_cards(hand), hand), int(bid)

def parse_line_v2(line: str): 
    hand, bid = line.split()
    # translate T, J, Q, K, A to ABCDE so that we can sort nicely
    # 0 = joker
    # 0 is important for sorting because it is the lowest value !
    # previously I set it to X, which gave the wrong sorting
    hand: str = hand.translate(str.maketrans('TJQKA', f'A0CDE'))
    # do all possible replacements of 0 with 2, 3, 4, 5, 6, 7, 8, 9, A, B, C, D, E
    # and return the maximum count of cards of all possibilities
    # this is a very naive approach, but it works
    # a better solution would be to only replace with the cards that are in the hand
    return max((count_cards(hand.replace("0", newcard)), hand) for newcard in '23456789ABCDE'), int(bid)

def main() -> tuple[int, int]:
    fn: str = sys.argv[1]

    with open(fn, mode="r") as f:
        raw: list[str] = f.read().strip().split("\n")

    solution_1 = 0
    # parse each line: count the cards, return the hand and the bid
    # sort the hands by the number of cards, then by the hand
    derp = sorted([parse_line_v1(line) for line in raw])
    for rank, ((cc, hand), bid) in enumerate(derp, start=1):
        solution_1 += rank * bid

    solution_2 = 0
    derp = sorted([parse_line_v2(line) for line in raw])
    for rank, ((cc, hand), bid) in enumerate(derp, start=1):
        solution_2 += rank * bid

    return solution_1, solution_2


if __name__ == '__main__':
    solutions: tuple[int, int] = main()
    print(solutions)