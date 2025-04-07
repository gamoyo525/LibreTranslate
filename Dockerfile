# React アプリをビルドするためのステージ
FROM node:18 AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Nginx でビルド済みファイルを配信するステージ
FROM nginx:alpine

# ✅ Render に「ポート80を使うよ」と伝える
EXPOSE 80

# ✅ Nginx をフォアグラウンドで起動（デフォルトだとバックグラウンドになる）
CMD ["nginx", "-g", "daemon off;"]

# ✅ React アプリを Nginx の公開ディレクトリへコピー
COPY --from=builder /app/build /usr/share/nginx/html


