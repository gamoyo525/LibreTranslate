# --------- ビルドフェーズ ---------
FROM python:3.11.11-slim-bullseye AS builder

WORKDIR /app

# venv作るためにビルドに必要なツールを入れる
RUN apt-get update && apt-get install -y gcc g++ pkg-config && rm -rf /var/lib/apt/lists/*

# 仮想環境とpipアップグレード
RUN python -m venv venv && ./venv/bin/pip install --upgrade pip

# ソースコードを全部コピー
COPY . .

# 翻訳ファイルのコンパイルと依存関係のインストール
RUN ./venv/bin/pip install Babel==2.12.1 \
  && ./venv/bin/python scripts/compile_locales.py \
  && ./venv/bin/pip install torch==2.0.1 --extra-index-url https://download.pytorch.org/wh
