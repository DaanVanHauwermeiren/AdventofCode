`# Advent of Code

<div style="text-align: center;">
    <img src="./figs/AoC_screencap.png" alt="AoC" width="650" style="display: block; margin: 10 auto;">
    <img src="./figs/re50_ComfyUI_20281122__00102_.png" alt="AoC" width="650" style="display: block; margin: 10 auto;">
    <img src="./figs/re50_ComfyUI_20281122__00141_.png" alt="AoC" width="650" style="display: block; margin: 10 auto;">
    <img src="./figs/re50_ComfyUI_20281122__00158_.png" alt="AoC" width="650" style="display: block; margin: 10 auto;">
    <img src="./figs/re50_ComfyUI_20281122__00172_.png" alt="AoC" width="650" style="display: block; margin: 10 auto;">
</div>

# Intro
Greetings and salutations fellow coder!

This is the code repository for the greatest code event of the year: the [Advent of Code](https://adventofcode.com/).

Join our [Private leaderboard](https://adventofcode.com/2021/leaderboard/private) !
(join with code: `1059646-48d5074b`)

[Join the chat](https://matrix.to/#/#AoC-BW-UGent:gitter.im) 
(If you have never used gitter: you can click on `Element` and select `use in browser`. You can sign up with your `github.com` account.)


## Contributing

- You can contribute code for any programming language you want, however at the moment, the solution checker only works for `Python` and `Julia`. 
- Put your code as `INITIALS_YYYY_D.EXTENSIONS` in the folder `code`. 
- Branch off and make a pull request to add code. The maintainers will likely group the pull requests per week to have weekly updates of the main branch. 
- If you need specific libs, do not forget to add them to either `requirements.txt` or the `Project.toml`
- The code assumes `Python` version `3.1.10`, and `Julia` version `1.9.3`. Since this is a code golf repo, normally any recent release should be fine.
- unless otherwise specified, all scripts are assumed to be run from the top level folder.

Regarding formatting, please adhere to these standards (otherwise the solution check will not work):

Python
```python
#!.venv/bin/python3
def main() -> tuple[int|str, int|str]:
    fn = sys.argv[1] # this is the path to the data file eg "data/input_2023_1.txt"
    solution_1 = ...
    solution_2 = ...
    return solution_1, solution_2
if __name__ == '__main__':
    solutions = main()
    print(solutions)
```

Julia
```julia
# If you are using non standard lib packages: make sure to license the Pkg output !
using Pkg
Pkg.activate(".", io=devnull)
# using ...
function main(args)
    fn = args[1] # this is the path to the data file eg "data/input_2023_1.txt"
    solution_1 = ...
    solution_2 = ...
    println(solution_1, ' ', solution_2)
end
main(ARGS)
```

## summary stats

Here be some summary statistics.

### Average execution time per user

<!-- START_PLACEHOLDER_FOR_stats_user.md -->
| Language | Execution Time (s) |
|-----------|---------------------|
| AAA | 0.139000 |
| DVH | 3.815500 |
<!-- END_PLACEHOLDER_FOR_stats_user.md -->

### Average execution time per year

<!-- START_PLACEHOLDER_FOR_stats_year.md -->
| Language | Execution Time (s) |
|-----------|---------------------|
| 2021 | 0.426333 |
| 2022 | 4.640240 |
| 2023 | 0.050800 |
<!-- END_PLACEHOLDER_FOR_stats_year.md -->

### Average execution time per language

<!-- START_PLACEHOLDER_FOR_stats_language.md -->
| Language | Execution Time (s) |
|-----------|---------------------|
| julia | 6.644250 |
| python | 0.053360 |
<!-- END_PLACEHOLDER_FOR_stats_language.md -->

### Average execution time per year and day

<!-- START_PLACEHOLDER_FOR_stats_year_day.md -->
| Language | Execution Time (s) |
|-----------|---------------------|
| 2023-1 | 0.073500 |
| 2022-6 | 0.285000 |
| 2023-2 | 0.028100 |
| 2022-7 | 0.015000 |
| 2022-8 | 2.317000 |
| 2022-9 | 2.929000 |
| 2021-1 | 0.426333 |
| 2022-10 | 1.666000 |
| 2022-20 | 1.143000 |
| 2022-11 | 1.542000 |
| 2022-12 | 1.205000 |
| 2022-13 | 0.057000 |
| 2022-1 | 0.353500 |
| 2022-23 | 63.722000 |
| 2022-2 | 0.013000 |
| 2022-3 | 0.021000 |
| 2022-4 | 0.511500 |
| 2022-5 | 2.239000 |
<!-- END_PLACEHOLDER_FOR_stats_year_day.md -->
