#!/bin/bash

NUMBERS=500
STRATEGY="--medium"
CHECKER="checker"
RUNS=100

LOG_DIR="run_log"

echo "Testing with $STRATEGY strategy..."

for ((run=1; run<=RUNS; run++))
do
    ARGS=$(shuf -i 0-10000 -n $NUMBERS | tr '\n' ' ')

    TMP_INS=$(mktemp)
    ./push_swap $STRATEGY $ARGS > "$TMP_INS"

    RESULT=$(./$CHECKER $ARGS < "$TMP_INS" | tr -d ' \n')

    if [ "$RESULT" = "OK" ]; then
        printf "\rChecker running testing... (n = %d, %d/%d)" "$NUMBERS" "$run" "$RUNS"
    else
        if [ ! -d "$LOG_DIR" ]; then
            mkdir -p "$LOG_DIR"
        fi

        echo -e "\n[!] Result : [ KO ] at Run $run"
        
        NEXT_IDX=$(ls "$LOG_DIR" 2>/dev/null | grep "^ko_${NUMBERS}_case" | sed -E "s/ko_${NUMBERS}_case([0-9]+)\.txt/\1/" | sort -n | tail -1)
        [ -z "$NEXT_IDX" ] && NEXT_IDX=1 || NEXT_IDX=$((NEXT_IDX + 1))

        FILE_NAME="${LOG_DIR}/ko_${NUMBERS}_case${NEXT_IDX}.txt"
        echo "$ARGS" > "$FILE_NAME"
        echo "    Failed case saved to: $FILE_NAME"
    fi

    rm -f "$TMP_INS"
done

echo -e "\n\nAll tests completed!"