#!/usr/bin/env bash
set -euo pipefail

python -m venv .venv
.venv/bin/python -m pip install --upgrade pip
.venv/bin/pip install -r server/requirements.txt
npm --prefix client install
chmod +x start-dev.sh

echo "Installing Codex CLI..."
curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=true sh

echo "Codespace setup complete."
echo "Run ./start-dev.sh to start the app."
echo "Run codex to start Codex CLI."
echo "For first sign-in in Codespaces, use: codex login --device-auth"
