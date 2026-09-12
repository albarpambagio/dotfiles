#!/usr/bin/env bash
# Fetches one or more secret Google Calendar iCal feeds without passing
# URLs as command-line arguments, keeping bearer secrets out of `ps`.
#
# Reads URLs (one per non-empty line) from <feed-url-path> (or stdin if
# "-" is passed) and fetches each via curl, concatenating all ICS output.
# Usage: fetch-feed.sh <feed-url-path>
set -euo pipefail

target="${1:?usage: fetch-feed.sh <feed-url-path>}"

if [[ "$target" == "-" ]]; then
  urls="$(cat)"
else
  if [[ ! -r "$target" ]]; then
    exit 1
  fi
  urls="$(cat "$target")"
fi

# Strip carriage returns, drop blank lines
urls="$(printf '%s' "$urls" | tr -d '\r' | grep -v '^[[:space:]]*$')"

if [[ -z "$urls" ]]; then
  exit 1
fi

found=0
while IFS= read -r url; do
  url="$(printf '%s' "$url" | tr -d '\r\n')"
  [[ -z "$url" ]] && continue

  escaped_url="${url//\\/\\\\}"
  escaped_url="${escaped_url//\"/\\\"}"

  if printf 'url = "%s"\n' "$escaped_url" | curl -fsS --max-time 10 --config - 2>/dev/null; then
    found=1
  fi
done <<< "$urls"

if [[ "$found" -eq 0 ]]; then
  exit 1
fi
