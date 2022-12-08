#!.venv/bin/python3
# %%

"""
author: Daan Van Hauwermeiren
AoC 2022 day 7
"""
import sys
from collections import defaultdict
# from itertools import accumulate

def main() -> tuple[int, int]:
    fn = sys.argv[1]

    with open(fn, mode="r") as f:
        raw = [i.strip() for i in f.readlines()]
    # NOTE: 
    # I got lucky here that the folders themselves are of no importance:
    # only the sizes and what size to delete,
    # If I had to traverse the dir tree to find the exact folder, the solution below
    # is probably not sufficient and the construction of a proper tree is needed.
    # Or maybe I can get away with the notation I used (the forward slashes between folder names)
    # NOTE 2:
    # I actually started in julia with making tree-like structs, but soon found out for
    # the reason above, that I was overengineering this thing

    # dict of dirname:dirsize
    # NOTE: 
    # defaultdict is used here because this simplifies the code.
    # In this way, we do not need to check if a key already exists, 
    # if it does not, it will return a 0
    # with standard dict it would look like:
    # dirsizes[dirtree_as_astring] = # dirsizes.get(dirtree_as_astring, 0) + int(filesize)
    # now it looks like:
    # dirsizes[dirtree_as_astring] += int(filesize)
    dirsizes = defaultdict(int)

    for line in raw:
        # split line on whitespace so that we can match each word/command
        # NOTE: my first use of pattern matching in the AoC!
        match line.split():
            # top level directory
            # this is where we start and is the initial definition of the folder
            # this is the start of the file and will be matched exactly once
            case "$", "cd", "/":
                current_directory = [""]
            # two things to ignore:
            # file listing, do nothing (but we match the sizes below)
            case "$", "ls":
                pass
            # ignore the listing of folder names, e.g "dir e"
            case "dir", _:
                pass
            # two things about moving to another directory:
            # command move on up in the dir tree:
            # pop the latest value out of the current directory
            case "$", "cd", "..":
                current_directory.pop()
            # in case cd is matched:
            # move down in the dir tree
            case "$", "cd", folder:
                current_directory.append(f"{folder}/")
            # file sizes! 
            # we need to sum these up and add to the directory size! e.g.
            # 45454505 file.extension
            case filesize, _:
                # as we do not care about the exact names of the directories of a certain size
                # we can just use accumulate to make a single string out of the current 
                # directory list by adding each element
                # these values are used as keys for dirsizes
                # see note on default values at dirsizes' initialisation.
                dirtree_as_astring = ""
                for directory in current_directory:
                    dirtree_as_astring += directory + "/"
                    dirsizes[dirtree_as_astring] += int(filesize)
                # I could have just used accumulate instead of this wonky concoction above:
                # e.g accumulate(["", "a", "d", "q"]) => ["", "a", "ad", "adq"]
                # Since I do not need the directory name it self, this might have been the 
                # best solution.
                # Accumulate abuses the ability to concatenate string by summing them up
                # for dirtree_as_astring in accumulate(current_directory):
                    # dirsizes[dirtree_as_astring] += int(filesize)

    solution_1 = sum(i for i in dirsizes.values() if i <= 100_000)
    # need to free space: 70_000_000 - 30_000_000 = 40_000_000
    # only looking at dirs that are larger than this value:
    # if i >= dirsizes[""] - 40_000_000
    # the minimum value is the one that we need to delete
    solution_2 = min(i for i in dirsizes.values() if i >= dirsizes["/"] - 40_000_000)

    return solution_1, solution_2

if __name__ == "__main__":
    solutions = main()
    print(solutions)
# %%
# fn = "../data/input_2022_7.txt"
# fn = "../data/input_2022_7_small.txt"
