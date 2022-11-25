#!/bin/bash

USER_KEY=$1

echo "Making 20 requests"

RESPONSES_200=6
RESPONSES_201=7
RESPONSES_203=7

CURL_COMMAND="curl -s -k https://monitoring-analytics-3scale-apicast-staging.apps.ocp4.example.com/status/%s?user_key=${USER_KEY} -o /dev/null"

for i in $(seq 1 $RESPONSES_200); do
    RESPONSES_200_COMMAND=$(printf "$CURL_COMMAND" "200")
    ${RESPONSES_200_COMMAND}
done

for i in $(seq 1 $RESPONSES_201); do
    RESPONSES_201_COMMAND=$(printf "$CURL_COMMAND" "201")
    ${RESPONSES_201_COMMAND}
done

for i in $(seq 1 $RESPONSES_203); do
    RESPONSES_203_COMMAND=$(printf "$CURL_COMMAND" "203")
    ${RESPONSES_203_COMMAND}
done

echo "Responses with status code 200: ${RESPONSES_200}"
echo "Responses with status code 201: ${RESPONSES_201}"
echo "Responses with status code 203: ${RESPONSES_203}"
