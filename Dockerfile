# ベースイメージ：slimじゃない方にすることで依存関係の問題を減らす
FROM python:3.11

# 作業ディレクトリ作成
WORKDIR /app

# ビルドツールや必要なパッケージをインストール
RUN apt-get update -o Acquire::Retries=5 && \
    apt-get install -y gcc g++ pkg-config && \
    rm -rf /var/lib/apt/lists/*

# 仮想環境を作成して pip をアップグレード
RUN python -m venv venv && \
    . venv/bin/activate && \
    pip install --upgrade pip

# （必要ならここに依存パッケージのインストールなどを追記）
# 例: requirements.txt を追加したい場合
# COPY requirements.txt .
# RUN . venv/bin/activate && pip install -r requirements.txt

# アプリのコードをコピー（任意）
# COPY . .

# デフォルトのコマンド（あとで書き換えてOK）
CMD [ "bash" ]
