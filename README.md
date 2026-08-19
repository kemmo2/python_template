# React + FastAPI on GitHub Codespaces

GitHub Codespaces 上で、クライアントサイドを **React + Vite**、サーバーサイドを **Python + FastAPI** として開発するための最小構成です。

PCだけでなく、iPhone / iPad のブラウザから Codespaces を開き、**Codex CLI を使って実装・修正・テストを行いながら、Web アプリをプレビューする**用途も想定しています。

## Architecture

```text
Browser / iPhone Safari
        |
        | HTTPS
        v
GitHub Codespaces
        |
        +---------------------------+
        |                           |
        v                           v
Vite + React                   FastAPI
port 5173                      port 8000
        |                           ^
        |  /api/*                   |
        +-------- Vite Proxy -------+
        |
        +-- Terminal
              |
              +-- Codex CLI
```

React から FastAPI を直接 `localhost:8000` で呼ぶのではなく、React は `/api/*` にアクセスし、Vite の development server が FastAPI にプロキシします。

例えば React では次のように API を呼びます。

```javascript
fetch('/api/health')
```

Vite は `/api` へのリクエストを Codespace 内の FastAPI に転送します。

```text
/api/health
    ↓
Vite :5173
    ↓ proxy
FastAPI :8000
```

この構成にすることで、Codespaces のようにブラウザと開発サーバーが別環境に存在する場合でも、フロントエンドから API に接続しやすくしています。

## Technology Stack

### Client

- React
- Vite
- JavaScript

### Server

- Python
- FastAPI
- Uvicorn

### Development Environment

- GitHub Codespaces
- Dev Container
- VS Code Web
- Codex CLI

## Directory Structure

```text
.
├── .devcontainer/
│   ├── devcontainer.json
│   └── post-create.sh
├── client/
│   ├── package.json
│   ├── vite.config.js
│   └── src/
│       ├── App.jsx
│       └── main.jsx
├── server/
│   ├── main.py
│   └── requirements.txt
├── AGENTS.md
├── start-dev.sh
└── README.md
```

### `.devcontainer/devcontainer.json`

Codespace の開発環境を定義します。

主な設定は以下です。

- Dev Container の Linux イメージ
- React 用ポート `5173` の転送
- FastAPI 用ポート `8000` の転送
- Python / ESLint / Prettier などの VS Code Extension
- Codespace 作成後に実行するセットアップスクリプト

### `.devcontainer/post-create.sh`

Codespace が初めて作成されたときに自動実行されます。

以下をセットアップします。

1. Python virtual environment `.venv` の作成
2. Python package のインストール
3. React / Node package のインストール
4. `start-dev.sh` への実行権限付与
5. Codex CLI のインストール

したがって、Codespace 作成後に手動で `pip install`、`npm install`、Codex CLI のインストールを行う必要は基本的にありません。

### `AGENTS.md`

Codex などのコーディングエージェント向けのリポジトリルールです。

特に、セットアップ方法、コマンド、アーキテクチャ、依存関係、開発フローなどを変更した場合は、**実装だけを変更して README を古い状態のまま残さない**ように定めています。

### `client/`

React アプリケーションです。

Vite development server を `0.0.0.0:5173` で起動します。

`vite.config.js` では `/api` を FastAPI にプロキシしています。

```text
React
  ↓
/api/*
  ↓
Vite Proxy
  ↓
http://127.0.0.1:8000
```

### `server/`

Python / FastAPI の API サーバーです。

現在は接続確認用として以下の API を提供しています。

```http
GET /api/health
```

レスポンス例:

```json
{
  "status": "ok",
  "message": "FastAPI is running"
}
```

### `start-dev.sh`

React と FastAPI をまとめて起動するためのスクリプトです。

内部では概ね次の2つを実行します。

```bash
.venv/bin/uvicorn server.main:app --host 0.0.0.0 --port 8000 --reload
npm --prefix client run dev
```

FastAPI はバックグラウンドで、Vite はフォアグラウンドで起動します。

## Start with GitHub Codespaces

### 1. Branch を選択

GitHub でこのリポジトリを開き、次のブランチを選択します。

```text
codespaces-react-python
```

### 2. Codespace を作成

GitHub のリポジトリ画面から以下を選択します。

```text
Code
  → Codespaces
  → Create codespace
```

Codespace が作成されると `.devcontainer/devcontainer.json` が読み込まれ、`post-create.sh` によって Python / Node の依存ライブラリと Codex CLI が自動的にインストールされます。

### 3. アプリケーションを起動

Codespace の Terminal で実行します。

```bash
./start-dev.sh
```

これで次の2つが起動します。

| Component | Port |
| --- | ---: |
| React / Vite | 5173 |
| FastAPI | 8000 |

### 4. React をプレビュー

Codespaces の `PORTS` から `5173` を開きます。

