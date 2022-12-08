#!/bin/bash
# echo "1. Now Every command will be printed as they get executed"
# set -o verbose

# prepend this to the python file:
# #!/home/daan/Documents/github_downloads/AdventofCode_2022/.venv/bin/python3

# chmod +x /home/daan/Documents/github_downloads/AdventofCode_2022/code/DVH_2021_1.py
# out=/home/daan/Documents/github_downloads/AdventofCode_2022/code/DVH_2021_1.py /home/daan/Documents/github_downloads/AdventofCode_2022/data/input_2021_1.txt

# the python executable in this virtual environment
PYTHON_EXEC=.venv/bin/python3

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

# something of the form: ./data/input_YYYY_D.txt
# echo $DATAFILE



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
##################################################
# specific for julia
#################################################3
# end if





# TODO:
# howto query this json file:
# cat ./data/solutions.json | jq $('."2022"."1"[0]')
SOLUTION1=$(cat ./data/solutions.json | jq ".\"$YEAR\".\"$DAY\"[0]")
SOLUTION2=$(cat ./data/solutions.json | jq ".\"$YEAR\".\"$DAY\"[1]")

# test correctness of solution.
if [ "$RESULT1" -eq "$SOLUTION1" ]; then
    echo "Solution 1 is correct.";
fi
if [ "$RESULT2" -eq "$SOLUTION2" ]; then
    echo "Solution 2 is correct.";
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
# export PATH="/path/to/julia/bin/julia_bin/julia-1.8.0/bin/:$PATH"
# Also assuming julia version 1.8.0

for SCRIPT_FN in $fns
do
echo $SCRIPT_FN
done