# ========================
# 1. ビルド用ステージ
# ========================
FROM python:3.11.11-slim-bullseye AS builder

WORKDIR /app

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq \
  && apt-get -qqq install --no-install-recommends -y pkg-config gcc g++ \
  && apt-get upgrade --assume-yes \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN python -m venv venv && ./venv/bin/pip install --no-cache-dir --upgrade pip

# 🔥 もしリポジトリのルートにあるなら「COPY . .」でOK
COPY . . 

# 🔥 もし `src/` にあるなら「COPY src/ .」に変更する
# COPY src/ . 

# パッケージのインストール & 翻訳ファイルのコンパイル
RUN ./venv/bin/pip install Babel==2.12.1 && ./venv/bin/python scripts/compile_locales.py \
  && ./venv/bin/pip install torch==2.0.1 --extra-index-url https://download.pytorch.org/whl/cpu \
  && ./venv
