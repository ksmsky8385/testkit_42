#!/bin/bash

MAX_N=1000
STEP=10
RUNS=1
STRATEGIES=("simple" "medium" "complex")

echo "Starting data collection up to N=$MAX_N..."

for STRATEGY in "${STRATEGIES[@]}"
do
    FILENAME="results_${STRATEGY}.csv"
    echo "n,ops,theory_val" > "$FILENAME"
    
    echo "Processing strategy: $STRATEGY..."

    for ((N=10; N<=MAX_N; N+=STEP))
    do
        total_ops=0

        for ((i=0; i<RUNS; i++))
        do
            ARGS=$(shuf -i 0-9999 -n $N | tr '\n' ' ')
            ops=$(./push_swap --$STRATEGY $ARGS | wc -l)
            total_ops=$((total_ops + ops))
        done

        avg_ops=$(echo "scale=2; $total_ops / $RUNS" | bc -l)

        if [ "$STRATEGY" == "simple" ]; then
            theory=$(echo "scale=4; $N * $N" | bc -l)
        elif [ "$STRATEGY" == "medium" ]; then
            theory=$(echo "scale=4; $N * sqrt($N)" | bc -l)
        else
            theory=$(echo "scale=4; $N * (l($N)/l(2))" | bc -l)
        fi

        echo "$N,$avg_ops,$theory" >> "$FILENAME"
        
        printf "\r  Strategy: %-8s | N: %d/%d" "$STRATEGY" "$N" "$MAX_N"
    done
    echo -e "\n  Finished $STRATEGY. Saved to $FILENAME"
done

echo "All data collection complete."