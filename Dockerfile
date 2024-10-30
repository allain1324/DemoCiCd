# Sử dụng Node.js làm base image
FROM node:20 AS build-stage

# Thiết lập thư mục làm việc
WORKDIR /app

# Sao chép package.json và pnpm-lock.yaml (nếu có)
COPY package*.json ./
COPY pnpm-lock.yaml ./

# Cài đặt pnpm
RUN npm install -g pnpm

# Cài đặt dependencies
RUN pnpm install

# Sao chép mã nguồn
COPY . .

# Xây dựng ứng dụng
RUN pnpm run build

# Bước chạy
FROM nginx:alpine

# Sao chép files build được từ build-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Cấu hình Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 3002
EXPOSE 3002

# Khởi động Nginx
CMD ["nginx", "-g", "daemon off;"]