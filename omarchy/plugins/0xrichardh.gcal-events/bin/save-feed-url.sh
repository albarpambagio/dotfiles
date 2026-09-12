#!/usr/bin/env bash
# Appends a secret Google Calendar iCal URL to disk, restrictively.
# Duplicate URLs are skipped. One URL per line.
#
# Invoked by Panel.qml as a Process with stdinEnabled: true — the URL is
# written to this script's stdin, never passed as an argv, so it never
# shows up in `ps`. Usage: save-feed-url.sh <target-path>
set -euo pipefail

target="${1:?usage: save-feed-url.sh <target-path>}"
dir="$(dirname "$target")"
mkdir -p "$dir"

# Read the new URL from stdin
IFS= read -r new_url
new_url="$(printf '%s' "$new_url" | tr -d '\r\n')"
if [[ -z "$new_url" ]]; then
  exit 1
fi

# Read existing URLs (if file exists) and check for duplicate
existing=""
if [[ -r "$target" ]]; then
  existing="$(cat "$target")"
fi

if printf '%s\n' "$existing" | grep -qF "$new_url"; then
  # URL already in file, nothing to do
  exit 0
fi

# Append the new URL
umask 077
tmp="$(mktemp "$dir/.feed-url.XXXXXX")"

if [[ -n "$existing" ]]; then
  printf '%s\n%s\n' "$existing" "$new_url" > "$tmp"
else
  printf '%s\n' "$new_url" > "$tmp"
fi

mv -f "$tmp" "$target"
