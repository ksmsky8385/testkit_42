#!/bin/bash

RUNS=10
SIZES=(50 100 150 200 300 500 700 1000)

for STRATEGY in simple medium complex
do
    if [ "$STRATEGY" == "simple" ]; then
        EXPRESSION="O(n^2)"
    elif [ "$STRATEGY" == "medium" ]; then
        EXPRESSION="O(n√n)"
    else
        EXPRESSION="O(n log n)"
    fi

    echo "===== $STRATEGY : $EXPRESSION ====="

    for N in "${SIZES[@]}"
    do
        total_ops=0

        for ((i=0; i<RUNS; i++))
        do
            ARGS=$(shuf -i 0-9999 -n $N | tr '\n' ' ')
            ops=$(./push_swap --$STRATEGY $ARGS | wc -l)
            total_ops=$((total_ops + ops))
        done

        avg_ops=$(echo "$total_ops / $RUNS" | bc -l)

        if [ "$STRATEGY" == "simple" ]; then
            norm=$(echo "$avg_ops / ($N * $N)" | bc -l)
        elif [ "$STRATEGY" == "medium" ]; then
            norm=$(echo "$avg_ops / ($N * sqrt($N))" | bc -l)
        else
            norm=$(echo "$avg_ops / ($N * (l($N)/l(2)))" | bc -l)
        fi

        printf "N=%d avg_ops=%.2f norm=%.4f\n" "$N" "$avg_ops" "$norm"
    done
    echo
done