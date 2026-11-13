#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: ./check_api.sh <API_URL>"
    exit 1
fi

API_URL="$1"

HTTP_CODE=$(curl -sS -o /dev/null -w "%{http_code}" \
    --max-time 10 "$API_URL")

if [ "$HTTP_CODE" = "200" ]; then
    echo "API доступен"
    exit 0
else
    echo "API недоступен, код ответа: $HTTP_CODE"
    exit 1
fi
