#!/bin/sh

# This script parses a JSON array of college radio stations and outputs them in CSV format.
# Usage: ./parse_college_stations.sh /path/to/college_stations.json output.csv

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq is required but not installed. Please install jq and try again."
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="$2"

# Parse the JSON file and append to output CSV file
# Each element in array is JSON object with keys: call_sign, college_name, audio_url, station_url
jq -c '.[]' "$INPUT_FILE" | while read -r station; do
    CALL_SIGN=$(echo "$station" | jq -r '.call_sign')
    COLLEGE_NAME=$(echo "$station" | jq -r '.college_name')
    AUDIO_URL=$(echo "$station" | jq -r '.audio_url')
    STATION_URL=$(echo "$station" | jq -r '.station_url')

    # Strip "https://cors-proxy.elfsight.com/" prefix from AUDIO_URL if present
    AUDIO_URL=${AUDIO_URL#https://cors-proxy.elfsight.com/}

    # Output in CSV format: Name, Stream URL, Home Page URL
    echo "$CALL_SIGN - $COLLEGE_NAME,$AUDIO_URL,$STATION_URL"
done >> "$OUTPUT_FILE"
