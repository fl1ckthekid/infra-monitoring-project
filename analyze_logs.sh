#!/bin/bash

LOG_FILE="access.log"

echo "Generating test log file..."

> "$LOG_FILE"

for i in $(seq 1 300); do

    if [ $((i % 10)) -lt 5 ]; then
        IP="192.168.1.10"
    elif [ $((i % 10)) -lt 8 ]; then
        IP="10.0.0.5"
    else
        IP="172.16.0.8"
    fi

    if [ $((i % 2)) -eq 0 ]; then
        METHOD="GET"
        ENDPOINT="/api/users"
    else
        METHOD="POST"
        ENDPOINT="/api/login"
    fi

    if [ $((i % 20)) -eq 0 ]; then
        STATUS=500
    elif [ $((i % 20)) -le 3 ]; then
        STATUS=401
    else
        STATUS=200
    fi

    echo "$IP - - [15/Aug/2026:10:15:32] \"$METHOD $ENDPOINT HTTP/1.1\" $STATUS" >> "$LOG_FILE"

done

echo ""
echo "Log file generated: $LOG_FILE"

TOTAL=$(wc -l < "$LOG_FILE")

echo ""
echo "Total requests: $TOTAL"

echo ""
echo "Top 3 IP addresses:"

grep -Eo '^([0-9]{1,3}\.){3}[0-9]{1,3}' "$LOG_FILE" \
    | sort \
    | uniq -c \
    | sort -nr \
    | head -3

ERROR_4XX=$(awk '$9 ~ /^4[0-9][0-9]$/ {count++} END {print count+0}' "$LOG_FILE")
ERROR_5XX=$(awk '$9 ~ /^5[0-9][0-9]$/ {count++} END {print count+0}' "$LOG_FILE")

echo ""
echo "4xx errors: $ERROR_4XX"
echo "5xx errors: $ERROR_5XX"

echo ""
echo "Log analysis completed."
