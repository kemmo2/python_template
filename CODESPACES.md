# React + FastAPI Codespaces

このブランチは GitHub Codespaces で React + Python を開発するための最小構成です。

## 構成

- `client/`: Vite + React
- `server/`: FastAPI
- `.devcontainer/`: Codespaces の開発コンテナ設定
- `start-dev.sh`: React と FastAPI を同時に起動

## 起動

Codespace の作成が完了すると依存関係が自動でインストールされます。

ターミナルで次を実行してください。

```bash
./start-dev.sh
```

- React: port `5173`
- FastAPI: port `8000`
- React から `/api/*` へのアクセスは Vite が FastAPI に proxy します。

React のプレビューを開くと、`FastAPI is running` と表示されれば接続成功です。
