#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   BASE_URL=http://127.0.0.1:8000 ./scripts/pregen_mcp_audio.sh
#
# Requirements:
#   - FastAPI backend running at BASE_URL
#   - SARVAM_API_KEY exported in the backend process environment

BASE_URL="${BASE_URL:-http://127.0.0.1:8000}"

experiments=(
  "6:transparency"
  "6:shadow"
  "6:pinhole"
  "6:refraction"
  "7:planeMirror"
  "7:sphericalMirror"
  "7:newtonDisc"
  "9:lawsOfReflection"
  "9:kaleidoscope"
  "11:tir"
  "11:prism"
  "11:lens"
)

languages=("en" "te")

extract_json_value() {
  local json="$1"
  local key="$2"
  printf '%s' "$json" | sed -n "s/.*\"${key}\":\"\\([^\"]*\\)\".*/\\1/p"
}

echo "Pre-generating MCP audio via: ${BASE_URL}"
echo

for item in "${experiments[@]}"; do
  class_id="${item%%:*}"
  experiment_id="${item##*:}"
  for lang in "${languages[@]}"; do
    url="${BASE_URL}/mcp/explanation/${class_id}/${experiment_id}/${lang}"
    echo "-> ${class_id}/${experiment_id}/${lang}"

    response="$(curl -sS "$url")"
    status="$(extract_json_value "$response" "status")"
    audio_url="$(extract_json_value "$response" "audioUrl")"
    audio_error="$(extract_json_value "$response" "audioError")"

    if [[ "$status" == "ready" && -n "$audio_url" ]]; then
      echo "   ready: ${audio_url}"
    elif [[ "$status" == "failed" ]]; then
      if [[ -n "$audio_error" ]]; then
        echo "   failed: ${audio_error}"
      else
        echo "   failed: see response below"
        echo "   ${response}"
      fi
    else
      echo "   status: ${status:-unknown}"
      if [[ -n "$audio_url" ]]; then
        echo "   audioUrl: ${audio_url}"
      fi
    fi
  done
done

echo
echo "Done."
