#!/bin/bash
# get this from the cookies tab in network tools on the AOC website
AOC_COOKIE=$(cat cookie.txt)
curl --cookie "session=$AOC_COOKIE" "https://adventofcode.com/$1/day/$2/input" > "./data/input_$1_$2.txt"
