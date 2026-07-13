#!/bin/bash

STRATEGY="--medium"
RUNS=1000
SIZES=(100 500)
LOG_DIR="grade_log"

get_next_index() {
    local size=$1
    if [ ! -d "$LOG_DIR" ]; then
        echo 1
        return
    fi
    local last_idx=$(ls "$LOG_DIR" 2>/dev/null | grep "fail_${size}_case" | sed -E "s/fail_${size}_case([0-9]+).txt/\1/" | sort -n | tail -1)

    if [ -z "$last_idx" ]; then
        echo 1
    else
        echo $((last_idx + 1))
    fi
}

echo "============ Check Grade ============"
echo "-------------------------------------"
CURRENT_FAIL_LOGS=()
MAX_OPS_100=0
MAX_OPS_500=0

for N in "${SIZES[@]}"
do
    total_ops=0
    fail_count=0
    max_ops=0
    next_idx=$(get_next_index "$N")

    [ $N -eq 100 ] && THRESHOLD=700 || THRESHOLD=5500

    echo "[N = $N] Target Threshold: $THRESHOLD"

    for ((i=1; i<=RUNS; i++))
    do
        ARGS=$(shuf -i 0-10000 -n $N | tr '\n' ' ')
        ops=$(./push_swap $STRATEGY $ARGS | wc -l)

        total_ops=$((total_ops + ops))
        if [ $ops -gt $max_ops ]; then
            max_ops=$ops
        fi

        if [ $ops -gt $THRESHOLD ]; then
            if [ ! -d "$LOG_DIR" ]; then
                mkdir -p "$LOG_DIR"
            fi
            FILE_NAME="${LOG_DIR}/fail_${N}_case${next_idx}.txt"
            echo "$ARGS" > "$FILE_NAME"
            CURRENT_FAIL_LOGS+=("$FILE_NAME")

            fail_count=$((fail_count + 1))
            next_idx=$((next_idx + 1))
        fi

        printf "\rProgress: %d/%d" "$i" "$RUNS"
    done

    [ $N -eq 100 ] && MAX_OPS_100=$max_ops || MAX_OPS_500=$max_ops

    avg_ops=$(echo "scale=2; $total_ops / $RUNS" | bc -l)
    fail_rate=$(echo "scale=2; ($fail_count / $RUNS) * 100" | bc -l)

    echo -e "\n  > Average Ops   : $avg_ops"
    echo "  > Over $THRESHOLD : $fail_rate% ($fail_count out of $RUNS)"
    echo "-------------------------------------"
done

if [ ${#CURRENT_FAIL_LOGS[@]} -gt 0 ]; then
    echo -e "\nAnalyzing NEW Fail Cases (${#CURRENT_FAIL_LOGS[@]}) with --bench:"

    for fail_file in "${CURRENT_FAIL_LOGS[@]}"
    do
        echo "-------------------------------------"
        echo -e "[$fail_file]\n"
        ./push_swap $STRATEGY --bench $(cat "$fail_file") > /dev/null
    done
    echo "-------------------------------------"
else
    echo -e "\nNo new fail cases in this run. Perfect!"
    echo "  > Max Ops (100) : $MAX_OPS_100"
    echo "  > Max Ops (500) : $MAX_OPS_500"
fi