Codespaces が自動的にプレビューを開く場合もあります。

画面に以下のように表示されれば、React → FastAPI の通信まで成功しています。

```text
React + FastAPI

API: FastAPI is running
```

## Use Codex CLI in Codespaces

Codex CLI は Codespace 作成時に `.devcontainer/post-create.sh` から自動インストールされます。

### First sign-in

Codespaces のようなリモート環境では、初回認証に Device Code を使います。

```bash
codex login --device-auth
```

Terminal に表示された URL とコードを使ってブラウザで認証します。

認証後は次のコマンドで Codex を起動できます。

```bash
codex
```

例えば、次のように依頼できます。

```text
このリポジトリの構成を説明して

React にユーザー一覧画面を追加して

FastAPI に /api/users を追加して

テストを実行して失敗している箇所を修正して
```

Codex は Codespace 内のリポジトリを対象として、コードの読み取り、編集、コマンド実行、テストなどを行えます。

### Verify installation

Codex CLI が利用可能か確認するには次を実行します。

```bash
codex --version
```

## API Verification

FastAPI 単体を確認したい場合は、Codespaces の `PORTS` から `8000` を開きます。

FastAPI の Swagger UI は次のパスです。

```text
/docs
```

例えば Codespaces で公開された FastAPI URL が次の場合、

```text
https://<codespace>-8000.app.github.dev
```

Swagger UI は次になります。

```text
https://<codespace>-8000.app.github.dev/docs
```

## Development Workflow

手動で実装する場合の基本フローは以下です。

```text
Codespaceを開く
    ↓
./start-dev.sh
    ↓
React / FastAPI を編集
    ↓
Hot Reload
    ↓
ブラウザで確認
    ↓
git diff
    ↓
commit / push
```

Codex を使う場合は次のような流れになります。

```text
Codespaceを開く
    ↓
./start-dev.sh
    ↓
codex
    ↓
実装・修正を依頼
    ↓
Codex がコード編集 / テスト
    ↓
ブラウザでプレビュー
    ↓
必要なら追加修正を依頼
    ↓
git diff で確認
    ↓
commit / push
```

React と FastAPI はどちらも Hot Reload が有効です。

- React: Vite HMR
- FastAPI: Uvicorn `--reload`

そのため、通常はコード変更のたびにサーバーを再起動する必要はありません。

## Development on iPhone

iPhone では Safari から GitHub を開き、Codespaces を起動できます。

構成としては、iPhone 自体で Node.js や Python、Codex を実行するわけではありません。

```text
iPhone
  ↓
Safari / VS Code Web
  ↓
GitHub Codespaces
  ↓
Linux Container
  ├── Node.js / Vite / React
  ├── Python / FastAPI
  └── Codex CLI
```

実際のビルド、サーバー実行、Codex によるコード編集はすべて GitHub 側の Codespace で行われます。

iPhone は主に以下を担当します。

- コード確認・軽微な編集
- Terminal 操作
- Codex への実装指示
- Git 操作
- Web アプリのプレビュー

通勤中などのスマートフォン開発では、細かなコード編集をすべてタッチ操作で行うより、Codex に変更内容を指示し、`git diff` とブラウザプレビューで確認する使い方が向いています。

## Run Without Codespaces

ローカル PC でも起動できます。

### Python setup

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r server/requirements.txt
```

### React setup

```bash
npm --prefix client install
```

### Start

```bash
./start-dev.sh
```

Windows の場合は `start-dev.sh` をそのまま利用できないため、FastAPI と Vite を別々の Terminal から起動してください。

```bash
uvicorn server.main:app --host 0.0.0.0 --port 8000 --reload
```

```bash
npm --prefix client run dev
```

## Documentation Policy

このリポジトリでは、実装とドキュメントを同期して管理します。

以下を変更した場合は、同じ変更の中で README も確認・更新してください。

- セットアップ手順
- 起動・停止コマンド
- `.devcontainer` の内容
- 使用する言語・フレームワーク・主要ツール
- ポート番号
- ディレクトリ構成
- API の利用方法
- 開発ワークフロー
- Codex の利用方法

詳細なエージェント向けルールは `AGENTS.md` を参照してください。

## Current Scope

このリポジトリはフルスタック開発環境の最小構成です。

現時点では以下は含めていません。

- Database
- Authentication
- Docker Compose
- Production deployment
- API schema generation
- React Router
- State management library
- Test framework

必要になった段階で追加する前提です。

## Next Steps

アプリケーションを拡張する場合は、例えば次の順序で追加できます。

1. FastAPI に実際の API を追加
2. React 側から API を利用
3. Pydantic で Request / Response schema を定義
4. pytest / Vitest を追加
5. Database を追加
6. GitHub Actions で CI を構築
7. Production deployment を追加
