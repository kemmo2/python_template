# React + FastAPI on GitHub Codespaces

GitHub Codespaces 上で、クライアントサイドを **React + Vite**、サーバーサイドを **Python + FastAPI** として開発するための最小構成です。

PCだけでなく、iPhone / iPad のブラウザから Codespaces を開いて開発・実行・プレビューする用途も想定しています。

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

したがって、Codespace 作成後に手動で `pip install` や `npm install` を実行する必要は基本的にありません。

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

Codespace が作成されると `.devcontainer/devcontainer.json` が読み込まれ、`post-create.sh` によって依存ライブラリが自動的にインストールされます。

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

基本的な開発フローは以下です。

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

React と FastAPI はどちらも Hot Reload が有効です。

- React: Vite HMR
- FastAPI: Uvicorn `--reload`

そのため、通常はコード変更のたびにサーバーを再起動する必要はありません。

## Development on iPhone

iPhone では Safari から GitHub を開き、Codespaces を起動できます。

構成としては、iPhone 自体で Node.js や Python を実行するわけではありません。

```text
iPhone
  ↓
Safari / VS Code Web
  ↓
GitHub Codespaces
  ↓
Linux Container
  ├── Node.js / Vite / React
  └── Python / FastAPI
```

実際のビルド・サーバー実行はすべて GitHub 側の Codespace で行われます。

そのため、iPhone は主に以下を担当します。

- コード編集
- Terminal 操作
- Git 操作
- Web アプリのプレビュー

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
