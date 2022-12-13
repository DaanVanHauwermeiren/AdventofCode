#!.venv/bin/python3
# %%

"""
author: Daan Van Hauwermeiren
AoC 2022 day 13
"""
import sys
from functools import cmp_to_key

def main() -> tuple[int, int]:
    fn = sys.argv[1]

        # NOTE: just like in day 7, this seems like something for structural pattern matching !

    # horrible readability with the nested for loop, but it `just werks`^TM
    # just look at the output if it does not make sense anymore
    with open(fn, mode="r") as f:
        raw = f.read().split('\n\n')
    signalpairs = [[eval(jj) for jj in ii.split()] for ii in raw]
    # quick parsing check on the small input
    # assert type(signalpairs[0][0]) == list
    # assert type(signalpairs[0][0][0]) == int
    # indeed: parsed as lists of integers, good to go!

    # again some recursion, compare left and right,
    # depending on the types (types, not values), go deeper in the recursion or return an error
    def compare(left:list|int, right:list|int)->int:
        """compare left and right
        returns 1 if the rules are ok, -1 if not
        """
        # see https://peps.python.org/pep-0636/#adding-a-ui-matching-objects
        # structural pattern matching can be used to match types as well!
        match left, right:
            # first case, both inputs are integers
            # left is larger than right: all good
            # left equal to right, continue comparing
            # else, right is larger: not ok!
            case int(), int():
                if left < right:
                    return 1
                elif left == right:
                    return 0
                else:
                    return -1
                # return (left>right) - (left<right)
            # comparing two lists.
            case list(), list():
                # for z in map(compare, left, right):
                    # if z: return z
                for (ll, rr) in zip(left, right):
                    # name is weird, had no inspiration
                    # the jist is: if left is equal to right, we want to continue looking,
                    # else, return the good/bad signal
                    # so `if derp` will only work for 1 and -1; nothing happens for 0! 
                    # EDIT: change to derp != 0 for readability
                    derp = compare(ll, rr)
                    if derp != 0:
                        return derp
                # If the left list runs out of items first, the inputs are in the right order. If the right list runs out of items first, the inputs are not in the right order.
                # this mean comparison of the length of the lists!
                # len(left) < len(right): all good
                # len(left) > len(right): not ok
                # note that for equal length of lists, nothing happens, as it should be
                return compare(len(left), len(right))
            # comparing mixed types: list and integers
            # convert the integer into a list with a single element, and compare the 2 lists,
            # so go deeper into the recursion
            case list(), int():
                return compare(left, [right,])
            case int(), list():
                return compare([left,], right)

    # some nice list comprehesion could probably enhance this horrible for loop
    idx_right_order = []
    for ii, sp in enumerate(signalpairs):
        # print(compare(*sp))
        # correct order: returns 1
        if compare(*sp) == 1:
            # plus one because zero based
            idx_right_order.append(ii+1)
    solution_1 = sum(idx_right_order)

    # for part 2 I need something that iteratively compares the output of the function `compare`
    # on two signal packets, and orders them
    # so not according to the input itself but on pairwise comparison basis.
    # so it has to do something with the key argument in sorted,
    # and after some googling I found a tutorial on sorting in the python docs
    # https://docs.python.org/3/howto/sorting.html#comparison-functions
    # cmp_to_key is the solution!
    # see example to sort a list based on the difference of the squared values
    # compare_squared = lambda x, y: x**2 - y**2
    # sorted([1, -2, -11, 8, -6], key=cmp_to_key(compare_squared))
    # NOTE: because of my choice for good=1, and bad=-1, the list is in reverse order, so adding [::-1] at the end.
    # Otherwise, this is a hassle to get the correct index number
    # not 100% sure about all the internal workings of cmp_to_key, but this seems to work
    # Also, there has to be a nicer way to unpack a list of lists, maybe abusing sum?
    # because [x for l in signalpairs for x in l] is horrible
    sortedsignalpairs = sorted([x for l in signalpairs for x in l] + [[2], [6]], key=cmp_to_key(compare))[::-1]
    # +1 because of zero based indexing
    solution_2 = (sortedsignalpairs.index([6]) + 1) * (sortedsignalpairs.index([2]) + 1)
    return solution_1, solution_2

if __name__ == "__main__":
    solutions = main()
    print(solutions)
# %%
# fn = "../data/input_2022_13.txt"
# fn = "../data/input_2022_13_small.txt"

# %%
