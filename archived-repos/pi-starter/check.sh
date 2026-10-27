#!/usr/bin/env bash
# Everything CI runs for this repo. Run it before a push: ./check.sh
#
# Pass --offline to skip the parity check against harness-configs (needs network).
set -euo pipefail
cd "$(dirname "$0")"

command -v jq >/dev/null 2>&1 || { echo "jq is required: brew install jq" >&2; exit 1; }

echo "== settings.json is valid and declares packages"
jq -e '.packages | type == "array" and length > 0' settings.json >/dev/null

echo "== no credentials or absolute local paths"
if git ls-files | grep -Ei '(^|/)(auth|models|credentials?)[^/]*\.json$'; then
  echo "credential-looking file is tracked" >&2; exit 1
fi
if grep -nE '"(/Users|/home)/' settings.json; then
  echo "settings.json has an absolute local path; it will not resolve on other machines" >&2; exit 1
fi

echo "== no leftover placeholders"
if grep -rn 'YOUR_USER\|THIS_REPO' --include='*.md' --include='*.json' . ; then
  echo "placeholder left in the pack" >&2; exit 1
fi

if [[ "${1:-}" != "--offline" ]]; then
  echo "== package list matches harness-configs/pi/settings.json"
  upstream="$(mktemp)"; trap 'rm -f "$upstream"' EXIT
  curl -fsSL https://raw.githubusercontent.com/AdrianTJ/harness-configs/main/pi/settings.json -o "$upstream"
  mine="$(jq -c '.packages | sort' settings.json)"
  theirs="$(jq -c '.packages | sort' "$upstream")"
  if [[ "$mine" != "$theirs" ]]; then
    echo "packages drifted from harness-configs/pi/settings.json" >&2
    echo "  here:           $mine" >&2
    echo "  harness-configs: $theirs" >&2
    exit 1
  fi
fi

echo "pi-starter: all checks passed"
