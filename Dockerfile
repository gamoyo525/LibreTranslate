# --------- ビルドフェーズ ---------
FROM python:3.11.11-slim-bullseye AS builder

WORKDIR /app

# venv作るためにビルドに必要なツールを入れる
RUN apt-get update && apt-get install -y gcc g++ pkg-config && rm -rf /var/lib/apt/lists/*
RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf


# 仮想環境とpipアップグレード
RUN python -m venv venv && ./venv/bin/pip install --upgrade pip

# ソースコードを全部コピー
COPY . .

# 翻訳ファイルのコンパイルと依存関係のインストール
RUN ./venv/bin/pip install Babel==2.12.1 \
  && ./venv/bin/python scripts/compile_locales.py \
  && ./venv/bin/pip install torch==2.0.1 --extra-index-url https://download.pytorch.org/whl/cpu \
  && ./venv/bin/pip install .

# --------- 実行フェーズ ---------
FROM python:3.11.11-slim-bullseye

WORKDIR /app

# 必要ファイルをコピー（venvだけ builder から取る）
COPY --from=builder /app /app

# 本番環境に不要な依存ツールを削除
RUN apt-get purge -y gcc g++ pkg-config && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

# 環境変数（Render が使うPORTに対応）
ENV PORT=5000

# サーバー起動（Renderでポート開けるために --host 0.0.0.0）
ENTRYPOINT [ "./venv/bin/libretranslate", "--host", "0.0.0.0", "--port", "5000" ]
