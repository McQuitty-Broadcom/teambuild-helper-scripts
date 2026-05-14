#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
SCRIPT="$ROOT_DIR/bin/exportz-zowe"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/exportz-zowe-test.XXXXXX")"
trap 'rm -rf "$TMP_ROOT"' EXIT

fail() {
  printf 'not ok - %s\n' "$*" >&2
  exit 1
}

assert_contains() {
  local haystack="$1"
  local needle="$2"
  [[ "$haystack" == *"$needle"* ]] || fail "expected output to contain: $needle"
}

assert_not_contains() {
  local haystack="$1"
  local needle="$2"
  [[ "$haystack" != *"$needle"* ]] || fail "expected output not to contain: $needle"
}

write_config() {
  local dir="$1"
  cat >"$dir/zowe.config.json" <<'JSON'
{
  "profiles": {
    "base": {
      "type": "base",
      "properties": {
        "user": "USER1",
        "password": "PASS1"
      }
    },
    "endevorRest": {
      "type": "endevor",
      "properties": {
        "host": "endevor.example.com",
        "port": 9443,
        "protocol": "https",
        "basePath": "EndevorService/api/v2"
      }
    },
    "devLocation": {
      "type": "endevor-location",
      "properties": {
        "instance": "ENDEVOR",
        "environment": "DEV",
        "stageNumber": "1",
        "system": "PAYROLL",
        "subsystem": "API"
      }
    }
  },
  "defaults": {
    "base": "base",
    "endevor": "endevorRest",
    "endevor-location": "devLocation"
  }
}
JSON
}

test_dry_run_derives_exportz_args() {
  local dir output
  dir="$TMP_ROOT/default"
  mkdir -p "$dir"
  write_config "$dir"

  output="$("$SCRIPT" --config "$dir/zowe.config.json" --dry-run --dataset-hlq USER1.TEAMBUILD)"

  assert_contains "$output" "exportz --environment DEV --stage-number 1 --system PAYROLL --subsystem API"
  assert_contains "$output" "--base-url https://endevor.example.com:9443/EndevorService/api/v2"
  assert_contains "$output" "--instance ENDEVOR"
  assert_not_contains "$output" "--username"
  assert_not_contains "$output" "--password"
  assert_contains "$output" "--dataset-hlq USER1.TEAMBUILD"
}

test_does_not_duplicate_caller_flags() {
  local dir output count
  dir="$TMP_ROOT/override"
  mkdir -p "$dir"
  write_config "$dir"

  output="$("$SCRIPT" --config "$dir/zowe.config.json" --dry-run --environment QA --dataset-hlq USER1.TEAMBUILD)"
  count="$(grep -o -- '--environment' <<<"$output" | wc -l | tr -d ' ')"

  [[ "$count" == "1" ]] || fail "expected one --environment flag, got $count"
  assert_contains "$output" "--environment QA --dataset-hlq USER1.TEAMBUILD"
}


test_maps_reject_unauthorized_to_insecure() {
  local dir output
  dir="$TMP_ROOT/insecure"
  mkdir -p "$dir"
  write_config "$dir"
  python3 - "$dir/zowe.config.json" <<'PY'
import json
import sys

path = sys.argv[1]
with open(path, "r", encoding="utf-8") as handle:
    config = json.load(handle)
config["profiles"]["endevorRest"]["properties"]["rejectUnauthorized"] = False
with open(path, "w", encoding="utf-8") as handle:
    json.dump(config, handle)
PY

  output="$("$SCRIPT" --config "$dir/zowe.config.json" --dry-run)"

  assert_contains "$output" "--insecure"
}

test_respects_existing_insecure_flag() {
  local dir output count
  dir="$TMP_ROOT/existing-insecure"
  mkdir -p "$dir"
  write_config "$dir"
  python3 - "$dir/zowe.config.json" <<'PY'
import json
import sys

path = sys.argv[1]
with open(path, "r", encoding="utf-8") as handle:
    config = json.load(handle)
config["profiles"]["endevorRest"]["properties"]["rejectUnauthorized"] = False
with open(path, "w", encoding="utf-8") as handle:
    json.dump(config, handle)
PY

  output="$("$SCRIPT" --config "$dir/zowe.config.json" --dry-run --insecure)"
  count="$(grep -o -- '--insecure' <<<"$output" | wc -l | tr -d ' ')"

  [[ "$count" == "1" ]] || fail "expected one --insecure flag, got $count"
}

test_dry_run_quotes_arguments() {
  local dir output
  dir="$TMP_ROOT/quotes"
  mkdir -p "$dir"
  write_config "$dir"

  output="$("$SCRIPT" --config "$dir/zowe.config.json" --dry-run --processor-directory "path with spaces")"

  assert_contains "$output" "--processor-directory path\\ with\\ spaces"
}

test_dry_run_derives_exportz_args
test_does_not_duplicate_caller_flags
test_maps_reject_unauthorized_to_insecure
test_respects_existing_insecure_flag
test_dry_run_quotes_arguments

printf 'ok - exportz-zowe bash script tests passed\n'
