ARG VERSION=10.8
ARG BUILDER=docker.io/library/node
FROM ${BUILDER}:${VERSION}-slim AS base

FROM base AS deps
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm install


FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules* ./node_modules
COPY . .
RUN npm run ng build --prod --build-optimizer --aot


FROM nginx:mainline-alpine3.20-slim AS runtime
WORKDIR /var/www
COPY nginx.conf /etc/nginx/
COPY --from=builder /app/dist/Angular6 /var/www/
EXPOSE 80