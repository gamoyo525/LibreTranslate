# React アプリをビルドするステージ
FROM node:18 AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# ビルド済みアプリをNginxで配信するステージ
FROM nginx:alpine

# 公開ディレクトリに静的ファイルをコピー
COPY --from=builder /app/build /usr/share/nginx/html

# 🔥 ここが大事：ポート開放 & Nginxを前面で起動
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
