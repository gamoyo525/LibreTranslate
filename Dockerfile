# Node.jsの公式イメージを使う
FROM node:18

# 作業ディレクトリを作成
WORKDIR /app

# package.jsonとpackage-lock.jsonをコピーして依存関係をインストール
COPY package*.json ./
RUN npm install

# アプリのソースコードをコピー
COPY . .

# ビルド（本番用）
RUN npm run build

# ビルドしたファイルを配信するために、軽量なサーバーに切り替える
FROM nginx:alpine
COPY --from=0 /app/build /usr/share/nginx/html

# NginxがReactアプリをホストするのでCMDは不要（Nginxが勝手に起動する）
