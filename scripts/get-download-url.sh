#!/usr/bin/env bash
# Fetches the latest Antigravity Linux (.tar.gz) download URL from antigravity.google
# The URL is embedded in the main JS bundle which has a cache-busted filename

set -euo pipefail

BASE_URL="https://antigravity.google"

# Get the JS bundle filename from the HTML page
main_js=$(curl -sL --compressed "${BASE_URL}/download/linux" | grep -oP 'main-[A-Z0-9]+\.js' | head -1)

if [[ -z "$main_js" ]]; then
  echo "Error: Could not find main JS bundle" >&2
  exit 1
fi

# Extract the Linux tar.gz download URL from the JS bundle
download_url=$(curl -sL --compressed "${BASE_URL}/${main_js}" | \
  grep -oP '"https://edgedl\.me\.gvt1\.com[^"]+linux-x64/Antigravity\.tar\.gz"' | \
  tr -d '"' | head -1)

if [[ -z "$download_url" ]]; then
  echo "Error: Could not find download URL in JS bundle" >&2
  exit 1
fi

echo "$download_url"
