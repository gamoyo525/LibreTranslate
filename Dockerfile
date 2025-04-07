# React アプリをビルドするステージ
FROM node:18 AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Nginxで配信するステージ
FROM nginx:alpine

# React のビルド成果物をコピー
COPY --from=builder /app/build /usr/share/nginx/html

# 🔥 Nginx のデフォルト設定を PORT に合わせて動かす
COPY nginx.conf.template /etc/nginx/templates/default.conf.template

EXPOSE 80
CMD ["sh", "-c", "envsubst '$PORT' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"]
