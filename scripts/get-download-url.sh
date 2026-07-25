#!/usr/bin/env bash
# Fetches the latest Antigravity IDE Linux download URL from antigravity.google.
#
# The download page now server-renders the links, so the URL is normally found
# directly in the page HTML. Older versions of the site only exposed it from a
# cache-busted JS bundle, so that path is kept as a fallback.
#
# Note: the page also lists "Antigravity 2.0" (the hub app, hosted on
# storage.googleapis.com). This script deliberately matches only the
# Antigravity IDE archives served from edgedl.me.gvt1.com.

set -euo pipefail

BASE_URL="https://antigravity.google"
ARCH="${ARCH:-linux-x64}"   # linux-x64 or linux-arm

fetch() {
  curl -fsSL --compressed \
    -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0 Safari/537.36" \
    "$1"
}

# Normalize HTML/JSON escaping so the URL appears as plain text:
#   / -> /   \/ -> /   &amp; -> &
unescape() {
  sed -e 's/\\u002[Ff]/\//g' -e 's/\\\//\//g' -e 's/&amp;/\&/g'
}

# Match the IDE tarball, tolerating "%20", "+" or a literal space in the filename.
extract_url() {
  grep -oiE "https://edgedl\.me\.gvt1\.com/[A-Za-z0-9._~:/?#@!$&'()*,;=%-]*/${ARCH}/Antigravity(%20|\+| )IDE\.tar\.gz" |
    sed -e 's/ /%20/g' -e 's/+/%20/g' |
    head -1
}

page=$(fetch "${BASE_URL}/download") || {
  echo "Error: could not fetch ${BASE_URL}/download" >&2
  exit 1
}

download_url=$(printf '%s' "$page" | unescape | extract_url || true)

# Fallback: scan the JS bundles referenced by the page.
if [[ -z "$download_url" ]]; then
  mapfile -t bundles < <(
    printf '%s' "$page" | unescape |
      grep -oE '(https://[A-Za-z0-9._/-]+|/[A-Za-z0-9._/-]+)\.js' |
      sort -u
  )
  for bundle in "${bundles[@]}"; do
    [[ "$bundle" == http* ]] || bundle="${BASE_URL}/${bundle#/}"
    download_url=$(fetch "$bundle" 2>/dev/null | unescape | extract_url || true)
    [[ -n "$download_url" ]] && break
  done
fi

if [[ -z "$download_url" ]]; then
  echo "Error: could not find Antigravity IDE ${ARCH} download URL" >&2
  exit 1
fi

echo "$download_url"
