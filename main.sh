#!/bin/bash

# create venv
python3.10 -m venv .venv
# add requirements for development
.venv/bin/pip install -r requirements.txt

# Download the Advent of Code puzzle input download command line utility:
# https://github.com/GreenLightning/advent-of-code-downloader/releases/tag/v1.0.1
# I have put this executable in this folder
# check the information about the session cookie:
# https://github.com/GreenLightning/advent-of-code-downloader#setting-the-session-cookie
# and add this to .aocdlconfig
# this download the puzzle from day 1 in 2021 and stores it in the file input_2021_1.txt
# ./aocdl -year 2021 -day 1

# or in case you do not want to download an external library, use wget
# for help on downloading and formatting cookies see
# http://fileformats.archiveteam.org/wiki/Netscape_cookies.txt
# an example file is provided in cookies_example.txt
# example usage:
# wget --load-cookies cookies.txt https://adventofcode.com/2021/day/1/input -O ./data/input_2021_1.txt

# echo $0
# echo $1
# echo $2
# echo "derp"

FILENAME="./data/input_2021_1.txt"

if [ -e $FILENAME ]
then
    echo "using local file"
else
    echo "downloading solution"
    wget --load-cookies cookies.txt https://adventofcode.com/2021/day/1/input -O ./data/input_2021_1.txt
fi



# query the solution.json file
# get solutions, extract year 2021, day 1, solution part 1
# cat ./data/solutions.json | jq '."2021"."1"[0]'
#

# run python file
OUTPUT=$(.venv/bin/python3.10 code/DVH_2021_1.py /home/daan/Documents/github_downloads/AdventofCode_2022/data/input_2021_1.txt)
echo $OUTPUT # this prints the solutions