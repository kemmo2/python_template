#!/usr/bin/env bash
set -euo pipefail

cleanup() {
  if [[ -n "${SERVER_PID:-}" ]]; then
    kill "$SERVER_PID" 2>/dev/null || true
  fi
}
trap cleanup EXIT INT TERM

ensure_private_codespaces_ports() {
  if [[ "${CODESPACES:-}" != "true" || -z "${CODESPACE_NAME:-}" ]]; then
    return 0
  fi

  for _ in {1..20}; do
    if gh codespace ports visibility 5173:private 8000:private -c "$CODESPACE_NAME" >/dev/null 2>&1; then
      echo "Codespaces ports 5173 and 8000 are private."
      return 0
    fi
    sleep 1
  done

  echo "Warning: could not force Codespaces port visibility to private." >&2
}

.venv/bin/uvicorn server.main:app --host 0.0.0.0 --port 8000 --reload &
SERVER_PID=$!

ensure_private_codespaces_ports &

npm --prefix client run dev
