#!/usr/bin/env bash
set -euo pipefail

config_name="${SYNCZ_CONFIG_NAME:-syncz.yml}"
dir="$PWD"

while [[ "$dir" != "/" ]]; do
  if [[ -f "$dir/$config_name" ]]; then
    cd "$dir"
    exec syncz "$@"
  fi
  dir="$(dirname "$dir")"
done

if [[ -f "/$config_name" ]]; then
  cd /
  exec syncz "$@"
fi

printf 'syncz wrapper: %s not found in current directory or any parent directory\n' "$config_name" >&2
exit 1
