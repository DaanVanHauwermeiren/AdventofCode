#!/bin/bash
# echo "1. Now Every command will be printed as they get executed"
# set -o verbose

# prepend this to the python file:
# #!.venv/bin/python3

# the python executable in this virtual environment
PYTHON_EXEC=.venv/bin/python3

# NOTE: assuming that julia executable is added to the path
# export PATH="/path/to/julia/bin/julia_bin/julia-1.9.3/bin/:$PATH"
# Also assuming julia version 1.9.3
echo `which julia`

fns="./code/*"
echo $fns

LOG_FILE="output.csv"

# Function to check if an entry already exists in the log file
entry_exists() {
    local user="$1"
    local year="$2"
    local day="$3"
    local language="$4"
    grep -q "$user, $year, $day, $language" "$LOG_FILE"
}

check_solution() {
    YEAR="$1"
    DAY="$2"
    RESULT1="$3"
    RESULT2="$4"

    # Query the solutions json file
    SOLUTION1=$(cat ./data/solutions.json | jq -r ".\"$YEAR\".\"$DAY\"[0]")
    SOLUTION2=$(cat ./data/solutions.json | jq -r ".\"$YEAR\".\"$DAY\"[1]")

    # Test correctness of solution 1
    if [ "$RESULT1" = "$SOLUTION1" ]; then
        CORRECT1=true
    else
        CORRECT1=false
    fi

    # Test correctness of solution 2
    if [ "$RESULT2" = "$SOLUTION2" ]; then
        CORRECT2=true
    else
        CORRECT2=false
    fi
}

for SCRIPT_FN in $fns
do
    echo $SCRIPT_FN
    # Extract user, YYYY, and D from the filename
    FILENAME=$(basename "$SCRIPT_FN")
    USER=$(echo "$FILENAME" | cut -d'_' -f1)
    YEAR=$(echo "$FILENAME" | cut -d'_' -f2)
    DAY=$(echo "$FILENAME" | cut -d'_' -f3 | cut -d'.' -f1)

    DATAFILE="./data/input_${YEAR}_${DAY}.txt"

    # Determine the language based on the file extension
    EXTENSION="${FILENAME##*.}"
    if [ "$EXTENSION" = "py" ]; then
        LANGUAGE="python"
        # Check if an entry with the same first 4 columns exists in the log file
        if entry_exists "$USER" "$YEAR" "$DAY" "$LANGUAGE"; then
            echo "Skipping execution for $USER, $YEAR, $DAY, $LANGUAGE as it already exists in the log."
            continue  # Skip the current iteration and move to the next script
        fi
        # Run the Python command and capture its output
        RESULT=$("$PYTHON_EXEC" "$SCRIPT_FN" "$DATAFILE")
        # Remove leading and trailing parentheses and spaces
        RESULT=${RESULT#*(}
        RESULT=${RESULT%)*}
        RESULT=${RESULT// /}
        # Measure execution time and capture the result
        EXECTIME=$({ TIMEFORMAT=%E; time $PYTHON_EXEC "$SCRIPT_FN" "$DATAFILE" > /dev/null; } 2>&1)
    elif [ "$EXTENSION" = "jl" ]; then
        LANGUAGE="julia"
        # Check if an entry with the same first 4 columns exists in the log file
        if entry_exists "$USER" "$YEAR" "$DAY" "$LANGUAGE"; then
            echo "Skipping execution for $USER, $YEAR, $DAY, $LANGUAGE as it already exists in the log."
            continue  # Skip the current iteration and move to the next script
        fi
        # Run the Julia command and capture its output
        RESULT=$(julia "$SCRIPT_FN" "$DATAFILE")
        # Splitting the tuple into two integers
        RESULT=${RESULT#*=}
        RESULT=${RESULT// /}
        RESULT=${RESULT//(/}
        RESULT=${RESULT//)/}
        # Measure execution time and capture the result
        EXECTIME=$({ TIMEFORMAT=%E; time julia "$SCRIPT_FN" "$DATAFILE" > /dev/null; } 2>&1)
    else
        LANGUAGE="unknown"
        echo "Unknown file extension: $EXTENSION"
    fi
    # Split the result into RESULT1 and RESULT2 using a comma as the delimiter
    IFS=',' read -r RESULT1 RESULT2 <<< "$RESULT"
    # Call the function with the appropriate arguments
    check_solution "$YEAR" "$DAY" "$RESULT1" "$RESULT2"

    echo $USER
    echo $YEAR
    echo $DAY
    echo $LANGUAGE
    echo $CORRECT1
    echo $CORRECT2
    echo $EXECTIME

    # Store the result in the log file
    echo "$USER, $YEAR, $DAY, $LANGUAGE, $CORRECT1, $CORRECT2, $EXECTIME" >> "$LOG_FILE"

done
