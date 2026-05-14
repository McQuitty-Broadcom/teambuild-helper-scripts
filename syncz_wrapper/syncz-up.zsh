#!/usr/bin/env zsh
set -euo pipefail

config_name="${SYNCZ_CONFIG_NAME:-syncz.yml}"
dir="$PWD"

while [[ "$dir" != "/" ]]; do
  if [[ -f "$dir/$config_name" ]]; then
    cd "$dir"
    exec syncz "$@"
  fi
  dir="${dir:h}"
done

if [[ -f "/$config_name" ]]; then
  cd /
  exec syncz "$@"
fi

print -u2 "syncz wrapper: $config_name not found in current directory or any parent directory"
exit 1
