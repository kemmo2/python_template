# Python Project Template

Copierを使用して、Pythonプロジェクトを生成するテンプレートです。

## Requirements

```bash
brew install copier uv
```

## プロジェクトの作成

```bash
copier copy gh:kemmo-2/python_template my-project
```

## 作成したプロジェクトのセットアップ

```bash
cd ../my-project
chmod +x setup.sh
./setup.sh
```

## GitHubへ公開
```bash
gh repo create graph-architect --private --source=. --push
```