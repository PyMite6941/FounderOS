#!/usr/bin/env bash
set -euo pipefail

device_name="${1:-iPhone 15}"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "iOS Simulator requires macOS with Xcode installed." >&2
  exit 1
fi

if ! command -v xcrun >/dev/null 2>&1; then
  echo "xcrun not found. Install Xcode and its command-line tools." >&2
  exit 1
fi

if ! device_list="$(xcrun simctl list devices available)"; then
  echo "Failed to list available iOS simulators." >&2
  exit 1
fi

device_udid="$(
  printf '%s\n' "$device_list" |
    awk -v wanted="$device_name" '
      {
        sub(/^[[:space:]]*/, "")
        if (index($0, wanted " (") == 1) {
          id = substr($0, length(wanted) + 3)
          sub(/\).*/, "", id)
          print id
          exit
        }
      }
    '
)"
if [[ -z "$device_udid" ]]; then
  echo "Requested simulator '$device_name' was not found. Available devices:" >&2
  printf '%s\n' "$device_list" >&2
  exit 1
fi

echo "Booting iOS simulator: $device_name"
if ! xcrun simctl boot "$device_udid"; then
  echo "Could not boot simulator '$device_name'. It may already be booted." >&2
  exit 1
fi
open -a Simulator
