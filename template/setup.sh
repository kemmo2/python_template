#!/usr/bin/env bash

set -euo pipefail

if ! command -v uv >/dev/null 2>&1; then
    echo "Error: uv が見つかりません。"
    echo "macOS: brew install uv"
    exit 1
fi

if ! command -v git >/dev/null 2>&1; then
    echo "Error: git が見つかりません。"
    exit 1
fi

echo "Installing dependencies..."
uv sync

echo "Installing pre-commit hook..."
uv run pre-commit install

echo "Running quality checks..."
uv run pre-commit run --all-files

if [ ! -d ".git" ]; then
    echo "Initializing Git repository..."
    git init
fi

git add .

if git diff --cached --quiet; then
    echo "No files to commit."
else
    git commit -m "Initial commit"
fi

read -p "Create GitHub repository? [y/N] " ans

if [[ "$ans" =~ ^[Yy]$ ]]; then

    REPO_NAME=$(grep '^project_slug:' .copier-answers.yml | awk '{print $2}')

    gh repo create "$REPO_NAME" --private --source=. --push
else
    echo
    echo "Setup completed."
    echo "To create the GitHub repository, run:"
    echo "  gh repo create --private --source=. --push"
fi