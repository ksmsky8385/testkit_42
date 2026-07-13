#!/bin/bash

LOG_DIR="grade_log"
SUCCESS_COUNT=0
TOTAL_COUNT=0

if [ ! -d "$LOG_DIR" ]; then
    echo "Error: $LOG_DIR directory not found."
    exit 1
fi

FILES=$(ls "$LOG_DIR"/fail_*_case*.txt 2>/dev/null | sort -V)

if [ -z "$FILES" ]; then
    echo "No fail cases found in $LOG_DIR."
    exit 0
fi

echo "============ Strict Retest (Both Must Pass) ============"
echo "--------------------------------------------------------"
printf "%-23s | %-15s | %-20s\n" "File Name" "Status" "Ops (M / C)"
echo "--------------------------------------------------------"

for file in $FILES
do
    N=$(echo "$file" | sed -E 's/.*fail_([0-9]+)_case.*/\1/')
    [ "$N" -eq 100 ] && THRESHOLD=700 || THRESHOLD=5500
    
    ARGS=$(cat "$file")
    TOTAL_COUNT=$((TOTAL_COUNT + 1))

    ops_m=$(./push_swap --medium $ARGS | wc -l)
    res_m=0
    [ "$ops_m" -le "$THRESHOLD" ] && res_m=1

    ops_c=$(./push_swap --complex $ARGS | wc -l)
    res_c=0
    [ "$ops_c" -le "$THRESHOLD" ] && res_c=1

    if [ $res_m -eq 1 ] && [ $res_c -eq 1 ]; then
        STATUS="Success"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    elif [ $res_m -eq 0 ] && [ $res_c -eq 0 ]; then
        STATUS="Both Fali"
    elif [ $res_m -eq 0 ]; then
        STATUS="Medium Fail"
    else
        STATUS="Complex Fail"
    fi

    printf "%-23s | %-15s | %-20s\n" "$(basename "$file")" "$STATUS" "$ops_m / $ops_c"
done

echo "--------------------------------------------------------"
echo "Final Result: $SUCCESS_COUNT / $TOTAL_COUNT cases perfectly solved."

if [ "$SUCCESS_COUNT" -eq "$TOTAL_COUNT" ]; then
    echo "All cases passed for both strategies."
else
    echo "Some cases still fail in one or more strategies."
fi
echo "--------------------------------------------------------"