#!/usr/bin/env bash
set -euo pipefail

device_name="${1:-}"

sdk_root="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-}}"
if [[ -z "$sdk_root" ]]; then
  if [[ -n "${HOME:-}" && -d "$HOME/Android/Sdk" ]]; then
    sdk_root="$HOME/Android/Sdk"
  elif [[ -n "${HOME:-}" && -d "$HOME/Library/Android/sdk" ]]; then
    sdk_root="$HOME/Library/Android/sdk"
  fi
fi

if [[ -z "$sdk_root" ]]; then
  echo "Android SDK not found. Set ANDROID_HOME or ANDROID_SDK_ROOT." >&2
  exit 1
fi

emulator="$sdk_root/emulator/emulator"
if [[ ! -x "$emulator" ]]; then
  echo "Android emulator not found or not executable: $emulator" >&2
  exit 1
fi

if ! avd_list="$("$emulator" -list-avds)"; then
  echo "Failed to list Android Virtual Devices." >&2
  exit 1
fi
if [[ -z "$avd_list" ]]; then
  echo "No Android Virtual Devices found. Create one in Android Studio first." >&2
  echo "Example: avdmanager create avd -n FounderOS -k 'system-images;android-34;google_apis;x86_64' -d pixel_6" >&2
  exit 1
fi

if [[ -z "$device_name" ]]; then
  device_name="$(printf '%s\n' "$avd_list" | sed -n '1p')"
  echo "No AVD specified; using the first available device: $device_name"
fi

if ! grep -Fxq -- "$device_name" <<< "$avd_list"; then
  printf "Requested device '%s' was not found. Available AVDs:\n%s\n" "$device_name" "$avd_list" >&2
  exit 1
fi

echo "Launching Android emulator: $device_name"
exec "$emulator" -avd "$device_name"
