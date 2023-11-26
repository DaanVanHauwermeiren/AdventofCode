#!/bin/bash
# echo "1. Now Every command will be printed as they get executed"
# set -o verbose

# prepend this to the python file:
# #!.venv/bin/python3

# the python executable in this virtual environment
PYTHON_EXEC=.venv/bin/python3
echo $PYTHON_EXEC

# python files
# parsing ls is not a good idea
# fns=$(ls ./code/*.py)
# the correct solution is even simpler: just use glob
fns="./code/*.py"
echo $fns

for SCRIPT_FN in $fns
do
    echo $SCRIPT_FN

    # NOTE: this is super crappy programming, need to deal with this later
    # string manipulation so that everything after the first underscore is cut off:
    # ./code/DVH
    DERP=${SCRIPT_FN%%_*}
    # this get the number of letters in the string
    # echo ${#DERP}
    # we use the number of the sliced string above to slice the code file name
    # and get someting of the form: YYYY_D or YYYY_DD
    # echo ${SCRIPT_FN:${#DERP}+1:-3}
    YEARDAY=${SCRIPT_FN:${#DERP}+1:-3}
    # split again into the year and the day
    YEAR=${YEARDAY%%_*}
    DAY=${YEARDAY#*_}
    # we add that slice to some other small string to get our data file location
    DATAFILE="./data/input_"
    DATAFILE+=$YEAR
    DATAFILE+="_"
    DATAFILE+=$DAY
    DATAFILE+=".txt"

    # add if clause on extension to determine which of the files things to execute
    # specific for python
    #################################################3
    # run a command of the form:
    # python file.py data.txt
    # capturing the STDOUT from the python file execution
    # something of the form:
    # (13123, 2342424234)
    RESULT=$($PYTHON_EXEC $SCRIPT_FN $DATAFILE)
    echo $RESULT
    # once again crappy programming to split the tuple into two integers
    RESULT1=${RESULT%%, *}
    RESULT1=${RESULT1:1}
    echo $RESULT1
    RESULT2=${RESULT#*, }
    RESULT2=${RESULT2:0:-1}
    echo $RESULT2

    # query the solutions json file
    SOLUTION1=$(cat ./data/solutions.json | jq -r ".\"$YEAR\".\"$DAY\"[0]")
    SOLUTION2=$(cat ./data/solutions.json | jq -r ".\"$YEAR\".\"$DAY\"[1]")
    # test correctness of solution.
    if [ "$RESULT1" = "$SOLUTION1" ]; then
        echo "Solution 1 is correct."
    fi
    if [ "$RESULT2" = "$SOLUTION2" ]; then
        echo "Solution 2 is correct."
    fi

    # timing of execution
    # add another if clause here for python and julia
    # TIMEFORMAT=%E get real execution time in seconds
    EXECTIME=$({ TIMEFORMAT=%E; time $PYTHON_EXEC $SCRIPT_FN $DATAFILE > /dev/null; } 2>&1)
    echo $EXECTIME
done



# now julia
fns="./code/*.jl"
echo $fns
# NOTE: assuming that julia executable is added to the path
# export PATH="/path/to/julia/bin/julia_bin/julia-1.9.3/bin/:$PATH"
# Also assuming julia version 1.9.3

echo `which julia`

for SCRIPT_FN in $fns
do
    echo $SCRIPT_FN

    # NOTE: this is super crappy programming, need to deal with this later
    # string manipulation so that everything after the first underscore is cut off:
    # ./code/DVH
    DERP=${SCRIPT_FN%%_*}
    # this get the number of letters in the string
    # echo ${#DERP}
    # we use the number of the sliced string above to slice the code file name
    # and get someting of the form: YYYY_D or YYYY_DD
    # echo ${SCRIPT_FN:${#DERP}+1:-3}
    YEARDAY=${SCRIPT_FN:${#DERP}+1:-3}
    # split again into the year and the day
    YEAR=${YEARDAY%%_*}
    DAY=${YEARDAY#*_}
    # we add that slice to some other small string to get our data file location
    DATAFILE="./data/input_"
    DATAFILE+=$YEAR
    DATAFILE+="_"
    DATAFILE+=$DAY
    DATAFILE+=".txt"

    RESULT=$(julia $SCRIPT_FN $DATAFILE)

    # Splitting the tuple into two integers
    RESULT=${RESULT#*=}
    RESULT=${RESULT// /}
    RESULT=${RESULT//(/}
    RESULT=${RESULT//)/}
    IFS=',' read -r RESULT1 RESULT2 <<< "$RESULT"

    echo "Result 1: $RESULT1"
    echo "Result 2: $RESULT2"

    # query the solutions json file
    SOLUTION1=$(cat ./data/solutions.json | jq -r ".\"$YEAR\".\"$DAY\"[0]")
    SOLUTION2=$(cat ./data/solutions.json | jq -r ".\"$YEAR\".\"$DAY\"[1]")
    # test correctness of solution.
    if [ "$RESULT1" = "$SOLUTION1" ]; then
        echo "Solution 1 is correct."
    fi
    if [ "$RESULT2" = "$SOLUTION2" ]; then
        echo "Solution 2 is correct."
    fi

    # timing of execution
    # add another if clause here for python and julia
    # TIMEFORMAT=%E get real execution time in seconds
    EXECTIME=$({ TIMEFORMAT=%E; time julia $SCRIPT_FN $DATAFILE > /dev/null; } 2>&1)
    echo $EXECTIME
done