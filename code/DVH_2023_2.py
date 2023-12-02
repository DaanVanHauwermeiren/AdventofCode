#!.venv/bin/python3

"""
author: Daan Van Hauwermeiren
AoC: 2023 day 2
"""
import sys
from dataclasses import dataclass

@dataclass
class Draw:
    red: int
    green: int
    blue: int

    @classmethod
    def from_raw_input(cls, raw_input: str):
        """
        example:
        raw_input = '1 red, 10 blue, 5 green'
        usage:
        Draw.from_raw_input(raw_input)
        """
        red = 0
        green = 0
        blue = 0
        for (ii, cc) in [jj.split(" ") for jj in raw_input.split(", ")]:
            match cc:
                case "red":
                    red = int(ii)
                case "green":
                    green = int(ii)
                case "blue":
                    blue = int(ii)
                case _:
                    raise ValueError(f"Color {cc} not recognized.")
        return cls(red=red, green=green, blue=blue)
    
    def __iter__(self):
        yield self.red
        yield self.green
        yield self.blue
    
    def __eq__(self, other) -> bool:
        return (self.red == other.red) & (self.green == other.green) & (self.blue == other.blue)
    
    def __ne__(self, other) -> bool:
        return not self.__eq__(other)
    
    def __gt__(self, other) -> bool:
        return (self.red > other.red) & (self.green > other.green) & (self.blue > other.blue)

    def __lt__(self, other) -> bool:
        return (self.red < other.red) & (self.green < other.green) & (self.blue < other.blue)
    # Note to self: I forgot that the draws could also be equal to the original bag!
    # hence my first answer was wrong, and le and ge are needed.
    def __le__(self, other) -> bool:
        return (self.red <= other.red) & (self.green <= other.green) & (self.blue <= other.blue)
    
    def __ge__(self, other) -> bool:
        return (self.red >= other.red) & (self.green >= other.green) & (self.blue >= other.blue)
    
    def power(self) -> int:
        return self.red * self.green * self.blue
    
# This could probably be a nice class method, but I'm too lazy to figure it out atm
def maximum_(draws: list[Draw]) -> Draw:
    return Draw(
        red=max([draw.red for draw in draws]),
        green=max([draw.green for draw in draws]),
        blue=max([draw.blue for draw in draws]),
    )

# some assertions, commented them for SPEED
# assert Draw(red=1, green=10, blue=5) == Draw(red=1, green=10, blue=5)
# assert Draw(red=1, green=10, blue=5) < Draw(red=2, green=12, blue=7)
# assert Draw(red=1, green=10, blue=5) > Draw(red=0, green=9, blue=4)
# assert not (Draw(red=1, green=10, blue=5) > Draw(red=0, green=9, blue=112))

def main() -> tuple[int, int]:
    fn: str = sys.argv[1]

    with open(fn, mode="r") as f:
        raw: list[str] = f.readlines()

    solution_1: int = 0
    solution_2: int = 0

    bag = Draw(red=12, green=13, blue=14)

    for line in raw:
        line = line.strip()
        # could have used an enumerate instead of the game_number, but just making sure
        # that no games numbers are skipped
        game_number, line = line.split(": ")
        game_number = int(game_number[5:])
        draws = [Draw.from_raw_input(draw) for draw in line.split("; ")]

        if all(((draw <= bag) for draw in draws)):
            solution_1 += game_number

        solution_2 += maximum_(draws).power()
    
    return solution_1, solution_2


if __name__ == '__main__':
    solutions: list[int] = main()
    print(solutions)