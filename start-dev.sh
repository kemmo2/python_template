#!/usr/bin/env bash
set -euo pipefail

cleanup() {
  if [[ -n "${SERVER_PID:-}" ]]; then
    kill "$SERVER_PID" 2>/dev/null || true
  fi
}
trap cleanup EXIT INT TERM

.venv/bin/uvicorn server.main:app --host 0.0.0.0 --port 8000 --reload &
SERVER_PID=$!

npm --prefix client run dev
