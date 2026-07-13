#!/bin/bash

STRATEGY="--medium"
CHECKER="checker_linux"

LIMITS_100=(700 1500 2000)
LIMITS_500=(5500 8000 12000)

for N in 100 500
do
    ARGS=$(shuf -i 0-9999 -n $N | tr '\n' ' ')
    TMP_INS=$(mktemp)
    TMP_BENCH=$(mktemp)

    valgrind -q --leak-check=full --show-leak-kinds=all \
        ./push_swap --bench $STRATEGY $ARGS \
        1> "$TMP_INS" 2> "$TMP_BENCH"

    echo "=== N=$N Bench (stderr) ==="
    cat "$TMP_BENCH"
    echo "----------------------"

    echo -n "$CHECKER Result : "
    valgrind -q --leak-check=full --show-leak-kinds=all \
        ./$CHECKER $ARGS < "$TMP_INS"

    LINE_COUNT=$(grep -v '^$' "$TMP_INS" | wc -l)

    if [ "$N" -eq 100 ]; then
        if [ "$LINE_COUNT" -lt "${LIMITS_100[0]}" ]; then
            PERF="Excellent"
            TARGET="Less than ${LIMITS_100[0]}"
        elif [ "$LINE_COUNT" -lt "${LIMITS_100[1]}" ]; then
            PERF="Good"
            TARGET="Less than ${LIMITS_100[1]}"
        elif [ "$LINE_COUNT" -lt "${LIMITS_100[2]}" ]; then
            PERF="Pass"
            TARGET="Less than ${LIMITS_100[2]}"
        else
            PERF="Too many ops"
            TARGET="Over ${LIMITS_100[2]}"
        fi
    elif [ "$N" -eq 500 ]; then
        if [ "$LINE_COUNT" -lt "${LIMITS_500[0]}" ]; then
            PERF="Excellent"
            TARGET="Less than ${LIMITS_500[0]}"
        elif [ "$LINE_COUNT" -lt "${LIMITS_500[1]}" ]; then
            PERF="Good"
            TARGET="Less than ${LIMITS_500[1]}"
        elif [ "$LINE_COUNT" -lt "${LIMITS_500[2]}" ]; then
            PERF="Pass"
            TARGET="Less than ${LIMITS_500[2]}"
        else
            PERF="Too many ops"
            TARGET="Over ${LIMITS_500[2]}"
        fi
    fi

    echo "Performance (N=$N) : $PERF ($TARGET) ($LINE_COUNT ops)"
    echo
    rm -f "$TMP_INS" "$TMP_BENCH"
done