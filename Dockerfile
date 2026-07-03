# Stage 1: Build / Tải dependency
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci

# Stage 2: Môi trường chạy
FROM node:20-alpine
WORKDIR /app

# Khởi tạo non-root user tên là appuser
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy các thư viện và code từ stage trước
COPY package*.json ./
RUN npm ci --only=production
COPY server.js ./

# Cấp quyền cho non-root user và chuyển đổi sang user này
RUN chown -R appuser:appgroup /app
USER appuser

EXPOSE 8080

# Cấu hình Healthcheck để báo Service Healthy cho Docker Compose
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/healthz || exit 1

CMD ["node", "server.js"]