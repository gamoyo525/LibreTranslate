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

# ✅ Nginxが使うポートをRenderに教える
EXPOSE 80

# Nginxをフォアグラウンドで起動（←ここが追加！）
CMD ["nginx", "-g", "daemon off;"]

# buildされたReactファイルをNginxの公開ディレクトリへコピー
COPY --from=0 /app/build /usr/share/nginx/html
