# AGENTS.md

This file defines repository-level instructions for coding agents working in this project.

## Project Overview

This repository is a minimal full-stack development environment for GitHub Codespaces.

- Frontend: React + Vite
- Backend: Python + FastAPI
- Development environment: GitHub Codespaces / Dev Container
- AI coding assistant: Codex CLI

The repository is intended to work well from both desktop browsers and mobile devices such as iPhone.

## Core Rules

### 1. Keep README.md synchronized with implementation

Whenever a change affects how a developer understands, sets up, runs, tests, or uses this repository, update `README.md` in the same change.

Do not leave README instructions stale after changing implementation.

README review is required when changing any of the following:

- `.devcontainer/**`
- setup or installation commands
- startup or shutdown commands
- ports or forwarded ports
- environment variables or secrets
- directory structure
- frontend/backend frameworks or major dependencies
- API endpoints or public API usage
- development workflow
- Codex installation, authentication, or usage
- test commands
- deployment or CI procedures

If README changes are not necessary, explicitly verify that the existing documentation remains accurate before finishing the task.

### 2. Preserve the Codespaces developer experience

Changes should keep the repository usable from a fresh GitHub Codespace.

After changing setup-related files, verify that a new environment can still be initialized from `.devcontainer/devcontainer.json` and `.devcontainer/post-create.sh` without undocumented manual steps.

Prefer automated setup over instructions that require repeated manual configuration.

### 3. Keep mobile development practical

This project is intended to be usable from iPhone / iPad through Codespaces.

Prefer workflows that minimize unnecessary terminal typing and repetitive setup. Keep common commands simple and document them in `README.md`.

### 4. Never commit secrets

Do not add credentials or secrets to the repository.

Examples include:

- OpenAI API keys
- GitHub tokens
- AWS / Azure credentials
- database passwords
- `.env` files containing secrets

Use GitHub Codespaces Secrets or environment variables instead, and document required secret names without including secret values.

### 5. Make focused changes

Avoid unrelated refactors while implementing a requested change.

Before finishing, review the diff and ensure only files related to the requested work were modified.

## Validation

After implementation, run the relevant checks when possible.

For application changes, verify at minimum:

```bash
./start-dev.sh
```

For Codex installation changes, also verify:

```bash
codex --version
```

For backend changes, use the relevant Python/FastAPI checks or tests when they exist.

For frontend changes, use the relevant npm/Vite checks or tests when they exist.

## Documentation Checklist

Before declaring a task complete, check:

- Does `README.md` still describe the current architecture?
- Are setup commands accurate?
- Are startup commands accurate?
- Are port numbers accurate?
- Does the directory tree reflect meaningful structural changes?
- Are new tools or dependencies documented?
- Are new environment variables or secrets documented safely?
- Does the Codex workflow still match the actual Dev Container setup?

Documentation is part of the implementation, not a separate optional task.
