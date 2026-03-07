# Build stage
FROM node:16.14.2 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
COPY .env.example .env
RUN sed -i 's|MIX_WEB_URL=.*|MIX_WEB_URL=http://localhost:8080|' .env && \
    sed -i 's|MIX_APP_URL=.*|MIX_APP_URL=http://localhost:8080/tracker|' .env
RUN npm run dev

# Serve stage
FROM nginx:alpine
COPY --from=builder /app/public /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
