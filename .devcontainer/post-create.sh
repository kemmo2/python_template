#!/usr/bin/env bash
set -euo pipefail

python -m venv .venv
.venv/bin/python -m pip install --upgrade pip
.venv/bin/pip install -r server/requirements.txt
npm --prefix client install
chmod +x start-dev.sh

echo "Codespace setup complete. Run ./start-dev.sh"
