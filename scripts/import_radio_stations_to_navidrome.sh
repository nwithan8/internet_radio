#!/bin/sh

# This script imports radio stations from a JSON file into Navidrome.
# Usage: ./import_radio_stations.sh /path/to/radio_stations.json http://navidrome-url username password

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq is required but not installed. Please install jq and try again."
    exit 1
fi

# Check for correct number of arguments
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 /path/to/radio_stations.json http://navidrome-url username password"
    exit 1
fi

INPUT_FILE="$1"
NAVIDROME_URL="$2"
USERNAME="$3"
PASSWORD="$4"

# Login to Navidrome and get the auth token
AUTH_RESPONSE=$(curl -s -X POST "$NAVIDROME_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\"}")
AUTH_TOKEN=$(echo "$AUTH_RESPONSE" | jq -r '.token')

if [ "$AUTH_TOKEN" = "null" ]; then
  echo "Login failed. Please check your username and password."
  exit 1
fi

# Read the JSON file and import each radio station
# Each element in JSON array is a JSON object with keys: name, audio_url, station_url
jq -c '.[]' "$INPUT_FILE" | while read -r station; do
  STATION_NAME=$(echo "$station" | jq -r '.name')
  AUDIO_URL=$(echo "$station" | jq -r '.audio_url')
  STATION_URL=$(echo "$station" | jq -r '.station_url')

  # Make API call to Navidrome to add the radio station
  RESPONSE=$(curl -s -X POST "$NAVIDROME_URL/api/radio" \
    -H "Content-Type: application/json" \
    -H "x-nd-authorization: Bearer $AUTH_TOKEN" \
    -d "{\"streamUrl\":\"$AUDIO_URL\",\"name\":\"$STATION_NAME\",\"homePageUrl\":\"$STATION_URL\"}")

  if echo "$RESPONSE" | grep -q '"error"'; then
    echo "Failed to import station: $STATION_NAME. Response: $RESPONSE"
  else
    echo "Imported station: $STATION_NAME"
  fi
done

